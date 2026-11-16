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

<!-- 1. Màn hình đầu: tiêu đề lớn căn giữa, sản phẩm nổi bật bên dưới -->
<section class="hero-center max-w-5xl mx-auto px-4 sm:px-6 pt-12 pb-10 md:pt-20 md:pb-16">
    <div class="rise">
        <p class="t-eyebrow text-zinc-400">Gaming gear chính hãng</p>
        <h1 class="t-marquee mt-2 text-zinc-100">Chọn gear<br>theo thông số.</h1>
        <p class="t-lead mt-5 mx-auto max-w-2xl">Mỗi sản phẩm ghi rõ cảm biến, switch, trọng lượng và pin, để bạn so sánh trước khi mua.</p>
        <div class="mt-7 flex flex-wrap items-center justify-center gap-x-6 gap-y-3">
            <a href="/san-pham" class="btn-primary">Xem sản phẩm</a>
            <button type="button" onclick="window.ZenBotWidget && window.ZenBotWidget.toggle()" class="link-more">Hỏi ZenBot chọn giúp</button>
        </div>
    </div>
    <?php if ($hero): ?>
    <a href="/san-pham/<?= e($hero['slug']) ?>" class="group block rise" style="animation-delay:.1s" aria-label="<?= e($hero['name']) ?>">
        <div class="hero-img" data-par="0.06"><img src="<?= e($heroImg) ?>" alt="<?= e($hero['name']) ?>" class="transition-transform duration-700 ease-out group-hover:scale-[1.04]"></div>
        <p class="mt-6 t-eyebrow text-zinc-100"><?= e($hero['name']) ?></p>
        <p class="mt-1 text-zinc-400 tabular-nums">Từ <?= number_format($hero['min_price'], 0, ',', '.') ?>₫<?php if ($heroDisc > 0): ?> <span class="text-red-500 font-medium">· giảm <?= $heroDisc ?>%</span><?php endif; ?></p>
        <span class="link-more mt-2 inline-block">Mua ngay</span>
    </a>
    <?php endif; ?>
</section>

<!-- 2. Chính sách có thật -->
<section class="border-y border-zinc-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 grid grid-cols-1 sm:grid-cols-3 divide-y sm:divide-y-0 sm:divide-x divide-zinc-800">
        <p class="py-5 sm:px-6 first:sm:pl-0 text-sm text-zinc-400"><strong class="block text-zinc-100 font-semibold">Miễn phí vận chuyển</strong>Cho đơn từ 500.000₫</p>
        <p class="py-5 sm:px-6 text-sm text-zinc-400"><strong class="block text-zinc-100 font-semibold">Đổi trả trong 7 ngày</strong>Nếu sản phẩm có lỗi</p>
        <p class="py-5 sm:px-6 text-sm text-zinc-400"><strong class="block text-zinc-100 font-semibold">Bảo hành chính hãng</strong>12 tháng cho mọi sản phẩm</p>
    </div>
</section>

<!-- 3. Danh mục: ô lớn trên dải nền xám -->
<section class="band band-pad">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 class="t-section text-zinc-100">Mua theo loại.</h2>
        <?php $tops = array_slice(array_filter($categories ?? [], fn($c) => !$c['parent_id']), 0, 4); ?>
        <div class="mt-10 grid grid-cols-1 sm:grid-cols-2 gap-4">
            <?php foreach ($tops as $cat):
                $ci = $catImages[$cat['id']] ?? ''; ?>
            <a href="/san-pham?category[]=<?= e($cat['slug']) ?>" class="tile group">
                <div class="relative z-10">
                    <h3 class="t-eyebrow text-zinc-100"><?= e($cat['name']) ?></h3>
                    <span class="link-more mt-2 inline-block">Xem sản phẩm</span>
                </div>
                <?php if ($ci): ?><img src="<?= e($ci) ?>" alt="" loading="lazy" class="tile-img"><?php endif; ?>
            </a>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<!-- 4. Nổi bật -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24">
    <div class="flex items-end justify-between gap-4">
        <h2 class="t-section text-zinc-100">Đang được chọn nhiều.</h2>
        <a href="/san-pham" class="hidden sm:inline link-more">Xem tất cả</a>
    </div>
    <div class="mt-8 grid grid-cols-2 lg:grid-cols-4 gap-x-4 gap-y-10 sm:gap-x-6">
        <?php foreach (($featuredProducts ?? []) as $product): include VIEW_PATH . '/partials/product-card.php'; endforeach; ?>
    </div>
</section>

<!-- 5. ZenBot -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div class="rounded-3xl bg-zinc-900 px-6 py-12 sm:px-14 sm:py-16 flex flex-col md:flex-row md:items-center md:justify-between gap-8">
        <div class="max-w-xl">
            <h2 class="t-section text-zinc-100">Chưa biết chọn gì?</h2>
            <p class="mt-3 text-lg text-zinc-400">Nói ngân sách và game bạn chơi, ZenBot gợi ý vài mẫu phù hợp.</p>
        </div>
        <button type="button" onclick="window.ZenBotWidget && window.ZenBotWidget.toggle()" class="btn-primary shrink-0">Hỏi ZenBot</button>
    </div>
</section>

<!-- 6. Mới về -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-20">
    <h2 class="t-section text-zinc-100">Mới về.</h2>
    <div class="mt-8 grid grid-cols-2 lg:grid-cols-4 gap-x-4 gap-y-10 sm:gap-x-6">
        <?php foreach (($newProducts ?? []) as $product): include VIEW_PATH . '/partials/product-card.php'; endforeach; ?>
    </div>
</section>
