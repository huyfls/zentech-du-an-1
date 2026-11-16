<?php
/** VIEW: Sản phẩm yêu thích. Biến: $products */
?>
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <h1 class="text-3xl font-bold text-zinc-100">Sản phẩm yêu thích</h1>
    <p class="mt-1 text-sm text-zinc-400" id="wish-summary"><?= count($products) ?> sản phẩm đã lưu</p>

    <?php if (!$products): ?>
        <div class="mt-10 rounded-3xl bg-zinc-900 px-6 py-16 text-center">
            <p class="text-lg font-semibold text-zinc-100">Bạn chưa lưu sản phẩm nào</p>
            <p class="mt-1 text-sm text-zinc-400">Bấm biểu tượng trái tim trên sản phẩm để lưu lại xem sau.</p>
            <a href="/san-pham" class="btn-primary mt-6 inline-block">Xem sản phẩm</a>
        </div>
    <?php else: ?>
        <div class="mt-8 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-x-4 gap-y-10" id="wish-grid">
            <?php foreach ($products as $product): ?>
                <?php include VIEW_PATH . '/partials/product-card.php'; ?>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>
