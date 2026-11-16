#!/usr/bin/env python3
"""
Chọn ảnh đại diện "sạch" cho thẻ sản phẩm: ảnh đầu của bộ ảnh CellphoneS có sẵn logo và biểu tượng thông số,
nên lấy ảnh kế tiếp có viền gần như trắng hoặc trong suốt (ảnh sản phẩm trơn). Không tìm được thì giữ nguyên.
Ảnh cũ vẫn là ảnh đầu của product_images nên đổi lại được. Chạy: python3 scratch/pick_clean_thumbs.py [--dry]
"""
import subprocess, sys
from pathlib import Path
from PIL import Image
ROOT = Path(__file__).resolve().parent.parent
MY = ["/Applications/XAMPP/xamppfiles/bin/mysql", "-uroot", "-N", "-B", "zentech_db", "-e"]
def q(s): return subprocess.run(MY + [s], capture_output=True, text=True, check=True).stdout.strip()

def clean(path):
    """Viền ảnh (dải 6% quanh mép) có trên 92% điểm gần trắng hoặc trong suốt."""
    im = Image.open(path).convert("RGBA").resize((100, 100))
    px, n, ok = im.load(), 0, 0
    for y in range(100):
        for x in range(100):
            if 6 <= x < 94 and 6 <= y < 94: continue
            r, g, b, a = px[x, y]; n += 1
            ok += a < 12 or min(r, g, b) > 236
    return ok / n > .92

assert clean(ROOT / "public/uploads/products/5c9b0fcddf236f42.webp")          # ảnh chuột trơn nền trong suốt
changed = kept = 0
for row in q("select id, coalesce(thumbnail_url,'') from products where id >= 23 or id in (4,5,7,10,16,21)").split("\n"):
    pid, thumb = row.split("\t")
    imgs = q(f"select image_url from product_images where product_id={pid} order by sort_order, id").split()
    pick = next((u for u in imgs[1:] if u.startswith("/uploads/") and (ROOT / "public" / u.lstrip("/")).exists() and clean(ROOT / "public" / u.lstrip("/"))), None)
    if pick and pick != thumb:
        changed += 1
        if "--dry" not in sys.argv: q(f"update products set thumbnail_url='{pick}' where id={pid}")
    else: kept += 1
print(f"đổi {changed}, giữ nguyên {kept}")
