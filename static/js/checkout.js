document.addEventListener('DOMContentLoaded', function () {
  const radios     = document.querySelectorAll('input[name="saved_address"]');
  const phoneInput = document.getElementById('phone');
  const addrInput  = document.getElementById('shipping_address');

  if (radios.length > 0) {
    radios.forEach(function (radio) {
      radio.addEventListener('change', function () {
        if (this.value !== 'new' && phoneInput && addrInput) {
          phoneInput.value = this.dataset.phone || '';
          addrInput.value  = this.dataset.address || '';
        }
      });
    });
  }
});
