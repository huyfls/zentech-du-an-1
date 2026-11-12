#!/usr/bin/env python3
"""
Nạp scratch/data/cellphones_products.json vào database zentech_db.

- Chỉ thêm mới (bỏ qua slug đã có), chạy lại nhiều lần vẫn an toàn.
- Giá, giá gốc, tên, ảnh, màu, thông số: lấy từ dữ liệu thu thập.
- Tồn kho, lượt bán, lượt xem, ngày tạo: KHÔNG có trên nguồn, được sinh ngẫu nhiên (dữ liệu mẫu).
- Ảnh chỉ lưu URL (qua bộ resize của CDN nguồn), không tải về.

Chạy:  python3 scratch/import_cellphones.py [--dry]
"""
import json, random, re, subprocess, sys, unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DATA = ROOT / "data" / "cellphones_products.json"
MYSQL = ["/Applications/XAMPP/xamppfiles/bin/mysql", "-uroot", "zentech_db"]
DRY = "--dry" in sys.argv
random.seed(2026)  # kết quả lặp lại được

CDN = "https://cdn2.cellphones.com.vn/insecure/rs:fill:{w}:{w}/q:90/plain/"


def q(sql):
    return subprocess.run(MYSQL + ["-N", "-B", "-e", sql], capture_output=True, text=True, check=True).stdout


def esc(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"


def slugify(s):
    s = unicodedata.normalize("NFD", s.lower().replace("đ", "d"))
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    return re.sub(r"[^a-z0-9]+", "-", s).strip("-")


def img(raw, w=600):
    return CDN.format(w=w) + raw if raw else None


def category_id(p):
    n = (p["name"] + " " + " ".join(p["specs"].values())).lower()
    conn = (p["specs"].get("Kết nối", "") + " " + p["name"]).lower()
    g = p["group"]
    if g == "pad":
        return 4
    if g == "keyboard":
        if re.search(r"bàn phím cơ|mechanical|\bcơ\b|switch", n):
            return 9
        if re.search(r"tkl|mini|65%|75%|60%|compact|80%", n):
            return 11
        return 10
    if g == "headset":
        return 13 if re.search(r"không dây|bluetooth|wireless|tws|2\.4", n) else 12
    # mouse
    wireless = re.search(r"không dây|wireless|bluetooth|2\.4|lightspeed|tri-mode|dual", conn)
    if wireless:
        only_bt = "bluetooth" in conn and not re.search(r"2\.4|usb|không dây|wireless|lightspeed", conn.replace("bluetooth", ""))
        if only_bt:
            return 8
        price = p["price"]
        return 14 if price < 500000 else 15 if price < 1000000 else 16
    return 6


KNOWN = ["Logitech", "Razer", "Corsair", "SteelSeries", "HyperX", "ASUS", "Akko", "DareU", "Rapoo", "Aula", "E-Dra", "Mchose", "Havit",
         "Sony", "JBL", "Edifier", "Keychron", "Fuhlen", "Newmen", "Apple", "Xiaomi", "Ugreen", "Baseus", "Anker", "Samsung", "Lenovo", "HP", "Dell", "Zadez", "Fantech", "Leobog", "Royal Kludge", "Philips", "Sennheiser", "Marshall"]


def brand_name(p):
    b = (p.get("brand") or "").strip()
    if not b or b.lower() in ("hãng khác", "khác"):
        b = next((k for k in KNOWN if re.search(r"\b" + re.escape(k) + r"\b", p["name"], re.I)), "Khác")
    b = re.sub(r"\s*chính hãng$", "", b, flags=re.I)
    low = b.lower()
    if low == "asus":
        return "ASUS ROG" if "rog" in p["name"].lower() else "ASUS"
    return {"dareu": "DareU", "hyperx": "HyperX", "steelseries": "SteelSeries", "e-dra": "E-Dra", "edra": "E-Dra"}.get(low, b[:1].upper() + b[1:])


def main():
    data = json.loads(DATA.read_text(encoding="utf-8"))
    existing_slugs = set(q("select slug from products").split())
    brands = {}
    for line in q("select id,lower(name) from brands").strip().splitlines():
        i, n = line.split("\t"); brands[n] = int(i)
    attrs = {}
    for line in q("select id,lower(name) from attributes").strip().splitlines():
        i, n = line.split("\t"); attrs[n] = int(i)
    group = q("select id from attribute_groups where name='Thông số chi tiết'").strip()
    next_brand = int(q("select coalesce(max(id),0)+1 from brands").strip())
    next_attr = int(q("select coalesce(max(id),0)+1 from attributes").strip())
    next_prod = int(q("select coalesce(max(id),0)+1 from products").strip())
    next_group = int(q("select coalesce(max(id),0)+1 from attribute_groups").strip())

    sql = ["SET NAMES utf8mb4;", "START TRANSACTION;"]
    if not group:
        sql.append(f"INSERT INTO attribute_groups (id, name, sort_order) VALUES ({next_group}, 'Thông số chi tiết', 9);")
        group = str(next_group)

    kept = 0
    skipped = {"no_price": 0, "no_image": 0, "dup": 0}
    seen_names = set()
    rows = []
    for p in data:
        if p["group"] == "pad":  # thực ra là tay cầm chơi game, ZenTech không có danh mục này
            skipped["not_our_category"] = skipped.get("not_our_category", 0) + 1; continue
        if not p.get("price"):
            skipped["no_price"] += 1; continue
        if not (p.get("gallery") or p.get("image")):
            skipped["no_image"] += 1; continue
        slug = p["url"].rsplit("/", 1)[1].removesuffix(".html")
        key = p["name"].strip().lower()
        if slug in existing_slugs or key in seen_names:
            skipped["dup"] += 1; continue
        seen_names.add(key)
        rows.append((p, slug))

    # Nổi bật: 12 sản phẩm giảm giá sâu nhất
    def disc(p):
        return (p["old"] - p["price"]) / p["old"] if p.get("old") and p["old"] > p["price"] else 0
    featured = {id(p) for p, _ in sorted(rows, key=lambda r: -disc(r[0]))[:12]}

    for p, slug in rows:
        pid = next_prod; next_prod += 1
        bn = brand_name(p); bkey = bn.lower()
        if bkey not in brands:
            brands[bkey] = next_brand
            sql.append(f"INSERT INTO brands (id,name,slug,country,is_active) VALUES ({next_brand},{esc(bn)},{esc(slugify(bn))},NULL,1);")
            next_brand += 1
        cat = category_id(p)
        specs = {k: v for k, v in p["specs"].items() if k and v and k != "Hãng sản xuất"}
        short = " · ".join(f"{k}: {v}" for k, v in list(specs.items())[:3])[:480]
        full = "\n".join(f"{k}: {v}" for k, v in specs.items())
        thumb_raw = p.get("list_img") or p.get("image")
        thumb = img(thumb_raw, 600)
        price_now, old = p["price"], p.get("old")
        created = f"DATE_SUB(NOW(), INTERVAL {random.randint(0, 120)} DAY)"
        sql.append(
            "INSERT INTO products (id,category_id,brand_id,name,slug,sku,short_desc,full_desc,thumbnail_url,base_price,is_featured,is_active,view_count,sold_count,created_at) VALUES "
            f"({pid},{cat},{brands[bkey]},{esc(p['name'])},{esc(slug)},{esc((p.get('sku') or '')[:100])},{esc(short)},{esc(full)},{esc(thumb)},{price_now},{1 if id(p) in featured else 0},1,{random.randint(50, 4000)},{random.randint(5, 900)},{created});"
        )
        # Biến thể: mỗi màu một dòng; không có thì một dòng "Tiêu chuẩn"
        variants = p["variants"] or [{"color": "Tiêu chuẩn", "price": price_now, "img": None}]
        used = set()
        for n, v in enumerate(variants, 1):
            color = (v["color"] or "Tiêu chuẩn")[:50]
            if color in used:
                continue
            used.add(color)
            vp = v.get("price") or price_now
            if vp == price_now and old and old > price_now:
                price, sale = old, vp
            else:
                price, sale = vp, None
            vimg = img(v.get("img") or thumb_raw, 600)
            vsku = f"CPS{pid:04d}-{n}"
            sql.append(
                "INSERT INTO product_variants (product_id,sku,color,version_spec,price,sale_price,stock_qty,image_url,is_active) VALUES "
                f"({pid},{esc(vsku)},{esc(color)},'Mặc định',{price},{esc(sale)},{random.randint(5, 60)},{esc(vimg)},1);"
            )
        # Bộ ảnh: ảnh chính trước, rồi gallery (bỏ trùng)
        gal = [thumb_raw] + [g for g in p.get("gallery", []) if g != thumb_raw]
        for n, g in enumerate(dict.fromkeys(gal)):
            if n >= 6:
                break
            sql.append(f"INSERT INTO product_images (product_id,image_url,alt_text,sort_order) VALUES ({pid},{esc(img(g, 800))},{esc(p['name'])},{n});")
        # Thông số: mỗi tên thông số là một thuộc tính (tạo nếu chưa có)
        for n, (k, v) in enumerate(specs.items()):
            ak = k.lower()[:150]
            if ak not in attrs:
                attrs[ak] = next_attr
                sql.append(f"INSERT INTO attributes (id,group_id,name,unit,sort_order,is_filterable) VALUES ({next_attr},{group},{esc(k[:150])},NULL,{min(n, 100)},0);")
                next_attr += 1
            sql.append(f"INSERT INTO product_attributes (product_id,attribute_id,value) VALUES ({pid},{attrs[ak]},{esc(v[:500])});")
        kept += 1

    sql.append("COMMIT;")
    out = ROOT / "data" / "import_cellphones.sql"
    out.write_text("\n".join(sql), encoding="utf-8")
    print(f"Sẽ thêm {kept} sản phẩm; bỏ qua: {skipped}. SQL: {out} ({len(sql)} câu lệnh)")
    if DRY:
        return
    with open(out, "rb") as f:
        r = subprocess.run(MYSQL, stdin=f, capture_output=True, text=True)
    if r.returncode:
        print("LỖI MySQL:", r.stderr[:800]); sys.exit(1)
    print("Đã nạp xong.")


if __name__ == "__main__":
    main()
