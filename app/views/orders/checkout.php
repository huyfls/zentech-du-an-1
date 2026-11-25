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

<div class="apple-page max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <!-- Breadcrumb -->
    <nav class="flex items-center gap-2 text-xs text-zinc-400 mb-6">
        <a href="/" class="hover:text-accent-400">Trang chủ</a>
        <span>/</span>
        <a href="/cart" class="hover:text-accent-400">Giỏ hàng</a>
        <span>/</span>
        <span class="text-zinc-200">Xác nhận thanh toán</span>
    </nav>

    <h1 class="t-section text-zinc-100 mb-8">Thanh toán.</h1>

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
                <h2 class="text-base font-semibold text-white flex items-center gap-2 pb-3 border-b border-zinc-800">
                    <span class="w-5 h-5 rounded-full bg-accent-500/20 text-accent-400 flex items-center justify-center text-xs">1</span>
                    Thông tin giao hàng
                </h2>

                <?php if (!empty($addresses)): ?>
                <div>
                    <label class="block text-sm font-medium text-zinc-300 mb-1.5" for="saved-address">Chọn nhanh địa chỉ đã lưu</label>
                    <select id="saved-address" class="w-full bg-zinc-950 border border-zinc-700 rounded-xl px-3.5 py-2.5 text-sm text-white">
                        <option value="">-- Nhập địa chỉ mới --</option>
                        <?php foreach ($addresses as $i => $a): ?>
                        <option value="1" <?= $i === 0 && empty($flash['old']) ? 'selected' : '' ?> data-name="<?= e($a['receiver_name']) ?>" data-phone="<?= e($a['phone']) ?>" data-addr="<?= e($a['street'] . ', ' . $a['ward'] . ', ' . $a['district'] . ', ' . $a['province']) ?>"><?= e($a['receiver_name'] . ' – ' . $a['street'] . ', ' . $a['province']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <?php endif; ?>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-zinc-300 mb-1.5">Họ và tên người nhận *</label>
                        <input type="text" 
                               name="receiver_name" 
                               required 
                               placeholder="VD: Nguyễn Văn A"
                               autocomplete="name"
                               value="<?= e($flash['old']['receiver_name'] ?? ($addresses[0]['receiver_name'] ?? ($_SESSION['user_name'] ?? ''))) ?>"
                               class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-sm text-white outline-none">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-zinc-300 mb-1.5">Số điện thoại *</label>
                        <input type="tel" 
                               name="receiver_phone" 
                               required 
                               placeholder="VD: 0912345678"
                               pattern="0[0-9]{9}"
                               title="10 chữ số, bắt đầu bằng 0" autocomplete="tel" inputmode="numeric"
                               value="<?= e($flash['old']['receiver_phone'] ?? ($addresses[0]['phone'] ?? ($me['phone'] ?? ''))) ?>"
                               class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-sm text-white outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-zinc-300 mb-1.5">Địa chỉ nhận hàng chi tiết *</label>
                    <input type="text" 
                           name="shipping_address" 
                           required autocomplete="street-address"
                           value="<?= e($flash['old']['shipping_address'] ?? (isset($addresses[0]) ? $addresses[0]['street'] . ', ' . $addresses[0]['ward'] . ', ' . $addresses[0]['district'] . ', ' . $addresses[0]['province'] : '')) ?>"
                           placeholder="Số nhà, tên đường, Phường/Xã, Quận/Huyện, Tỉnh/TP"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2.5 text-sm text-white outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-zinc-300 mb-1.5">Ghi chú giao hàng (nếu có)</label>
                    <textarea name="note" 
                              rows="2" 
                              placeholder="Giao giờ hành chính, gọi trước khi giao..."
                              class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-3.5 py-2 text-sm text-white outline-none"><?= e($flash['old']['note'] ?? '') ?></textarea>
                </div>
            </div>

            <!-- 2. Phương thức thanh toán -->
            <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 space-y-4">
                <h2 class="text-base font-semibold text-white flex items-center gap-2 pb-3 border-b border-zinc-800">
                    <span class="w-5 h-5 rounded-full bg-ember-500/20 text-ember-400 flex items-center justify-center text-xs">2</span>
                    Phương thức thanh toán
                </h2>

                <div class="space-y-3" role="radiogroup" aria-label="Phương thức thanh toán">
                    <?php $pmSel = $flash['old']['payment_method'] ?? 'cod'; $bal = (float) ($me['wallet_balance'] ?? 0); ?>
                    <?php foreach ([
                        'cod'    => ['Thanh toán khi nhận hàng (COD)', 'Trả tiền mặt cho shipper khi nhận hàng'],
                        'online' => ['Thanh toán online (thẻ / QR)', 'Bản demo: cổng thanh toán giả lập, đơn được ghi nhận đã thanh toán ngay. Hủy/trả hàng hoàn về ví ZenTech'],
                        'wallet' => ['Ví ZenTech — số dư ' . number_format($bal, 0, ',', '.') . '₫', 'Trừ thẳng vào số dư ví (tiền hoàn từ đơn hủy/trả hàng)'],
                    ] as $val => [$title, $sub]): ?>
                    <label class="flex items-center gap-3 p-4 rounded-xl border cursor-pointer transition has-[:checked]:border-accent-500 has-[:checked]:bg-accent-500/5 border-zinc-800 bg-zinc-950/60 hover:border-zinc-700 <?= $val === 'wallet' && $bal <= 0 ? 'opacity-60' : '' ?>">
                        <input type="radio" name="payment_method" value="<?= $val ?>" <?= $pmSel === $val ? 'checked' : '' ?> <?= $val === 'wallet' && $bal <= 0 ? 'disabled' : '' ?> class="text-accent-500 focus:ring-0">
                        <div>
                            <div class="text-xs font-bold text-white"><?= e($title) ?></div>
                            <div class="text-[11px] text-zinc-400"><?= e($sub) ?></div>
                        </div>
                    </label>
                    <?php endforeach; ?>
                </div>
            </div>

        </div>

        <!-- RIGHT: TÓM TẮT ĐƠN HÀNG (5 cols) -->
        <div class="lg:col-span-5">
            <div class="bg-zinc-900/70 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 sticky top-24 space-y-6">
                <h2 class="text-base font-semibold text-white pb-3 border-b border-zinc-800 flex justify-between items-center">
                    <span>Đơn hàng của bạn</span>
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

                <!-- Mã giảm giá -->
                <div>
                    <label class="block text-sm font-medium text-zinc-300 mb-1.5" for="coupon_code">Mã giảm giá (nếu có)</label>
                    <div class="flex gap-2">
                        <input type="text" id="coupon_code" name="coupon_code" form="checkout-form" maxlength="50"
                               value="<?= e($flash['old']['coupon_code'] ?? '') ?>" placeholder="VD: ZENTECH10"
                               class="flex-1 min-w-0 bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-3.5 py-2.5 text-sm text-white outline-none uppercase">
                        <button type="button" id="coupon-apply" class="px-4 rounded-xl border border-zinc-700 text-xs font-semibold text-zinc-200 hover:border-accent-400">Áp dụng</button>
                    </div>
                    <p id="coupon-msg" class="text-[11px] text-zinc-500 mt-1" role="status">Bấm "Áp dụng" để xem số tiền giảm trước khi đặt hàng.</p>
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

                <div id="discount-row" class="hidden flex justify-between text-xs text-zinc-400">
                    <span>Mã giảm giá:</span><span id="discount-val" class="font-bold text-green-400"></span>
                </div>

                <!-- Grand Total -->
                <div class="pt-4 border-t border-zinc-800 flex justify-between items-baseline">
                    <span class="text-sm font-bold text-white">Tổng thanh toán:</span>
                    <span id="grand-total" class="text-2xl font-black text-transparent bg-clip-text bg-accent-500">
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

<script>
(() => {
    const btn = document.getElementById('coupon-apply'), inp = document.getElementById('coupon_code');
    if (!btn) return;
    const msg = document.getElementById('coupon-msg'), fmt = n => n.toLocaleString('vi-VN') + '₫';
    btn.addEventListener('click', async () => {
        const code = inp.value.trim();
        btn.disabled = true;
        try {
            const r = await fetch('/coupon/preview', {method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: 'coupon_code=' + encodeURIComponent(code)});
            const d = await r.json();
            msg.textContent = d.message; msg.className = 'text-[11px] mt-1 ' + (d.ok ? 'text-green-500' : 'text-red-500');
            document.getElementById('discount-row').classList.toggle('hidden', !d.ok);
            if (d.ok) { document.getElementById('discount-val').textContent = '-' + fmt(d.discount); document.getElementById('grand-total').textContent = fmt(d.total); }
        } catch (e) { msg.textContent = 'Không kiểm tra được mã, thử lại sau.'; }
        btn.disabled = false;
    });
})();
</script>
<script>
document.getElementById('saved-address')?.addEventListener('change', e => {
    const o = e.target.selectedOptions[0]; if (!o || !o.dataset.addr) return;
    const f = document.getElementById('checkout-form');
    f.receiver_name.value = o.dataset.name; f.receiver_phone.value = o.dataset.phone; f.shipping_address.value = o.dataset.addr;
});
</script>
