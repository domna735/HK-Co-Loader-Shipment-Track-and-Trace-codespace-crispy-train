// 影像預載與滑鼠事件
var browserOK = false;
var pics;

// 檢查 JavaScript 1.1 支援（原本用於判斷 browserOK）
if (typeof navigator !== 'undefined' && navigator.javaEnabled && navigator.javaEnabled()) {
  browserOK = true;
  pics = new Array();
}

if (browserOK) {
  invest_1 = new Image();
  invest_2 = new Image();
  invest_1.src = '../images/invest_1.gif';
  invest_2.src = '../images/invest_2.gif';
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

var objPIC1;
if (typeof invest_2 !== 'undefined' && typeof invest_1 !== 'undefined') {
  objPIC1 = new objMouseChangeImg('PIC1', invest_2.src, invest_1.src);
}
