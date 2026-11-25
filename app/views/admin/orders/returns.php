<?php
/**
 * VIEW: Admin - Tab Hoàn hàng
 * Variables: $returns, $tab ('pending' | 'done'), $pendingCount
 */
$rs = ['pending' => ['Chờ duyệt', 'amber'], 'approved' => ['Đã duyệt', 'green'], 'rejected' => ['Đã từ chối', 'red']];
?>
<div class="space-y-6">
    <div>
        <h1 class="text-2xl font-black text-white tracking-tight">Hoàn Hàng</h1>
        <p class="text-xs text-zinc-400 mt-1">Khách được yêu cầu trả hàng trong <?= OrderModel::RETURN_DAYS ?> ngày kể từ khi bấm "Đã nhận hàng". Duyệt: hàng về kho và hoàn tiền.</p>
    </div>

    <div class="flex gap-2">
        <a href="/admin/returns" class="px-4 py-2 rounded-xl text-xs font-semibold <?= $tab === 'pending' ? 'bg-accent-500/20 text-accent-400 border border-accent-500/30' : 'bg-zinc-900 border border-zinc-800 text-zinc-400' ?>">Chờ duyệt (<?= $pendingCount ?>)</a>
        <a href="/admin/returns?tab=done" class="px-4 py-2 rounded-xl text-xs font-semibold <?= $tab === 'done' ? 'bg-accent-500/20 text-accent-400 border border-accent-500/30' : 'bg-zinc-900 border border-zinc-800 text-zinc-400' ?>">Đã xử lý</a>
    </div>

    <?php if (!$returns): ?>
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-10 text-center text-xs text-zinc-500">Không có yêu cầu trả hàng nào.</div>
    <?php endif; ?>

    <div class="space-y-4">
    <?php foreach ($returns as $r): [$sl, $sc] = $rs[$r['status']]; ?>
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-2xl p-5 text-xs grid md:grid-cols-[1fr_auto] gap-5">
            <div class="space-y-1.5">
                <div class="flex items-center gap-3">
                    <a href="/admin/orders/detail/<?= $r['order_id'] ?>" class="font-mono font-bold text-white hover:text-accent-400"><?= e($r['order_code']) ?></a>
                    <span class="px-2.5 py-0.5 rounded-full border bg-<?= $sc ?>-500/10 text-<?= $sc ?>-400 border-<?= $sc ?>-500/20 font-semibold"><?= $sl ?></span>
                    <span class="text-zinc-500"><?= date('d/m/Y H:i', strtotime($r['created_at'])) ?></span>
                </div>
                <div class="text-zinc-300"><?= e($r['full_name']) ?> · <?= e($r['email']) ?> · <strong class="text-accent-400"><?= number_format($r['total_amount'], 0, ',', '.') ?>₫</strong></div>
                <div class="text-zinc-200"><strong>Lý do:</strong> <?= e($r['reason']) ?></div>
                <div class="text-zinc-400"><?= nl2br(e($r['description'])) ?></div>
                <div class="text-zinc-300">Hoàn tiền về: <?= $r['refund_method'] === 'wallet' ? 'Ví ZenTech' : 'Tài khoản ngân hàng — ' . e($r['bank_info']) ?></div>
                <?php if ($r['admin_note']): ?><div class="text-zinc-500">Ghi chú xử lý: <?= e($r['admin_note']) ?></div><?php endif; ?>
            </div>
            <div class="space-y-3">
                <?php if ($r['evidence_url']): ?>
                    <a href="<?= e($r['evidence_url']) ?>" target="_blank" rel="noopener"><img src="<?= e($r['evidence_url']) ?>" alt="Ảnh minh chứng" class="h-32 w-48 object-cover rounded-xl border border-zinc-800"></a>
                <?php endif; ?>
                <?php if ($r['status'] === 'pending'): ?>
                <form action="/admin/returns/<?= $r['order_id'] ?>" method="POST" class="space-y-2">
                    <?= Csrf::field() ?>
                    <input name="admin_note" maxlength="255" placeholder="Ghi chú (không bắt buộc)" class="w-48 bg-zinc-950 border border-zinc-700 rounded-xl px-3 py-2 text-xs text-white">
                    <div class="flex gap-2">
                        <button name="decision" value="approve" onclick="return confirm('Duyệt trả hàng và hoàn tiền?')" class="px-3 py-2 rounded-xl font-bold bg-accent-500 text-black">Duyệt</button>
                        <button name="decision" value="reject" onclick="return confirm('Từ chối yêu cầu này?')" class="px-3 py-2 rounded-xl font-bold bg-red-500/10 text-red-400 border border-red-500/30">Từ chối</button>
                    </div>
                </form>
                <?php endif; ?>
            </div>
        </div>
    <?php endforeach; ?>
    </div>
</div>
