/**
 * Chọn biến thể (màu, phiên bản) của sản phẩm. Hàm thuần, không đụng tới trang, nên kiểm thử được bằng Node.
 */
function findVariantIn(variants, color, version) {
    return variants.find(v => v.color === color && v.version_spec === version) || null;
}

/**
 * Người dùng đổi `changed` ('color' hoặc 'version'). Nếu tổ hợp mới không tồn tại, giữ giá trị vừa chọn và
 * chuyển trục còn lại sang biến thể có thật đầu tiên, để thứ hiển thị luôn khớp với thứ được thêm vào giỏ.
 * Trả về { color, version, variant }.
 */
function resolveVariant(variants, color, version, changed) {
    let variant = findVariantIn(variants, color, version);
    if (!variant) {
        variant = variants.find(v => (changed === 'color' ? v.color === color : v.version_spec === version));
    }
    return { color: variant.color, version: variant.version_spec, variant };
}

if (typeof module !== 'undefined') module.exports = { findVariantIn, resolveVariant };
