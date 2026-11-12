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

    return {
        updateCartBadge,
        showToast,
        formatVND,
    };
})();

// Gán toàn cục để view dễ gọi
window.ZenTechApp = ZenTechApp;
