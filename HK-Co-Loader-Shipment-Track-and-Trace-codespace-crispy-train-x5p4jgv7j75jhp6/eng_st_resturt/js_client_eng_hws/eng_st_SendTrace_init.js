// 外移自 eng_st_SendTrace.jsp 的 inline script
var browserOK = false;
var pics;

if (typeof window !== 'undefined') {
  // JavaScript 1.1 browser - oh yes!
  browserOK = true;
  pics = new Array();
}

if (browserOK) {
  var nextt1 = new Image();
  var nextt2 = new Image();
  nextt1.src = '../images/nextt1.gif';
  nextt2.src = '../images/nextt2.gif';
}

function private_MouseOver() {
  if (document.images) {
    eval("document." + this.stImageName + ".src='" + this.stOverImage + "'");
  }
}

function private_MouseOut() {
  if (document.images) {
    eval("document." + this.stImageName + ".src='" + this.stOutImage + "'");
  }
}

function objMouseChangeImg(stImageName, stOverImage, stOutImage) {
  this.stImageName = stImageName;
  this.stOverImage = stOverImage;
  this.stOutImage = stOutImage;
  this.MouseOut = private_MouseOut;
  this.MouseOver = private_MouseOver;
}

var objPIC1 = new objMouseChangeImg('PIC1', '../images/nextt2.gif', '../images/nextt1.gif');
