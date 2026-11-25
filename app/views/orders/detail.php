<?php
/**
 * VIEW: Chi tiết đơn hàng người dùng
 *
 * Variables:
 *   $order: array (kèm items)
 */
[$statusText, $statusClass] = OrderModel::badge($order['status']);
$steps = ['pending', 'confirmed', 'processing', 'handed_over', 'shipping', 'delivered', 'completed'];
$stepAt = array_search($order['status'], $steps, true);
if ($stepAt === false) $stepAt = in_array($order['status'], ['return_requested', 'returned'], true) ? 5 : -1;
$canReturn = OrderModel::canReturn($order);
?>

<div class="apple-page max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <nav class="flex items-center gap-2 text-xs text-zinc-400 mb-6">
        <a href="/" class="hover:text-accent-400">Trang chủ</a>
        <span>/</span>
        <a href="/orders" class="hover:text-accent-400">Đơn hàng</a>
        <span>/</span>
        <span class="text-zinc-200"><?= htmlspecialchars($order['order_code']) ?></span>
    </nav>

    <!-- Header Card -->
    <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-6 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
            <div class="flex items-center gap-3 mb-1">
                <h1 class="t-section text-zinc-100 font-mono"><?= htmlspecialchars($order['order_code']) ?></h1>
                <span class="text-xs font-semibold px-3 py-0.5 rounded-full border <?= $statusClass ?>">
                    <?= $statusText ?>
                </span>
            </div>
            <p class="text-xs text-zinc-400">
                Đặt ngày <?= date('d/m/Y lúc H:i', strtotime($order['created_at'])) ?>
            </p>
        </div>

        <div class="flex flex-wrap gap-2">
        <?php if (in_array($order['status'], OrderModel::CUSTOMER_CANCELLABLE, true)): ?>
            <form action="/orders/cancel/<?= $order['id'] ?>" method="POST" onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
<?= Csrf::field() ?>
                <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold bg-red-500/10 hover:bg-red-500/20 text-red-400 border border-red-500/30 transition">
                    Hủy đơn hàng
                </button>
            </form>
        <?php endif; ?>
        <?php if ($order['status'] === 'shipping'): ?>
            <form action="/orders/received/<?= $order['id'] ?>" method="POST" onsubmit="return confirm('Xác nhận bạn đã nhận đủ hàng?')">
<?= Csrf::field() ?>
                <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold bg-accent-500 hover:bg-accent-400 text-white transition">Đã nhận hàng</button>
            </form>
        <?php endif; ?>
        <?php if (in_array($order['status'], ['delivered', 'completed', 'return_requested'], true) && !empty($order['items'][0]['product_slug'])): ?>
            <a href="/san-pham/<?= e($order['items'][0]['product_slug']) ?>#tabs" class="px-4 py-2 rounded-xl text-xs font-bold bg-zinc-800 text-zinc-200 border border-zinc-700">Đánh giá sản phẩm</a>
        <?php endif; ?>
        </div>
    </div>

    <?php if ($stepAt >= 0): ?>
    <!-- Tiến trình đơn (một chiều) -->
    <ol class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 mb-6 grid grid-cols-2 sm:grid-cols-7 gap-3 text-[11px]">
        <?php foreach ($steps as $i => $st): ?>
        <li class="flex items-center gap-2 <?= $i <= $stepAt ? 'text-accent-400 font-semibold' : 'text-zinc-500' ?>">
            <span class="w-5 h-5 shrink-0 rounded-full flex items-center justify-center border <?= $i <= $stepAt ? 'bg-accent-500 text-white border-accent-500' : 'border-zinc-700' ?>"><?= $i + 1 ?></span>
            <?= e(OrderModel::LABELS[$st]) ?>
        </li>
        <?php endforeach; ?>
    </ol>
    <?php endif; ?>
    <?php if ((int) $order['fail_count'] > 0 && in_array($order['status'], ['handed_over', 'shipping'], true)): ?>
        <div class="mb-6 p-4 rounded-2xl bg-amber-500/10 border border-amber-500/20 text-xs text-amber-400">Giao hàng thất bại <?= (int) $order['fail_count'] ?>/<?= OrderModel::MAX_FAILS ?> lần. Vui lòng giữ máy để shipper liên hệ; thất bại <?= OrderModel::MAX_FAILS ?> lần đơn sẽ bị hủy.</div>
    <?php endif; ?>
    <?php if ($order['status'] === 'cancelled' && !empty($order['cancelled_reason'])): ?>
        <div class="mb-6 p-4 rounded-2xl bg-red-500/10 border border-red-500/20 text-xs text-red-400">Lý do hủy: <?= e($order['cancelled_reason']) ?><?= $order['payment_status'] === 'refunded' ? ' — tiền đã được hoàn vào ví ZenTech.' : '' ?></div>
    <?php endif; ?>

    <?php if ($return): ?>
    <div class="mb-6 p-5 rounded-2xl bg-zinc-900/60 border border-amber-500/30 text-xs space-y-1.5">
        <h3 class="font-bold text-amber-400">Yêu cầu trả hàng — <?= ['pending' => 'Đang chờ shop duyệt', 'approved' => 'Đã duyệt, tiền đã được hoàn', 'rejected' => 'Shop đã từ chối'][$return['status']] ?></h3>
        <div class="text-zinc-300">Lý do: <?= e($return['reason']) ?></div>
        <div class="text-zinc-400"><?= nl2br(e($return['description'])) ?></div>
        <div class="text-zinc-400">Hoàn tiền về: <?= $return['refund_method'] === 'wallet' ? 'Ví ZenTech' : 'Tài khoản ngân hàng (' . e($return['bank_info']) . ')' ?></div>
        <?php if ($return['admin_note']): ?><div class="text-zinc-500">Phản hồi của shop: <?= e($return['admin_note']) ?></div><?php endif; ?>
    </div>
    <?php elseif ($canReturn): ?>
    <details class="mb-6 bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs">
        <summary class="cursor-pointer font-bold text-zinc-200">Yêu cầu trả hàng / hoàn tiền (còn hạn đến <?= date('d/m/Y H:i', strtotime($order['delivered_at']) + OrderModel::RETURN_DAYS * 86400) ?>)</summary>
        <form action="/orders/return/<?= $order['id'] ?>" method="POST" enctype="multipart/form-data" class="mt-4 space-y-3">
            <?= Csrf::field() ?>
            <label class="block"><span class="block mb-1 text-zinc-300">Lý do *</span>
                <select name="reason" required class="w-full bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-white">
                    <option value="">-- Chọn lý do --</option>
                    <?php foreach (OrderModel::RETURN_REASONS as $r): ?><option><?= e($r) ?></option><?php endforeach; ?>
                </select></label>
            <label class="block"><span class="block mb-1 text-zinc-300">Mô tả chi tiết *</span>
                <textarea name="description" required minlength="10" maxlength="2000" rows="3" placeholder="Mô tả tình trạng sản phẩm..." class="w-full bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-white"></textarea></label>
            <label class="block"><span class="block mb-1 text-zinc-300">Ảnh minh chứng * (JPG/PNG/WEBP, tối đa 5MB)</span>
                <input type="file" name="evidence" required accept="image/jpeg,image/png,image/webp" class="text-zinc-300"></label>
            <fieldset class="space-y-1.5"><legend class="mb-1 text-zinc-300">Nhận tiền hoàn về *</legend>
                <label class="flex items-center gap-2"><input type="radio" name="refund_method" value="wallet" checked onchange="this.form.bank_info.required=false;document.getElementById('bank-box').hidden=true"> Ví ZenTech (nhận ngay khi shop duyệt)</label>
                <label class="flex items-center gap-2"><input type="radio" name="refund_method" value="bank" onchange="this.form.bank_info.required=true;document.getElementById('bank-box').hidden=false"> Tài khoản ngân hàng</label>
            </fieldset>
            <div id="bank-box" hidden><input name="bank_info" maxlength="255" placeholder="Ngân hàng - Số tài khoản - Tên chủ tài khoản" class="w-full bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-white"></div>
            <button type="submit" class="px-4 py-2 rounded-xl font-bold bg-amber-500 text-black">Gửi yêu cầu trả hàng</button>
        </form>
    </details>
    <?php endif; ?>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <!-- Người nhận -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold text-white uppercase text-[11px] text-zinc-400">Người Nhận</h3>
            <div class="font-bold text-zinc-200 text-sm"><?= htmlspecialchars($order['receiver_name']) ?></div>
            <div class="text-zinc-400">SĐT: <?= htmlspecialchars($order['receiver_phone']) ?></div>
            <div class="text-zinc-400">Địa chỉ: <?= htmlspecialchars($order['shipping_address']) ?></div>
        </div>

        <!-- Thanh toán -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold text-white uppercase text-[11px] text-zinc-400">Thanh Toán</h3>
            <div class="font-semibold text-zinc-200">
                <?= e(OrderModel::PAYMENT_LABELS[$order['payment_method']] ?? $order['payment_method']) ?>
            </div>
            <div class="text-zinc-400">
                Trạng thái: <strong class="<?= $order['payment_status'] === 'paid' ? 'text-green-400' : 'text-amber-400' ?>"><?= e(OrderModel::PAYMENT_STATUS_LABELS[$order['payment_status']] ?? $order['payment_status']) ?></strong>
            </div>
        </div>

        <!-- Ghi chú -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs space-y-2">
            <h3 class="font-bold text-white uppercase text-[11px] text-zinc-400">Ghi Chú Đơn Hàng</h3>
            <p class="text-zinc-400 italic">
                <?= !empty($order['note']) ? htmlspecialchars($order['note']) : 'Không có ghi chú' ?>
            </p>
        </div>
    </div>

    <!-- Items List -->
    <div class="bg-zinc-900/60 backdrop-blur-md border border-zinc-800 rounded-2xl p-6">
        <h2 class="text-base font-semibold text-white pb-4 border-b border-zinc-800 mb-4">
            Danh Sách Sản Phẩm
        </h2>

        <div class="divide-y divide-zinc-800">
            <?php foreach ($order['items'] ?? [] as $item): ?>
                <div class="py-4 first:pt-0 last:pb-0 flex items-center justify-between gap-4">
                    <div class="flex items-center gap-4">
                        <div class="w-14 h-14 rounded-xl bg-zinc-950 border border-zinc-800 p-1 flex items-center justify-center shrink-0">
                            <img src="<?= htmlspecialchars($item['variant_image'] ?? ($item['product_thumbnail'] ?? 'https://placehold.co/100x100/18181b/22d3ee')) ?>" 
                                 alt="" class="max-w-full max-h-full object-contain">
                        </div>
                        <div>
                            <div class="text-sm font-semibold text-zinc-200"><?= htmlspecialchars($item['product_name']) ?></div>
                            <div class="text-xs text-zinc-400">
                                <?= htmlspecialchars($item['variant_info'] ?? '') ?> • SL: <strong>x<?= $item['quantity'] ?></strong>
                            </div>
                        </div>
                    </div>

                    <div class="text-right">
                        <div class="text-xs text-zinc-500"><?= number_format($item['unit_price'], 0, ',', '.') ?>₫</div>
                        <div class="text-sm font-bold text-accent-400"><?= number_format($item['total_price'], 0, ',', '.') ?>₫</div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <!-- Breakdown Total -->
        <div class="pt-6 border-t border-zinc-800 mt-6 space-y-2 text-xs text-right max-w-xs ml-auto">
            <div class="flex justify-between text-zinc-400">
                <span>Tiền hàng:</span>
                <span class="text-zinc-200 font-bold"><?= number_format($order['subtotal'], 0, ',', '.') ?>₫</span>
            </div>
            <div class="flex justify-between text-zinc-400">
                <span>Phí vận chuyển:</span>
                <span class="text-zinc-200 font-bold"><?= number_format($order['shipping_fee'], 0, ',', '.') ?>₫</span>
            </div>
            <?php if (!empty($order['discount_amount'])): ?>
            <div class="flex justify-between text-zinc-400">
                <span>Mã giảm giá:</span>
                <span class="font-bold text-green-400">-<?= number_format($order['discount_amount'], 0, ',', '.') ?>₫</span>
            </div>
            <?php endif; ?>
            <div class="flex justify-between text-base font-bold pt-2 border-t border-zinc-800 text-white">
                <span>Tổng cộng:</span>
                <span class="text-accent-400"><?= number_format($order['total_amount'], 0, ',', '.') ?>₫</span>
            </div>
        </div>
    </div>
</div>
