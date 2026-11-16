<?php
/**
 * PARTIAL: Product Card
 * Hiển thị card sản phẩm phong cách Cyber-Dark Mode
 *
 * Variables:
 *   $product: array (id, name, slug, thumbnail, brand_name, min_price, original_price, max_discount_pct, avg_rating)
 */
$minPrice = $product['min_price'] ?? ($product['base_price'] ?? 0);
$origPrice = $product['original_price'] ?? null;
$discountPct = $product['max_discount_pct'] ?? 0;
$rating = $product['avg_rating'] ?? 5.0;
$thumbnail = !empty($product['thumbnail']) ? $product['thumbnail'] : (!empty($product['thumbnail_url']) ? $product['thumbnail_url'] : '');
?>

<article class="group relative flex flex-col">
    <div class="relative">
    <a href="/san-pham/<?= e($product['slug'] ?? '') ?>" class="stage relative block aspect-square" tabindex="-1" aria-hidden="true">
        <img src="<?= e($thumbnail) ?>" alt="" loading="lazy"
             class="w-full h-full object-contain p-6 transition-transform duration-700 ease-out group-hover:scale-[1.05]">
    </a>
    <?php if (!empty($product['id'])): ?>
    <button type="button" data-quick-add="<?= (int) $product['id'] ?>" aria-label="Thêm <?= e($product['name'] ?? 'sản phẩm') ?> vào giỏ hàng" title="Thêm vào giỏ hàng"
            class="absolute bottom-3 right-3 z-10 w-11 h-11 rounded-full bg-accent-500 text-on flex items-center justify-center shadow-lg transition duration-200 hover:scale-110 active:scale-95 lg:opacity-0 lg:translate-y-1 lg:group-hover:opacity-100 lg:group-hover:translate-y-0 focus-visible:opacity-100 focus-visible:translate-y-0">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" d="M12 5v14M5 12h14"/></svg>
    </button>
    <?php endif; ?>
    </div>

    <div class="flex flex-1 flex-col pt-4 px-1">
        <p class="text-xs font-medium text-zinc-400"><?= e($product['brand_name'] ?? 'Gaming Gear') ?></p>
        <h3 class="mt-1 text-[15px] font-semibold text-zinc-100 leading-snug line-clamp-2">
            <a href="/san-pham/<?= e($product['slug'] ?? '') ?>" class="after:absolute after:inset-0"><?= e($product['name'] ?? '') ?></a>
        </h3>
        <div class="mt-auto pt-3 flex items-baseline gap-2 flex-wrap">
            <span class="text-[15px] font-semibold text-zinc-100 tabular-nums">Từ <?= number_format($minPrice, 0, ',', '.') ?>₫</span>
            <?php if (!empty($origPrice) && $origPrice > $minPrice): ?>
                <span class="text-sm text-zinc-500 line-through tabular-nums"><?= number_format($origPrice, 0, ',', '.') ?>₫</span>
            <?php endif; ?>
            <?php if (!empty($discountPct) && $discountPct > 0): ?>
                <span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-red-500/10 text-red-500">Giảm <?= (int) $discountPct ?>%</span>
            <?php endif; ?>
        </div>
        <?php if (!empty($product['review_count'])): ?>
        <p class="mt-1 text-xs text-zinc-400"><span class="text-ember-400">★</span> <?= number_format($rating, 1) ?> · <?= (int) $product['review_count'] ?> đánh giá</p>
        <?php endif; ?>
    </div>
</article>
