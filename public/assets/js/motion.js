/* ZenTech — chuyển động theo cuộn chuột, con trỏ và click. Xem motion.css. */
(function () {
    'use strict';
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    var de = document.documentElement, fine = window.matchMedia('(pointer: fine)').matches;
    de.classList.add('zt-js');
    var $ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };

    // ---- Nền chuyển động + thanh tiến độ + header ----
    var bg = document.createElement('div'); bg.className = 'zt-bg'; bg.setAttribute('aria-hidden', 'true');
    bg.innerHTML = '<i class="zt-blob b1"></i><i class="zt-blob b2"></i><i class="zt-blob b3"></i><i class="zt-blob b4"></i><i class="zt-ring r1"></i><i class="zt-ring r2"></i>';
    document.body.prepend(bg);
    var bar = document.createElement('div'); bar.id = 'zt-progress'; document.body.appendChild(bar);

    // ---- Bong bóng xà phòng: lượn lờ, trôi theo cuộn, né con trỏ, click vào thì vỡ ----
    var cv = document.createElement('canvas'); bg.appendChild(cv); cv.style.cssText = 'position:absolute;inset:0;width:100%;height:100%';
    var cx = cv.getContext('2d'), W = 0, H = 0, dpr = Math.min(2, window.devicePixelRatio || 1), bubbles = [], drops = [], lastY = window.scrollY, lastT = 0;
    function size() { W = innerWidth; H = innerHeight; cv.width = W * dpr; cv.height = H * dpr; cx.setTransform(dpr, 0, 0, dpr, 0, 0); }
    function spawn(b, anywhere) {
        var r = 16 + Math.pow(Math.random(), 1.8) * 70;
        b = b || {}; b.r = r; b.z = r / 86;                        // z: bóng to ở "gần" nên trôi theo cuộn nhiều hơn
        b.x = Math.random() * W; b.y = anywhere ? Math.random() * H : H + r + Math.random() * 200;
        b.vx = 0; b.vy = -(10 + Math.random() * 22) * (.5 + b.z); b.ph = Math.random() * 6.28; b.sw = 14 + Math.random() * 26; b.hue = Math.random() * 360; b.wob = Math.random() * 6.28;
        return b;
    }
    function init() { size(); var n = Math.round(Math.min(34, Math.max(14, W / 48))); bubbles = []; for (var i = 0; i < n; i++) bubbles.push(spawn(null, true)); }
    function draw(b, t) {
        var wob = 1 + Math.sin(t / 700 + b.wob) * .05, rx = b.r * wob, ry = b.r / wob, h = (b.hue + t / 40) % 360;
        cx.save(); cx.translate(b.x, b.y);
        var g = cx.createRadialGradient(0, 0, b.r * .15, 0, 0, b.r);
        g.addColorStop(0, 'hsla(' + h + ',90%,85%,0)'); g.addColorStop(.72, 'hsla(' + h + ',90%,80%,.10)');
        g.addColorStop(.92, 'hsla(' + (h + 70) % 360 + ',95%,72%,.34)'); g.addColorStop(1, 'hsla(' + (h + 150) % 360 + ',95%,70%,.55)');
        cx.beginPath(); cx.ellipse(0, 0, rx, ry, 0, 0, 6.2832); cx.fillStyle = g; cx.fill();
        cx.lineWidth = 1.2; cx.strokeStyle = 'hsla(' + (h + 200) % 360 + ',80%,65%,.45)'; cx.stroke();
        cx.beginPath(); cx.ellipse(-rx * .38, -ry * .42, rx * .22, ry * .12, -.7, 0, 6.2832); cx.fillStyle = 'rgba(255,255,255,.95)'; cx.fill();
        cx.beginPath(); cx.ellipse(-rx * .38, -ry * .42, rx * .22, ry * .12, -.7, 0, 6.2832); cx.strokeStyle = 'rgba(120,150,255,.35)'; cx.lineWidth = 1; cx.stroke();
        cx.beginPath(); cx.arc(0, 0, rx * .78, .35, 1.25); cx.strokeStyle = 'hsla(' + (h + 100) % 360 + ',90%,70%,.45)'; cx.lineWidth = 2; cx.stroke();
        cx.restore();
    }
    function pop(b) {
        for (var i = 0; i < 12; i++) { var a = i / 12 * 6.2832 + Math.random() * .5; drops.push({ x: b.x + Math.cos(a) * b.r, y: b.y + Math.sin(a) * b.r, vx: Math.cos(a) * (60 + Math.random() * 80), vy: Math.sin(a) * (60 + Math.random() * 80), life: 1, h: b.hue }); }
        spawn(b, false);
    }
    function stepBubbles(t) {
        var dt = Math.min(.05, (t - lastT) / 1000 || .016); lastT = t;
        var dy = window.scrollY - lastY; lastY = window.scrollY;
        cx.clearRect(0, 0, W, H);
        bubbles.forEach(function (b) {
            b.y += b.vy * dt - dy * (.25 + b.z * .6);                // cuộn xuống thì bóng trôi lên nhanh hơn
            b.x += (Math.cos(t / 1800 + b.ph) * b.sw) * dt + b.vx * dt;
            b.vx *= .94;
            if (fine) {                                              // né con trỏ
                var px = (tmx + .5) * W, py = (tmy + .5) * H, ddx = b.x - px, ddy = b.y - py, d = Math.hypot(ddx, ddy), lim = b.r + 110;
                if (d < lim && d > 1) { var f = (1 - d / lim) * 520 * dt; b.vx += ddx / d * f * 8; b.y += ddy / d * f; }
            }
            if (b.y < -b.r - 40 || b.y > H + b.r + 600 || b.x < -b.r - 120 || b.x > W + b.r + 120) spawn(b, false);
            draw(b, t);
        });
        drops = drops.filter(function (p) { return p.life > 0; });
        drops.forEach(function (p) { p.x += p.vx * dt; p.y += p.vy * dt + 40 * dt; p.vx *= .96; p.vy *= .96; p.life -= dt * 1.8; cx.beginPath(); cx.arc(p.x, p.y, 2.6 * p.life + .4, 0, 6.2832); cx.fillStyle = 'hsla(' + (p.h + 60) % 360 + ',90%,70%,' + (p.life * .7).toFixed(2) + ')'; cx.fill(); });
    }
    addEventListener('resize', init); init();
    document.addEventListener('pointerdown', function (e) {
        for (var i = 0; i < bubbles.length; i++) { var b = bubbles[i]; if (Math.hypot(e.clientX - b.x, e.clientY - b.y) < b.r) { pop(b); break; } }
    });
    var blobs = $('.zt-blob, .zt-ring', bg), speed = [.22, -.16, .3, -.12, -.35, .28];
    var header = document.getElementById('main-header');
    var target = 0, cur = 0, mx = 0, my = 0, tmx = 0, tmy = 0, ticking = false;

    function frame(t) {
        cur += (target - cur) * .09; mx += (tmx - mx) * .06; my += (tmy - my) * .06;
        var max = Math.max(1, de.scrollHeight - innerHeight), p = Math.min(1, Math.max(0, cur / max));
        bg.style.setProperty('--p', p.toFixed(3));
        bar.style.transform = 'scaleX(' + (window.scrollY / max).toFixed(4) + ')';
        blobs.forEach(function (b, i) {
            var drift = Math.sin(t / 3200 + i * 1.7) * 24;
            b.style.transform = 'translate3d(' + (mx * (14 + i * 6) + drift).toFixed(1) + 'px,' + (-cur * speed[i] + my * (14 + i * 6) + drift).toFixed(1) + 'px,0) scale(' + (1 + p * .25 * (i % 2 ? -1 : 1)).toFixed(3) + ')';
        });
        $('[data-par]').forEach(function (el) {
            var r = el.getBoundingClientRect();
            if (r.bottom < -200 || r.top > innerHeight + 200) return;
            el.style.transform = 'translate3d(0,' + (((r.top + r.height / 2 - innerHeight / 2) * parseFloat(el.dataset.par)) * -1).toFixed(1) + 'px,0)';
        });
        stepBubbles(t);
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

    // ---- Click: vòng tròn và các chấm bắn ra ----
    document.addEventListener('pointerdown', function (e) {
        if (e.button) return;
        var b = document.createElement('div'); b.className = 'zt-burst'; b.style.left = e.clientX + 'px'; b.style.top = e.clientY + 'px';
        var h = '<b></b>', cols = ['#0f5de0', '#7a5cff', '#ff5fd2', '#2ee6ff'];
        for (var i = 0; i < 8; i++) { var a = i / 8 * Math.PI * 2 + Math.random() * .4, d = 34 + Math.random() * 30; h += '<i style="--x:' + (Math.cos(a) * d).toFixed(0) + 'px;--y:' + (Math.sin(a) * d).toFixed(0) + 'px;--c:' + cols[i % 4] + '"></i>'; }
        b.innerHTML = h; document.body.appendChild(b); setTimeout(function () { b.remove(); }, 800);
    });

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
