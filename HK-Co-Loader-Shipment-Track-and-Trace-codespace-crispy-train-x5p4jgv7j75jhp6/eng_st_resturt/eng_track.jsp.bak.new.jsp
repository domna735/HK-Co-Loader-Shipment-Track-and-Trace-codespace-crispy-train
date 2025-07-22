<%@ page import="hkapps.shipment_tracking.*"%>
<%@ page import="hkapps.event_extract.*"%>
<%@ page import="com.hkapps.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.lang.reflect.Array"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="org.json.*"%>
<%
String nonce = java.util.UUID.randomUUID().toString().replace("-", "");
response.setHeader("Content-Security-Policy",
    "default-src 'self'; " +
    "script-src 'self' https://www.google.com/recaptcha/ https://www.gstatic.com/recaptcha/ https://www.recaptcha.net/ 'nonce-" + nonce + "' 'strict-dynamic'; " +
    "style-src 'self' 'unsafe-inline' https://www.gstatic.com/recaptcha/ https://www.recaptcha.net/; " +
    "img-src 'self' data: https://www.gstatic.com/recaptcha/ https://www.recaptcha.net/; " +
    "frame-src https://www.google.com/recaptcha/ https://www.recaptcha.net/ https://www.gstatic.com/recaptcha/; " +
    "object-src 'none'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'; " +
    "upgrade-insecure-requests; block-all-mixed-content;");
%>
<html>
<head>
<title>Shipment Tracking</title>
<script src="https://www.recaptcha.net/recaptcha/api.js?render=6LcB8dcZAAAAAJO9mElsjCkPrWVj1rXr2SH9ML_h" nonce="<%=nonce%>"></script>
<script src="/eng_st/js_client_eng_hws/eng_st_FormCheck.js" nonce="<%=nonce%>"></script>
<script src="/eng_st/js_client_eng_hws/eng_track.js" nonce="<%=nonce%>"></script>
</head>

<%
Common common = new Common();
//out.println(request.getParameter("g-recaptcha-response"));
if ((request.getParameter("g-recaptcha-response") == null) || (request.getParameter("g-recaptcha-response").equals(""))) {
    out.println("[eng_track.jsp] reCAPTCHA 參數為空: " + request.getParameter("g-recaptcha-response"));
    out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
    if(true){return;}
} else {
    Curl curl = new Curl();
    boolean chk_result = false;
    Properties prop=new Properties();
    FileInputStream ip=new FileInputStream(System.getProperty("catalina.base")+"/webapps/config.properties");
    prop.load(ip);
    //String captcha_secretKey = prop.getProperty("captcha_secretKey_v2");
    String captcha_secretKey = prop.getProperty("captcha_secretKey_v3");
    chk_result = curl.chk_captcha(captcha_secretKey, request.getParameter("g-recaptcha-response"));
    System.out.println("[eng_track.jsp] reCAPTCHA 驗證結果: " + chk_result);
    if (!chk_result) {
        out.println("[eng_track.jsp] reCAPTCHA 驗證失敗");
        out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
        if(true){return;}
    }
}

String referpage = request.getHeader("referer");

if (referpage == null) {
   out.println("[eng_track.jsp] referer header 為 null");
   out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
   if(true){return;}
}

URL referurl = new URL(referpage);

if (!common.isValidProtocol(referurl.getProtocol(),request.getServerPort())) {
   out.println("[eng_track.jsp] referer protocol 不符: " + referurl.getProtocol());
   out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
   if(true){return;}
}


if (!common.isValidHost(referurl.getHost())) {
   out.println("[eng_track.jsp] referer host 不符: " + referurl.getHost());
   out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
   if(true){return;}
}

if (!referurl.getPath().equals("/eng_st/eng_track_home.html")) {
   out.println("[eng_track.jsp] referer path 不符: " + referurl.getPath());
   out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
   if(true){return;}
}


if (request.getQueryString() != null) {
   out.println("[eng_track.jsp] query string 不為 null: " + request.getQueryString());
   out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
   if(true){return;}
}


if ((request.getParameter("awb") == null) || (request.getParameter("awb").equals("")) || (request.getParameter("awb").equals("undefined"))) {
   out.println("[eng_track.jsp] AWB 參數為空或 undefined: " + request.getParameter("awb"));
   out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
   if(true){return;}
  //out.println(referpage);
} else {

  String tmpawb=request.getParameter("awb");
  String[] awblist=tmpawb.split("\\|");
  int nawb=Array.getLength(awblist);

  if (nawb == 0) {
   out.println("[eng_track.jsp] AWB 數量為 0");
   out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
   if(true){return;}
  }

  DataTypeUtil dtu = new DataTypeUtil();

  boolean chk_awb = true;
  for (int p=0; p<nawb; p++) {
  /*
    if (awblist[p].length() != 10) {
       chk_awb = false;
       p=nawb;
    } else {
       if (!dtu.isNumeric(awblist[p])) {
        chk_awb = false;
          p=nawb;
       }
    }
  */

  if (!dtu.isAwb(awblist[p])) {

    chk_awb = false;
        p=nawb;
    }
  }

  if (!chk_awb) {
    out.println("[eng_track.jsp] AWB 格式驗證失敗: " + tmpawb);
    out.println("[eng_track.jsp] DEBUG: 本來要 redirect 回 eng_track_home.html");
    if(true){return;}
  }

  boolean awb_too_freq = false;
  boolean too_freq = false;
  String too_freq_awblist = "";
  boolean checked_freq = false;


  Shipment_tracking ship_track = new Shipment_tracking();

  //System.out.println("awblist:" + awblist.toString());

   //if ((awblist != null) && (awblist != "")) {
   if ((awblist != null) && (nawb > 0)) {

    for (int n=0; n<nawb; n++) {
        //System.out.println("awb:" + awblist[n]);
              //get the time difference from last tracking
              awb_too_freq = false;
              awb_too_freq = ship_track.chk_too_freq(awblist[n],"KO_ST");

        if (awb_too_freq) {
          //n = nawb;
          too_freq_awblist += "<br>" + awblist[n];
          too_freq = true;
        }

    }
    checked_freq = true;
    too_freq = false;

    if (too_freq) {
       out.println("<blockquote><font size='2' face='Frutiger, Arial'><b>Sorry, system is busy at the moment and cannot process your request now. Customers are suggested to raise enquiry on the same airwaybill number in no less than 2 hours. We apologize for any inconvenience caused.</b></font></blockquote>");
       //out.println("<blockquote><font size='2' face='Frutiger, Arial'><b>Sorry, system is busy at the moment and cannot process your request now. Customers are suggested to raise enquiry on the same airwaybill number in no less than 30 minutes. We apologize for any inconvenience caused.</b></font></blockquote>");
    } else {

      Log log = new Log();

      if (!log.add_log("KO_ST", tmpawb)) {
      out.println("[eng_track.jsp] DB log 寫入失敗，原本要 redirect 到 err_htmls/eng_st_DbErr.html");
      if(true){return;}
      }

      //out.println("");

    }

  } else {
    checked_freq = true;
  }


if ((checked_freq) && (!too_freq)) {


%>

<body bgcolor=#ffffff>
<blockquote>

<font SIZE="2" face="Frutiger, Arial">
&#60 &#60 note 1 - this URL is reserved for the enquiry and case registration of shipment under Hong Kong 63 account. &#62 &#62
<br>
&#60 &#60 note 2 - case can be registered after 24 hrs of pick up scan for shipment. &#62 &#62
<!--
<br><br>
Please kindly <a href="mailto:net012@dhl.com?cc=vicky.chan@dhl.com">email to net012@dhl.com cc to vicky.chan@dhl.com</a> if your enquiry belongs to following scenarios: <br>
1.  You had enquired the shipment before and now it is already over 30 days since your last enquiry. <br>
2.  Shipment already sent out or sent out over 90 calendar days, and you cannot see any shipment status via the URL. <br>
3.  You had registered a request for two days but there is without any acknowledgement response from DHL agent. <br>
4.  In case of top urgent issue that require DHL's immediate follow up but case cannot be registered over the web due to the time constraint. <br>
-->
</font>

<h2><strong><small><small><font size="2" face="Frutiger, Arial" color="#9C0000">
These are the tracking results :</font></small></small></strong></h2>

<form id="f_inp" action="eng_st_Stm.jsp" method="post" name="result">
  <input type="hidden" id="g-recaptcha-response" name="g-recaptcha-response">
  <table border="0">
    <tr>
      <td VALIGN=TOP width="15%">
      <font size="2" face="Frutiger, Arial"  color="#a60018">
      <b>Airwaybill<br> Number</b></font></td>

      <td VALIGN=TOP width="16%" nowrap height="32">
      <font size="2" face="Frutiger, Arial" color="#a60018">
      <b>Origin<br> Service Area</b></font></td>

      <td VALIGN=TOP width="20%">
      <font size="2" face="Frutiger, Arial" color="#a60018">
      <b>Destination<br> Service Area</b></font></td>

      <td VALIGN=TOP width="37%">
      <font size="2" face="Frutiger, Arial" color="#a60018">
      <b>Status</b></font></td>

      <td VALIGN=TOP width="12%">
      <font size="2" face="Frutiger, Arial" color="#a60018">
      <b>Further Investigation</b></font>
      <font face="Frutiger, Arial" color="#0080FF">*</font></td>
    </tr>

    <tr>
      <td width="100%" colspan="5" valign="middle" align="center" height="19">
      <hr SIZE="1" NOSHADE></td>
    </tr>

<%
Properties prop=new Properties();

FileInputStream ip=new FileInputStream(System.getProperty("catalina.base")+"/webapps/config.properties");
prop.load(ip);

JSONObject req_json = new JSONObject();
ConnectAPI connectAPI = new ConnectAPI();
//connectAPI.set_request_json(req_json);
connectAPI.set_api_url(prop.getProperty("coloader_api"));
connectAPI.set_api_key(prop.getProperty("apikey"));

      //ShipDetail shipdetail;
      boolean have_ckpt_box = false;
      int k=0;
      int c=0;

      Vector myResultList = new Vector();
      for (int n=0; n<nawb; n++) {
        //shipdetail = ship_track.query(awblist[n],"");
          req_json.put("awbn", awblist[n]);
    req_json.put("lang", "en");

                connectAPI.set_request_json(req_json);

    connectAPI.send_request();

    JSONObject res_json = connectAPI.get_response_json();

    JSONObject res_json_awb;
    JSONObject res_json_shp;
    JSONArray res_jsonarr_result;
    JSONObject res_json_result;

    res_json_awb = res_json.getJSONObject(awblist[n]);
    res_json_shp = res_json_awb.getJSONObject("shp");

    res_jsonarr_result = res_json_shp.getJSONArray("Event");

    ShipDetail shipdetail = new ShipDetail();

    shipdetail.awb_no = awblist[n];

    if (res_jsonarr_result.length() > 0) {

      Vector ckpt_list = new Vector();

      for (byte b = 0; b < res_jsonarr_result.length(); b++) {
        res_json_result = res_jsonarr_result.getJSONObject(b);
        if (b == 0) {
          shipdetail.orig = res_json_result.getString("origin");
          shipdetail.dest = res_json_result.getString("dest");
          shipdetail.accept_trace = res_json_result.getString("accept_trace");
        }

        Checkpoint ckpt = new Checkpoint();
        ckpt.gen_date = res_json_result.getString("date");

        ckpt.gen_date = common.get_month_mmm(ckpt.gen_date.substring(5,7)) + " " + ckpt.gen_date.substring(8,10) + " " + ckpt.gen_date.substring(0,4);
        ckpt.gen_time = res_json_result.getString("time").substring(0,5);
        ckpt.gen_stn = res_json_result.getString("Location Service Area");
        ckpt.gen_ckpt = res_json_result.getString("ckpt_mess");
        ckpt.gen_cd = res_json_result.getString("ckpt");
        ckpt.signature = res_json_result.getString("rmk");
       ckpt_list.addElement(ckpt);

      }

      shipdetail.ckpt = ckpt_list;
    }
        myResultList.addElement(shipdetail);

      }

      //ShipDetail shipdetail;
      for (k=0; k<myResultList.size(); k++) {
        ShipDetail shipdetail = (ShipDetail) myResultList.elementAt(k);

        out.println("<tr>");
  out.println("<p>");

  // First column : AWB Number
  out.println("<td width=\"15%\" height=\"19\" valign=\"top\" align=\"left\">");
        out.println("<font size=1 face=\"Frutiger, Arial\">");
        out.println("<a href=\"#" + shipdetail.awb_no + "\">" + shipdetail.awb_no + "</a></td>");

  //out.println(shipdetail.orig + shipdetail.dest + shipdetail.accept_trace + shipdetail.ckpt);

  //if (shipdetail.ckpt == null) {
  if ((shipdetail.ckpt == null) || (shipdetail.ckpt.size() == 0)) {
    // Second column : Origin Service Area (country - city)
          out.println("<td width=\"15%\" height=\"19\" valign=\"top\" align=\"left\">");
          out.println("<font size=1 face=\"Frutiger, Arial\">No information available</td>");

          // Third column : Dest. Service Area (country - city)
          out.println("<td width=\"15%\" height=\"19\" valign=\"top\" align=\"left\">");
          out.println("<font size=1 face=\"Frutiger, Arial\">&nbsp;</td>");

    out.println("<td width = \"15%\" height=\"19\" valign=top align=\"left\">");

    // Forth column : Status
    out.println("<font size=1 face=\"Frutiger, Arial\">Please contact our 24 hours Customer Service hotline on 2400-3388 for arrangement.</td>");

    // Fifth column : Further Investigation
    out.println("<input type=\"hidden\" name=\"cb" + k + "\" value=\"NA\"></input>");

  } else {
    // Second column : Origin Service Area (country - city)
          out.println("<td width=\"15%\" height=\"19\" valign=\"top\" align=\"left\">");
          out.println("<font size=1 face=\"Frutiger, Arial\">"+ shipdetail.orig + "</td>");

    // Third column : Dest. Service Area (country - city)
          out.println("<td width=\"15%\" height=\"19\" valign=\"top\" align=\"left\">");
          out.println("<font size=1 face=\"Frutiger, Arial\">"+ shipdetail.dest +"</td>");

    out.println("<td width = \"15%\" height=\"19\" valign=top align=\"left\">");

    //Checkpoint lst_ckpt = (Checkpoint) shipdetail.ckpt.elementAt(0);
    Checkpoint lst_ckpt = (Checkpoint) shipdetail.ckpt.elementAt(shipdetail.ckpt.size()-1);

    // Forth column : Status
          //if (lst_ckpt.gen_id.equals("18"))
          if (lst_ckpt.gen_cd.equals("OK"))
      {
      out.println("<font size=1 face=\"Frutiger, Arial\">" +
      "Signed by: " + lst_ckpt.signature + " <br>" +
      lst_ckpt.gen_ckpt + " <br>" +
      lst_ckpt.gen_date + " " +
      lst_ckpt.gen_time + "<img src=\"../images/del.gif\"></td>");
      }
      else
      {
        out.println("<font size=1 face=\"Frutiger, Arial\">" +
      lst_ckpt.gen_ckpt + " <br>" +
      lst_ckpt.gen_date + " " +
      lst_ckpt.gen_time + "</td>");
      }

      // Fifth column : Further Investigation

      //if (shipdetail.accept_trace.equals("1")) {
    if (shipdetail.accept_trace.equals("Y")) {
       out.println("<td width=\"12%\" height=\"19\" valign=top align=\"center\">");
       out.println("<font face=\"Frutiger, Arial\"><center><p>");
       out.println("<input type=\"checkbox\" name=\"awbchk\" value=\"" + shipdetail.awb_no + "\"></td>");
       have_ckpt_box = true;
      } else {
        out.println("<input type=\"hidden\" name=\"cb" + k + "\" value=\"NA\"></input>");
      }

  }

  out.println("</tr>");

      } // end for for loop

      out.println("</table>");

      if (have_ckpt_box) {
         // 收集所有可勾選的 AWB，組成 | 分隔字串
         out.println("<input type='hidden' name='hidawb' value=''>");
         out.println("<div align=\"left\">\n<p><small><em><font color=\"#0080FF\">*</font><font size=2 face=\"Frutiger, Arial\">If you need more delivery details, please select \"Further Investigation\" for assistance from our Customer Service Representatives, you will need to fill in your contact information and question for tracing purpose.</font></em></small></p>\n<p><input type=submit value=\"Further Investigation\"></p>\n</div>");
         out.println("<script src=\"/eng_st/js_client/eng_track_fi.js\" nonce='" + nonce + "'></script>");
      }
      out.println("</form>");

      for (k=0; k<myResultList.size(); k++) {
        ShipDetail shipdetail = (ShipDetail) myResultList.elementAt(k);

      //if (shipdetail.ckpt != null) {
      if ((shipdetail.ckpt != null) && (shipdetail.ckpt.size() > 0)) {

           out.println("<p align=\"center\"><strong><font size=\"2\" face=\"Frutiger, Arial\">");
           out.println("<a name=\"" + shipdetail.awb_no + "\">" + shipdetail.awb_no + "</a> - Detailed Report");
           out.println("</font></strong></p>");

           out.println("<div align=\"center\"><center>");
           out.println("<table border=\"0\"  width=\"90%\">");
           out.println("<tr>");
           out.println("<td VALIGN=TOP width=\"15%\">");
           out.println("<font size=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\">");
           out.println("<b>Date</b></font></td>");
           out.println("<td VALIGN=\"top\" TOP width=\"15%\" nowrap>");
           out.println("<font size=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\">");
           out.println("<font size=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\">");
           out.println("<b>Local Time</b></font></td>");
           out.println("<td VALIGN=TOP width=\"30%\">");
           out.println("<font size=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\">");
           out.println("<b>Location Service Area</b></font></td>");
           out.println("<td VALIGN=TOP width=\"40%\">");
           out.println("<font size=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\">");
           out.println("<b>Checkpoint Details</b></font></td>");
           out.println("</tr>");

           out.println("<tr>");
           out.println("<td width=\"100%\" colspan=\"4\" valign=\"middle\" align=\"center\">");
           out.println("<hr SIZE=\"1\" NOSHADE></td>");
           out.println("</tr>");

     //for (c=shipdetail.ckpt.size()-1; c>=0; c--) {
     for (c=0; c<shipdetail.ckpt.size(); c++) {
            Checkpoint ckpt = (Checkpoint) shipdetail.ckpt.elementAt(c);
            out.println("<tr>");
      out.println("<td width=\"15%\" valign=\"top\">");
      out.println("<font size=\"1\" face=\"Frutiger, Arial\">");
      out.println( ckpt.gen_date + "</font></td>");
            out.println("<td width=\"15%\" valign=\"top\">");
      out.println("<font size=\"1\" face=\"Frutiger, Arial\">");
      out.println( ckpt.gen_time + "</font></td>");
            out.println("<td width=\"30%\" valign=\"top\">");
      out.println("<font size=\"1\" face=\"Frutiger, Arial\">");
      out.println( ckpt.gen_stn + "</font></td>");
            out.println("<td width=\"40%\" valign=\"top\">");
      out.println("<font size=\"1\" face=\"Frutiger, Arial\">");
      out.println( ckpt.gen_ckpt + "</font></td>");

      //if (ckpt.gen_cd.equals("AR")) {
     //         out.println( ckpt.gen_ckpt + ", delivery will be arranged.</font></td>");
      //} else {
      //    out.println( ckpt.gen_ckpt + "</font></td>");
      //}

      out.println("</tr>");
    }
          out.println("</table>");
          out.println("</center></div>");
       }//End If
     }//End For Loop


%>

<p align="center"><br>
&nbsp; </p>

</blockquote>
</body>

<%
}
}
%>
<SCRIPT LANGUAGE="javascript" SRC="/eng_st/js_client/copyright_r.js"></SCRIPT>
