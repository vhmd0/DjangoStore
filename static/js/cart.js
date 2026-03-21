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

document.querySelectorAll('.prod-overlay').forEach(overlay => {
  overlay.addEventListener('click', e => e.stopPropagation());
});

document.querySelectorAll('.js-wishlist-form').forEach(form => {
  form.addEventListener('submit', function(e) {
    const btn = this.querySelector('button');
    const orig = btn.innerHTML;
    btn.innerHTML = '<i class="bi bi-check-circle-fill"></i> Added!';
    btn.style.background = 'var(--accent)';
    setTimeout(() => {
      btn.innerHTML = orig;
      btn.style.background = '';
    }, 1800);
  });
});
