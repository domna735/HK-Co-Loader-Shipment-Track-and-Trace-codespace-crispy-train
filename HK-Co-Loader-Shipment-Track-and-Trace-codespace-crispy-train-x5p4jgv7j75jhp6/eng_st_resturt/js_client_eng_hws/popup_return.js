// 外部化 Return 按鈕事件，CSP 安全

document.addEventListener('DOMContentLoaded', function() {
  var btn = document.getElementById('returnBtn');
  if (btn) btn.addEventListener('click', function() { window.close(); });
});
