<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= Csrf::meta() ?>
    <title><?php echo $pageTitle ?? 'ZenTech: gaming gear chính hãng'; ?></title>
    <meta name="description" content="<?php echo $pageDescription ?? 'ZenTech – Chuyên cung cấp thiết bị gaming, PC, phụ kiện công nghệ cao cấp.'; ?>">

    <!-- ===== Google Fonts ===== -->
    <link rel="stylesheet" href="/assets/css/fonts.css">

    <!-- ===== Tailwind CSS CDN ===== -->
    <script src="/assets/vendor/tailwind-3.4.0.js"></script>
    <script src="/assets/js/tailwind-theme.js"></script>

    

    <!-- ===== Inline global styles ===== -->
    <style>

        /* Spotlight search overlay backdrop */
        #spotlight-overlay { backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); }

        /* Mobile menu transition */
        #mobile-menu { transition: max-height .35s cubic-bezier(.4,0,.2,1), opacity .25s ease; }
    </style>

    <!-- ===== Custom CSS ===== -->
    <link rel="stylesheet" href="/assets/css/custom.css">

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
<script>
// Ảnh lỗi (404/offline) -> thay bằng placeholder SVG nội tuyến, tránh ô trống
(function () {
    const svg = "data:image/svg+xml;utf8," + encodeURIComponent(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><rect width="400" height="400" fill="#f5f5f7"/>' +
        '<path d="M215 110l-70 100h50l-10 80 70-100h-50z" fill="#c7c7cc"/></svg>');
    document.addEventListener('error', function (e) {
        const el = e.target;
        if (el.tagName === 'IMG' && !el.dataset.fallback) {
            el.dataset.fallback = '1';
            el.removeAttribute('srcset');
            el.src = svg;
        }
    }, true);
})();
</script>
    <?php echo $extraHead ?? ''; ?>
</head>
<body class="font-sans text-white antialiased">
<?php $cartBadgeCount = array_sum(array_column($_SESSION['cart'] ?? [], 'quantity')); ?>

<!-- ================================================================
     HEADER – sticky glassmorphism
     ================================================================ -->
<header id="main-header"
        class="sticky top-0 z-50 bg-zinc-950 border-b border-zinc-800 transition-shadow duration-300">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16 gap-4">

            <!-- ---------- LOGO ---------- -->
            <a href="/" class="flex items-center gap-2 shrink-0 group">
                <!-- Lightning bolt SVG icon -->
                <svg class="w-6 h-6 text-accent-500"
                     viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                    <path d="M13 2L4.5 13.5H11L10 22l9-12h-6.5L13 2Z"/>
                </svg>
                <span class="text-xl font-bold tracking-tight text-zinc-100">
                    ZenTech
                </span>
            </a>

            <!-- ---------- NAV LINKS (desktop) ---------- -->
            <nav class="hidden md:flex items-center gap-1" aria-label="Điều hướng chính">
                <?php
                // Danh sách menu chính
                $navLinks = [
                    ['href' => '/',           'label' => 'Trang chủ'],
                    ['href' => '/san-pham',   'label' => 'Sản phẩm'],
                    ['href' => '/thuong-hieu','label' => 'Thương hiệu'],
                    ['href' => '/ve-chung-toi','label' => 'Về chúng tôi'],
                ];
                $currentPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
                foreach ($navLinks as $link):
                    $isActive = ($currentPath === $link['href']) || ($link['href'] !== '/' && str_starts_with($currentPath, $link['href']));
                ?>
                <a href="<?php echo $link['href']; ?>"
                   class="relative px-4 py-2 rounded-lg text-sm font-medium transition-colors duration-200
                          <?php echo $isActive
                              ? 'text-accent-400'
                              : 'text-zinc-400 hover:text-white hover:bg-white/5'; ?>">
                    <?php echo $link['label']; ?>
                    <?php if ($isActive): ?>
                    <span class="absolute bottom-0 left-1/2 -translate-x-1/2 w-4 h-0.5
                                 bg-accent-500 rounded-full"></span>
                    <?php endif; ?>
                </a>
                <?php endforeach; ?>
            </nav>

            <!-- ---------- SPOTLIGHT SEARCH (Ctrl+K) ---------- -->
            <button id="btn-spotlight"
                    onclick="openSpotlight()"
                    class="hidden sm:flex items-center gap-2 flex-1 max-w-xs
                           bg-zinc-800/60 border border-zinc-700/50 rounded-full
                           px-4 py-2 text-sm text-zinc-500
                           hover:border-accent-400/40 hover:text-zinc-300
                           transition-all duration-200 cursor-pointer"
                    aria-label="Tìm kiếm (Ctrl+K)">
                <!-- Search icon -->
                <svg class="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M21 21l-4.35-4.35M17 11A6 6 0 1 1 5 11a6 6 0 0 1 12 0Z"/>
                </svg>
                <span class="flex-1 text-left">Tìm kiếm...</span>
                <!-- Keyboard shortcut badge -->
                <span class="hidden lg:flex items-center gap-0.5 text-xs text-zinc-600">
                    <kbd class="px-1.5 py-0.5 bg-zinc-700 rounded text-zinc-500 font-mono">Ctrl</kbd>
                    <kbd class="px-1.5 py-0.5 bg-zinc-700 rounded text-zinc-500 font-mono">K</kbd>
                </span>
            </button>

            <!-- ---------- ICONS: Cart & User ---------- -->
            <div class="flex items-center gap-2">

                <!-- Mobile search button -->
                <button class="sm:hidden p-2 text-zinc-400 hover:text-accent-400 rounded-lg hover:bg-white/5"
                        onclick="openSpotlight()" aria-label="Tìm kiếm">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M21 21l-4.35-4.35M17 11A6 6 0 1 1 5 11a6 6 0 0 1 12 0Z"/>
                    </svg>
                </button>

                <!-- Giỏ hàng -->
                <a href="/gio-hang"
                   class="relative p-2 text-zinc-400 hover:text-accent-400 rounded-lg hover:bg-white/5
                          transition-colors duration-200"
                   aria-label="Giỏ hàng">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4ZM3 6h18M16 10a4 4 0 0 1-8 0"/>
                    </svg>
                    <!-- Badge số lượng sản phẩm trong giỏ -->
                    <span id="cart-badge"
                          class="<?php echo ($cartBadgeCount > 0) ? '' : 'hidden'; ?>
                                 absolute -top-1 -right-1 min-w-[18px] h-[18px] flex items-center justify-center
                                 bg-accent-500
                                 text-on text-[10px] font-bold rounded-full px-1 leading-none">
                        <?php echo $cartBadgeCount; ?>
                    </span>
                </a>

                <!-- User dropdown -->
                <div class="relative" id="user-dropdown-wrap">
                    <button id="btn-user-dropdown"
                            onclick="toggleUserDropdown()"
                            class="flex items-center gap-2 p-2 text-zinc-400 hover:text-accent-400
                                   rounded-lg hover:bg-white/5 transition-colors duration-200"
                            aria-label="Tài khoản" aria-expanded="false">
                        <?php if (!empty($_SESSION['user_avatar'])): ?>
                            <img src="<?php echo htmlspecialchars($_SESSION['user_avatar']); ?>"
                                 alt="Avatar" class="w-6 h-6 rounded-full object-cover ring-1 ring-zinc-700">
                        <?php else: ?>
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8Z"/>
                            </svg>
                        <?php endif; ?>
                    </button>

                    <!-- Dropdown menu -->
                    <div id="user-dropdown-menu"
                         class="hidden absolute right-0 mt-2 w-52
                                bg-zinc-950 border border-zinc-800
                                rounded-2xl shadow-xl overflow-hidden
                                animate-slide-down"
                         role="menu">
                        <?php if (!empty($_SESSION['user_id'])): ?>
                            <div class="px-4 py-3 border-b border-zinc-800">
                                <p class="text-sm font-semibold text-white truncate">
                                    <?php echo htmlspecialchars($_SESSION['user_name'] ?? 'Người dùng'); ?>
                                </p>
                                <p class="text-xs text-zinc-500 truncate">
                                    <?php echo htmlspecialchars($_SESSION['user_email'] ?? ''); ?>
                                </p>
                            </div>
                            <a href="/tai-khoan" class="flex items-center gap-3 px-4 py-2.5 text-sm text-zinc-300
                                                         hover:bg-white/5 hover:text-accent-400 transition-colors" role="menuitem">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8Z"/>
                                </svg>
                                Tài khoản của tôi
                            </a>
                            <a href="/don-hang" class="flex items-center gap-3 px-4 py-2.5 text-sm text-zinc-300
                                                        hover:bg-white/5 hover:text-accent-400 transition-colors" role="menuitem">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2"/>
                                </svg>
                                Đơn hàng của tôi
                            </a>
                            <div class="border-t border-zinc-800 mt-1">
                                <form action="/dang-xuat" method="POST"><?= Csrf::field() ?>
                                <button type="submit" class="w-full text-left flex items-center gap-3 px-4 py-2.5 text-sm text-red-400
                                                             hover:bg-red-500/10 transition-colors" role="menuitem">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M17 16l4-4m0 0-4-4m4 4H7m6 4v1a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3V7a3 3 0 0 1 3-3h4a3 3 0 0 1 3 3v1"/>
                                    </svg>
                                    Đăng xuất
                                </button>
                                </form>
                            </div>
                        <?php else: ?>
                            <a href="/dang-nhap" class="flex items-center gap-3 px-4 py-2.5 text-sm text-zinc-300
                                                         hover:bg-white/5 hover:text-accent-400 transition-colors" role="menuitem">
                                Đăng nhập
                            </a>
                            <a href="/dang-ky" class="flex items-center gap-3 px-4 py-2.5 text-sm text-zinc-300
                                                       hover:bg-white/5 hover:text-accent-400 transition-colors" role="menuitem">
                                Đăng ký
                            </a>
                        <?php endif; ?>
                    </div>
                </div>

                <!-- Hamburger (mobile) -->
                <button id="btn-hamburger"
                        onclick="toggleMobileMenu()"
                        class="md:hidden p-2 text-zinc-400 hover:text-accent-400 rounded-lg hover:bg-white/5"
                        aria-label="Menu" aria-expanded="false" aria-controls="mobile-menu">
                    <svg id="icon-hamburger" class="w-5 h-5 block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                    </svg>
                    <svg id="icon-close" class="w-5 h-5 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div><!-- /icons -->
        </div><!-- /flex row -->
    </div>

    <!-- ---------- MOBILE MENU ---------- -->
    <nav id="mobile-menu"
         class="md:hidden max-h-0 opacity-0 overflow-hidden border-t border-zinc-800/50"
         aria-label="Điều hướng mobile">
        <div class="px-4 py-3 space-y-1">
            <?php foreach ($navLinks as $link): ?>
            <a href="<?php echo $link['href']; ?>"
               class="flex items-center px-4 py-3 rounded-xl text-sm font-medium
                      <?php echo ($currentPath === $link['href'])
                          ? 'bg-accent-500/10 text-accent-400'
                          : 'text-zinc-400 hover:text-white hover:bg-white/5'; ?>
                      transition-colors duration-200">
                <?php echo $link['label']; ?>
            </a>
            <?php endforeach; ?>
        </div>
    </nav>
</header>

<!-- ================================================================
     MAIN CONTENT
     ================================================================ -->
<main id="main-content" role="main">
    <?php echo $content ?? ''; ?>
</main>

<!-- ================================================================
     FOOTER
     ================================================================ -->
<footer class="mt-8 bg-zinc-900 border-t border-zinc-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-14">
        <div class="grid grid-cols-1 md:grid-cols-12 gap-10">
            <div class="md:col-span-5">
                <a href="/" class="inline-flex items-center gap-2">
                    <svg class="w-6 h-6 text-accent-500" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M13 2L4.5 13.5H11L10 22l9-12h-6.5L13 2Z"/></svg>
                    <span class="text-xl font-bold text-zinc-100">ZenTech</span>
                </a>
                <p class="mt-4 max-w-sm text-sm leading-relaxed text-zinc-400">Gaming gear chính hãng, chọn theo thông số. Chuột, bàn phím cơ, tai nghe và phụ kiện.</p>
            </div>
            <nav class="md:col-span-3" aria-label="Mua sắm">
                <h3 class="text-sm font-semibold text-zinc-100">Mua sắm</h3>
                <ul class="mt-4 space-y-3 text-sm">
                    <li><a class="text-zinc-400 hover:text-accent-400" href="/san-pham">Tất cả sản phẩm</a></li>
                    <li><a class="text-zinc-400 hover:text-accent-400" href="/thuong-hieu">Thương hiệu</a></li>
                    <li><a class="text-zinc-400 hover:text-accent-400" href="/gio-hang">Giỏ hàng</a></li>
                    <li><a class="text-zinc-400 hover:text-accent-400" href="/don-hang">Đơn hàng của tôi</a></li>
                </ul>
            </nav>
            <div class="md:col-span-4">
                <h3 class="text-sm font-semibold text-zinc-100">Chính sách</h3>
                <ul class="mt-4 space-y-3 text-sm text-zinc-400">
                    <li>Miễn phí vận chuyển cho đơn từ 500.000₫</li>
                    <li>Đổi trả trong 7 ngày nếu sản phẩm có lỗi</li>
                    <li>Bảo hành chính hãng 12 tháng</li>
                    <li>Thanh toán khi nhận hàng, chuyển khoản hoặc MoMo</li>
                </ul>
            </div>
        </div>
        <p class="mt-12 pt-6 border-t border-zinc-800 text-xs text-zinc-500">&copy; <?= date('Y') ?> ZenTech. Đồ án môn Dự án 1 - Lập trình website.</p>
    </div>
</footer>

<!-- ================================================================
     SPOTLIGHT SEARCH MODAL
     ================================================================ -->
<div id="spotlight-overlay"
     class="fixed inset-0 z-[200] flex items-start justify-center pt-[12vh] px-4
            bg-black/60 hidden"
     onclick="closeSpotlightOnBackdrop(event)"
     role="dialog" aria-modal="true" aria-label="Tìm kiếm nhanh">

    <div class="w-full max-w-2xl bg-zinc-900/95 backdrop-blur-2xl
                border border-zinc-700/50 rounded-2xl shadow-2xl shadow-black/60
                overflow-hidden animate-slide-down">

        <!-- Search input -->
        <div class="flex items-center gap-3 px-5 py-4 border-b border-zinc-800">
            <svg class="w-5 h-5 text-zinc-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M21 21l-4.35-4.35M17 11A6 6 0 1 1 5 11a6 6 0 0 1 12 0Z"/>
            </svg>
            <input id="spotlight-input"
                   type="text"
                   placeholder="Tìm sản phẩm, thương hiệu..."
                   autocomplete="off"
                   class="flex-1 bg-transparent text-white text-base placeholder-zinc-500 outline-none"
                   oninput="handleSpotlightInput(this.value)">
            <button onclick="closeSpotlight()"
                    class="text-zinc-500 hover:text-white transition-colors p-1 rounded-lg hover:bg-white/5"
                    aria-label="Đóng">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
        </div>

        <!-- Khu vực kết quả tìm kiếm -->
        <div id="spotlight-results" class="max-h-80 overflow-y-auto">
            <!-- Trạng thái mặc định: gợi ý tìm kiếm -->
            <div id="spotlight-default" class="px-5 py-5">
                <p class="text-xs font-medium text-zinc-400 mb-3">Gợi ý tìm kiếm</p>
                <div class="flex flex-wrap gap-2">
                    <?php foreach (['Chuột gaming', 'Bàn phím cơ', 'Tai nghe', 'Logitech', 'Razer', 'Akko', 'Không dây'] as $kw): ?>
                        <a href="/san-pham?q=<?= urlencode($kw) ?>" class="px-3.5 py-1.5 rounded-full bg-zinc-900 text-sm text-zinc-200 hover:bg-zinc-850 hover:text-accent-400 transition-colors"><?= $kw ?></a>
                    <?php endforeach; ?>
                </div>
            </div>
            <!-- Spinner loading -->
            <div id="spotlight-loading" class="hidden px-5 py-8 flex justify-center">
                <div class="w-6 h-6 border-2 border-accent-400 border-t-transparent rounded-full animate-spin"></div>
            </div>
            <!-- Danh sách kết quả (inject bằng JS) -->
            <ul id="spotlight-list" class="hidden py-2" role="listbox"></ul>
            <!-- Không có kết quả -->
            <div id="spotlight-empty" class="hidden px-5 py-6 text-center text-zinc-500 text-sm">
                Không tìm thấy kết quả phù hợp.
            </div>
        </div>

        <!-- Footer hint -->
        <div class="px-5 py-3 border-t border-zinc-800 flex gap-4 text-xs text-zinc-600">
            <span><kbd class="bg-zinc-800 px-1.5 py-0.5 rounded font-mono">↑↓</kbd> Điều hướng</span>
            <span><kbd class="bg-zinc-800 px-1.5 py-0.5 rounded font-mono">Enter</kbd> Chọn</span>
            <span><kbd class="bg-zinc-800 px-1.5 py-0.5 rounded font-mono">Esc</kbd> Đóng</span>
        </div>
    </div>
</div>

<!-- ================================================================
     JAVASCRIPT
     ================================================================ -->
<script>
// ----------------------------------------------------------------
// Spotlight Search
// ----------------------------------------------------------------
let spotlightTimer = null;

/** Mở modal spotlight */
function openSpotlight() {
    document.getElementById('spotlight-overlay').classList.remove('hidden');
    document.body.style.overflow = 'hidden';
    setTimeout(() => document.getElementById('spotlight-input').focus(), 50);
}

/** Đóng modal spotlight */
function closeSpotlight() {
    document.getElementById('spotlight-overlay').classList.add('hidden');
    document.body.style.overflow = '';
    document.getElementById('spotlight-input').value = '';
    resetSpotlightResults();
}

/** Đóng khi click vào backdrop */
function closeSpotlightOnBackdrop(e) {
    if (e.target === document.getElementById('spotlight-overlay')) closeSpotlight();
}

/** Reset vùng kết quả về mặc định */
function resetSpotlightResults() {
    document.getElementById('spotlight-default').classList.remove('hidden');
    document.getElementById('spotlight-loading').classList.add('hidden');
    document.getElementById('spotlight-list').classList.add('hidden');
    document.getElementById('spotlight-empty').classList.add('hidden');
}

/** Xử lý input tìm kiếm với debounce 300ms */
function handleSpotlightInput(value) {
    clearTimeout(spotlightTimer);
    if (value.trim().length < 2) { resetSpotlightResults(); return; }

    // Hiện spinner
    document.getElementById('spotlight-default').classList.add('hidden');
    document.getElementById('spotlight-loading').classList.remove('hidden');
    document.getElementById('spotlight-list').classList.add('hidden');
    document.getElementById('spotlight-empty').classList.add('hidden');

    // Debounce 300ms rồi fetch API
    spotlightTimer = setTimeout(() => fetchSpotlightResults(value.trim()), 300);
}

/** Gọi API tìm kiếm và render kết quả */
function escapeHtml(s) {
    return String(s ?? '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}

function highlightKeyword(text, query) {
    const safe = escapeHtml(text);
    const q = escapeHtml(query.trim()).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    return q ? safe.replace(new RegExp('(' + q + ')', 'ig'), '<mark class="bg-accent-100 text-accent-700 rounded px-0.5">$1</mark>') : safe;
}

function fetchSpotlightResults(query) {
    fetch('/search?q=' + encodeURIComponent(query) + '&format=json')
        .then(r => r.json())
        .then(data => {
            // Bỏ phản hồi cũ nếu người dùng đã gõ tiếp
            if (document.getElementById('spotlight-input').value.trim() !== query) return;
            document.getElementById('spotlight-loading').classList.add('hidden');
            const list = document.getElementById('spotlight-list');
            const empty = document.getElementById('spotlight-empty');
            empty.textContent = 'Không tìm thấy kết quả phù hợp.';

            if (!data.results || data.results.length === 0) {
                empty.classList.remove('hidden');
                return;
            }

            list.innerHTML = data.results.map(item => `
                <li role="option">
                    <a href="/san-pham/${encodeURIComponent(item.slug)}"
                       onclick="closeSpotlight()"
                       class="spotlight-item flex items-center gap-4 px-5 py-3 hover:bg-zinc-900 transition-colors duration-150 cursor-pointer">
                        <img src="${escapeHtml(item.thumbnail || item.thumbnail_url || '')}" alt=""
                             class="w-10 h-10 rounded-lg object-contain bg-zinc-900 shrink-0">
                        <div class="flex-1 min-w-0">
                            <p class="text-sm font-medium text-white truncate">${highlightKeyword(item.name, query)}</p>
                            <p class="text-xs text-zinc-500 truncate">${escapeHtml(item.brand_name || '')}</p>
                        </div>
                        <span class="text-sm font-semibold text-accent-400 shrink-0">
                            ${item.min_price ? formatPrice(item.min_price) + '₫' : ''}
                        </span>
                    </a>
                </li>
            `).join('') + `
                <li role="option">
                    <a href="/san-pham?q=${encodeURIComponent(query)}" class="spotlight-item block px-5 py-3 text-sm font-medium text-accent-400 hover:bg-zinc-900">
                        Xem tất cả kết quả cho “${escapeHtml(query)}” &rsaquo;
                    </a>
                </li>`;
            list.classList.remove('hidden');
        })
        .catch(() => {
            document.getElementById('spotlight-loading').classList.add('hidden');
            const empty = document.getElementById('spotlight-empty');
            empty.textContent = 'Không tìm kiếm được lúc này, vui lòng thử lại.';
            empty.classList.remove('hidden');
        });
}

// ----------------------------------------------------------------
// User Dropdown Toggle
// ----------------------------------------------------------------
function toggleUserDropdown() {
    const menu = document.getElementById('user-dropdown-menu');
    const btn  = document.getElementById('btn-user-dropdown');
    const isOpen = !menu.classList.contains('hidden');
    menu.classList.toggle('hidden');
    btn.setAttribute('aria-expanded', String(!isOpen));
}

/** Đóng dropdown khi click ra ngoài */
document.addEventListener('click', (e) => {
    const wrap = document.getElementById('user-dropdown-wrap');
    if (wrap && !wrap.contains(e.target)) {
        document.getElementById('user-dropdown-menu')?.classList.add('hidden');
    }
});

// ----------------------------------------------------------------
// Mobile Menu Toggle
// ----------------------------------------------------------------
function toggleMobileMenu() {
    const menu = document.getElementById('mobile-menu');
    const btn  = document.getElementById('btn-hamburger');
    const iconOpen  = document.getElementById('icon-hamburger');
    const iconClose = document.getElementById('icon-close');

    const isOpen = menu.style.maxHeight && menu.style.maxHeight !== '0px';

    if (isOpen) {
        menu.style.maxHeight = '0px';
        menu.style.opacity   = '0';
        btn.setAttribute('aria-expanded', 'false');
        iconOpen.classList.remove('hidden');
        iconClose.classList.add('hidden');
    } else {
        menu.style.maxHeight = menu.scrollHeight + 'px';
        menu.style.opacity   = '1';
        btn.setAttribute('aria-expanded', 'true');
        iconOpen.classList.add('hidden');
        iconClose.classList.remove('hidden');
    }
}

// ----------------------------------------------------------------
// Cart Badge Updater – gọi sau khi thêm sản phẩm vào giỏ
// ----------------------------------------------------------------
function updateCartBadge(count) {
    const badge = document.getElementById('cart-badge');
    if (!badge) return;
    if (count > 0) {
        badge.textContent = count > 99 ? '99+' : count;
        badge.classList.remove('hidden');
    } else {
        badge.classList.add('hidden');
    }
}

// ----------------------------------------------------------------
// Keyboard shortcuts
// ----------------------------------------------------------------
document.addEventListener('keydown', (e) => {
    // Ctrl+K hoặc Cmd+K mở spotlight
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        openSpotlight();
    }
    // Esc đóng spotlight
    if (e.key === 'Escape') {
        closeSpotlight();
    }
    // ↑ ↓ chọn kết quả, Enter mở kết quả đang chọn (không chọn gì thì xem toàn bộ kết quả)
    const overlay = document.getElementById('spotlight-overlay');
    if (overlay.classList.contains('hidden')) return;
    const items = [...document.querySelectorAll('#spotlight-list .spotlight-item')];
    const cur = items.findIndex(i => i.classList.contains('bg-zinc-900'));
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
        if (!items.length) return;
        e.preventDefault();
        const next = e.key === 'ArrowDown' ? (cur + 1) % items.length : (cur - 1 + items.length) % items.length;
        items.forEach(i => i.classList.remove('bg-zinc-900'));
        items[next].classList.add('bg-zinc-900');
        items[next].scrollIntoView({ block: 'nearest' });
    } else if (e.key === 'Enter') {
        const q = document.getElementById('spotlight-input').value.trim();
        if (cur >= 0) { e.preventDefault(); items[cur].click(); }
        else if (q.length >= 2) { e.preventDefault(); window.location.href = '/san-pham?q=' + encodeURIComponent(q); }
    }
});

// ----------------------------------------------------------------
// Utility: Format số tiền VNĐ
// ----------------------------------------------------------------
function formatPrice(number) {
    return new Intl.NumberFormat('vi-VN').format(number);
}

// ----------------------------------------------------------------
// Header shadow khi scroll
// ----------------------------------------------------------------
window.addEventListener('scroll', () => {
    const header = document.getElementById('main-header');
    if (window.scrollY > 10) {
        header.classList.add('shadow-lg', 'shadow-black/30');
    } else {
        header.classList.remove('shadow-lg', 'shadow-black/30');
    }
}, { passive: true });
</script>

<!-- ===== AI Tech Assistant Widget ===== -->
<?php 
if (file_exists(VIEW_PATH . '/partials/ai-widget.php')) {
    include VIEW_PATH . '/partials/ai-widget.php';
}
?>

<!-- ===== Global Client JS ===== -->
<script src="/assets/js/app.js"></script>
<script src="/assets/js/form-loading.js"></script>
<?php
// Thông báo sau hành động (đăng ký, đặt hàng, hủy đơn, đăng xuất...) hiển thị dạng toast
$flashToasts = [];
foreach ((array) ($_SESSION['flash'] ?? []) as $k => $v) {
    if ($k === 'old') continue;
    foreach ((array) $v as $msg) {
        if (is_string($msg) && $msg !== '') $flashToasts[] = [$msg, in_array($k, ['error', 'errors'], true) ? 'error' : 'success'];
    }
}
unset($_SESSION['flash']);
if (isset($_SESSION['flash_message'])) unset($_SESSION['flash_message']);
if ($flashToasts): ?>
<script>
document.addEventListener('DOMContentLoaded', () => <?= json_encode($flashToasts, JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP) ?>.forEach(([m, t], i) => setTimeout(() => ZenTechApp.showToast(m, t, 5000), i * 250)));
</script>
<?php endif; ?>

<?php echo $extraScripts ?? ''; ?>
</body>
</html>
