document.addEventListener('DOMContentLoaded', function () {
  fixRTLDropdowns();
});

function fixRTLDropdowns() {
  if (document.documentElement.dir !== 'rtl') return;
  document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
    if (menu.closest('.lang-switcher')) return;
    if (menu.classList.contains('dropdown-menu-end')) {
      menu.classList.remove('dropdown-menu-end');
      menu.classList.add('dropdown-menu-start');
    }
  });
}
