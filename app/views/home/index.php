<?php
/**
 * VIEW: Trang chủ ZenTech (Home Page)
 * Phong cách Cyber-Minimalist Dark Mode
 *
 * Variables:
 *   $featuredProducts : array
 *   $newProducts      : array
 *   $categories       : array
 */
?>

<?php
$hero = $featuredProducts[0] ?? null;
$heroImg = $hero ? ($hero['thumbnail'] ?? '') : '';
$heroDisc = $hero ? (int) ($hero['max_discount_pct'] ?? 0) : 0;
?>

<!-- 1. Màn hình đầu: luận điểm + sản phẩm nổi bật có giá và nút mua -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-10 pb-14 md:pt-16 md:pb-20">
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-12 items-center">
        <div class="lg:col-span-5 rise">
            <h1 class="text-[2.6rem] sm:text-6xl lg:text-[3.8rem] font-bold leading-[1.04] text-zinc-100">
                Chọn gear<br>theo thông số.
            </h1>
            <p class="mt-6 text-lg text-zinc-400 max-w-md leading-relaxed">
                Chuột, bàn phím cơ và tai nghe chính hãng. Mỗi sản phẩm ghi rõ cảm biến, switch, trọng lượng và pin, để bạn so sánh trước khi mua.
            </p>
            <div class="mt-8 flex flex-wrap items-center gap-2">
                <a href="/san-pham" class="btn-primary">Xem sản phẩm</a>
                <button type="button" onclick="window.ZenBotWidget && window.ZenBotWidget.toggle()" class="btn-ghost">Hỏi ZenBot chọn giúp &rsaquo;</button>
            </div>
        </div>

        <?php if ($hero): ?>
        <a href="/san-pham/<?= e($hero['slug']) ?>" class="stage group lg:col-span-7 block rise" data-par="0.08" style="animation-delay:.08s">
            <div class="aspect-[16/10] flex items-center justify-center px-8 pt-8 sm:px-12 sm:pt-12">
                <img src="<?= e($heroImg) ?>" alt="<?= e($hero['name']) ?>"
                     class="max-h-full max-w-full object-contain transition-transform duration-700 ease-out group-hover:scale-[1.04]">
            </div>
            <div class="flex flex-wrap items-end justify-between gap-3 p-5 sm:p-7">
                <div>
                    <p class="text-sm text-zinc-400"><?= e($hero['brand_name']) ?></p>
                    <h2 class="text-lg sm:text-xl font-semibold text-zinc-100"><?= e($hero['name']) ?></h2>
                    <p class="mt-0.5 text-zinc-300 tabular-nums">
                        Từ <?= number_format($hero['min_price'], 0, ',', '.') ?>₫
                        <?php if ($heroDisc > 0): ?><span class="ml-1 text-red-500 font-medium">Giảm <?= $heroDisc ?>%</span><?php endif; ?>
                    </p>
                </div>
                <span class="btn-primary pointer-events-none">Mua ngay</span>
            </div>
        </a>
        <?php endif; ?>
    </div>
</section>

<!-- 2. Chính sách có thật -->
<section class="border-y border-zinc-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 grid grid-cols-1 sm:grid-cols-3 divide-y sm:divide-y-0 sm:divide-x divide-zinc-800">
        <p class="py-5 sm:px-6 first:sm:pl-0 text-sm text-zinc-400"><strong class="block text-zinc-100 font-semibold">Miễn phí vận chuyển</strong>Cho đơn từ 500.000₫</p>
        <p class="py-5 sm:px-6 text-sm text-zinc-400"><strong class="block text-zinc-100 font-semibold">Đổi trả trong 7 ngày</strong>Nếu sản phẩm có lỗi</p>
        <p class="py-5 sm:px-6 text-sm text-zinc-400"><strong class="block text-zinc-100 font-semibold">Bảo hành chính hãng</strong>12 tháng cho mọi sản phẩm</p>
    </div>
</section>

<!-- 3. Danh mục -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <h2 class="text-3xl sm:text-4xl font-bold text-zinc-100">Mua theo loại.</h2>
    <div class="mt-8 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3">
        <?php foreach (array_slice(array_filter($categories ?? [], fn($c) => !$c['parent_id']), 0, 5) as $cat): ?>
            <a href="/san-pham?category[]=<?= e($cat['slug']) ?>"
               class="group flex flex-col justify-between min-h-[8.5rem] p-5 rounded-2xl bg-zinc-900 hover:bg-zinc-850 transition-colors">
                <span class="text-lg font-semibold leading-snug text-zinc-100"><?= e($cat['name']) ?></span>
                <span class="text-sm font-medium text-accent-400 group-hover:underline">Xem ngay &rsaquo;</span>
            </a>
        <?php endforeach; ?>
    </div>
</section>

<!-- 4. Nổi bật -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div class="flex items-end justify-between gap-4">
        <h2 class="text-3xl sm:text-4xl font-bold text-zinc-100">Đang được chọn nhiều.</h2>
        <a href="/san-pham" class="hidden sm:inline text-sm font-medium text-accent-400 hover:underline">Xem tất cả &rsaquo;</a>
    </div>
    <div class="mt-8 grid grid-cols-2 lg:grid-cols-4 gap-x-4 gap-y-10 sm:gap-x-6">
        <?php foreach (($featuredProducts ?? []) as $product): include VIEW_PATH . '/partials/product-card.php'; endforeach; ?>
    </div>
</section>

<!-- 5. ZenBot -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div class="rounded-3xl bg-zinc-900 px-6 py-12 sm:px-14 sm:py-16 flex flex-col md:flex-row md:items-center md:justify-between gap-8">
        <div class="max-w-xl">
            <h2 class="text-3xl sm:text-4xl font-bold text-zinc-100">Chưa biết chọn gì?</h2>
            <p class="mt-3 text-lg text-zinc-400">Nói ngân sách và game bạn chơi, ZenBot gợi ý vài mẫu phù hợp.</p>
        </div>
        <button type="button" onclick="window.ZenBotWidget && window.ZenBotWidget.toggle()" class="btn-primary shrink-0">Hỏi ZenBot</button>
    </div>
</section>

<!-- 6. Mới về -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-20">
    <h2 class="text-3xl sm:text-4xl font-bold text-zinc-100">Mới về.</h2>
    <div class="mt-8 grid grid-cols-2 lg:grid-cols-4 gap-x-4 gap-y-10 sm:gap-x-6">
        <?php foreach (($newProducts ?? []) as $product): include VIEW_PATH . '/partials/product-card.php'; endforeach; ?>
    </div>
</section>
