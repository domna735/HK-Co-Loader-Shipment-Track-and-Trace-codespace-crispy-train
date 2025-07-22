// 外部化自 eng_track.jsp 的所有 inline JS

// 1. browserOK, pics 變數宣告
var browserOK = false;
var pics;

// 2. JavaScript 1.1 browser 檢查
browserOK = true;
pics = new Array();

// 3. 預載圖片與滑鼠事件
var invest_1, invest_2;
if (typeof window !== 'undefined') {
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

var objPIC1 = new objMouseChangeImg('PIC1', '../images/invest_2.gif', '../images/invest_1.gif');

// 4. doOpen1 function
function doOpen1() {
  var remote1 = window.open('fipop.html', 'remote1', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=350,height=230');
  if (remote1 && remote1.focus) remote1.focus();
}

// 5. merge function (JSP 產生，需由 JSP 動態產生 nawb)

// 動態產生的 merge function，nawb 由 JSP 產生（這裡用自動偵測）
window.merge = function(f) {
  var selected = false;
  f.hidawb.value = "";
  // 自動偵測 checkbox 數量
  var i = 0;
  while (f["cb" + i]) {
    if (f["cb" + i].value != "NA") {
      if (f["cb" + i].checked) {
        if (!selected) {
          selected = true;
          f.hidawb.value = f["cb" + i].value;
        } else {
          f.hidawb.value += "|" + f["cb" + i].value;
        }
      }
    }
    i++;
  }
  if (!selected) {
    if (typeof dhl_alert === 'function') {
      dhl_alert("Missing/Invalid Value", "Further investigation tick box is not selected. Please select the box to specify the investigation.", 230);
    } else {
      alert("Further investigation tick box is not selected. Please select the box to specify the investigation.");
    }
    return false;
  }
  return true;
};

// 6. reCAPTCHA v3 submit hook for dynamic form
// 注意：請將 site key 替換為你自己的 reCAPTCHA v3 site key

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
