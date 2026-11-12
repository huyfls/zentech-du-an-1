// Chạy: node scratch/variant_picker_test.js
const assert = require('assert');
const { findVariantIn, resolveVariant } = require('../public/assets/js/variant-picker.js');

// Dữ liệu thật của DareU EK87 Pro: không có tổ hợp Trắng + Brown Switch
const V = [
    { id: 11, color: 'Đen',   version_spec: 'Red Switch' },
    { id: 12, color: 'Đen',   version_spec: 'Brown Switch' },
    { id: 13, color: 'Trắng', version_spec: 'Red Switch' },
];

// tổ hợp có thật: giữ nguyên
assert.strictEqual(resolveVariant(V, 'Đen', 'Brown Switch', 'version').variant.id, 12);
// đổi màu sang Trắng khi đang chọn Brown (không có Trắng + Brown): ở lại màu Trắng, phiên bản chuyển sang Red
let r = resolveVariant(V, 'Trắng', 'Brown Switch', 'color');
assert.deepStrictEqual([r.color, r.version, r.variant.id], ['Trắng', 'Red Switch', 13]);
// đổi phiên bản sang Brown khi đang chọn Trắng: ở lại Brown, màu chuyển sang Đen
r = resolveVariant(V, 'Trắng', 'Brown Switch', 'version');
assert.deepStrictEqual([r.color, r.version, r.variant.id], ['Đen', 'Brown Switch', 12]);
// biến thể được trả về luôn là một biến thể có thật trong danh sách
for (const c of ['Đen', 'Trắng']) for (const v of ['Red Switch', 'Brown Switch'])
    for (const ch of ['color', 'version']) assert.ok(V.includes(resolveVariant(V, c, v, ch).variant));
assert.strictEqual(findVariantIn(V, 'Trắng', 'Brown Switch'), null);
console.log('variant_picker: đạt');
