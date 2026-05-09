/* ═══════════════════════════════════════════════
   RMDIOT — Shared Header JS
   Handles: hamburger toggle, mobile menu, close-on-outside-click
   ═══════════════════════════════════════════════ */

(function () {
    'use strict';

    function initHeader() {
        var toggle = document.getElementById('hamburger');
        var menu   = document.getElementById('mobileMenu');
        if (!toggle || !menu) return;

        toggle.addEventListener('click', function () {
            var isOpen = menu.classList.toggle('open');
            toggle.classList.toggle('active', isOpen);
            toggle.setAttribute('aria-expanded', isOpen);
        });

        // Close when clicking a link inside the menu
        menu.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                menu.classList.remove('open');
                toggle.classList.remove('active');
                toggle.setAttribute('aria-expanded', 'false');
            });
        });

        // Close when clicking outside
        document.addEventListener('click', function (e) {
            if (!menu.contains(e.target) && !toggle.contains(e.target)) {
                menu.classList.remove('open');
                toggle.classList.remove('active');
                toggle.setAttribute('aria-expanded', 'false');
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initHeader);
    } else {
        initHeader();
    }
})();
