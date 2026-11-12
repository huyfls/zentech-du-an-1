#!/usr/bin/env python3
"""
Tải ảnh sản phẩm về public/uploads/products/ và đổi đường dẫn trong database sang ảnh trên máy,
để website hiển thị đủ ảnh khi không có mạng.

- Ảnh CellphoneS: xin bản WebP 640px qua bộ resize của nguồn (nhẹ, khoảng 15-20KB).
- Tải song song 6 luồng. Chạy lại được: ảnh đã tải thì bỏ qua.
- Ảnh tải lỗi vẫn giữ đường dẫn cũ (trang đã có ảnh thay thế khi lỗi).
Chạy: python3 scratch/localize_images.py
"""
import hashlib, re, subprocess, sys, time, urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "public" / "uploads" / "products"; OUT.mkdir(parents=True, exist_ok=True)
MYSQL = ["/Applications/XAMPP/xamppfiles/bin/mysql", "-uroot", "zentech_db"]
UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36 ZenTech-coursework-crawler"

def q(sql): return subprocess.run(MYSQL + ["-N", "-B", "-e", sql], capture_output=True, text=True, check=True).stdout

urls = [u for u in q("select thumbnail_url from products union select image_url from product_variants union select image_url from product_images").split("\n") if u.startswith("http")]
print(len(urls), "ảnh cần xử lý", flush=True)

def source(u):
    """URL thực sự dùng để tải, và đuôi file."""
    if "cdn2.cellphones.com.vn" in u:
        return re.sub(r"rs:fill:\d+:\d+/q:\d+", "rs:fill:640:640/q:80", u) + "@webp", ".webp"
    return u, ".jpg"

from concurrent.futures import ThreadPoolExecutor

def fetch(u):
    """Tải một ảnh (bỏ qua nếu đã có). Trả về (url, đường dẫn trong site hoặc None, lỗi)."""
    src, ext = source(u)
    name = hashlib.sha1(u.encode()).hexdigest()[:16] + ext
    f = OUT / name
    if not (f.exists() and f.stat().st_size > 500):
        try:
            data = urllib.request.urlopen(urllib.request.Request(src, headers={"User-Agent": UA}), timeout=30).read()
            if len(data) < 500: raise ValueError("ảnh quá nhỏ")
            f.write_bytes(data)
        except Exception as e:
            return u, None, str(e)
    return u, "/uploads/products/" + name, None

done, failed = {}, []
# 6 luồng song song: vẫn nhẹ với máy chủ ảnh (khoảng 6 yêu cầu cùng lúc)
with ThreadPoolExecutor(max_workers=6) as pool:
    for i, (u, p, err) in enumerate(pool.map(fetch, urls), 1):
        if p: done[u] = p
        else: failed.append((u, err))
        if i % 200 == 0: print(f"  {i}/{len(urls)}", flush=True)

esc = lambda v: "'" + v.replace("\\", "\\\\").replace("'", "''") + "'"
sql = ["SET NAMES utf8mb4;", "START TRANSACTION;"]
for u, p in done.items():
    for tbl, col in (("products", "thumbnail_url"), ("product_variants", "image_url"), ("product_images", "image_url")):
        sql.append(f"UPDATE {tbl} SET {col}={esc(p)} WHERE {col}={esc(u)};")
sql.append("COMMIT;")
subprocess.run(MYSQL, input="\n".join(sql), text=True, check=True)
print(f"XONG: {len(done)} ảnh đã lưu về máy, {len(failed)} lỗi", flush=True)
for u, e in failed[:10]: print("  lỗi:", e, u[:100])
