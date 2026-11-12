#!/usr/bin/env python3
"""Đổi 6 sản phẩm seed (không có trên CellphoneS) sang mẫu tương đương có bán, lấy giá + ảnh thật."""
import re, hashlib, subprocess, urllib.request, io, json
from pathlib import Path
from PIL import Image
import crawl_cellphones as c

ROOT = Path(__file__).resolve().parent.parent
UP = ROOT / "public" / "uploads" / "products"
MYSQL = ["/Applications/XAMPP/xamppfiles/bin/mysql", "-uroot", "zentech_db", "-N", "-B", "-e"]
def q(s): return subprocess.run(MYSQL + [s], capture_output=True, text=True, check=True).stdout.strip()
def esc(v): return "NULL" if v is None else "'" + str(v).replace("\\", "\\\\").replace("'", "\\'") + "'"
def slugify(s):
    s = re.sub(r"[đĐ]", "d", s); import unicodedata
    s = unicodedata.normalize("NFD", s); s = "".join(ch for ch in s if unicodedata.category(ch) != "Mn")
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")[:140]

MAP = {  # id seed -> (url, hãng)
  4:  ("https://cellphones.com.vn/chuot-gaming-razer-deathadder-v2-rz0103210100r3m1.html", "Razer"),
  5:  ("https://cellphones.com.vn/chuot-gaming-corsair-katar-pro-ultra-light.html", "Corsair"),
  7:  ("https://cellphones.com.vn/ban-phim-gaming-corsair-k70-pro-rgb-red-switch.html", "Corsair"),
  16: ("https://cellphones.com.vn/ban-phim-gaming-corsair-k70-pro-blk-mx-speed-rgb.html", "Corsair"),
  10: ("https://cellphones.com.vn/tam-lot-chuot-hyperwork-core-pad-size-xxl.html", "Hyperwork"),
  21: ("https://cellphones.com.vn/ban-di-chuot-asus-rog-hone-ace-aim-lab-edition.html", "ASUS ROG"),
}

def save_img(raw):
    u = re.sub(r"^https://cellphones\.com\.vn/media/", "https://cdn2.cellphones.com.vn/600x/media/", raw)
    data = urllib.request.urlopen(urllib.request.Request(u, headers={"User-Agent": "Mozilla/5.0"}), timeout=40).read()
    im = Image.open(io.BytesIO(data))
    if im.mode in ("RGBA", "P"):
        im = im.convert("RGBA"); bg = Image.new("RGB", im.size, "white"); bg.paste(im, mask=im.split()[3]); im = bg
    else: im = im.convert("RGB")
    h = hashlib.md5(data).hexdigest()[:16]
    im.save(UP / f"{h}.webp", "WEBP", quality=82)
    return f"/uploads/products/{h}.webp"

for pid, (url, brand) in MAP.items():
    html = c.get(url)
    d = c.parse_detail(html, url) if html else None
    if not d or not d.get("price"):
        print("BỎ QUA", pid, url); continue
    bid = q(f"select id from brands where name={esc(brand)}")
    if not bid:
        q(f"insert into brands(name,slug) values({esc(brand)},{esc(slugify(brand))})"); bid = q(f"select id from brands where name={esc(brand)}")
    price = d["price"]; old = d["old"] if d["old"] and d["old"] > price else None
    thumb = save_img(d["image"])
    name = d["name"]; slug = slugify(name)
    desc = (d["desc"] or name)[:400]
    q(f"update products set name={esc(name)},slug={esc(slug)},brand_id={bid},short_desc={esc(desc)},base_price={old or price},thumbnail_url={esc(thumb)} where id={pid}")
    q(f"delete from product_images where product_id={pid}")
    for i, g in enumerate(d["gallery"][:3], 1):
        try: u = thumb if i == 1 else save_img(g)
        except Exception: continue
        q(f"insert into product_images(product_id,image_url,alt_text,sort_order) values({pid},{esc(u)},{esc(name)},{i})")
    q(f"update product_variants set price={old or price}, sale_price={price if old else 'NULL'}, image_url={esc(thumb)} where product_id={pid}")
    print(pid, "->", name, price, old, thumb)
