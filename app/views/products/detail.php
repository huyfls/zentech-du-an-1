<?php
/**
 * VIEW: Product Detail Page
 * Hiển thị chi tiết sản phẩm, biến thể, thông số kỹ thuật, đánh giá
 *
 * Variables:
 *   $product        - array thông tin sản phẩm
 *   $variants       - array biến thể (color, version_spec, price, sale_price, stock_qty, image_url)
 *   $specs          - array thông số kỹ thuật, nhóm theo group_name
 *   $images         - array ảnh sản phẩm
 *   $relatedProducts- array sản phẩm liên quan
 */

// --- Dữ liệu mẫu khi chạy standalone (không qua controller) ---
if (!isset($product)) {
    $product = [
        'id'          => 1,
        'name'        => 'Chuột Không Dây ZenTech X Pro',
        'brand'       => 'ZenTech',
        'category'    => 'Chuột máy tính',
        'short_desc'  => 'Chuột gaming không dây cao cấp với cảm biến 26000 DPI, pin 70 giờ, kết nối 2.4GHz & Bluetooth.',
        'is_featured' => true,
        'thumbnail'   => 'https://placehold.co/600x600/1e293b/22d3ee?text=ZenTech+X+Pro',
        'avg_rating'  => 4.7,
        'review_count'=> 128,
    ];
    $images = [
        'https://placehold.co/600x600/1e293b/22d3ee?text=View+1',
        'https://placehold.co/600x600/1e293b/a855f7?text=View+2',
        'https://placehold.co/600x600/27272a/22d3ee?text=View+3',
        'https://placehold.co/600x600/27272a/a855f7?text=View+4',
        'https://placehold.co/600x600/18181b/22d3ee?text=View+5',
    ];
    $variants = [
        ['id' => 1, 'color' => 'Đen', 'version_spec' => 'Wireless 2.4G',   'price' => 1890000, 'sale_price' => 1750000, 'stock_qty' => 25, 'image_url' => $images[0]],
        ['id' => 2, 'color' => 'Đen', 'version_spec' => 'Bluetooth',        'price' => 1890000, 'sale_price' => 1750000, 'stock_qty' => 10, 'image_url' => $images[1]],
        ['id' => 3, 'color' => 'Trắng','version_spec' => 'Wireless 2.4G',   'price' => 1890000, 'sale_price' => 1800000, 'stock_qty' => 18, 'image_url' => $images[2]],
        ['id' => 4, 'color' => 'Trắng','version_spec' => 'Bluetooth',        'price' => 1890000, 'sale_price' => 1800000, 'stock_qty' => 5,  'image_url' => $images[3]],
        ['id' => 5, 'color' => 'Xanh', 'version_spec' => 'Wireless 2.4G',   'price' => 1990000, 'sale_price' => null,     'stock_qty' => 7,  'image_url' => $images[4]],
    ];
    $specs = [
        'Kết nối' => [
            ['label' => 'Loại kết nối',   'value' => 'Wireless 2.4GHz / Bluetooth 5.0'],
            ['label' => 'Phạm vi',         'value' => 'Lên đến 10m'],
        ],
        'Hiệu năng' => [
            ['label' => 'Cảm biến',        'value' => 'PixArt PAW3395 (26000 DPI)'],
            ['label' => 'Polling rate',    'value' => '1000Hz (có thể lên 8000Hz)'],
            ['label' => 'Nút bấm',         'value' => 'Omron D2FC-F-K 60M'],
        ],
        'Thiết kế' => [
            ['label' => 'Trọng lượng',     'value' => '95g (không dây)'],
            ['label' => 'Kích thước',      'value' => '126 × 68 × 42mm'],
            ['label' => 'Chất liệu',       'value' => 'Nhựa ABS cao cấp + Coating chống trơn'],
        ],
        'Pin' => [
            ['label' => 'Dung lượng',      'value' => '1000mAh Li-Po'],
            ['label' => 'Thời gian dùng',  'value' => 'Lên đến 70 giờ (tắt LED)'],
            ['label' => 'Sạc',             'value' => 'USB-C, sạc đầy 2 tiếng'],
        ],
    ];
    $relatedProducts = [
        ['id' => 2, 'name' => 'ZenTech Pad XXL', 'thumbnail' => 'https://placehold.co/300x300/27272a/22d3ee?text=Pad', 'sale_price' => 350000, 'price' => 420000],
        ['id' => 3, 'name' => 'ZenTech KeyBoard K1', 'thumbnail' => 'https://placehold.co/300x300/27272a/a855f7?text=KB', 'sale_price' => null, 'price' => 2200000],
        ['id' => 4, 'name' => 'ZenTech Headset H3', 'thumbnail' => 'https://placehold.co/300x300/1e293b/22d3ee?text=HS', 'sale_price' => 890000, 'price' => 1100000],
        ['id' => 5, 'name' => 'ZenTech Hub 7-in-1', 'thumbnail' => 'https://placehold.co/300x300/1e293b/a855f7?text=Hub', 'sale_price' => null, 'price' => 650000],
    ];
}

// --- Helper: format tiền VND ---
function fmtVnd(int|float|string|null $price): string {
    $price = (float) $price;
    return number_format($price, 0, ',', '.') . '₫';
}

// --- Lấy giá hiển thị của variant đầu tiên ---
$firstVariant     = $variants[0] ?? [];
$displayPrice     = $firstVariant['sale_price'] ?? $firstVariant['price'] ?? 0;
$originalPrice    = $firstVariant['price'] ?? 0;
$discountPct      = ($originalPrice > 0 && $displayPrice < $originalPrice)
                    ? round((1 - $displayPrice / $originalPrice) * 100)
                    : 0;

// --- Lấy danh sách màu và phiên bản duy nhất ---
$uniqueColors    = array_values(array_unique(array_column($variants, 'color')));
$uniqueVersions  = array_values(array_unique(array_column($variants, 'version_spec')));

// --- Ảnh chính ---
$mainImage = $images[0] ?? $product['thumbnail_url'] ?? $product['thumbnail'] ?? '';
?>
    <style>
        /* Hiệu ứng zoom ảnh */
        .img-zoom { transition: transform 0.3s ease; }
        .img-zoom:hover { transform: scale(1.03); }

        /* Thumbnail active */
        .thumb-active { border-color: #0f5de0 !important; box-shadow: 0 0 0 2px rgba(15,93,224,0.3); }

        /* Variant button */
        .variant-btn { transition: all 0.2s ease; }
        .variant-btn.unavailable:not(.active) { opacity: .45; text-decoration: line-through; }
        .variant-btn.active {
            border-color: #0f5de0;
            color: #0f5de0;
            background: rgba(15,93,224,0.08);
            box-shadow: 0 0 0 2px rgba(15,93,224,0.25);
        }

        /* Tab active */
        .tab-btn.active { color: #0f5de0; border-bottom-color: #0f5de0; }

        /* Rating bar fill */
        .rating-fill { background: linear-gradient(90deg, #0f5de0, #e8a100); }

        /* Smooth fade cho tab panel */
        .tab-panel { display: none; animation: fadeIn .25s ease; }
        .tab-panel.active { display: block; }
        @keyframes fadeIn { from { opacity:0; transform:translateY(6px); } to { opacity:1; transform:translateY(0); } }

        /* Custom scrollbar */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: #f5f5f7; }
        ::-webkit-scrollbar-thumb { background: #3f3f46; border-radius: 3px; }
    </style>
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- ── BREADCRUMB ───────────────────────────────────────── -->
    <nav class="flex items-center gap-2 text-sm text-zinc-500 mb-6 whitespace-nowrap overflow-hidden" aria-label="Breadcrumb">
        <a href="/" class="hover:text-accent-400 transition-colors">Trang chủ</a>
        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
        <a href="/san-pham?category=<?= urlencode($product['category_slug'] ?? '') ?>" class="hover:text-accent-400 transition-colors">
            <?= htmlspecialchars($product['category'] ?? 'Danh mục') ?>
        </a>
        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
        <span class="text-zinc-300 truncate min-w-0"><?= htmlspecialchars($product['name']) ?></span>
    </nav>

    <!-- ══════════════════════════════════════════════════════
         SECTION 1: 2 CỘT — ẢNH (TRÁI) + THÔNG TIN (PHẢI)
         ══════════════════════════════════════════════════════ -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-10 mb-14">

        <!-- ── CỘT TRÁI: GALLERY ÀNH ─────────────────────── -->
        <div class="space-y-4">
            <!-- Ảnh chính -->
            <div class="relative overflow-hidden rounded-2xl border border-zinc-700 bg-zinc-800 aspect-square cursor-zoom-in group">
                <img id="main-image"
                     src="<?= htmlspecialchars($mainImage) ?>"
                     alt="<?= htmlspecialchars($product['name']) ?>"
                     class="w-full h-full object-contain img-zoom p-4">
                <!-- Badge Featured -->
                <?php if (!empty($product['is_featured'])): ?>
                <span class="absolute top-3 left-3 bg-accent-500 text-on text-xs font-bold px-2.5 py-1 rounded-full">
                    HOT
                </span>
                <?php endif; ?>
            </div>

            <!-- Dải thumbnail -->
            <div class="grid grid-cols-5 gap-2">
                <?php foreach ($images as $idx => $imgUrl): ?>
                <button onclick="setMainImage('<?= htmlspecialchars($imgUrl) ?>', this)"
                        class="thumb-btn overflow-hidden rounded-xl border border-zinc-700 bg-zinc-800 aspect-square transition-all hover:border-accent-500/50 <?= $idx === 0 ? 'thumb-active' : '' ?>">
                    <img src="<?= htmlspecialchars($imgUrl) ?>"
                         alt="Ảnh <?= $idx + 1 ?>"
                         class="w-full h-full object-contain p-1">
                </button>
                <?php endforeach; ?>
            </div>
        </div>

        <!-- ── CỘT PHẢI: THÔNG TIN SẢN PHẨM ────────────── -->
        <div class="flex flex-col gap-5">

            <!-- Brand badge -->
            <div>
                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-accent-500/10 text-accent-400 border border-accent-500/20">
                    <?= htmlspecialchars($product['brand'] ?? 'Brand') ?>
                </span>
            </div>

            <!-- Tên sản phẩm -->
            <h1 class="text-2xl sm:text-3xl font-bold text-white leading-tight">
                <?= htmlspecialchars($product['name']) ?>
            </h1>

            <!-- Rating -->
            <div class="flex items-center gap-3">
                <div class="flex items-center gap-0.5">
                    <?php
                    $rating = round($product['avg_rating'] ?? 0);
                    for ($i = 1; $i <= 5; $i++):
                    ?>
                    <svg class="w-5 h-5 <?= $i <= $rating ? 'text-yellow-400' : 'text-zinc-600' ?>"
                         fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                    </svg>
                    <?php endfor; ?>
                </div>
                <span class="text-accent-400 font-semibold"><?= number_format($product['avg_rating'] ?? 0, 1) ?></span>
                <span class="text-zinc-500 text-sm">(<?= number_format($product['review_count'] ?? 0) ?> đánh giá)</span>
            </div>

            <!-- Giá -->
            <div class="flex items-end gap-3 flex-wrap">
                <span id="current-price"
                      class="text-3xl font-extrabold text-accent-400">
                    <?= fmtVnd($displayPrice) ?>
                </span>
                <?php if ($discountPct > 0): ?>
                <span id="original-price"
                      class="text-xl text-zinc-500 line-through">
                    <?= fmtVnd($originalPrice) ?>
                </span>
                <span class="inline-flex items-center px-2.5 py-1 rounded-lg bg-red-500/15 text-red-400 text-sm font-semibold border border-red-500/20">
                    Tiết kiệm <?= $discountPct ?>%
                </span>
                <?php endif; ?>
            </div>

            <!-- Mô tả ngắn -->
            <p class="text-zinc-400 text-sm leading-relaxed border-t border-white/5 pt-4">
                <?= htmlspecialchars($product['short_desc'] ?? '') ?>
            </p>

            <!-- ─── SELECTOR BIẾN THỂ ─────────────────────── -->
            <!-- Chọn màu sắc -->
            <div>
                <p class="text-zinc-400 text-sm mb-2">
                    Màu sắc: <span id="selected-color" class="text-white font-medium"><?= htmlspecialchars($uniqueColors[0] ?? '') ?></span>
                </p>
                <div class="flex gap-2 flex-wrap" id="color-options">
                    <?php foreach ($uniqueColors as $color): ?>
                    <button onclick="selectColor('<?= htmlspecialchars($color) ?>')"
                            data-color="<?= htmlspecialchars($color) ?>"
                            class="variant-btn px-4 py-2 rounded-xl border border-zinc-600 text-zinc-300 text-sm font-medium hover:border-accent-400/50 hover:text-accent-300 <?= $color === ($uniqueColors[0] ?? '') ? 'active' : '' ?>">
                        <?= htmlspecialchars($color) ?>
                    </button>
                    <?php endforeach; ?>
                </div>
            </div>

            <!-- Chọn phiên bản -->
            <div>
                <p class="text-zinc-400 text-sm mb-2">
                    Phiên bản: <span id="selected-version" class="text-white font-medium"><?= htmlspecialchars($uniqueVersions[0] ?? '') ?></span>
                </p>
                <div class="flex gap-2 flex-wrap" id="version-options">
                    <?php foreach ($uniqueVersions as $version): ?>
                    <button onclick="selectVersion('<?= htmlspecialchars($version) ?>')"
                            data-version="<?= htmlspecialchars($version) ?>"
                            class="variant-btn px-4 py-2 rounded-xl border border-zinc-600 text-zinc-300 text-sm font-medium hover:border-accent-400/50 hover:text-accent-300 <?= $version === ($uniqueVersions[0] ?? '') ? 'active' : '' ?>">
                        <?= htmlspecialchars($version) ?>
                    </button>
                    <?php endforeach; ?>
                </div>
            </div>

            <!-- Tồn kho -->
            <div id="stock-info" class="text-sm">
                <span class="text-accent-400 flex items-center gap-1.5">
                    <span class="inline-block w-2 h-2 rounded-full bg-accent-400 animate-pulse"></span>
                    Còn hàng (<span id="stock-count"><?= $firstVariant['stock_qty'] ?? 0 ?></span> sản phẩm)
                </span>
            </div>

            <!-- FORM THÊM VÀO GIỎ HÀNG -->
            <form action="/cart/add" method="POST" id="add-to-cart-form">
<?= Csrf::field() ?>
                <input type="hidden" name="product_id" value="<?= $product['id'] ?>">
                <input type="hidden" name="variant_id" id="variant-id-input" value="<?= $firstVariant['id'] ?? '' ?>">
                <!-- CSRF token (thực tế lấy từ session) -->

                <div class="flex flex-col sm:flex-row gap-3">
                    <!-- Bộ chọn số lượng -->
                    <div class="flex items-center rounded-xl border border-zinc-700 bg-zinc-800 overflow-hidden h-12 w-fit">
                        <button type="button" onclick="changeQty(-1)"
                                class="px-4 h-full text-zinc-400 hover:text-accent-400 hover:bg-zinc-700 transition-colors text-lg font-bold">−</button>
                        <input type="number" name="quantity" id="qty-input"
                               value="1" min="1" max="<?= $firstVariant['stock_qty'] ?? 99 ?>"
                               class="w-14 h-full bg-transparent text-center text-white font-semibold focus:outline-none [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none">
                        <button type="button" onclick="changeQty(1)"
                                class="px-4 h-full text-zinc-400 hover:text-accent-400 hover:bg-zinc-700 transition-colors text-lg font-bold">+</button>
                    </div>

                    <!-- Nút Thêm vào giỏ -->
                    <button type="submit" name="action" value="add_cart"
                            class="flex-1 h-12 bg-accent-500 hover:from-accent-400 hover:to-ember-400 text-on font-semibold rounded-xl transition-all hover:shadow-lg hover: flex items-center justify-center gap-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2 9m5-9v9m4-9v9m5-9l2 9"/>
                        </svg>
                        Thêm vào giỏ hàng
                    </button>

                    <!-- Nút Wishlist -->
                    <button type="button" id="wishlist-btn" onclick="toggleWishlist()"
                            class="w-12 h-12 flex items-center justify-center rounded-xl border border-zinc-700 bg-zinc-800 text-zinc-400 hover:text-accent-400 hover:border-accent-400/40 transition-all">
                        <svg id="wishlist-icon" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                        </svg>
                    </button>
                </div>

                <!-- Nút Mua ngay -->
                <button type="submit" name="action" value="buy_now"
                        class="mt-3 w-full h-12 rounded-xl border border-accent-500/40 text-accent-400 hover:bg-accent-500/10 font-semibold transition-all">
                    Mua ngay
                </button>
            </form>

            <!-- Chính sách nhanh -->
            <div class="grid grid-cols-3 gap-2 pt-2 border-t border-white/5">
                <?php
                $policies = [
                    ['icon' => 'M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z', 'label' => 'Bảo hành 12 tháng'],
                    ['icon' => 'M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15', 'label' => 'Đổi trả 7 ngày'],
                    ['icon' => 'M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4', 'label' => 'Giao hàng toàn quốc'],
                ];
                foreach ($policies as $p):
                ?>
                <div class="flex flex-col items-center gap-1 text-center p-2 rounded-xl bg-zinc-800/50">
                    <svg class="w-5 h-5 text-accent-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="<?= $p['icon'] ?>"/>
                    </svg>
                    <span class="text-xs text-zinc-400"><?= $p['label'] ?></span>
                </div>
                <?php endforeach; ?>
            </div>
        </div><!-- end right col -->
    </div><!-- end 2-col grid -->

    <!-- ══════════════════════════════════════════════════════
         SECTION 2: TABS — Thông số | Mô tả | Đánh giá
         ══════════════════════════════════════════════════════ -->
    <div class="mb-14">
        <!-- Tab buttons -->
        <div class="flex gap-0 border-b border-zinc-700 mb-6">
            <?php
            $tabs = [
                ['id' => 'specs',    'label' => 'Thông số kỹ thuật'],
                ['id' => 'desc',     'label' => 'Mô tả sản phẩm'],
                ['id' => 'reviews',  'label' => "Đánh giá ({$product['review_count']})"],
            ];
            foreach ($tabs as $i => $tab):
            ?>
            <button onclick="switchTab('<?= $tab['id'] ?>')"
                    class="tab-btn px-5 py-3 text-sm font-semibold border-b-2 border-transparent text-zinc-400 hover:text-accent-400 transition-all -mb-px <?= $i === 0 ? 'active' : '' ?>"
                    data-tab="<?= $tab['id'] ?>">
                <?= $tab['label'] ?>
            </button>
            <?php endforeach; ?>
        </div>

        <!-- Tab: Thông số kỹ thuật -->
        <div id="tab-specs" class="tab-panel active">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <?php if (empty($specs)): ?>
                <p class="text-sm text-zinc-500 md:col-span-2 py-6 text-center">Thông số kỹ thuật đang được cập nhật.</p>
                <?php endif; ?>
                <?php foreach (($specs ?? []) as $groupName => $specItems): ?>
                <div class="bg-zinc-800/60 border border-white/5 rounded-2xl overflow-hidden">
                    <div class="px-5 py-3 bg-gradient-to-r from-accent-500/10 to-ember-500/5 border-b border-white/5">
                        <h3 class="text-sm font-semibold text-accent-400"><?= htmlspecialchars($groupName) ?></h3>
                    </div>
                    <div class="divide-y divide-white/5">
                        <?php foreach ($specItems as $j => $spec): ?>
                        <div class="flex px-5 py-3 <?= $j % 2 === 0 ? 'bg-zinc-800/30' : '' ?>">
                            <span class="w-2/5 text-zinc-400 text-sm"><?= htmlspecialchars($spec['label']) ?></span>
                            <span class="w-3/5 text-zinc-100 text-sm font-medium"><?= htmlspecialchars($spec['value']) ?></span>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>

        <!-- Tab: Mô tả sản phẩm -->
        <div id="tab-desc" class="tab-panel">
            <div class="bg-zinc-800/60 border border-white/5 rounded-2xl p-6">
                <div class="prose prose-invert max-w-none text-zinc-300 leading-relaxed">
                    <h2 class="text-xl font-bold text-white mb-4"><?= htmlspecialchars($product['name']) ?></h2>
                    <p><?= htmlspecialchars($product['short_desc'] ?? '') ?></p>
                    <p class="mt-4 text-zinc-400">
                        Được thiết kế dành riêng cho game thủ chuyên nghiệp, ZenTech X Pro mang đến trải nghiệm chơi game không giới hạn với cảm biến quang học thế hệ mới nhất từ PixArt, polling rate lên đến 1000Hz và thời lượng pin lên đến 70 giờ liên tục.
                    </p>
                    <ul class="mt-4 space-y-2 text-zinc-400 list-none pl-0">
                        <li class="flex items-center gap-2"><span class="text-accent-400">✓</span> Cảm biến PAW3395 độ chính xác tuyệt đối</li>
                        <li class="flex items-center gap-2"><span class="text-accent-400">✓</span> Switch Omron D2FC-F-K 60 triệu lần nhấn</li>
                        <li class="flex items-center gap-2"><span class="text-accent-400">✓</span> Thiết kế ergonomic giảm mỏi tay</li>
                        <li class="flex items-center gap-2"><span class="text-accent-400">✓</span> RGB Chroma 16.8 triệu màu</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Tab: Đánh giá -->
        <div id="tab-reviews" class="tab-panel">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Tổng quan rating -->
                <div class="bg-zinc-800/60 border border-white/5 rounded-2xl p-6 flex flex-col items-center justify-center gap-3">
                    <div class="text-6xl font-extrabold text-accent-400"><?= number_format($product['avg_rating'] ?? 0, 1) ?></div>
                    <div class="flex gap-1">
                        <?php for ($i = 1; $i <= 5; $i++): ?>
                        <svg class="w-6 h-6 <?= $i <= round($product['avg_rating'] ?? 0) ? 'text-yellow-400' : 'text-zinc-600' ?>"
                             fill="currentColor" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                        </svg>
                        <?php endfor; ?>
                    </div>
                    <p class="text-zinc-400 text-sm"><?= number_format($product['review_count'] ?? 0) ?> đánh giá</p>
                    <!-- Rating bars -->
                    <?php
                    $ratingBars = [5 => 72, 4 => 18, 3 => 6, 2 => 2, 1 => 2];
                    foreach ($ratingBars as $star => $pct):
                    ?>
                    <div class="w-full flex items-center gap-2">
                        <span class="text-xs text-zinc-400 w-4"><?= $star ?></span>
                        <svg class="w-3 h-3 text-yellow-400 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                        </svg>
                        <div class="flex-1 h-1.5 bg-zinc-700 rounded-full overflow-hidden">
                            <div class="rating-fill h-full rounded-full" style="width:<?= $pct ?>%"></div>
                        </div>
                        <span class="text-xs text-zinc-500 w-6 text-right"><?= $pct ?>%</span>
                    </div>
                    <?php endforeach; ?>
                </div>

                <!-- Danh sách review -->
                <div class="md:col-span-2 space-y-4">
                    <?php
                    // Dữ liệu review từ Database (hoặc fallback nếu chưa có đánh giá)
                    $displayReviews = $reviews ?? [];
                    foreach ($displayReviews as $review):
                        $uName = $review['user_name'] ?? 'Khách hàng';
                        $rDate = $review['review_date'] ?? 'Gần đây';
                        $rBody = $review['content'] ?? '';
                        $rRate = (int)($review['rating'] ?? 5);
                    ?>
                    <div class="bg-zinc-800/60 border border-white/5 rounded-2xl p-5">
                        <div class="flex items-start justify-between mb-3">
                            <div class="flex items-center gap-3">
                                <div class="w-9 h-9 rounded-full bg-accent-500 flex items-center justify-center text-on font-bold text-sm flex-shrink-0">
                                    <?= mb_substr($uName, 0, 1) ?>
                                </div>
                                <div>
                                    <p class="text-white font-medium text-sm"><?= htmlspecialchars($uName) ?></p>
                                    <p class="text-zinc-500 text-xs"><?= htmlspecialchars($rDate) ?></p>
                                </div>
                            </div>
                            <div class="flex items-center gap-1">
                                <?php for ($i = 1; $i <= 5; $i++): ?>
                                <svg class="w-3.5 h-3.5 <?= $i <= $rRate ? 'text-yellow-400' : 'text-zinc-600' ?>"
                                     fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                </svg>
                                <?php endfor; ?>
                            </div>
                        </div>
                        <p class="text-zinc-300 text-sm leading-relaxed"><?= htmlspecialchars($rBody) ?></p>
                        <?php if (!empty($review['order_id'])): ?>
                        <div class="mt-3 flex items-center gap-1.5 text-xs text-emerald-400">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            Đã mua hàng chính hãng tại ZenTech
                        </div>
                        <?php endif; ?>
                    </div>
                    <?php endforeach; ?>
                    <?php if (empty($displayReviews)): ?>
                    <p class="text-sm text-zinc-500 py-6 text-center">Chưa có đánh giá nào cho sản phẩm này.</p>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════════════
         SECTION 3: SẢN PHẨM LIÊN QUAN
         ══════════════════════════════════════════════════════ -->
    <section>
        <h2 class="text-xl font-bold text-white mb-5 flex items-center gap-2">
            <span class="inline-block w-1 h-5 bg-gradient-to-b from-accent-400 to-ember-500 rounded-full"></span>
            Sản phẩm liên quan
        </h2>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <?php foreach ($relatedProducts as $rp): ?>
            <?php
            $rpPrice     = (float) ($rp['min_price'] ?? 0);
            $rpOriginal  = (float) ($rp['original_price'] ?? $rpPrice);
            $rpDisc      = ($rpOriginal > 0 && $rpPrice < $rpOriginal) ? (int) round((1 - $rpPrice / $rpOriginal) * 100) : 0;
            ?>
            <a href="/san-pham/<?= e($rp['slug'] ?? $rp['id']) ?>"
               class="group bg-zinc-800/60 border border-white/5 rounded-2xl overflow-hidden hover:border-accent-400/30 hover:shadow-lg hover: transition-all">
                <div class="aspect-square bg-zinc-800 overflow-hidden">
                    <img src="<?= e($rp['thumbnail'] ?? '') ?>" loading="lazy"
                         alt="<?= htmlspecialchars($rp['name']) ?>"
                         class="w-full h-full object-contain p-4 group-hover:scale-105 transition-transform duration-300">
                </div>
                <div class="p-4">
                    <p class="text-zinc-200 text-sm font-medium line-clamp-2 mb-2 group-hover:text-accent-400 transition-colors">
                        <?= htmlspecialchars($rp['name']) ?>
                    </p>
                    <div class="flex items-center gap-2 flex-wrap">
                        <span class="text-accent-400 font-bold text-sm"><?= fmtVnd($rpPrice) ?></span>
                        <?php if ($rpDisc > 0): ?>
                        <span class="text-zinc-500 text-xs line-through"><?= fmtVnd($rpOriginal) ?></span>
                        <span class="text-xs bg-red-500/15 text-red-400 px-1.5 py-0.5 rounded-md">-<?= $rpDisc ?>%</span>
                        <?php endif; ?>
                    </div>
                </div>
            </a>
            <?php endforeach; ?>
        </div>
    </section>

</main>

<!-- ═══════════════════════════════════════════════════════════
     JAVASCRIPT: Quản lý biến thể, gallery, tabs, cart
     ═══════════════════════════════════════════════════════════ -->
<script src="/assets/js/variant-picker.js"></script>
<script>
// ── Dữ liệu variants được encode từ PHP ──
const variants = <?= json_encode(array_map(function($v) {
    return [
        'id'           => $v['id'],
        'color'        => $v['color'],
        'version_spec' => $v['version_spec'],
        'price'        => $v['price'],
        'sale_price'   => $v['sale_price'],
        'stock_qty'    => $v['stock_qty'],
        'image_url'    => $v['image_url'],
        // effective_price: sale_price nếu có, không thì price
        'effective_price' => $v['sale_price'] ?? $v['price'],
    ];
}, $variants), JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP) ?>;

// ── Trạng thái biến thể đang chọn ──
let selectedColor   = <?= json_encode($uniqueColors[0] ?? '', JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_HEX_APOS) ?>;
let selectedVersion = <?= json_encode($uniqueVersions[0] ?? '', JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_HEX_APOS) ?>;
let currentVariant  = null;

// ────────────────────────────────────────
// KHỞI TẠO: chọn variant mặc định
// ────────────────────────────────────────
function initVariants() {
    if (variants.length) pickVariant(selectedColor, selectedVersion, 'color');
}

// Tìm variant theo color + version
function findVariant(color, version) {
    return findVariantIn(variants, color, version);
}

// ── Cập nhật UI khi chọn variant ──
function updateVariantUI(variant) {
    if (!variant) return;

    // Cập nhật giá hiển thị
    document.getElementById('current-price').textContent = formatPrice(variant.effective_price);

    // Cập nhật giá gốc nếu có sale
    const originalEl = document.getElementById('original-price');
    if (originalEl) {
        originalEl.textContent = variant.sale_price ? formatPrice(variant.price) : '';
        originalEl.style.display = variant.sale_price ? '' : 'none';
    }

    // Cập nhật ảnh nếu variant có ảnh riêng
    if (variant.image_url) {
        document.getElementById('main-image').src = variant.image_url;
    }

    // Tồn kho: dựng lại cả khối, và khóa cả hai nút mua khi hết hàng
    const stockInfo = document.getElementById('stock-info');
    const buyButtons = document.querySelectorAll('#add-to-cart-form button[type="submit"]');
    buyButtons.forEach(b => { b.disabled = variant.stock_qty === 0; b.classList.toggle('opacity-50', variant.stock_qty === 0); b.classList.toggle('cursor-not-allowed', variant.stock_qty === 0); });
    if (variant.stock_qty === 0) {
        stockInfo.innerHTML = '<span class="text-red-400 flex items-center gap-1.5"><span class="inline-block w-2 h-2 rounded-full bg-red-400"></span>Hết hàng</span>';
    } else {
        stockInfo.innerHTML = `<span class="text-accent-400 flex items-center gap-1.5"><span class="inline-block w-2 h-2 rounded-full bg-accent-400 animate-pulse"></span>Còn hàng (<span id="stock-count">${variant.stock_qty}</span> sản phẩm)</span>`;
    }

    // Cập nhật variant_id hidden input
    document.getElementById('variant-id-input').value = variant.id;

    // Giới hạn số lượng tối đa
    const qtyInput = document.getElementById('qty-input');
    qtyInput.max = variant.stock_qty;
    if (parseInt(qtyInput.value) > variant.stock_qty) {
        qtyInput.value = Math.max(1, variant.stock_qty);
    }
}

// ── Chọn màu ──
// Chọn màu hoặc phiên bản. Tổ hợp không tồn tại thì tự chuyển trục còn lại sang biến thể có thật,
// để thứ hiển thị luôn đúng với thứ được thêm vào giỏ.
function pickVariant(color, version, changed) {
    const r = resolveVariant(variants, color, version, changed);
    color = r.color; version = r.version; const v = r.variant;
    selectedColor = color; selectedVersion = version; currentVariant = v;
    document.getElementById('selected-color').textContent = color;
    document.getElementById('selected-version').textContent = version;
    document.querySelectorAll('#color-options .variant-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.color === color);
        btn.classList.toggle('unavailable', !findVariant(btn.dataset.color, version));
    });
    document.querySelectorAll('#version-options .variant-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.version === version);
        btn.classList.toggle('unavailable', !findVariant(color, btn.dataset.version));
    });
    updateVariantUI(v);
}
function selectColor(color)     { pickVariant(color, selectedVersion, 'color'); }
function selectVersion(version) { pickVariant(selectedColor, version, 'version'); }

// ── Nút tăng/giảm số lượng ──
function changeQty(delta) {
    const input = document.getElementById('qty-input');
    const max   = parseInt(input.max) || 99;
    let   val   = parseInt(input.value) + delta;
    val = Math.min(Math.max(1, val), max);
    input.value = val;
}

// ── Chuyển ảnh chính từ thumbnail ──
function setMainImage(src, btn) {
    document.getElementById('main-image').src = src;
    document.querySelectorAll('.thumb-btn').forEach(b => b.classList.remove('thumb-active'));
    btn.classList.add('thumb-active');
}

// ── Chuyển tab ──
function switchTab(tabId) {
    // Ẩn tất cả panels
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));

    // Hiện panel và active tab button được chọn
    document.getElementById('tab-' + tabId)?.classList.add('active');
    document.querySelector(`.tab-btn[data-tab="${tabId}"]`)?.classList.add('active');
}

// ── Toggle wishlist ──
// Trạng thái yêu thích lấy từ máy chủ (session), không tự đoán ở trình duyệt
function paintWishlist(on) {
    const btn = document.getElementById('wishlist-btn');
    document.getElementById('wishlist-icon').setAttribute('fill', on ? 'currentColor' : 'none');
    btn.classList.toggle('text-accent-400', on);
    btn.classList.toggle('border-accent-400/40', on);
    btn.classList.toggle('text-zinc-400', !on);
    btn.classList.toggle('border-zinc-700', !on);
    btn.setAttribute('aria-pressed', on);
    btn.setAttribute('aria-label', on ? 'Bỏ khỏi yêu thích' : 'Thêm vào yêu thích');
}
async function toggleWishlist() {
    try {
        const res = await fetch('/wishlist/toggle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ product_id: <?= (int) $product['id'] ?> })
        });
        const data = await res.json();
        if (!data.success) throw new Error(data.message);
        paintWishlist(data.wished);
        ZenTechApp.showToast(data.wished ? 'Đã thêm vào yêu thích' : 'Đã bỏ khỏi yêu thích', 'success');
    } catch (e) {
        ZenTechApp.showToast('Không cập nhật được yêu thích, vui lòng thử lại.', 'error');
    }
}
paintWishlist(<?= in_array((int) $product['id'], $_SESSION['wishlist'] ?? [], true) ? 'true' : 'false' ?>);

// ── Format giá VNĐ ──
function formatPrice(price) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price);
}

// ── Thêm vào giỏ / Mua ngay (AJAX, không rời trang) ──
document.getElementById('add-to-cart-form').addEventListener('submit', async function (e) {
    e.preventDefault();
    const form    = this;
    const buyNow  = e.submitter && e.submitter.value === 'buy_now';
    const qtyEl   = document.getElementById('qty-input');
    const qty     = parseInt(qtyEl.value);
    const max     = parseInt(qtyEl.max) || 1;
    const toast   = (m, t) => (window.ZenTechApp ? ZenTechApp.showToast(m, t) : alert(m));

    if (!currentVariant)            return toast('Vui lòng chọn biến thể sản phẩm!', 'error');
    if (currentVariant.stock_qty === 0) return toast('Sản phẩm đã hết hàng!', 'error');
    if (!(qty >= 1 && qty <= max))  return toast(`Số lượng phải từ 1 đến ${max}!`, 'error');

    const buttons = form.querySelectorAll('button[type=submit]');
    buttons.forEach(b => { b.disabled = true; b.classList.add('opacity-60', 'cursor-wait'); });

    try {
        const res  = await fetch('/cart/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({
                variant_id: document.getElementById('variant-id-input').value,
                quantity: qty,
            }),
        });
        const data = await res.json();
        if (!data.success) {
            toast(data.message || 'Không thể thêm vào giỏ hàng.', 'error');
            return;
        }
        if (buyNow) { window.location.href = '/thanh-toan'; return; }
        toast(data.message || 'Đã thêm vào giỏ hàng!', 'success');
        if (window.ZenTechApp) ZenTechApp.updateCartBadge();
    } catch (err) {
        toast('Lỗi kết nối máy chủ, vui lòng thử lại.', 'error');
    } finally {
        buttons.forEach(b => { b.disabled = false; b.classList.remove('opacity-60', 'cursor-wait'); });
    }
});

// Khởi tạo khi DOM ready
document.addEventListener('DOMContentLoaded', initVariants);
</script>


