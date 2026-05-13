/* ═══════════════════════════════════════════════
   RMDIOT — Shared Header JS
   Handles: hamburger toggle, mobile menu, close-on-outside-click,
            page transition animation
   ═══════════════════════════════════════════════ */

(function () {
    'use strict';

    /* ── Hamburger / Mobile Menu ── */
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

    /* ── Page Transition ── */
    function initPageTransitions() {
        // Duration must match the CSS pageFadeOut animation
        var EXIT_MS = 280;

        document.addEventListener('click', function (e) {
            // Only handle left-clicks without modifier keys
            if (e.ctrlKey || e.metaKey || e.shiftKey || e.altKey || e.button !== 0) return;

            // Walk up to find the nearest <a>
            var anchor = e.target.closest('a');
            if (!anchor) return;

            var href = anchor.getAttribute('href');
            if (!href) return;

            // Skip hash-only links, javascript: links, mailto:, tel:, and external links
            if (
                href.startsWith('#') ||
                href.startsWith('javascript:') ||
                href.startsWith('mailto:') ||
                href.startsWith('tel:') ||
                anchor.target === '_blank'
            ) return;

            // Skip external links
            try {
                var linkUrl = new URL(href, window.location.origin);
                if (linkUrl.origin !== window.location.origin) return;
            } catch (_) {
                return;
            }

            // Prevent default navigation
            e.preventDefault();

            // Apply exit animation
            document.body.classList.add('page-exit');

            // Navigate after animation completes
            setTimeout(function () {
                window.location.href = href;
            }, EXIT_MS);
        });

        // Restore body state when navigating back via bfcache
        window.addEventListener('pageshow', function (e) {
            if (e.persisted) {
                document.body.classList.remove('page-exit');
            }
        });
    }

    /* ── Boot ── */
    function init() {
        initHeader();
        initPageTransitions();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
