<?php
/**
 * LAYOUT: Admin Dashboard
 * Dark tech modern control panel
 */
$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
$currentPath = parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH);
?>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-zinc-950 text-white">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= Csrf::meta() ?>
    <title>ZenTech Admin Control Center</title>
    <link rel="stylesheet" href="/assets/css/fonts.css">
    <script src="/assets/vendor/tailwind-3.4.0.js"></script>
    <script src="/assets/js/tailwind-theme.js"></script>
    <link rel="stylesheet" href="/assets/css/custom.css">
    <style>
        code, pre { font-family: 'JetBrains Mono', monospace; }
    </style>
<script>
// Tự động gắn CSRF token cho mọi fetch ghi dữ liệu cùng origin
(function () {
    const meta = document.querySelector('meta[name="csrf-token"]');
    const token = meta ? meta.content : '';
    const _fetch = window.fetch;
    window.fetch = function (input, init = {}) {
        const method = (init.method || (input && input.method) || 'GET').toUpperCase();
        if (method !== 'GET' && method !== 'HEAD') {
            const h = new Headers(init.headers || {});
            if (!h.has('X-CSRF-Token')) h.set('X-CSRF-Token', token);
            h.set('X-Requested-With', 'XMLHttpRequest');
            init = Object.assign({}, init, { headers: h });
        }
        return _fetch.call(this, input, init);
    };
})();
</script>
</head>
<body class="h-full flex overflow-hidden">

    <!-- SIDEBAR (Fixed Left, w-64) -->
    <div id="admin-backdrop" class="fixed inset-0 bg-black/60 z-30 hidden lg:hidden" onclick="toggleAdminMenu()"></div>
    <aside id="admin-sidebar" class="fixed inset-y-0 left-0 w-64 -translate-x-full lg:translate-x-0 lg:static transition-transform duration-200 bg-zinc-900 lg:bg-zinc-900/90 border-r border-zinc-800 flex flex-col shrink-0 z-40">
        <!-- Brand -->
        <div class="h-16 flex items-center px-6 border-b border-zinc-800 gap-2.5">
            <svg class="w-6 h-6 text-accent-400" viewBox="0 0 24 24" fill="currentColor">
                <path d="M13 2L4.5 13.5H11L10 22l9-12h-6.5L13 2Z"/>
            </svg>
            <div class="font-black text-lg text-accent-400">
                ZenTech Admin
            </div>
        </div>

        <!-- Navigation Menu -->
        <nav class="flex-1 px-4 py-6 space-y-1.5 overflow-y-auto">
            <a href="/admin" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold transition <?= $currentPath === '/admin' ? 'bg-accent-500/10 text-accent-400 border border-accent-500/30' : 'text-zinc-400 hover:text-white hover:bg-zinc-800/60' ?>">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                </svg>
                <span>Dashboard</span>
            </a>

            <a href="/admin/products" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold transition <?= str_starts_with($currentPath, '/admin/products') ? 'bg-accent-500/10 text-accent-400 border border-accent-500/30' : 'text-zinc-400 hover:text-white hover:bg-zinc-800/60' ?>">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                </svg>
                <span>Quản lý sản phẩm</span>
            </a>

            <a href="/admin/orders" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold transition <?= str_starts_with($currentPath, '/admin/orders') ? 'bg-accent-500/10 text-accent-400 border border-accent-500/30' : 'text-zinc-400 hover:text-white hover:bg-zinc-800/60' ?>">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                </svg>
                <span>Quản lý đơn hàng</span>
            </a>

            <div class="pt-4 pb-2 px-3 text-[10px] font-bold uppercase tracking-wider text-zinc-500">
                Hệ thống
            </div>

            <a href="/" target="_blank" 
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold text-zinc-400 hover:text-white hover:bg-zinc-800/60 transition">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
                </svg>
                <span>Xem Website</span>
            </a>
        </nav>

        <!-- Current Admin Info -->
        <div class="p-4 border-t border-zinc-800 bg-zinc-950/40 flex items-center justify-between">
            <div class="flex items-center gap-2.5">
                <div class="w-8 h-8 rounded-full bg-accent-500 flex items-center justify-center font-bold text-xs text-on">
                    <?= strtoupper(substr($_SESSION['user_name'] ?? 'A', 0, 1)) ?>
                </div>
                <div class="text-left overflow-hidden">
                    <div class="text-xs font-bold text-white truncate max-w-[100px]"><?= htmlspecialchars($_SESSION['user_name'] ?? 'Admin') ?></div>
                    <div class="text-[10px] text-accent-400 font-mono">Administrator</div>
                </div>
            </div>
            <form action="/auth/logout" method="POST"><?= Csrf::field() ?><button type="submit" title="Đăng xuất" aria-label="Đăng xuất" class="text-zinc-400 hover:text-red-400 p-1.5 rounded-lg hover:bg-zinc-800 transition">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                </svg>
            </button></form>
        </div>
    </aside>

    <!-- MAIN WRAPPER (Top Bar + Scrollable Content) -->
    <div class="flex-1 min-w-0 flex flex-col overflow-hidden bg-zinc-950">
        <!-- Top Bar -->
        <header class="h-16 border-b border-zinc-800 bg-zinc-900/40 backdrop-blur-md px-4 sm:px-8 flex items-center justify-between shrink-0 gap-3">
            <button type="button" onclick="toggleAdminMenu()" aria-label="Mở menu" class="lg:hidden p-2 -ml-2 rounded-lg text-zinc-300 hover:bg-zinc-800">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg>
            </button>
            <div class="hidden sm:block text-xs text-zinc-400">
                ZenTech Control Panel &bull; Phiên bản <span class="font-mono text-accent-400">v1.0.0 MVC</span>
            </div>
            <div class="hidden sm:flex items-center gap-4 text-xs">
                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-green-500/10 text-green-400 border border-green-500/20 text-[11px]">
                    <span class="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse"></span>
                    Database: zentech_db (Online)
                </span>
            </div>
        </header>

        <!-- Main Body Content -->
        <main class="flex-1 overflow-y-auto p-4 sm:p-8">
            <?php if (!empty($flash['success'])): ?>
                <div class="mb-6 p-4 rounded-2xl bg-green-500/10 border border-green-500/20 text-xs font-semibold text-green-400 flex items-center gap-2">
                    <span>✓</span>
                    <span><?= htmlspecialchars($flash['success']) ?></span>
                </div>
            <?php endif; ?>

            <?php if (!empty($flash['error'])): ?>
                <div class="mb-6 p-4 rounded-2xl bg-red-500/10 border border-red-500/20 text-xs font-semibold text-red-400 flex items-center gap-2">
                    <span>✕</span>
                    <span><?= htmlspecialchars($flash['error']) ?></span>
                </div>
            <?php endif; ?>

            <?= $content ?? '' ?>
        </main>
    </div>

<script src="/assets/js/form-loading.js"></script>
<script>
function toggleAdminMenu() {
    document.getElementById('admin-sidebar').classList.toggle('-translate-x-full');
    document.getElementById('admin-backdrop').classList.toggle('hidden');
}
</script>
</body>
</html>
