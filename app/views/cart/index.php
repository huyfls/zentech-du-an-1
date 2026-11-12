<?php
/**
 * VIEW: Giỏ hàng (Shopping Cart)
 *
 * Variables:
 *   $cartItems : array
 *   $subtotal  : float
 *   $itemCount : int
 */
$shippingFee = ($subtotal >= 500000 || $subtotal == 0) ? 0 : 30000;
$total = $subtotal + $shippingFee;
?>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <!-- Breadcrumb -->
    <nav class="flex items-center gap-2 text-xs text-zinc-400 mb-6">
        <a href="/" class="hover:text-accent-400">Trang chủ</a>
        <span>/</span>
        <span class="text-zinc-200">Giỏ hàng của bạn</span>
    </nav>

    <h1 class="text-2xl sm:text-3xl font-black text-white tracking-tight mb-8 flex items-center gap-3">
        <span>Giỏ Hàng</span>
        <span class="text-sm font-semibold px-2.5 py-0.5 rounded-full bg-accent-500/20 text-accent-400 border border-accent-500/30">
            <?= $itemCount ?> sản phẩm
        </span>
    </h1>

    <?php if (empty($cartItems)): ?>
        <!-- EMPTY CART STATE -->
        <div class="text-center py-20 bg-zinc-900/40 rounded-3xl border border-zinc-800 max-w-2xl mx-auto p-8">
            <div class="w-20 h-20 mx-auto mb-6 rounded-full bg-zinc-800/80 flex items-center justify-center text-4xl text-zinc-500">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4ZM3 6h18M16 10a4 4 0 0 1-8 0"/></svg>
            </div>
            <h2 class="text-xl font-bold text-white mb-2">Giỏ hàng của bạn đang trống</h2>
            <p class="text-sm text-zinc-400 mb-8 max-w-sm mx-auto">
                Hãy khám phá các thiết bị Gaming Gear đỉnh cao và thêm vào giỏ hàng ngay hôm nay.
            </p>
            <a href="/products" 
               class="inline-flex items-center gap-2 px-8 py-3.5 rounded-xl font-bold text-sm bg-accent-500 text-on hover:opacity-90 transition ">
                <span>Khám phá sản phẩm ngay</span>
                &rarr;
            </a>
        </div>
    <?php else: ?>
        <!-- CART HAS ITEMS -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            <!-- LEFT: CART ITEMS LIST (8 cols) -->
            <div class="lg:col-span-8 space-y-4">
                <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-4 sm:p-6 divide-y divide-zinc-800/80">
                    <?php foreach ($cartItems as $vid => $item): 
                        $lineTotal = (float)$item['price'] * (int)$item['quantity'];
                    ?>
                        <div class="py-5 first:pt-0 last:pb-0 flex flex-col sm:flex-row items-center gap-4 sm:gap-6" id="cart-row-<?= $vid ?>">
                            <!-- Product Image -->
                            <div class="w-20 h-20 sm:w-24 sm:h-24 rounded-xl bg-zinc-950/60 border border-zinc-800 p-2 shrink-0 flex items-center justify-center">
                                <img src="<?= htmlspecialchars($item['image'] ?? 'https://placehold.co/200x200/18181b/22d3ee') ?>" 
                                     alt="<?= htmlspecialchars($item['product_name'] ?? '') ?>"
                                     class="max-w-full max-h-full object-contain">
                            </div>

                            <!-- Product Info -->
                            <div class="flex-1 min-w-[10rem] text-center sm:text-left">
                                <h3 class="font-bold text-sm text-white hover:text-accent-400 transition-colors">
                                    <?= htmlspecialchars($item['product_name'] ?? '') ?>
                                </h3>
                                <?php if (!empty($item['variant_info'])): ?>
                                    <div class="text-xs text-zinc-400 mt-1 inline-block px-2 py-0.5 rounded bg-zinc-800/80 border border-zinc-700/50">
                                        <?= htmlspecialchars($item['variant_info']) ?>
                                    </div>
                                <?php endif; ?>
                                <div class="text-sm font-bold text-accent-400 mt-2 lg:hidden">
                                    <?= number_format($item['price'], 0, ',', '.') ?>₫
                                </div>
                            </div>

                            <!-- Unit Price (Desktop) -->
                            <div class="hidden lg:block text-right">
                                <div class="text-xs text-zinc-500">Đơn giá</div>
                                <div class="text-sm font-bold text-zinc-200">
                                    <?= number_format($item['price'], 0, ',', '.') ?>₫
                                </div>
                            </div>

                            <!-- Quantity Stepper -->
                            <div class="flex items-center gap-2">
                                <div class="flex items-center border border-zinc-700 rounded-xl bg-zinc-950/80 overflow-hidden">
                                    <button type="button" 
                                            onclick="changeQty(<?= $vid ?>, -1)"
                                            class="w-8 h-8 flex items-center justify-center text-zinc-400 hover:text-white hover:bg-zinc-800 transition">
                                        -
                                    </button>
                                    <input type="number" 
                                           id="qty-<?= $vid ?>" 
                                           value="<?= (int)$item['quantity'] ?>" 
                                           min="1" 
                                           max="<?= (int)($item['stock_qty'] ?? 99) ?>"
                                           onchange="updateCart(<?= $vid ?>, this.value)"
                                           class="w-10 text-center bg-transparent text-xs font-bold text-white outline-none">
                                    <button type="button" 
                                            onclick="changeQty(<?= $vid ?>, 1)"
                                            class="w-8 h-8 flex items-center justify-center text-zinc-400 hover:text-white hover:bg-zinc-800 transition">
                                        +
                                    </button>
                                </div>
                            </div>

                            <!-- Line Total -->
                            <div class="text-right min-w-[100px]">
                                <div class="text-xs text-zinc-500 hidden sm:block">Thành tiền</div>
                                <div class="text-sm font-bold text-accent-400" id="total-<?= $vid ?>">
                                    <?= number_format($lineTotal, 0, ',', '.') ?>₫
                                </div>
                            </div>

                            <!-- Remove Button -->
                            <button type="button" 
                                    onclick="removeItem(<?= $vid ?>)"
                                    class="p-2 text-zinc-500 hover:text-red-400 hover:bg-red-500/10 rounded-lg transition"
                                    title="Xóa khỏi giỏ">
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                            </button>
                        </div>
                    <?php endforeach; ?>
                </div>

                <div class="flex items-center justify-between text-xs text-zinc-400 px-2">
                    <a href="/products" class="hover:text-accent-400 flex items-center gap-1">
                        &larr; Tiếp tục mua sắm
                    </a>
                </div>
            </div>

            <!-- RIGHT: SUMMARY & CHECKOUT (4 cols) -->
            <div class="lg:col-span-4">
                <div class="bg-zinc-900/70 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 sticky top-24 space-y-6">
                    <h2 class="text-base font-bold text-white uppercase tracking-wider pb-3 border-b border-zinc-800">
                        Tóm Tắt Đơn Hàng
                    </h2>

                    <div class="space-y-3 text-xs">
                        <div class="flex justify-between text-zinc-400">
                            <span>Tạm tính hàng:</span>
                            <span class="text-zinc-200 font-bold" id="cart-subtotal"><?= number_format($subtotal, 0, ',', '.') ?>₫</span>
                        </div>

                        <div class="flex justify-between text-zinc-400">
                            <span>Phí vận chuyển:</span>
                            <span class="text-zinc-200 font-bold" id="cart-shipping">
                                <?= $shippingFee == 0 ? '<span class="text-green-400">Miễn phí</span>' : number_format($shippingFee, 0, ',', '.') . '₫' ?>
                            </span>
                        </div>

                        <?php if ($subtotal < 500000): ?>
                            <div class="p-2.5 rounded-xl bg-accent-500/10 border border-accent-500/20 text-[11px] text-accent-300">
                                Mua thêm <strong class="text-white"><?= number_format(500000 - $subtotal, 0, ',', '.') ?>₫</strong> để được <strong>Miễn phí vận chuyển</strong>!
                            </div>
                        <?php endif; ?>
                    </div>

                    <div class="pt-4 border-t border-zinc-800 flex justify-between items-baseline">
                        <span class="text-sm font-bold text-white">Tổng thanh toán:</span>
                        <span class="text-2xl font-black text-transparent bg-clip-text bg-accent-500" id="cart-total">
                            <?= number_format($total, 0, ',', '.') ?>₫
                        </span>
                    </div>

                    <a href="/checkout" 
                       class="w-full flex items-center justify-center gap-2 py-4 px-6 rounded-xl font-bold text-sm bg-accent-500 hover:bg-accent-600 text-on  transition-all duration-300 ">
                        <span>Tiến hành đặt hàng</span>
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/>
                        </svg>
                    </a>

                    <div class="flex items-center justify-center gap-4 text-[11px] text-zinc-500 pt-2">
                        <span>Bảo mật thanh toán</span>
                        <span>•</span>
                        <span>Giao hàng toàn quốc</span>
                    </div>
                </div>
            </div>

        </div>
    <?php endif; ?>
</div>

<script>
function changeQty(vid, delta) {
    const input = document.getElementById('qty-' + vid);
    if (!input) return;
    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;
    const max = parseInt(input.max) || 99;
    if (val > max) val = max;
    input.value = val;
    updateCart(vid, val);
}

function updateCart(vid, qty) {
    fetch('/cart/update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ variant_id: vid, quantity: qty })
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            alert(data.message || 'Lỗi cập nhật giỏ hàng');
        }
    })
    .catch(() => alert('Lỗi kết nối máy chủ'));
}

function removeItem(vid) {
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ?')) return;
    fetch('/cart/remove', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ variant_id: vid })
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            location.reload();
        }
    })
    .catch(() => alert('Lỗi xóa sản phẩm'));
}
</script>
