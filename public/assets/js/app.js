/**
 * ZenTech Frontend Client Application
 * Vanilla JavaScript (Zero External Dependencies)
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Cập nhật số lượng giỏ hàng theo thời gian thực
    ZenTechApp.updateCartBadge();
});

const ZenTechApp = (function() {

    /**
     * Cập nhật badge số lượng giỏ hàng trên header
     */
    async function updateCartBadge() {
        try {
            const res = await fetch('/cart/count');
            if (res.ok) {
                const data = await res.json();
                const badge = document.getElementById('cart-badge');
                if (badge) {
                    badge.textContent = data.count || 0;
                    if (data.count > 0) {
                        badge.classList.remove('hidden');
                    } else {
                        badge.classList.add('hidden');
                    }
                }
            }
        } catch (e) {
            // Silently ignore if offline
        }
    }

    /**
     * Hệ thống Toast thông báo nổi hiện đại (Cyber style)
     */
    function showToast(message, type = 'success', duration = 3000) {
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'fixed top-5 right-5 z-[9999] flex flex-col gap-2.5 pointer-events-none max-w-sm w-full px-4';
            document.body.appendChild(container);
        }

        const toast = document.createElement('div');
        toast.className = `pointer-events-auto flex items-center gap-3 p-4 rounded-2xl backdrop-blur-xl border shadow-2xl transition-all duration-300 transform translate-x-full text-xs font-semibold ${
            type === 'success' 
                ? 'bg-zinc-900/95 text-green-400 border-green-500/30 shadow-green-500/10' 
                : 'bg-zinc-900/95 text-red-400 border-red-500/30 shadow-red-500/10'
        }`;

        toast.innerHTML = `
            <span class="text-base">${type === 'success' ? '✓' : '✕'}</span>
            <span class="flex-1 text-zinc-100">${escapeHtml(message)}</span>
            <button onclick="this.parentElement.remove()" class="text-zinc-500 hover:text-white">&times;</button>
        `;

        container.appendChild(toast);

        // Slide in
        requestAnimationFrame(() => {
            toast.classList.remove('translate-x-full');
            toast.classList.add('translate-x-0');
        });

        // Auto remove
        setTimeout(() => {
            toast.classList.add('opacity-0', 'scale-95');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    /**
     * Helper Escape HTML
     */
    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    /**
     * Format tiền tệ Việt Nam Đồng
     */
    function formatVND(amount) {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
    }

    // Thêm nhanh vào giỏ từ thẻ sản phẩm (nút có data-quick-add="<product id>")
    document.addEventListener('click', async (e) => {
        const btn = e.target.closest('[data-quick-add]');
        if (!btn || btn.disabled) return;
        e.preventDefault();
        btn.disabled = true;
        try {
            const res = await fetch('/cart/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ product_id: btn.dataset.quickAdd, quantity: 1 }),
            });
            const data = await res.json();
            showToast(data.message || (data.success ? 'Đã thêm vào giỏ hàng!' : 'Không thể thêm vào giỏ hàng.'), data.success ? 'success' : 'error');
            if (data.success) {
                updateCartBadge();
                if (window.ztFly) ztFly(btn.parentElement.querySelector('img'));
            }
        } catch (err) {
            showToast('Lỗi kết nối máy chủ, vui lòng thử lại.', 'error');
        } finally {
            btn.disabled = false;
        }
    });

    // ---- Yêu thích: nút tim trên thẻ sản phẩm (data-wish) ----
    function setWishBadge(n) {
        const b = document.getElementById('wish-badge');
        if (b) { b.textContent = n; b.classList.toggle('hidden', n <= 0); }
    }
    document.addEventListener('click', async (e) => {
        const btn = e.target.closest('[data-wish]');
        if (!btn || btn.disabled) return;
        e.preventDefault();
        btn.disabled = true;
        try {
            const res = await fetch('/wishlist/toggle', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ product_id: +btn.dataset.wish }) });
            const d = await res.json();
            if (!d.success) throw new Error();
            btn.setAttribute('aria-pressed', d.wished ? 'true' : 'false');
            btn.classList.toggle('text-red-500', d.wished); btn.classList.toggle('text-zinc-500', !d.wished);
            btn.querySelector('svg')?.setAttribute('fill', d.wished ? 'currentColor' : 'none');
            setWishBadge(d.count);
            showToast(d.wished ? 'Đã lưu vào yêu thích.' : 'Đã bỏ khỏi yêu thích.', 'success', 1800);
            const grid = document.getElementById('wish-grid');
            if (grid && !d.wished) {                       // trang Yêu thích: bỏ thẻ khỏi danh sách
                const card = btn.closest('article'); card.style.transition = 'opacity .3s, transform .3s'; card.style.opacity = 0; card.style.transform = 'scale(.95)';
                setTimeout(() => { card.remove(); const n = grid.querySelectorAll('article').length;
                    document.getElementById('wish-summary').textContent = n + ' sản phẩm đã lưu'; if (!n) location.reload(); }, 300);
            }
        } catch (err) { showToast('Không cập nhật được yêu thích, thử lại sau.', 'error'); }
        finally { btn.disabled = false; }
    });

    // ---- So sánh: chọn tối đa 3 sản phẩm (lưu ở trình duyệt), thanh nổi ở đáy màn hình ----
    const CMP_KEY = 'zt_compare', CMP_MAX = 3;
    const cmpGet = () => { try { return JSON.parse(localStorage.getItem(CMP_KEY)) || []; } catch (e) { return []; } };
    const cmpSet = (l) => { try { localStorage.setItem(CMP_KEY, JSON.stringify(l)); } catch (e) {} cmpRender(); };
    function cmpRender() {
        const list = cmpGet();
        document.querySelectorAll('[data-compare]').forEach(b => {
            const on = list.some(x => x.id === +b.dataset.compare);
            b.setAttribute('aria-pressed', on ? 'true' : 'false');
            b.classList.toggle('!bg-accent-500', on); b.classList.toggle('!text-on', on);
            const t = b.querySelector('span'); if (t) t.textContent = on ? 'Đã chọn' : 'So sánh';
        });
        let tray = document.getElementById('cmp-tray');
        if (!list.length || location.pathname === '/so-sanh') { tray && tray.remove(); return; }
        if (!tray) { tray = document.createElement('div'); tray.id = 'cmp-tray'; tray.setAttribute('role', 'region'); tray.setAttribute('aria-label', 'Sản phẩm đang so sánh');
            tray.className = 'fixed left-1/2 -translate-x-1/2 bottom-4 z-40 max-w-[calc(100vw-2rem)] flex items-center gap-3 rounded-2xl bg-zinc-950 border border-zinc-800 shadow-xl px-3 py-2.5'; document.body.appendChild(tray); }
        tray.innerHTML = list.map(x => `<span class="relative"><img src="${x.img}" alt="${x.name.replace(/"/g, '')}" class="w-11 h-11 rounded-xl object-contain bg-zinc-900"><button type="button" data-cmp-remove="${x.id}" aria-label="Bỏ ${x.name.replace(/"/g, '')} khỏi so sánh" class="absolute -top-2 -right-2 w-6 h-6 rounded-full bg-zinc-100 border border-zinc-800 text-xs leading-none">×</button></span>`).join('')
            + `<a href="/so-sanh?ids=${list.map(x => x.id).join(',')}" class="btn-primary !py-2.5 !px-4 text-sm whitespace-nowrap ${list.length < 2 ? 'opacity-60' : ''}">So sánh (${list.length})</a>`
            + `<button type="button" data-cmp-clear class="text-sm text-zinc-400 hover:text-zinc-100 px-1">Xóa</button>`;
    }
    document.addEventListener('click', (e) => {
        const add = e.target.closest('[data-compare]');
        if (add) {
            e.preventDefault();
            const id = +add.dataset.compare, list = cmpGet(), at = list.findIndex(x => x.id === id);
            if (at >= 0) list.splice(at, 1);
            else if (list.length >= CMP_MAX) return showToast('Chỉ so sánh tối đa ' + CMP_MAX + ' sản phẩm cùng lúc.', 'error');
            else list.push({ id, name: add.dataset.name || '', img: add.dataset.img || '' });
            return cmpSet(list);
        }
        const rm = e.target.closest('[data-cmp-remove]');
        if (rm) return cmpSet(cmpGet().filter(x => x.id !== +rm.dataset.cmpRemove));
        if (e.target.closest('[data-cmp-clear]')) cmpSet([]);
    });
    cmpRender();

    return {
        setWishBadge,
        updateCartBadge,
        showToast,
        formatVND,
    };
})();

// Gán toàn cục để view dễ gọi
window.ZenTechApp = ZenTechApp;
