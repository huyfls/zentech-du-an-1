<?php
/**
 * VIEW: Admin Product Create / Edit Form
 * Hỗ trợ nhập đa biến thể (Màu sắc, Phiên bản, Giá, Tồn kho)
 *
 * Variables:
 *   $product    : array|null
 *   $categories : array
 *   $brands     : array
 *   $variants   : array
 */
$isEdit = !empty($product['id']);
$actionUrl = $isEdit ? '/admin/products/update/' . $product['id'] : '/admin/products/store';
?>

<div class="max-w-5xl mx-auto space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between pb-4 border-b border-zinc-800">
        <div>
            <a href="/admin/products" class="text-xs text-zinc-400 hover:text-accent-400 flex items-center gap-1 mb-1">
                &larr; Quay lại danh sách
            </a>
            <h1 class="text-2xl font-black text-white tracking-tight">
                <?= $isEdit ? 'Chỉnh Sửa Sản Phẩm: ' . htmlspecialchars($product['name']) : 'Thêm Mới Sản Phẩm Gaming Gear' ?>
            </h1>
        </div>
    </div>

    <form action="<?= $actionUrl ?>" method="POST" class="space-y-8">
<?= Csrf::field() ?>
        
        <!-- SECTION 1: THÔNG TIN CƠ BẢN -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-3xl p-6 sm:p-8 space-y-5">
            <h2 class="text-sm font-bold text-white uppercase tracking-wider flex items-center gap-2 pb-3 border-b border-zinc-800">
                <span class="w-2 h-2 rounded-full bg-accent-400"></span>
                1. Thông Tin Cơ Bản
            </h2>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                <div class="sm:col-span-2">
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Tên sản phẩm *</label>
                    <input type="text" name="name" required placeholder="VD: Razer DeathAdder V3 HyperSpeed"
                           value="<?= htmlspecialchars($product['name'] ?? '') ?>"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 focus:ring-1 focus:ring-accent-400/30 rounded-xl px-4 py-2.5 text-xs text-white outline-none">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Danh mục *</label>
                    <select name="category_id" required class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                        <option value="">-- Chọn danh mục --</option>
                        <?php foreach ($categories as $c): ?>
                            <option value="<?= $c['id'] ?>" <?= ($product['category_id'] ?? '') == $c['id'] ? 'selected' : '' ?>>
                                <?= htmlspecialchars($c['name']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Thương hiệu *</label>
                    <select name="brand_id" required class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
                        <option value="">-- Chọn thương hiệu --</option>
                        <?php foreach ($brands as $b): ?>
                            <option value="<?= $b['id'] ?>" <?= ($product['brand_id'] ?? '') == $b['id'] ? 'selected' : '' ?>>
                                <?= htmlspecialchars($b['name']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Mã SKU gốc</label>
                    <input type="text" name="sku" placeholder="VD: RZR-DAV3HS"
                           value="<?= htmlspecialchars($product['sku'] ?? '') ?>"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-4 py-2.5 text-xs text-white outline-none font-mono">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">URL Ảnh đại diện chính</label>
                    <input type="url" name="thumbnail_url" placeholder="https://..."
                           value="<?= htmlspecialchars($product['thumbnail_url'] ?? '') ?>"
                           class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-4 py-2.5 text-xs text-white outline-none">
                </div>

                <div class="sm:col-span-2">
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Mô tả ngắn</label>
                    <textarea name="short_desc" rows="2" placeholder="Tóm tắt tính năng chính của gear..."
                              class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-4 py-2 text-xs text-white outline-none"><?= htmlspecialchars($product['short_desc'] ?? '') ?></textarea>
                </div>

                <div class="sm:col-span-2">
                    <label class="block text-xs font-semibold text-zinc-300 mb-1.5">Mô tả chi tiết</label>
                    <textarea name="full_desc" rows="5" placeholder="Thông số chi tiết, nội dung bài viết..."
                              class="w-full bg-zinc-950 border border-zinc-700 focus:border-accent-400 rounded-xl px-4 py-2 text-xs text-white outline-none"><?= htmlspecialchars($product['full_desc'] ?? '') ?></textarea>
                </div>

                <div class="sm:col-span-2">
                    <label class="flex items-center gap-2 cursor-pointer">
                        <input type="checkbox" name="is_featured" value="1" 
                               <?= !empty($product['is_featured']) ? 'checked' : '' ?>
                               class="rounded bg-zinc-950 border-zinc-700 text-accent-500 focus:ring-0">
                        <span class="text-xs font-semibold text-zinc-200">Đặt làm sản phẩm NỔI BẬT (Hiển thị trang chủ)</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- SECTION 2: QUẢN LÝ ĐA BIẾN THỂ (VARIANTS TABLE) -->
        <div class="bg-zinc-900/60 border border-zinc-800 rounded-3xl p-6 sm:p-8 space-y-4">
            <div class="flex items-center justify-between pb-3 border-b border-zinc-800">
                <div>
                    <h2 class="text-sm font-bold text-white uppercase tracking-wider flex items-center gap-2">
                        <span class="w-2 h-2 rounded-full bg-ember-400"></span>
                        2. Các Biến Thể Sản Phẩm (Màu sắc, Chuẩn kết nối, Giá, Tồn kho)
                    </h2>
                    <p class="text-[11px] text-zinc-400 mt-0.5">Khách hàng sẽ chọn các biến thể này trên trang chi tiết</p>
                </div>

                <button type="button" onclick="addVariantRow()" 
                        class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-ember-500/10 hover:bg-ember-500/20 text-ember-400 border border-ember-500/30 text-xs font-bold transition">
                    + Thêm dòng biến thể
                </button>
            </div>

            <!-- Dynamic Table of Variants -->
            <div class="overflow-x-auto">
                <table class="w-full text-left text-xs" id="variants-table">
                    <thead class="bg-zinc-950/60 text-zinc-400 border-b border-zinc-800">
                        <tr>
                            <th class="py-2.5 px-3 font-semibold">MÀU SẮC</th>
                            <th class="py-2.5 px-3 font-semibold">PHIÊN BẢN / KẾT NỐI</th>
                            <th class="py-2.5 px-3 font-semibold">MÃ SKU</th>
                            <th class="py-2.5 px-3 font-semibold">GIÁ BÁN (₫) *</th>
                            <th class="py-2.5 px-3 font-semibold">GIÁ SALE (₫)</th>
                            <th class="py-2.5 px-3 font-semibold">TỒN KHO *</th>
                            <th class="py-2.5 px-3 font-semibold">ẢNH RIÊNG</th>
                            <th class="py-2.5 px-3 text-right">XÓA</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-zinc-800/60" id="variants-body">
                        <?php if (!empty($variants)): ?>
                            <?php foreach ($variants as $idx => $v): ?>
                                <tr class="variant-row">
                                    <input type="hidden" name="variants[<?= $idx ?>][id]" value="<?= $v['id'] ?>">
                                    <td class="py-2 px-3">
                                        <input type="text" name="variants[<?= $idx ?>][color]" value="<?= htmlspecialchars($v['color'] ?? 'Đen') ?>" 
                                               placeholder="VD: Đen, Trắng" class="w-24 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                    </td>
                                    <td class="py-2 px-3">
                                        <input type="text" name="variants[<?= $idx ?>][version_spec]" value="<?= htmlspecialchars($v['version_spec'] ?? 'Wireless 2.4G') ?>" 
                                               placeholder="VD: Wireless, Có dây" class="w-32 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                    </td>
                                    <td class="py-2 px-3">
                                        <input type="text" name="variants[<?= $idx ?>][sku]" value="<?= htmlspecialchars($v['sku'] ?? '') ?>" 
                                               class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white font-mono">
                                    </td>
                                    <td class="py-2 px-3">
                                        <input type="number" name="variants[<?= $idx ?>][price]" required value="<?= (int)($v['price'] ?? 0) ?>" 
                                               class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white font-bold text-accent-400">
                                    </td>
                                    <td class="py-2 px-3">
                                        <input type="number" name="variants[<?= $idx ?>][sale_price]" value="<?= !empty($v['sale_price']) ? (int)$v['sale_price'] : '' ?>" 
                                               placeholder="Bỏ trống nếu không KM" class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                    </td>
                                    <td class="py-2 px-3">
                                        <input type="number" name="variants[<?= $idx ?>][stock_qty]" required value="<?= (int)($v['stock_qty'] ?? 10) ?>" 
                                               class="w-20 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                    </td>
                                    <td class="py-2 px-3">
                                        <input type="text" name="variants[<?= $idx ?>][image_url]" value="<?= htmlspecialchars($v['image_url'] ?? '') ?>" 
                                               placeholder="https://..." class="w-36 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                    </td>
                                    <td class="py-2 px-3 text-right">
                                        <button type="button" onclick="this.closest('tr').remove()" class="text-zinc-500 hover:text-red-400 p-1">
                                            ✕
                                        </button>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <!-- Mặc định 1 dòng mẫu khi tạo mới -->
                            <tr class="variant-row">
                                <td class="py-2 px-3">
                                    <input type="text" name="variants[0][color]" value="Đen" placeholder="VD: Đen" class="w-24 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                </td>
                                <td class="py-2 px-3">
                                    <input type="text" name="variants[0][version_spec]" value="Wireless 2.4G" placeholder="VD: Wireless" class="w-32 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                </td>
                                <td class="py-2 px-3">
                                    <input type="text" name="variants[0][sku]" placeholder="SKU-01" class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white font-mono">
                                </td>
                                <td class="py-2 px-3">
                                    <input type="number" name="variants[0][price]" required placeholder="1890000" class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white font-bold text-accent-400">
                                </td>
                                <td class="py-2 px-3">
                                    <input type="number" name="variants[0][sale_price]" placeholder="1750000" class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                </td>
                                <td class="py-2 px-3">
                                    <input type="number" name="variants[0][stock_qty]" required value="20" class="w-20 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                </td>
                                <td class="py-2 px-3">
                                    <input type="text" name="variants[0][image_url]" placeholder="https://..." class="w-36 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
                                </td>
                                <td class="py-2 px-3 text-right">
                                    <button type="button" onclick="this.closest('tr').remove()" class="text-zinc-500 hover:text-red-400 p-1">
                                        ✕
                                    </button>
                                </td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Submit Button -->
        <div class="flex items-center justify-end gap-4 pt-4">
            <a href="/admin/products" class="px-6 py-3 rounded-xl border border-zinc-700 text-zinc-300 hover:text-white text-xs font-semibold">
                Hủy bỏ
            </a>
            <button type="submit" 
                    class="px-8 py-3.5 rounded-xl font-bold text-xs bg-accent-500 hover:bg-accent-600 text-on  transition">
                <?= $isEdit ? 'Lưu thay đổi sản phẩm' : 'Hoàn tất thêm sản phẩm' ?>
            </button>
        </div>

    </form>
</div>

<script>
let variantCount = <?= count($variants ?? [1]) ?>;

function addVariantRow() {
    variantCount++;
    const idx = variantCount;
    const tbody = document.getElementById('variants-body');
    const tr = document.createElement('tr');
    tr.className = 'variant-row';
    tr.innerHTML = `
        <td class="py-2 px-3">
            <input type="text" name="variants[${idx}][color]" placeholder="Màu sắc" class="w-24 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
        </td>
        <td class="py-2 px-3">
            <input type="text" name="variants[${idx}][version_spec]" placeholder="Phiên bản" class="w-32 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
        </td>
        <td class="py-2 px-3">
            <input type="text" name="variants[${idx}][sku]" placeholder="SKU" class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white font-mono">
        </td>
        <td class="py-2 px-3">
            <input type="number" name="variants[${idx}][price]" required placeholder="Giá bán" class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white font-bold text-accent-400">
        </td>
        <td class="py-2 px-3">
            <input type="number" name="variants[${idx}][sale_price]" placeholder="Giá KM" class="w-28 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
        </td>
        <td class="py-2 px-3">
            <input type="number" name="variants[${idx}][stock_qty]" required value="10" class="w-20 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
        </td>
        <td class="py-2 px-3">
            <input type="text" name="variants[${idx}][image_url]" placeholder="https://..." class="w-36 bg-zinc-950 border border-zinc-700 rounded-lg px-2 py-1.5 text-xs text-white">
        </td>
        <td class="py-2 px-3 text-right">
            <button type="button" onclick="this.closest('tr').remove()" class="text-zinc-500 hover:text-red-400 p-1">
                ✕
            </button>
        </td>
    `;
    tbody.appendChild(tr);
}
</script>
