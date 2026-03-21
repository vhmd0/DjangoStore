document.querySelectorAll('.js-cart-form').forEach(form => {
  form.addEventListener('submit', function(e) {
    const btn = this.querySelector('button');
    btn.innerHTML = '<i class="bi bi-check-circle-fill"></i> Added!';
    btn.style.background = 'var(--accent)';
    btn.style.color = '#fff';
    setTimeout(() => {
      btn.innerHTML = '<i class="bi bi-cart-plus"></i> Add to Cart';
      btn.style.background = '';
      btn.style.color = '';
    }, 1800);
  });
});
