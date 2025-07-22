<!-- hide
var win;
var msie3=false;

browserVer=parseInt( navigator.appVersion );
if( browserVer == 2 && navigator.appName == "Microsoft Internet Explorer" ) {
  browserVer++;
  msie3=true;
}

var whitespace = " \t\n\r";

function winclose() {
  if( browserVer <= 2 )
    return true;
  if( msie3 != true && typeof( win ) == 'object' && !win.closed )
    win.close();
  return true;
}

function dhl_alert(name, text, height)
{    
  if( typeof( height) == "undefined" )
    height = 200;
  winclose();
  win=open( "", "dhl_alert", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=300,height=" + height);
  if( msie3 == true )
    while( typeof( win.document ) == "undefined" );

  win.document.write( "<!DOCTYPE html><html><head><title>International Shipment Tracking</title></head>\n");
  win.document.write( '<link rel="stylesheet" href="/eng_st/css/popup.css">'); // 如有 popup 樣式可加，沒有可移除
  win.document.write( "<body bgcolor=\"#FFFFFF\" text=\"#000000\" topmargin=0 leftmargin=0 rightmargin=0 marginheight=0 marginwidth=0 scroll=no>\n");
  win.document.write("<table width=\"103%\" border=0 cellspacing=0 cellpadding=0>");
  win.document.write("<tr bgcolor=\"#FFCC00\"><td>&nbsp;</td></tr>");
  win.document.write("<tr bgcolor=\"#CC0000\" valign=\"bottom\"><td height=\"45\">");
  win.document.write("<table height=\"100%\" width=\"100%\" border=0>");
  win.document.write("<tr valign=\"bottom\"><td width=\"2%\">&nbsp;</td><td><font color=\"#FFFFFF\" size=\"+1\" face=\"Arial\"><b>"+name+"</b></font></td></tr>");
  win.document.write("</table>");
  win.document.write("</td></tr>");
  win.document.write("<tr><td>");
  win.document.write("<table cellpadding=12 border=0 width=100%>");
  win.document.write("<tr><td><font face=\"Arial\" size=2>"+ text +"</font></td></tr>");
  win.document.write("<tr><td align=\"right\"><button id=\"returnBtn\">Return</button></td></tr>");
  win.document.write("</table>");
  win.document.write("</td></tr>");
  win.document.write("</table>");
  win.document.write('<script src="/eng_st/js_client_eng_hws/popup_return.js"></script>');
  win.document.write("</body></html>\n");
  win.document.close();
  return false;
}

function strip( instring )
{
  var outstring="";
  var bit="";
  var founddigit=false;

  for( j=0;j<instring.length;j++ ) {
    c=instring.charAt(j);
    if( c != " " && c !="\t" && c !="\n"  && c !="\r" ) {
      if( founddigit == true )
        outstring+=bit;
      bit="";
      outstring+=c;
      founddigit=true;
    }
    else if( founddigit == true )
      bit+=c;
  }
  return outstring;
}

function checkForm(form)
{
  if( browserVer <= 2 )
    return true;
  awb=strip( form.airbill.value );
  var awbs=new Array;
  var tmp="";
  var curr=0;
  for(i=0;i<awb.length;i++) {
    c=awb.charAt( i );
    d=parseInt( c );
    if( ( msie3==true && !( d==0 && c != "0" ) ) || ( msie3==false && !isNaN( d ) ) ) {
      tmp+=c;
    }
    else {
      if( tmp != "" ) {
        awbs[curr]=tmp;
        curr++;
        tmp="";
      }
    }
  }
  if( tmp != "" )
    awbs[curr]=tmp;

  num=awbs.length;

  if( num == 0 )
  {
     dhl_alert( "The Airwaybill No. is missing.", "Please enter a 10-digit Airwaybill No.", 180 );
     return false;
  }


  errors="";
  off=0;
  for( i=0 ; i< num ; i++ )
  {
    awbs[i]=strip( awbs[i] );
    if( awbs[i].length == 3 && awbs[i+1] && awbs[i+1].length == 4 && awbs[i+2] && awbs[i+2].length == 3 )
    {
      if( errors == "" )
        errors=""+(i+1);
      else
        errors+=(  ", " + (i+1-off) );
      off+=2;
    }
  }

  if( errors != "" ) {
    if( msie3 == false )
      numbad=errors.split( ", " );
    else
      numbad=new Array(2);
  if( numbad.length == 1 )
      dhl_alert( "Invalid Airwaybill No.", "Airwaybill No. " + numbad[0] + " has been split into 3 groups of digits.<BR>Airwaybill No. should be an unbroken string of 10-digits.<P>Please correct or remove this Airwaybill No.", 230 );
    else
      dhl_alert( "Invalid Airwaybill numbers", "Airwaybill numbers " + errors + " have all been split into 3 groups of digits.<BR>Airwaybill numbers should be an unbroken string of 10-digits.<P>Please correct or remove these Airwaybill numbers.", 230 );

    return false;
  }

  if( num > 10  ) {
     dhl_alert( "More than 10 shipments are input.", "Please enter a maximum of 10 shipments.", 180 );
     return false;
  }

  errors="";
  for( i=0 ; i< num ; i++ ) {
    awbs[i]=strip( awbs[i] );
    if( awbs[i].length != 10 && !isNaN( awbs[i] ) ) {
      if( errors == "" )
        errors=""+(i+1);
      else
        errors+=(  ", " + (i+1) );
    }
  }
  if( errors != "" ) {
    if( msie3 == false )
      numbad=errors.split( ", " );
    else
      numbad=new Array(2);

    if( numbad.length == 1 )
      dhl_alert( "Invalid Airwaybill No.", "The Airwaybill No. on row " + numbad[0] + " is not a 10-digit No.<P>Please enter a 10-digit Airwaybill No." );
    else
      dhl_alert( "Invalid Airwaybill numbers", "The Airwaybill numbers on rows " + errors + " are not 10-digit numbers.<P>Please enter 10-digit Airwaybill numbers." );

    return false;
  }

  errors="";
  for( i=0 ; i< num ; i++ ) {
    awbs[i]=strip( awbs[i] );
    check1=awbs[i].substring(9,10);
    tocheck=awbs[i].substring(0,9);
    check2=tocheck % 7;
    if( check1 != check2  && awbs[i] != "" ) {
      if( errors == "" )
        errors=""+(i+1);
      else
        errors+=(  ", " + (i+1) );
    }
  }
  if( errors != "" ) {
    if( msie3 == false )
      numbad=errors.split( ", " );
    else
      numbad=new Array(2);

    if( numbad.length == 1 )
      dhl_alert( "Invalid Airwaybill No.", "The Airwaybill No. on row " + numbad[0] + " is not a valid Airwaybill No.<P>Please correct or remove this Airwaybill No." );
    else
      dhl_alert( "Invalid Airwaybill numbers", "The Airwaybill numbers on rows " + errors + " are not valid airwaybill numbers.<P>Please correct or remove these Airwaybill numbers." );

    return false;
  }

  form.awb.value=awbs[0];

  for( i=1 ; i< num ; i++ )
    form.awb.value+="|"+awbs[i];

  return true;
}

function isEmpty(s)
{   return ((s == null) || (s.length == 0))
}

function isWhitespace (s)
{   var i;
    //var whitespace = " \t\n\r";

    // Is s empty?
    if (isEmpty(s)) return true;

    // Search through string's characters one by one
    // until we find a non-whitespace character.
    // When we do, return false; if we don't, return true.

    for (i = 0; i < s.length; i++)
    {   
        // Check that current character isn't whitespace.
        var c = s.charAt(i);

        if (whitespace.indexOf(c) == -1) return false;
    }

    // All characters are whitespace.
    return true;
}

function isDigit (c)
{   return ((c >= "0") && (c <= "9"))
}

function isEmail(s)
{
   var defaultEmptyOK = false

   if (isEmpty(s)) 
       if (isEmail.arguments.length == 1) return defaultEmptyOK;
       else return (isEmail.arguments[1] == true);
   
    // is s whitespace?
    if (isWhitespace(s)) return false;
    
    // there must be >= 1 character before @, so we
    // start looking at character position 1 
    // (i.e. second character)
    var i = 1;
    var sLength = s.length;

    // look for @
    while ((i < sLength) && (s.charAt(i) != "@"))
    { i++
    }

    if ((i >= sLength) || (s.charAt(i) != "@")) return false;
    else i += 2;

    // look for .
    while ((i < sLength) && (s.charAt(i) != "."))
    { i++
    }

    // there must be at least one character after the .
    if ((i >= sLength - 1) || (s.charAt(i) != ".")) return false;
    else return true;
}

function CheckStmInfo(theContactName, theCompanyName, thePhoneNum, theShpEmailAddr)
{
	//if (isEmpty(theContactName.value))
	if (isWhitespace(theContactName.value))
	{
		theContactName.focus()
		theContactName.select()
		dhl_alert("The name of the contact person is missing.", "Please enter the name of the contact person.", 180 );
		return false;	
	}
	
	if (containInvalidSymbol(theContactName.value))
	{
		theContactName.focus()
		theContactName.select()
		dhl_alert("The name of the contact person contains invalid symbol.", "Please remove invalid symbol.", 180 );
		return false;
	}
	
	
	if (!isWhitespace(theCompanyName.value))
	{
		if (containInvalidSymbol(theCompanyName.value))
		{
			theCompanyName.focus()
			theCompanyName.select()
			dhl_alert("The company name contains invalid symbol.", "Please remove invalid symbol.", 180 );
			return false;	
		}
		
	}
	
	//if (isEmpty(thePhoneNum.value))
	if (isWhitespace(thePhoneNum.value))
	{
		thePhoneNum.focus()
		thePhoneNum.select()
		dhl_alert("The phone number is missing.", "Please enter your phone number.", 180 );
		return false;	
	}
	
	if (!isValidPhone(thePhoneNum.value))
	{
		thePhoneNum.focus()
		thePhoneNum.select()
		dhl_alert("The phone number is invalid.", "Please enter valid phone number.", 180 );
		return false;	
	}
	
	//if (isEmpty(theShpEmailAddr.value))
	if (isWhitespace(theShpEmailAddr.value))
	{
		theShpEmailAddr.focus()
		theShpEmailAddr.select()
		dhl_alert("The email is missing.", "Please enter your email.", 180 );
		return false;	
		
	}		
	
	  if (!isEmail(theShpEmailAddr.value, true))
	  {
		theShpEmailAddr.focus()
		theShpEmailAddr.select()
		dhl_alert("Invalid Email Address", "You have not entered a valid email address.<P>Please enter.", 180 );
		return false;	
	  }
	  
	  if (containInvalidSymbol_Email(theShpEmailAddr.value, true))
	  {
		theShpEmailAddr.focus()
		theShpEmailAddr.select()
		dhl_alert("Invalid Email Address.", "You have not entered a valid email address.<P>Please enter.", 180 );
		return false;	
	  }
	
	return true;
}


// check to see if input is alphabetic
function isAlphabetic(str) {
	if (str.match(/^[a-zA-Z]+$/)) {
		return true;
	} else {
		return false;
	}
}

function isAlphaNum(s, n, type) {
    ttl = 0;
    for (i = 0; i < s.length; i++) {
    	var c = s.charAt(i);
    	
    	if (type == "Numeric" || type == "AlNum") {
    		if (isDigit(c)) {
    			ttl = ttl + 1;
    		} 
    	}
    	
    	if (type == "Alpha" || type == "AlNum") {
    		if (isAlphabetic(c)) {
    			ttl = ttl + 1;
    		}
    	}
    }
    
    if (ttl < n) {
    	return false;
    } else {
    	return true;
    }
}

function isValidPhone (s) {
    if (s.length < 5) {
      return false;
    } else {
	const firstDigit = s.charAt(0);
        var diffDigit = false;
	for (i = 0; i < s.length; i++) {
	    var c = s.charAt(i);
	    //if (isDigit(c) || isAlphabetic(c) || c == "+" || c == "-" || c == "_" || c == "(" || c == ")" || c == "{" || c == "}" || c == "[" || c == "]"  || c == "\\" || c == "/" || c == "#") {	        
	    if (!isDigit(c)) {
	       //if ((isAlphabetic(c)) || (containInvalidSymbol_Phone(c))) {
	           return false;
	       //}
	    } else {
               if (c != firstDigit) {
		   diffDigit = true;
	       }

            }

	}
        if (diffDigit) { 
	    return true;
	} else {
	    return false;
	}
    }
}

function containInvalidSymbol (s)
{   
		var i;
		//var InvalidSymbol = "`~!@#$%^*+={}|[]:;'<>?\\\"";
		var InvalidSymbol = "$%*=;<>?\\\"";
		
		//block: $%*=\;"<>?
		//used: `!@#&()-+[]:',./
		//not used: ~$%^*_={}|\;"<>?
		//still allow: ~^_{}|
		
		for (i = 0; i < s.length; i++)
		{   
			var c = s.charAt(i);	
			if (InvalidSymbol.indexOf(c) != -1) return true;
		}

		// All characters do not contain invalid symbol.
		return false;
}

function containInvalidSymbol_Email (s)
{   
		var i;
		var InvalidSymbol = "`~!#$%^&*()+={}|[]:;'<>?,/\\\"";
		//allow @.-_
		for (i = 0; i < s.length; i++)
		{   
			var c = s.charAt(i);	
			if (InvalidSymbol.indexOf(c) != -1) return true;
			if (whitespace.indexOf(c) != -1) return true;
		}

		// All characters do not contain invalid symbol.
		return false;
}

function containInvalidSymbol_Phone (s)
{
		var i;
		var InvalidSymbol = "`~!@#$%^&*_={}|[]:;'<>?,.\\\"";
		//allow +-() /
		
		for (i = 0; i < s.length; i++)
		{   
			var c = s.charAt(i);
			if (InvalidSymbol.indexOf(c) != -1) return true;
		}
		// All characters do not contain invalid symbol.
		return false;
}

// -->
