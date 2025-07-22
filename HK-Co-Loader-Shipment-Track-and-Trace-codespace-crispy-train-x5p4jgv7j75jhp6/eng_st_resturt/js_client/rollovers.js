document.write('<link rel="STYLESHEET" type="text/css" href="../css/common.css">');

function loadTop(head, lang, path)
{	
document.write('<BODY BGCOLOR="#FFFFFF" TEXT="#000000" topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" SCROLL="NO">');
document.write('<table width="103%" border="0" CELLSPACING=0 CELLPADDING=0>');
document.write('<tr bgcolor="#FFCC00"><td>&nbsp;</td></tr>');
document.write('<tr bgcolor="#CC0000" valign="bottom"><td height="50">');
document.write('<table height="100%" width="100%" border="0">');
document.write('<tr valign="bottom"><td width="2%">&nbsp;</td><td><font color="#FFFFFF" size="4" face="Arial"><b>'+head+'</b></font></td>');
document.write('<td width="10%" nowrap>');

if (lang == "eng") {
  document.write('<a href="javascript:parent.location.href=\'../'+path+'\';"><font face="Arial,·s²Ó©úÅé" size="3" color="#FFFFFF">English</font>');
} else if (lang == "big5") {
  document.write('<a href="javascript:parent.location.href=\'../'+path+'\';"><font face="Arial,·s²Ó©úÅé" size="3" color="#FFFFFF">&#20013;&#25991;</font>');
}

document.write('</a></td></tr>');
document.write('</table>');
document.write('</td></tr>');
document.write('</table>');
document.write('</body>');
}
	
function doPopup1(s, windowname) {
	var scrWt=(screen.availWidth) ? screen.availWidth : 800;var scrHt=(screen.availHeight) ? screen.availHeight : 600;
	var winWt = 593;
	var winHt = 588;	
	if ((winWt > scrWt)) winWt=scrWt-100;
	if ((winHt > scrHt-75)) winHt=scrHt-75;
	var posLinks=(scrWt-winWt)/2;
	var posTop=(scrHt-winHt)/2-20;
	window.open(s, windowname, 'width='+winWt+',height='+winHt+',left='+posLinks+',top='+posTop+',location=no,menubar=no,toolbar=no,resizable=no');
}

function doPopup2(s, windowname) {
	var scrWt=(screen.availWidth) ? screen.availWidth : 800;var scrHt=(screen.availHeight) ? screen.availHeight : 600;
	var winWt = 593;
	var winHt = 588;	
	if ((winWt > scrWt)) winWt=scrWt-100;
	if ((winHt > scrHt-75)) winHt=scrHt-75;
	var posLinks=((scrWt-winWt)/2)+20;
	var posTop=((scrHt-winHt)/2-20)+20;
        window.open(s, windowname, 'width='+winWt+',height='+winHt+',left='+posLinks+',top='+posTop+',location=no,menubar=no,toolbar=no,resizable=no');
}

function doPopup3(s) {
	window.open(s, 'hws');
}

var image = new Object();

function preloadImage(name, state, src)
{
  if (!image[name]) image[name] = new Object();
  image[name][state] = new Image();
  image[name][state].src = src;
}

function swapImageById(img, name, state)
{
  if (image[name])
  {
    //img = document.images[img];
    //img.src = image[name][state].src;
    document.images[img].src = image[name][state].src;
    
  }
}

preloadImage('arrow', 'off', '../images/arrow_r.gif');
preloadImage('arrow', 'on', '../images/arrow_y.gif');


