<%@ page import="hkapps.shipment_tracking.*"%>
<%@ page import="com.hkapps.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.lang.reflect.Array"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>


<%
String nonce = java.util.UUID.randomUUID().toString().replace("-", "");
response.setHeader("Content-Security-Policy",
    "default-src 'self'; " +
    "img-src 'self' https://apps.dhl.com.hk; " +
    "script-src 'self' 'nonce-" + nonce + "' 'strict-dynamic' https://www.recaptcha.net https://www.gstatic.com; " +
    "connect-src 'self' https://www.recaptcha.net https://www.gstatic.com; " +
    "style-src 'self' 'unsafe-inline' https://www.recaptcha.net https://www.gstatic.com; " +
    "frame-src https://www.recaptcha.net https://www.gstatic.com; " +
    "object-src 'none'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'; " +
    "upgrade-insecure-requests; block-all-mixed-content;");
%>

<html>

<head>
<title>Shipment Tracing</title>
</head>


<script src="https://www.recaptcha.net/recaptcha/api.js?render=6LcB8dcZAAAAAJO9mElsjCkPrWVj1rXr2SH9ML_h" nonce="<%=nonce%>"></script>
<script src="/eng_st/js_client_eng_hws/eng_st_FormCheck.js" nonce="<%=nonce%>"></script>
<script src="/eng_st/js_client_eng_hws/eng_st_Stm_concat.js" nonce="<%=nonce%>"></script>

<%
String referpage = request.getHeader("referer");

Common common = new Common();

if (referpage == null) {
   out.println("<pre>DEBUG: referpage == null</pre>");
   // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   // if(true){return;}
}

URL referurl = new URL(referpage);
if (!common.isValidProtocol(referurl.getProtocol(),request.getServerPort())) {
   out.println("<pre>DEBUG: Invalid protocol: " + referurl.getProtocol() + "</pre>");
   // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   // if(true){return;}
}

if (!common.isValidHost(referurl.getHost())) {
   out.println("<pre>DEBUG: Invalid host: " + referurl.getHost() + "</pre>");
   // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   // if(true){return;}
}

if (!referurl.getPath().equals("/eng_st/eng_track.jsp")) {
   out.println("<pre>DEBUG: Invalid path: " + referurl.getPath() + "</pre>");
   // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   // if(true){return;}
}


if (request.getQueryString() != null) {
   out.println("<pre>DEBUG: Query string present: " + request.getQueryString() + "</pre>");
   // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   // if(true){return;}
}


if ((request.getParameter("hidawb") == null) || (request.getParameter("hidawb").equals("")) || (request.getParameter("hidawb").equals("undefined"))) {
   out.println("<pre>DEBUG: hidawb param missing or invalid: " + request.getParameter("hidawb") + "</pre>");
   // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
   // if(true){return;} 
} else {
  
  String hidawb=request.getParameter("hidawb");
  String[] awblist=hidawb.split("\\|");
  int noawb=Array.getLength(awblist);  
  String t = "";
  
  if ((noawb <= 0) || (noawb > 10)) {
     out.println("<pre>DEBUG: noawb out of range: " + noawb + "</pre>");
     // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
     // if(true){return;}
  }
  
  DataTypeUtil dtu = new DataTypeUtil();
  
  boolean chk_awb = true;
  for (int p = 0 ; p < noawb ; p++) {
     if (!dtu.isAwb(awblist[p])) {
       chk_awb = false;
        p=noawb;
      }
  } 
  
  if (!chk_awb) {
    out.println("<pre>DEBUG: AWB check failed. awblist=" + Arrays.toString(awblist) + "</pre>");
    // response.sendRedirect(common.convert_path(request.getServerPort(), (request.getRequestURL()).toString(), request.getServletPath(), "eng_track_home.html"));
    // if(true){return;}
  }
  
  String freq_awb = "";
  boolean awb_too_freq = false;
  Shipment_tracking ship_track = new Shipment_tracking();
  Properties prop=new Properties();
  FileInputStream ip=new FileInputStream(System.getProperty("catalina.base")+"/webapps/config.properties");
  prop.load(ip);
  
  for (int f = 0 ; f < noawb ; f++) {
     awb_too_freq = ship_track.chk_too_freq2(awblist[f],"TRC",Integer.parseInt(prop.getProperty("trc_chkday")));
     if (awb_too_freq) {
       freq_awb = freq_awb + "<br>" + awblist[f];
      }
  }
  
  
  if (!freq_awb.equals("")) {
   //out.println("<pre>DEBUG: freq_awb not empty, too frequent: " + freq_awb + "</pre>");
   //out.println("<blockquote><font size='2' face='Frutiger, Arial'><b>This following shipment(s) has/have trace case created in past " + prop.getProperty("trc_chkday") + " days.<br>" + freq_awb + "</b></font></blockquote>");	  
   out.println("<blockquote><font size='2' face='Frutiger, Arial'><b><br>Dear Customer,");
   out.println("<br><br>According to our records, you have enquired the following shipment(s) earlier.<br>" + freq_awb);
   out.println("<br><br>Kindly refer to the previous email communication and reply to us if there is anything that we can be of assistance.");
   out.println("<br><br>Thank you for your kind attention.<br><br>Regards,<br><br>Customer Service Division</b></font></blockquote>");
   // return;
  } else {
  
  
  out.println("<form id=\"f_inp\" NAME=\"f_inp\" method=\"post\" action=\"eng_st_SendTrace.jsp\" onsubmit='return concat(this, " + noawb + ");'>");
  out.println("<INPUT type=\"hidden\" name=\"awblist\">\n<INPUT type=\"hidden\" name=\"rmkslist\">\n<INPUT type=\"hidden\" name=\"noawb\" value=\"" + noawb + "\">\n<INPUT type=\"hidden\" id=\"g-recaptcha-response\" name=\"g-recaptcha-response\">\n");
  out.println("  <table BORDER=\"0\">");

    out.println("    <tr VALIGN=\"middle\">");
    out.println("      <td WIDTH=\"40%\"><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\"><b>Company Contact Person:</b></font></td>");
    out.println("      <td><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#9C0000\">");
    out.println("      <input type=\"text\" name=\"aname\" size=\"30\" maxlength=\"20\"></font></td>");
    out.println("    </tr>");

    out.println("    <tr>");
    out.println("      <td WIDTH=\"40%\"><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\"><b>Company Name:</b></font></td>");
    out.println("      <td><font SIZE=\"2\" face=\"Frutiger, Arial\">");
    out.println("      <input type=\"text\" name=\"cname\" size=\"30\" maxlength=\"30\"></font></td>");
    out.println("    </tr>");

    out.println("    <tr>");
    out.println("      <td WIDTH=\"40%\"><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\"><b>Company Contact Phone:</b></font></td>");
    out.println("      <td><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#9C0000\">");
    out.println("	 <input type=\"text\" name=\"cphone\" size=\"18\" maxlength=\"18\"></font></td>");
    out.println("    </tr>");

    out.println("    <tr>");
    out.println("      <td WIDTH=\"40%\"><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\"><b>Company Contact E-mail:</b></font></td>");
    out.println("      <td><font SIZE=\"2\" face=\"Frutiger, Arial\">");
    out.println("	  <input type=\"text\" name=\"emailaddr\" size=\"30\" maxlength=\"50\"></font>");
    out.println("      </td>");
    out.println("    </tr>");

    out.println("    <tr>");
    out.println("      <td><br>");
    out.println("      </td>");
    out.println("    </tr>");

    out.println("  </table>");

    out.println("<hr>");

    out.println("  <font SIZE=\"2\" face=\"Frutiger, Arial\">");
    out.println("  Please type your question(s) about shipment status in the following box <b><u>in English</u></b>.<br>");
    out.println("  An example of question is shown below for your reference. Please feel <br>");
    out.println("  free to change the example's wording to suit your query.</font>");
    out.println("<br>");
  
    for (int i = 0; i < noawb; i++) { 
     out.println("<table>\n");
     out.println("<tr>\n");
     out.println("<td><font SIZE=\"2\" face=\"Frutiger, Arial\" color=\"#a60018\">\n");
     out.println("<b>Airwaybill Number:</b></font></td>\n");
     out.println("<td><font size=\"2\" face=\"Frutiger, Arial\"><b>"+awblist[i]+" </b>\n");
     out.println("<input type=\"hidden\" name=\"awb"+i+"\" value=\""+awblist[i]+"\"></font></td>\n");
     out.println("</tr>\n\n");
     out.println("</table>");
     out.println("<table>");
     out.println("<tr valign=top>\n");
     out.println("<td><font size=\"2\" face=\"Frutiger, Arial\" color=#a60018>\n");
     out.println("<b>Remarks<br>(maximum 600<br>characters):</b></font></td>\n");
     out.println("<td>");
 
     //print 10 textboxes with maxlength of 60.
     //out.println("<input type=textbox name=rmks"+i+"_0 size=60 maxlength=60 value=\"Please check shipment delivery details\"><br>");
     out.println("<input type=textbox name=rmks"+i+"_0 size=60 maxlength=60 value=\"Please input your question.\"><br>");
     for (int tb = 1; tb < 10; tb++) {
        out.println("<input type=textbox name=rmks"+i+"_"+tb+" size=60 maxlength=60><br>");     	
     }

     out.println("</tr>\n\n");
     out.println("</table>");
     
    }
%>

   <br>
  <table> 
  <tr>
   <td>
<font SIZE="2" face="Frutiger, Arial">
<!--
&#60 &#60 note 1 - this URL is reserved for the enquiry and case registration of shipment under coloader's Hong Kong 63 account. &#62 &#62
<br>
&#60 &#60 note 2 - case can be registered after 24 hrs of pick up scan for shipment. &#62 &#62
<br><br>
Please kindly <a href="mailto:net012@dhl.com?cc=vicky.chan@dhl.com">email to net012@dhl.com cc to vicky.chan@dhl.com</a> if your enquiry belongs to following scenarios: <br>
1.  You had enquired the shipment before and now it is already over 30 days since your last enquiry. <br>
2.  Shipment already sent out or sent out over 90 calendar days, and you cannot see any shipment status via the URL. <br>
3.  You had registered a request for two days but there is without any acknowledgement response from DHL agent. <br>
4.  In case of top urgent issue that require DHL's immediate follow up but case cannot be registered over the web due to the time constraint. <br>
<br>
-->
Please read and agree <a href="https://apps.dhl.com.hk/statement/eng_hk/pics.html" target="_blank" rel="noopener noreferrer">Personal Information Collection Statement</a> before submission.

</font>
    </td>
    </tr>
    <tr><td><br>
      <input type=submit value="Send Request">&nbsp;&nbsp;
      <input type=reset value="Clear">
   </td>
      </tr>
    </table>


</form>

</blockquote>
<script src="/eng_st/js_client/copyright_a.js" nonce="<%=nonce%>"></script>

<script nonce="<%=nonce%>">
// reCAPTCHA v3 submit hook for dynamic form
document.addEventListener('DOMContentLoaded', function() {
  var form = document.getElementById('f_inp');
  if (!form) return;
  form.addEventListener('submit', function(e) {
    // 若 concat() 回傳 false，則不送出
    if (typeof concat === 'function' && concat(form, form.noawb ? form.noawb.value : 0) === false) {
      e.preventDefault();
      return;
    }
    e.preventDefault();
    grecaptcha.ready(function() {
      grecaptcha.execute('6LcB8dcZAAAAAJO9mElsjCkPrWVj1rXr2SH9ML_h', {action: 'submit'}).then(function(token) {
        document.getElementById('g-recaptcha-response').value = token;
        form.submit();
      });
    });
  });
});
</script>
</body>

<%
  }
}
%>

</html>

