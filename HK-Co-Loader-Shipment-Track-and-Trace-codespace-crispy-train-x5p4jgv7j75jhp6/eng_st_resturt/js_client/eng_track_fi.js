// eng_track_fi.js
// 動態收集勾選的 AWB 並填入 hidawb，送出前檢查至少有一個

document.addEventListener('DOMContentLoaded', function() {
  var form = document.getElementById('f_inp');
  if (!form) return;
  form.addEventListener('submit', function(e) {
    var checkboxes = form.querySelectorAll('input[type="checkbox"][name="awbchk"]:checked');
    var hidawb = form.querySelector('input[name="hidawb"]');
    var awbs = [];
    checkboxes.forEach(function(cb) {
      if (cb.value) awbs.push(cb.value);
    });
    if (awbs.length === 0) {
      alert('Please select at least one shipment for further investigation.');
      e.preventDefault();
      return false;
    }
    if (hidawb) hidawb.value = awbs.join('|');
    // 讓 reCAPTCHA JS 處理 submit
    // e.preventDefault(); // 不要阻止，讓 reCAPTCHA JS 處理
    return true;
  });
});
