/* ZenTech — chuyển động theo cuộn chuột, con trỏ và click. Xem motion.css. */
(function () {
    'use strict';
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    var de = document.documentElement, fine = window.matchMedia('(pointer: fine)').matches;
    de.classList.add('zt-js');
    var $ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };

    // ---- Thanh tiến độ cuộn + header ----
    var bar = document.createElement('div'); bar.id = 'zt-progress'; document.body.appendChild(bar);
    var header = document.getElementById('main-header');
    var target = 0, cur = 0, mx = 0, my = 0, tmx = 0, tmy = 0, ticking = false;

    function frame(t) {
        cur += (target - cur) * .09; mx += (tmx - mx) * .06; my += (tmy - my) * .06;
        var max = Math.max(1, de.scrollHeight - innerHeight), p = Math.min(1, Math.max(0, cur / max));
        bar.style.transform = 'scaleX(' + (window.scrollY / max).toFixed(4) + ')';
        $('[data-par]').forEach(function (el) {
            var r = el.getBoundingClientRect();
            if (r.bottom < -200 || r.top > innerHeight + 200) return;
            el.style.transform = 'translate3d(0,' + (((r.top + r.height / 2 - innerHeight / 2) * parseFloat(el.dataset.par)) * -1).toFixed(1) + 'px,0)';
        });
        if (!document.hidden) requestAnimationFrame(frame);
    }
    addEventListener('scroll', function () { target = window.scrollY; if (header) header.classList.toggle('zt-scrolled', target > 8); }, { passive: true });
    if (fine) addEventListener('pointermove', function (e) { tmx = e.clientX / innerWidth - .5; tmy = e.clientY / innerHeight - .5; }, { passive: true });
    target = cur = window.scrollY; requestAnimationFrame(frame);
    document.addEventListener('visibilitychange', function () { if (!document.hidden) requestAnimationFrame(frame); });

    // ---- Hiện dần khi cuộn tới, các thẻ trong cùng hàng vào lần lượt ----
    var rvSel = 'main section > *, main article, main h1, main h2, main table, main form, footer > div';
    var io = new IntersectionObserver(function (es) {
        es.forEach(function (e) { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } });
    }, { threshold: .12, rootMargin: '0px 0px -6% 0px' });
    function arm(root) {
        $(rvSel, root).forEach(function (el) {
            if (el.classList.contains('zt-rv') || el.closest('[data-no-reveal]') || el.closest('dialog')) return;
            var sib = el.parentElement ? Array.prototype.indexOf.call(el.parentElement.children, el) : 0;
            el.style.setProperty('--d', Math.min(sib, 8) * 70 + 'ms'); el.classList.add('zt-rv'); io.observe(el);
        });
    }
    arm(document);

    // ---- Thẻ sản phẩm nghiêng theo con trỏ ----
    if (fine) {
        document.addEventListener('pointermove', function (e) {
            var st = e.target.closest && e.target.closest('article .stage');
            if (!st) return;
            var r = st.getBoundingClientRect(), x = (e.clientX - r.left) / r.width - .5, y = (e.clientY - r.top) / r.height - .5;
            st.classList.add('zt-tilt'); st.style.setProperty('--ry', (x * 10).toFixed(1) + 'deg'); st.style.setProperty('--rx', (-y * 10).toFixed(1) + 'deg');
        }, { passive: true });
        document.addEventListener('pointerout', function (e) {
            var st = e.target.closest && e.target.closest('article .stage');
            if (st && !st.contains(e.relatedTarget)) { st.style.setProperty('--rx', '0deg'); st.style.setProperty('--ry', '0deg'); }
        });
    }


    // ---- Bay vào giỏ hàng: ztFly(phầnTửẢnh) ----
    window.ztFly = function (src) {
        var cart = document.getElementById('cart-badge'); cart = cart && (cart.closest('a,button') || cart);
        if (!src || !cart) return;
        var a = src.getBoundingClientRect(), c = cart.getBoundingClientRect();
        var im = document.createElement('img'); im.src = src.currentSrc || src.src; im.className = 'zt-fly';
        im.style.cssText += 'left:' + a.left + 'px;top:' + a.top + 'px;width:' + a.width + 'px;height:' + a.height + 'px';
        document.body.appendChild(im);
        var dx = c.left + c.width / 2 - (a.left + a.width / 2), dy = c.top + c.height / 2 - (a.top + a.height / 2);
        var an = im.animate([{ transform: 'translate(0,0) scale(1)', opacity: 1 }, { transform: 'translate(' + dx * .55 + 'px,' + (dy * .55 - 90) + 'px) scale(.45)', opacity: 1, offset: .55 }, { transform: 'translate(' + dx + 'px,' + dy + 'px) scale(.08)', opacity: .2 }], { duration: 850, easing: 'cubic-bezier(.5,0,.4,1)' });
        an.onfinish = function () { im.remove(); var bd = document.getElementById('cart-badge'); if (bd) { bd.classList.remove('zt-bump'); void bd.offsetWidth; bd.classList.add('zt-bump'); } };
    };
})();
