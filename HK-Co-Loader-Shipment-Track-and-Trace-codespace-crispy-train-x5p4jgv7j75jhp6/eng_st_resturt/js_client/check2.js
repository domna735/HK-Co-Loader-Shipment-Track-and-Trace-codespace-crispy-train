// --------------------                                     
// To initialize two variables as the page begin loaded     
// which will be used to verify the type of browser         
var isNav4, isIE4                                           
isNav = false;                                              
isIE4 = false;                                              
if (parseInt(navigator.appVersion.charAt(0)) >= 4) {                
  if (navigator.appName == "Netscape") {                    
    isNav = true;                                           
  } else if (navigator.appVersion.indexOf("MSIE") != -1) {  
    isIE4 = true;                                           
  }                                                         
}                                                           


function dhl_alert( theField, name, text, height )                              
{                                                                               
  if (!height) height = 200;                                                    
                                                                                
  if (isNav) {                                                                  
    if (typeof(newWin) != "undefined" && !newWin.closed) newWin.close(); 
    newWin=window.open("", "dhl_alert", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=300,height=" + height);    
    newWin.focus(); 
  } else if (isIE4) {                                                           
    if (typeof(newWin) != "undefined" && !newWin.closed) newWin.close(); 
    newWin=open("", "dhl_alert", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=300,height=" + height);
    newWin.focus();                                                             
  } else {                                                                      
    // all browsers with version 3.x or below
    newWin=window.open("", "dhl_alert", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=300,height=" + height);    
    newWin.focus();                                    
  }                                                                             
                                                                                
  newWin.document.write( "<HTML><HEAD><TITLE>"+ name +"</TITLE></HEAD>\n")


  newWin.document.write( "<script language=\"JavaScript\"> \n <!-- \n")


  newWin.document.write( "\nfunction private_MouseOver() \n")
  newWin.document.write( "{\nif (document.images) { eval(\"document.\" + this.stImageName + \".src=\\\'\" + this.stOverImage + \"\\\'\");}\n}\n")

  newWin.document.write( "\nfunction private_MouseOut() \n")
  newWin.document.write( "{\nif (document.images) { eval(\"document.\" + this.stImageName + \".src=\\\'\" + this.stOutImage + \"\\\'\");}\n}\n")

  newWin.document.write( "\n\nfunction objMouseChangeImg(stImageName, stOverImage, stOutImage) \n")
  newWin.document.write( "{\nthis.stImageName = stImageName; \n this.stOverImage = stOverImage; \n this.stOutImage = stOutImage; \n")
  newWin.document.write( " this.MouseOut = private_MouseOut; \n this.MouseOver = private_MouseOver; } \n ")

  newWin.document.write( "\n\nobjPIC1 = new objMouseChangeImg('PIC1', \'../images/return2.gif\', \'../images/return1.gif\'); ")
  
  newWin.document.write( "\n // --> </script> \n")

  newWin.document.write("<BODY BGCOLOR=\"#FFFFFF\">\n" );                                                           

  newWin.document.write( "<TABLE CELLPADDING=6 WIDTH=\"100\%\" HEIGHT=\"100\%\" BORDER=0><TR><TD BGCOLOR=\"#951314\"><FONT FACE=\"arial,helvetica\" COLOR=\"#FFFFFF\" SIZE=\"+1\"><B>" + name +"</B></FONT></TD></TR>" );                          
  newWin.document.write( "<TR><TD><FONT FACE=\"arial,helvetica\" SIZE=2>"+ text +"</FONT></TD></TR>" ); 
  
  newWin.document.write( "<TR><TD ALIGN=RIGHT><a href=\"javascript:window.close()\" onMouseOver=objPIC1.MouseOver() onMouseOut=objPIC1.MouseOut()><img src=../images/return1.gif border=0 name=PIC1></a></td></tr></TABLE>" );                                                                  
  newWin.document.write( "</BODY></HTML>\n" );                                     
  newWin.document.close();           
                                  
        //theField.focus();       
        //theField.select();      
                                  
}               

function isEmpty(s)                         
{   return ((s == null) || (s.length == 0)) 
}                                           
         
//
// Show notice in a popup window if the product TDD is selected.
// Nov 2002 by Nicole Choi

function check_prod(f) {
  	i=f.other.selectedIndex;
  	prod=f.other.options[i].value;
  	if (prod == "TDD") {
  	    ad_Width      = 470;
	    ad_Height     = 270;

            options    = "scrollbars=no,resizable=no,menubar=no,status=no,toolbar=no,location=no,directories=no," + "width=" + ad_Width + ",height=" + ad_Height + ",left=100,top=100";
    	    var remote=window.open('../TDD_Notice/eng_notice.html','popup',options);
            remote.focus();
	    return false;
	}
	return true;
}

function getSelectedRadio(buttonGroup) {
    // returns the array number of the selected radio button or -1 if no button is selected
    if (buttonGroup[0]) { // if the button group is an array (one button is not an array)
       for (var i=0; i<buttonGroup.length; i++) {
            if (buttonGroup[i].checked) {
            return i
            }
       }
    }
}
function getSelectedRadioValue(buttonGroup) {
                             // returns the value of the selected radio button or "" if no button is selected
                             var i = getSelectedRadio(buttonGroup);
                             if (i == -1) {
                                return "";
                             } else {
                                if (buttonGroup[i]) { // Make sure the button group is an array (not just one button)
                                   return buttonGroup[i].value;
                                } else { // The button group is just the one button, and it is checked
                                   return buttonGroup.value;
                                }
                             }
 } // Ends the "getSelectedRadioValue" function         


function isAlphaNum (s) {
    //var whitespace = " \t\n\r";
    var whitespace = " \n\r";
    
    for (i = 0; i < s.length; i++)
    {   
        var c = s.charAt(i);
        
        if (!(isAlphabetic(c) || isDigit(c))) {
            if ((!isValidSymbol(c)) && (whitespace.indexOf(c) == -1)) {
        	return false;
            }
        }    	
    }
    return true;
}

function isAlphaNum_acno (s) {
    //var whitespace = " \t\n\r";
    var whitespace = " \n\r";
    
    for (i = 0; i < s.length; i++)
    {   
        var c = s.charAt(i);
        
        if (!(isAlphabetic(c) || isDigit(c))) {
            //if ((!isValidSymbol(c)) && (whitespace.indexOf(c) == -1)) {
        	return false;
            //}
        }    	
    }
    return true;
}

function isDigit (c)
{   return ((c >= "0") && (c <= "9"))
}

function isAlphabetic(str) {
	if (str.match(/^[a-zA-Z]+$/)) {
		return true;
	} else {
		return false;
	}
}

function isValidSymbol (s)
{   
    var i;
    var Symbol = "`~!@#$%^&*()_-+={}|[]:;'<>?,./\\\"";
                  
    if (Symbol.indexOf(s) != -1) return true;
    
    return false;
}

