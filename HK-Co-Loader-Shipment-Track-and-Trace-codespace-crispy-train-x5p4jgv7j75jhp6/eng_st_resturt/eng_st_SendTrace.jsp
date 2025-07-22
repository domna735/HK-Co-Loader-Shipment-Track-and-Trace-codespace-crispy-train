<%@ page import="com.hkapps.util.*"%>
<%@ page import="hkapps.shipment_tracking.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.lang.reflect.Array"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.text.*" %>

<%
String nonce = java.util.UUID.randomUUID().toString().replace("-", "");
response.setHeader("Content-Security-Policy",
    "default-src 'self'; " +
    "script-src 'self' 'nonce-" + nonce + "' 'strict-dynamic'; " +
    "object-src 'none'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'; " +
    "upgrade-insecure-requests; block-all-mixed-content;");
%>

<html>

<head>
<title>Shipment Tracking</title>
</head>
<script src="../js_client/rollovers.js" type="text/javascript" nonce="<%=nonce%>"></script>
<script src="../js_client_eng_hws/eng_st_SendTrace_init.js" nonce="<%=nonce%>"></script>
<body bgcolor=#ffffff><blockquote>
<font face="Frutiger, Arial">

<%
Common common = new Common();

String referpage = request.getHeader("referer");

if (referpage == null) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}

URL referurl = new URL(referpage);
if (!common.isValidProtocol(referurl.getProtocol(),request.getServerPort())) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}

if (!common.isValidHost(referurl.getHost())) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}

if (!referurl.getPath().equals("/eng_st/eng_st_Stm.jsp")) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}


if (request.getQueryString() != null) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;}
}


if ((request.getParameter("awblist") == null) || (request.getParameter("awblist").equals("")) || (request.getParameter("awblist").equals("undefined"))) {
   response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   if(true){return;} 
}

//double validation on input
if ((request.getParameter("aname") == null) || (request.getParameter("cphone") == null) || (request.getParameter("emailaddr") == null)) {
  response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
  if(true){return;}
}
  
if ((request.getParameter("aname").equals("")) || (request.getParameter("cphone").equals("")) || (request.getParameter("emailaddr").equals(""))) {
  response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
  if(true){return;}
}

DataTypeUtil dtu = new DataTypeUtil();
  
if ((!dtu.isValidLine(request.getParameter("aname"),20)) || (!dtu.isValidPhone(request.getParameter("cphone"),18)) || (!dtu.isValidEmail(request.getParameter("emailaddr"),50))) {
  response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
  if(true){return;}
}

if ((!request.getParameter("cname").equals("")) && (!dtu.isValidLine(request.getParameter("cname"),30))) {
  response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
  if(true){return;}
}


  String awblist=request.getParameter("awblist");
  String[] awb=awblist.split("\\|");
  int noawb=Array.getLength(awb);  
  String rmkslist=request.getParameter("rmkslist");
  String[] rmks=rmkslist.split("\\|");
  String[] rmkline;
  String[] rmk = new String[10];
  int normkline = 0;
  int d = 0;
  //String staticrmk="undefined\nundefined\nundefined\n";
   
  boolean chk_awb = true;
  for (int p = 0 ; p < noawb ; p++) {
    if (!dtu.isAwb(awb[p])) {
      chk_awb = false;
        p=noawb;
      }
  } 
  
  if (!chk_awb) {
    response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
  if(true){return;}
  }

  
  Date Today = dtu.hk_datetime();
  
  Shipment_tracking ship_track = new Shipment_tracking();
  Properties prop=new Properties();
  FileInputStream ip=new FileInputStream(System.getProperty("catalina.base")+"/webapps/config.properties");
  prop.load(ip);
  boolean awb_too_freq = false;
    
  for (int i=0; i<noawb; i++) {
 /* 
   if (!ship_track.accept_trace(awb[i])) {
    out.println("<p><font SIZE=\"2\" face=\"Frutiger, Arial\">");
    out.println("<b>Please send trace request at least 24 hours after shipment is picked up.</b>");
    out.println("</font></p>");
    i = noawb;
   } else {
*/
    awb_too_freq = ship_track.chk_too_freq2(awb[i],"TRC",Integer.parseInt(prop.getProperty("trc_chkday")));
    
    if (awb_too_freq) {	
    out.println("<blockquote><font size='2' face='Frutiger, Arial'><b><br>Dear Customer,");
    out.println("<br><br>According to our records, you have enquired the following shipment(s) earlier.<br>" + awb[i]);
    out.println("<br><br>Kindly refer to the previous email communication and reply to us if there is anything that we can be of assistance.");
    //out.println("<br><br>For any other questions, please email to <a href='mailto:hk.wsc@dhl.com'>hk.wsc@dhl.com</a>");
    out.println("<br><br>Thank you for your kind attention.<br><br>Regards,<br><br>Customer Service Division</b></font></blockquote>");
      i = noawb;
      } else {
      
        for (d=0; d<10; d++) {
           rmk[d] = "";        
        }
        
        //rmk=staticrmk.split("\\\n");
        rmkline=rmks[i].split("\\^~");
        normkline = Array.getLength(rmkline);
    
        for (d=0; d<normkline; d++) {
           rmk[d] = rmkline[d];
        }        

    String tracebody=awb[i]+"|"+request.getParameter("cname")+"|"+request.getParameter("aname")+"|"+request.getParameter("emailaddr")+"|"+request.getParameter("cphone")+"|"+rmk[0]+"|"+rmk[1]+"|"+rmk[2]+"|"+rmk[3]+"|"+rmk[4]+"|"+rmk[5]+"|"+rmk[6]+"|"+rmk[7]+"|"+rmk[8]+"|"+rmk[9]+"|";
    //out.println(tracebody);

    String FileName = awb[i];
  String FullFileName = "";
  
  FullFileName = System.getProperty("catalina.base") + "/web_files/trace/work/" + FileName;
    
   try {
    
          File file = new File(FullFileName);
          BufferedWriter output = new BufferedWriter(new FileWriter(file));
          output.write(tracebody);
          
          output.close();
      
      Log log = new Log();
  
        if (!log.add_log("TRC", awb[i])) {
      response.sendRedirect("err_htmls/eng_st_DbErr.html");
      if(true){return;} 
        }
     
   } catch ( IOException e ) {
          e.printStackTrace();
   }
   
   
 
%>

<p><font SIZE="2" face="Frutiger, Arial"><b>Your Trace has been Registered!</b></font></p>

<p><font SIZE="2" face="Frutiger, Arial">
Note: Thank you for using our shipment tracking service. We shall <br>
contact you in next working day for acknowledgement. Should you <br>
have any other questions regarding shipment tracking, please call our <br>
24-hour Customer Service Hotline on (852) 2400-3388 and quote your Airwaybill <br>
Number(s) for our reference.
</font>
</p>


<table border=0>
<tr>
<td>
    <form action="eng_track_home.html">
    <input type=submit value="Next Tracking">
    </form>
</td>
<td>
   
</td>
</tr>
</table>	
<%
    }
//   }
  }  
%>

</blockquote></body>
<script src="/eng_st/js_client/copyright_a.js" nonce="<%=nonce%>"></script>
</html>
