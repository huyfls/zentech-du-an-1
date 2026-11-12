<?php
/**
 * VIEW: One-page Checkout (Thanh toán đơn hàng)
 *
 * Variables:
 *   $cartItems   : array
 *   $subtotal    : float
 *   $shippingFee : int
 */
$total = $subtotal + $shippingFee;
$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
?>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <!-- Breadcrumb -->
    <nav class="flex items-center gap-2 text-xs text-zinc-400 mb-6">
        <a href="/" class="hover:text-accent-400">Trang chủ</a>
        <span>/</span>
        <a href="/cart" class="hover:text-accent-400">Giỏ hàng</a>
        <span>/</span>
        <span class="text-zinc-200">Xác nhận thanh toán</span>
    </nav>

    <h1 class="text-2xl sm:text-3xl font-black text-white tracking-tight mb-8">
        Xác Nhận & Thanh Toán Đơn Hàng
    </h1>

    <?php if (!empty($flash['errors'])): ?>
        <div class="mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/30 text-xs text-red-400 space-y-1">
            <strong>Vui lòng kiểm tra lại:</strong>
            <ul class="list-disc pl-5">
                <?php foreach ($flash['errors'] as $err): ?>
                    <li><?= htmlspecialchars($err) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php elseif (!empty($flash['error'])): ?>
        <div class="mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/30 text-xs text-red-400">
            <?= htmlspecialchars($flash['error']) ?>
        </div>
    <?php endif; ?>

    <form action="/order/place" method="POST" id="checkout-form" class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
<?= Csrf::field() ?>
        
        <!-- LEFT: FORM THÔNG TIN NHẬN HÀNG (7 cols) -->
        <div class="lg:col-span-7 space-y-6">
            
            <!-- 1. Thông tin người nhận -->
            <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 space-y-4">
                <h2 class="text-sm font-bold text-white uppercase tracking-wider flex items-center gap-2 pb-3 border-b border-zinc-800">
                    <span class="w-5 h-5 rounded-full bg-accent-500/20 text-accent-400 flex items-center justify-center text-xs">1</span>
                    Thông Tin Giao Hàng
                </h2>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Họ và tên người nhận *</label>
                        <input type="text" 
                               name="receiver_name" 
                               required 
                               placeholder="VD: Nguyễn Văn A"
                               autocomplete="name"
                               value="<?= e($flash['old']['receiver_name'] ?? ($_SESSION['user_name'] ?? '')) ?>"
                               class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                    </div>

                    <div>
                        <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Số điện thoại *</label>
                        <input type="tel" 
                               name="receiver_phone" 
                               required 
                               placeholder="VD: 0912345678"
                               pattern="0[0-9]{9}"
                               title="10 chữ số, bắt đầu bằng 0" autocomplete="tel" inputmode="numeric"
                               value="<?= e($flash['old']['receiver_phone'] ?? '') ?>"
                               class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Địa chỉ nhận hàng chi tiết *</label>
                    <input type="text" 
                           name="shipping_address" 
                           required autocomplete="street-address"
                           value="<?= e($flash['old']['shipping_address'] ?? '') ?>"
                           placeholder="Số nhà, tên đường, Phường/Xã, Quận/Huyện, Tỉnh/TP"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Ghi chú giao hàng (nếu có)</label>
                    <textarea name="note" 
                              rows="2" 
                              placeholder="Giao giờ hành chính, gọi trước khi giao..."
                              class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2 text-xs text-white outline-none"><?= e($flash['old']['note'] ?? '') ?></textarea>
                </div>
            </div>

            <!-- 2. Phương thức thanh toán -->
            <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 space-y-4">
                <h2 class="text-sm font-bold text-white uppercase tracking-wider flex items-center gap-2 pb-3 border-b border-zinc-800">
                    <span class="w-5 h-5 rounded-full bg-ember-500/20 text-ember-400 flex items-center justify-center text-xs">2</span>
                    Phương Thức Thanh Toán
                </h2>

                <div class="space-y-3">
                    <!-- COD -->
                    <label class="flex items-center gap-3 p-4 rounded-xl border border-accent-500/40 bg-zinc-900/80 cursor-pointer hover:border-accent-400 transition">
                        <input type="radio" name="payment_method" value="cod" <?= ($flash['old']['payment_method'] ?? 'cod') === 'cod' ? 'checked' : '' ?> class="text-accent-500 focus:ring-0">
                        <div class="w-8 h-8 rounded-lg bg-accent-500/10 text-accent-400 flex items-center justify-center text-lg">
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 7h20v10H2zM12 14a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/></svg>
                        </div>
                        <div>
                            <div class="text-xs font-bold text-white">Thanh toán khi nhận hàng (COD)</div>
                            <div class="text-[11px] text-zinc-400">Kiểm tra hàng trước khi thanh toán tiền mặt</div>
                        </div>
                    </label>

                    <!-- Chuyển khoản ngân hàng -->
                    <label class="flex items-center gap-3 p-4 rounded-xl border border-zinc-800 bg-zinc-950/60 cursor-pointer hover:border-zinc-700 transition">
                        <input type="radio" name="payment_method" value="bank_transfer" <?= ($flash['old']['payment_method'] ?? '') === 'bank_transfer' ? 'checked' : '' ?> class="text-accent-500 focus:ring-0">
                        <div class="w-8 h-8 rounded-lg bg-ember-500/10 text-ember-400 flex items-center justify-center text-lg">
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 10l9-6 9 6M5 10v8m4-8v8m6-8v8m4-8v8M3 21h18"/></svg>
                        </div>
                        <div>
                            <div class="text-xs font-bold text-white">Chuyển khoản VietQR / 247</div>
                            <div class="text-[11px] text-zinc-400">Mã QR động tự động xác nhận đơn trong 1 phút</div>
                        </div>
                    </label>

                    <!-- Ví điện tử (sắp ra mắt) -->
                    <div class="flex items-center justify-between p-4 rounded-xl border border-zinc-800/60 bg-zinc-950/30 opacity-60">
                        <div class="flex items-center gap-3">
                            <div class="w-8 h-8 rounded-lg bg-pink-500/10 text-accent-400 flex items-center justify-center text-lg">
                                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M7 2h10a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V3a1 1 0 0 1 1-1zm5 17h.01"/></svg>
                            </div>
                            <div>
                                <div class="text-xs font-semibold text-zinc-300">Ví MoMo / VNPay</div>
                                <div class="text-[10px] text-zinc-500">Cổng thanh toán tự động</div>
                            </div>
                        </div>
                        <span class="text-[10px] px-2 py-0.5 rounded bg-zinc-800 text-zinc-400">Sắp ra mắt</span>
                    </div>
                </div>
            </div>

        </div>

        <!-- RIGHT: TÓM TẮT ĐƠN HÀNG (5 cols) -->
        <div class="lg:col-span-5">
            <div class="bg-zinc-900/70 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 sticky top-24 space-y-6">
                <h2 class="text-sm font-bold text-white uppercase tracking-wider pb-3 border-b border-zinc-800 flex justify-between items-center">
                    <span>Đơn Hàng Của Bạn</span>
                    <a href="/cart" class="text-xs text-accent-400 hover:underline">Sửa</a>
                </h2>

                <!-- Items mini list -->
                <div class="max-h-64 overflow-y-auto space-y-3 pr-1 divide-y divide-zinc-800/60">
                    <?php foreach ($cartItems as $item): ?>
                        <div class="pt-3 first:pt-0 flex items-center gap-3">
                            <div class="w-12 h-12 rounded-lg bg-zinc-950 border border-zinc-800 p-1 shrink-0 flex items-center justify-center">
                                <img src="<?= htmlspecialchars($item['image'] ?? 'https://placehold.co/100x100/18181b/22d3ee') ?>" 
                                     alt="" class="max-w-full max-h-full object-contain">
                            </div>
                            <div class="flex-1 min-w-0">
                                <div class="text-xs font-semibold text-zinc-200 truncate"><?= htmlspecialchars($item['product_name']) ?></div>
                                <div class="text-[11px] text-zinc-500">x<?= $item['quantity'] ?> • <?= htmlspecialchars($item['variant_info'] ?? '') ?></div>
                            </div>
                            <div class="text-xs font-bold text-accent-400">
                                <?= number_format($item['price'] * $item['quantity'], 0, ',', '.') ?>₫
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>

                <!-- Price Breakdown -->
                <div class="pt-4 border-t border-zinc-800 space-y-2 text-xs">
                    <div class="flex justify-between text-zinc-400">
                        <span>Tiền hàng:</span>
                        <span class="text-zinc-200 font-bold"><?= number_format($subtotal, 0, ',', '.') ?>₫</span>
                    </div>
                    <div class="flex justify-between text-zinc-400">
                        <span>Phí giao hàng:</span>
                        <span class="text-zinc-200 font-bold">
                            <?= $shippingFee == 0 ? '<span class="text-green-400">Miễn phí</span>' : number_format($shippingFee, 0, ',', '.') . '₫' ?>
                        </span>
                    </div>
                </div>

                <!-- Grand Total -->
                <div class="pt-4 border-t border-zinc-800 flex justify-between items-baseline">
                    <span class="text-sm font-bold text-white">Tổng thanh toán:</span>
                    <span class="text-2xl font-black text-transparent bg-clip-text bg-accent-500">
                        <?= number_format($total, 0, ',', '.') ?>₫
                    </span>
                </div>

                <!-- Submit Button -->
                <button type="submit" 
                        id="submit-order-btn"
                        class="w-full flex items-center justify-center gap-2 py-4 px-6 rounded-xl font-bold text-sm bg-accent-500 hover:bg-accent-600 text-on  transition-all duration-300 ">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                    <span>Hoàn tất đặt hàng</span>
                </button>

                <p class="text-[11px] text-zinc-500 text-center leading-relaxed">
                    Bằng việc nhấn đặt hàng, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo hành của ZenTech.
                </p>
            </div>
        </div>

    </form>
</div>

<script>
document.getElementById('checkout-form').addEventListener('submit', function() {
    const btn = document.getElementById('submit-order-btn');
    btn.disabled = true;
    btn.innerHTML = '<span>Đang xử lý đơn hàng...</span>';
});
</script>
