<?php
/**
 * VIEW: Danh sách sản phẩm & Bộ lọc (CellphoneS Style)
 *
 * Variables:
 *   $products   : array
 *   $categories : array
 *   $brands     : array
 *   $filters    : array (category_slug, brand_slug, price_min, price_max, sort)
 *   $page       : int
 *   $totalPages : int
 *   $totalItems : int
 */
?>

<?php
// Bộ lọc dạng pop-up: dữ liệu cho nút "Bộ lọc", các chip đang áp dụng và các nút chọn nhanh
$catName   = array_column($categories, 'name', 'slug');
$brandName = array_column($brands, 'name', 'slug');
$pMin = (int) ($filters['price_min'] ?? 0);
$pMax = (int) ($filters['price_max'] ?? 0);
$fmt  = fn($n) => number_format($n, 0, ',', '.') . '₫';
$cats   = (array) ($filters['category_slug'] ?? []);
$brs    = (array) ($filters['brand_slug'] ?? []);
// Bỏ một tham số, hoặc chỉ một giá trị trong tham số dạng mảng, rồi về trang 1
$without = function (array $drop, ?string $key = null, ?string $val = null): string {
    $q = $_GET; unset($q['page']);
    if ($key !== null && is_array($q[$key] ?? null)) { $q[$key] = array_values(array_diff($q[$key], [$val])); }
    elseif ($key !== null && ($q[$key] ?? null) === $val) { unset($q[$key]); }
    foreach ($drop as $k) unset($q[$k]);
    return '/san-pham?' . http_build_query($q);
};
$active = [];   // [nhãn, url bỏ chip]
if (!empty($filters['keyword'])) $active[] = ['“' . $filters['keyword'] . '”', $without(['q', 'keyword'])];
foreach ($cats as $v) $active[] = [$catName[$v] ?? $v, $without([], 'category', $v)];
foreach ($brs as $v)  $active[] = [$brandName[$v] ?? $v, $without([], 'brand', $v)];
if ($pMin > 0 || $pMax > 0) $active[] = [$pMin && $pMax ? $fmt($pMin) . ' - ' . $fmt($pMax) : ($pMin ? 'Từ ' . $fmt($pMin) : 'Đến ' . $fmt($pMax)), $without(['price_min', 'price_max', 'min_price', 'max_price'])];
$pricePresets = [['Dưới 500K', 0, 500000], ['500K - 1 triệu', 500000, 1000000], ['1 - 2 triệu', 1000000, 2000000], ['2 - 4 triệu', 2000000, 4000000], ['Trên 4 triệu', 4000000, 0]];
// Nút chọn dạng pill: input radio ẩn + nhãn
$pill = 'inline-flex items-center px-4 py-2 rounded-full text-sm font-medium border border-zinc-700 bg-zinc-950 text-zinc-300 cursor-pointer transition-colors hover:border-zinc-500 peer-checked:bg-accent-500 peer-checked:border-accent-500 peer-checked:text-on peer-focus-visible:ring-2 peer-focus-visible:ring-accent-400';
?>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <nav class="flex items-center gap-2 text-xs text-zinc-400 mb-6" aria-label="Breadcrumb">
        <a href="/" class="hover:text-accent-400">Trang chủ</a>
        <span aria-hidden="true">/</span>
        <span class="text-zinc-200">Sản phẩm Gaming Gear</span>
    </nav>

    <div class="flex flex-col gap-1">
        <h1 class="text-3xl sm:text-4xl font-bold text-zinc-100">Gaming gear &amp; phụ kiện</h1>
        <p class="text-sm text-zinc-400"><?= (int) ($totalItems ?? 0) ?> sản phẩm phù hợp</p>
    </div>

    <!-- Thanh công cụ: nút Bộ lọc (mở pop-up), chip đang áp dụng, sắp xếp -->
    <div class="mt-6 flex flex-wrap items-center gap-2 pb-6 border-b border-zinc-800">
        <button type="button" id="open-filter" aria-haspopup="dialog"
                class="inline-flex items-center gap-2 px-4 py-2.5 rounded-full border border-zinc-700 text-sm font-semibold text-zinc-100 hover:border-zinc-500 transition-colors">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 6h16M7 12h10M10 18h4"/></svg>
            Bộ lọc
            <?php if ($active): ?><span class="min-w-5 h-5 px-1 rounded-full bg-accent-500 text-on text-xs flex items-center justify-center"><?= count($active) ?></span><?php endif; ?>
        </button>

        <?php foreach ($active as [$label, $url]): ?>
            <a href="<?= e($url) ?>" class="inline-flex items-center gap-1.5 pl-3.5 pr-2.5 py-2 rounded-full bg-accent-50 text-accent-400 text-sm font-medium hover:bg-accent-100 transition-colors" aria-label="Bỏ lọc <?= e($label) ?>">
                <?= e($label) ?>
                <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18"/></svg>
            </a>
        <?php endforeach; ?>
        <?php if ($active): ?><a href="/san-pham" class="px-2 text-sm text-zinc-400 hover:text-accent-400">Xóa tất cả</a><?php endif; ?>

        <form method="GET" action="/san-pham" class="ml-auto flex items-center gap-2">
            <?php foreach ($_GET as $k => $v): if ($k === 'sort' || $k === 'page') continue;
                foreach ((array) $v as $item): if (!is_string($item)) continue; ?>
                <input type="hidden" name="<?= e($k) ?><?= is_array($v) ? '[]' : '' ?>" value="<?= e($item) ?>">
            <?php endforeach; endforeach; ?>
            <label for="sort-select" class="text-sm text-zinc-400 whitespace-nowrap">Sắp xếp</label>
            <select id="sort-select" name="sort" onchange="this.form.submit()"
                    class="bg-zinc-950 border border-zinc-700 rounded-full pl-4 pr-8 py-2 text-sm text-zinc-100 focus:border-accent-400 focus:outline-none">
                <?php foreach (['newest' => 'Mới nhất', 'price_asc' => 'Giá tăng dần', 'price_desc' => 'Giá giảm dần', 'name_asc' => 'Tên A - Z'] as $val => $lbl): ?>
                    <option value="<?= $val ?>" <?= ($filters['sort'] ?? 'newest') === $val ? 'selected' : '' ?>><?= $lbl ?></option>
                <?php endforeach; ?>
            </select>
        </form>
    </div>

    <!-- POP-UP BỘ LỌC (thẻ dialog gốc: có Esc, khóa cuộn, trả focus) -->
    <dialog id="filter-dialog" aria-labelledby="filter-title"
            class="w-[min(40rem,calc(100vw-1.5rem))] max-h-[calc(100vh-2rem)] p-0 rounded-3xl bg-zinc-950 text-zinc-100 shadow-2xl backdrop:bg-black/40 open:flex open:flex-col m-auto">
        <form id="filter-form" method="GET" action="/san-pham" class="flex min-h-0 flex-1 flex-col">
            <input type="hidden" name="sort" value="<?= e($filters['sort'] ?? 'newest') ?>">

            <div class="flex items-center justify-between px-6 py-5 border-b border-zinc-800">
                <h2 id="filter-title" class="text-xl font-bold">Bộ lọc</h2>
                <button type="button" data-close class="p-2 -mr-2 rounded-full text-zinc-400 hover:bg-zinc-900" aria-label="Đóng bộ lọc">
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18"/></svg>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto px-6 py-5 space-y-7">
                <fieldset>
                    <legend class="text-sm font-semibold mb-1">Loại sản phẩm</legend>
                    <p class="text-xs text-zinc-400 mb-3">Chọn một hoặc nhiều loại. Không chọn nghĩa là tất cả.</p>
                    <div class="flex flex-wrap gap-2">
                        <?php foreach ($categories as $cat): if ($cat['child_count'] > 0) continue; // chỉ loại cuối, tránh trùng cha/con ?>
                            <label><input type="checkbox" name="category[]" value="<?= e($cat['slug']) ?>" class="peer sr-only" <?= in_array($cat['slug'], $cats, true) ? 'checked' : '' ?>><span class="<?= $pill ?>"><?= e($cat['name']) ?></span></label>
                        <?php endforeach; ?>
                    </div>
                </fieldset>

                <fieldset>
                    <legend class="text-sm font-semibold mb-1">Thương hiệu</legend>
                    <p class="text-xs text-zinc-400 mb-3">Chọn một hoặc nhiều hãng.</p>
                    <div class="flex flex-wrap gap-2">
                        <?php foreach ($brands as $brand): ?>
                            <label><input type="checkbox" name="brand[]" value="<?= e($brand['slug']) ?>" class="peer sr-only" <?= in_array($brand['slug'], $brs, true) ? 'checked' : '' ?>><span class="<?= $pill ?>"><?= e($brand['name']) ?></span></label>
                        <?php endforeach; ?>
                    </div>
                </fieldset>

                <fieldset>
                    <legend class="text-sm font-semibold mb-3">Khoảng giá</legend>
                    <div class="flex flex-wrap gap-2" id="price-presets">
                        <?php foreach ($pricePresets as [$lbl, $lo, $hi]): ?>
                            <label><input type="radio" name="price_preset" class="peer sr-only" data-min="<?= $lo ?>" data-max="<?= $hi ?>" <?= ($pMin === $lo && $pMax === $hi) ? 'checked' : '' ?>><span class="<?= $pill ?>"><?= $lbl ?></span></label>
                        <?php endforeach; ?>
                    </div>
                    <div class="mt-3 grid grid-cols-2 gap-3">
                        <label class="block"><span class="sr-only">Giá từ</span>
                            <input type="number" min="0" step="10000" inputmode="numeric" name="price_min" id="price-min" placeholder="Từ (₫)" value="<?= $pMin > 0 ? $pMin : '' ?>"
                                   class="w-full rounded-xl bg-zinc-900 border border-transparent focus:border-accent-400 focus:outline-none px-4 py-2.5 text-sm"></label>
                        <label class="block"><span class="sr-only">Giá đến</span>
                            <input type="number" min="0" step="10000" inputmode="numeric" name="price_max" id="price-max" placeholder="Đến (₫)" value="<?= $pMax > 0 ? $pMax : '' ?>"
                                   class="w-full rounded-xl bg-zinc-900 border border-transparent focus:border-accent-400 focus:outline-none px-4 py-2.5 text-sm"></label>
                    </div>
                </fieldset>
            </div>

            <div class="flex items-center gap-3 px-6 py-4 border-t border-zinc-800 bg-zinc-950">
                <a href="/san-pham" class="btn-ghost">Xóa lọc</a>
                <button type="submit" class="btn-primary ml-auto">Xem kết quả</button>
            </div>
        </form>
    </dialog>

    <div class="pt-8">
        <main>
            <?php if (!empty($products)): ?>
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-x-4 gap-y-10 sm:gap-x-6">
                    <?php 
                    foreach ($products as $product) {
                        include VIEW_PATH . '/partials/product-card.php';
                    }
                    ?>
                </div>

                <!-- Phân trang gọn: trước / 1 … trang hiện tại ±1 … cuối / sau -->
                <?php if ($totalPages > 1):
                    $pageUrl = fn(int $n) => '/san-pham?' . http_build_query(array_merge($_GET, ['page' => $n]));
                    $show = array_unique(array_filter([1, $page - 1, $page, $page + 1, $totalPages], fn($n) => $n >= 1 && $n <= $totalPages));
                    sort($show);
                    $btn = 'min-w-10 h-10 px-3 rounded-full flex items-center justify-center text-sm font-medium transition-colors';
                ?>
                    <nav class="flex flex-wrap items-center justify-center gap-1.5 mt-14" aria-label="Phân trang">
                        <?php if ($page > 1): ?><a href="<?= e($pageUrl($page - 1)) ?>" class="<?= $btn ?> text-accent-400 hover:bg-accent-50">&lsaquo; Trước</a><?php endif; ?>
                        <?php $prev = 0; foreach ($show as $n): ?>
                            <?php if ($n - $prev > 1): ?><span class="px-1 text-zinc-500" aria-hidden="true">&hellip;</span><?php endif; ?>
                            <a href="<?= e($pageUrl($n)) ?>" <?= $n === $page ? 'aria-current="page"' : '' ?>
                               class="<?= $btn ?> <?= $n === $page ? 'bg-accent-500 text-on' : 'text-zinc-200 hover:bg-zinc-900' ?>"><?= $n ?></a>
                        <?php $prev = $n; endforeach; ?>
                        <?php if ($page < $totalPages): ?><a href="<?= e($pageUrl($page + 1)) ?>" class="<?= $btn ?> text-accent-400 hover:bg-accent-50">Sau &rsaquo;</a><?php endif; ?>
                    </nav>
                <?php endif; ?>

            <?php else: ?>
                <div class="text-center py-20 bg-zinc-900/40 rounded-3xl border border-zinc-800">
                    <div class="text-5xl mb-4"></div>
                    <h3 class="text-lg font-bold text-white mb-2">Không tìm thấy sản phẩm nào</h3>
                    <p class="text-xs text-zinc-400 mb-6">Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm của bạn.</p>
                    <a href="/san-pham" class="inline-flex items-center px-5 py-2.5 rounded-xl bg-accent-500/20 text-accent-400 border border-accent-500/30 text-xs font-semibold hover:bg-accent-500/30 transition">
                        Đặt lại bộ lọc
                    </a>
                </div>
            <?php endif; ?>
        </main>
    </div>
</div>

<script>
(function () {
    const dlg = document.getElementById('filter-dialog');
    const open = document.getElementById('open-filter');
    open.addEventListener('click', () => dlg.showModal());
    dlg.querySelectorAll('[data-close]').forEach(b => b.addEventListener('click', () => dlg.close()));
    // Bấm ra ngoài hộp thoại thì đóng
    dlg.addEventListener('click', e => { if (e.target === dlg) dlg.close(); });

    // Nút chọn nhanh khoảng giá điền vào hai ô nhập; sửa tay thì bỏ chọn nút
    const min = document.getElementById('price-min'), max = document.getElementById('price-max');
    const presets = dlg.querySelectorAll('#price-presets input');
    presets.forEach(r => r.addEventListener('change', () => {
        min.value = +r.dataset.min || '';
        max.value = +r.dataset.max || '';
    }));
    [min, max].forEach(i => i.addEventListener('input', () => presets.forEach(r => r.checked = false)));
})();
</script>
