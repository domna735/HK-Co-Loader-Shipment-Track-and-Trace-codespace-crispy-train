// 外部化原本 eng_track_home.html 末尾的 inline JS

document.addEventListener('DOMContentLoaded', function() {
  if (typeof grecaptcha === 'undefined' || !grecaptcha.ready) return;
  grecaptcha.ready(function() {
    var form = document.getElementById('home');
    if (!form) return;
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      grecaptcha.execute('6LcB8dcZAAAAAJO9mElsjCkPrWVj1rXr2SH9ML_h', {action: 'submit'}).then(function(token) {
        var tokenField = document.createElement('input');
        tokenField.type = 'hidden';
        tokenField.name = 'g-recaptcha-response';
        tokenField.value = token;
        form.appendChild(tokenField);
        if (typeof checkForm === 'function' && checkForm(form)) {
          form.submit();
        }
      });
    });
  });
});
