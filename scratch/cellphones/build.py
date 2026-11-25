"""Gom dữ liệu crawl thành sản phẩm ZenTech (dòng máy -> biến thể phiên bản x màu), tải ảnh gốc và sinh file SQL.
Chạy sau crawl.py: python3 scratch/cellphones/build.py  -> database/seeds/2026_11_25_apple_cellphones.sql"""
import json, os, re, html, hashlib, urllib.request, unicodedata
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
IMG_DIR = os.path.join(ROOT, "public/uploads/products/apple")
OUT_SQL = os.path.join(ROOT, "database/seeds/2026_11_25_apple_cellphones.sql")
# nhóm -> (slug danh mục, tên danh mục mới hoặc None nếu dùng danh mục có sẵn)
CATS = {"iphone": ("dien-thoai", "Điện Thoại"), "ipad": ("may-tinh-bang", "Máy Tính Bảng"),
        "mac": ("laptop-may-mac", "Laptop & Máy Mac"), "watch": ("dong-ho-thong-minh", "Đồng Hồ Thông Minh"),
        "airpods": ("tai-nghe-khong-day", None)}
FEATURED_PER_GROUP = 3  # số dòng máy được xem nhiều nhất mỗi nhóm -> sản phẩm nổi bật
VER = re.compile(r"\b(Wi-?Fi|5G|4G|LTE|Cellular|\d+\s?CPU|\d+\s?GPU|\d+\s?GB|\d+\s?TB)\b", re.I)

def clean(n):
    n = re.split(r"\s+(?:\||I)\s+Chính|\s*\|\s*", n)[0]
    return re.sub(r"\s+", " ", n).strip(" -")

def split(group, name):
    n = clean(name)
    if group == "watch":
        m = re.match(r"(.*?)\s+(\d+\s?mm.*)", n)
        return (m.group(1), m.group(2)) if m else (n, "Tiêu chuẩn")
    if group == "airpods":
        return re.sub(r"^Tai nghe (Bluetooth |chụp tai chống ồn |chụp tai )?", "", n), "Tiêu chuẩn"
    m = VER.search(n)
    if not m: return n, "Tiêu chuẩn"
    base, ver = n[:m.start()].strip(), n[m.start():].strip()
    year = re.search(r"\b20\d\d\b", ver)
    if year:
        ver = re.sub(r"\s*\b20\d\d\b", "", ver).strip()
        if year.group(0) not in base: base += " " + year.group(0)
    return base.strip(), ver or "Tiêu chuẩn"

def slugify(s):
    s = unicodedata.normalize("NFD", s.replace("đ", "d").replace("Đ", "D"))
    s = "".join(c for c in s if unicodedata.category(c) != "Mn").lower()
    return re.sub(r"[^a-z0-9]+", "-", s).strip("-")

def text(h):
    return re.sub(r"\s+", " ", html.unescape(re.sub(r"<br\s*/?>", ", ", re.sub(r"<(?!br)[^>]+>", " ", h or "")))).strip()

SPECS = [("display_size", "Kích thước màn hình"), ("display_resolution", "Độ phân giải"), ("chipset", "Chip"), ("cpu", "CPU"), ("gpu", "GPU"),
         ("storage", "Bộ nhớ trong"), ("camera_primary", "Camera sau"), ("camera_secondary", "Camera trước"), ("battery", "Pin"),
         ("operating_system", "Hệ điều hành"), ("dimensions", "Kích thước"), ("product_weight", "Trọng lượng"), ("weight", "Trọng lượng"),
         ("sim", "SIM"), ("bluetooth", "Bluetooth"), ("wlan", "Wi-Fi"), ("warranty_information", "Bảo hành")]

def local(url):
    """Tên file cục bộ cho ảnh gốc (giữ đuôi), tải khi build."""
    ext = os.path.splitext(url.split("?")[0])[1].lower() or ".jpg"
    return hashlib.md5(url.encode()).hexdigest()[:16] + ext

def q(v):
    if v is None: return "NULL"
    if isinstance(v, (int, float)): return str(int(v))
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"

def main():
    data = json.load(open(os.path.join(HERE, "data.json")))
    groups = {}
    for it in data:
        base, ver = split(it["group"], it["name"])
        key = (it["group"], base.lower())
        g = groups.setdefault(key, {"group": it["group"], "name": base, "rank": it["rank"], "items": []})
        g["rank"] = min(g["rank"], it["rank"])
        g["items"].append((ver, it))

    images = set()
    products = []
    for g in groups.values():
        first = min(g["items"], key=lambda x: x[1]["rank"])[1]
        a = first["attributes"]
        variants, seen = [], set()
        for ver, it in sorted(g["items"], key=lambda x: x[1]["price"]):
            colors = it["colors"] or [{"id": str(it["cps_id"]), "color": "Mặc định", "price": it["special_price"] or it["price"], "image": it["thumbnail"], "discontinued": True}]
            for c in colors:
                k = (ver[:100], c["color"][:50])
                if k in seen: continue
                seen.add(k)
                img = c["image"] or it["thumbnail"]
                if img: images.add(img)
                price = it["price"] or c["price"] or 0
                sale = c["price"] if c["price"] and c["price"] < price else None
                if not price: continue
                variants.append({"sku": f"CPS-{c['id']}", "color": c["color"][:50], "ver": ver[:100], "price": price, "sale": sale,
                                 "stock": 0 if c.get("discontinued") else 20, "img": local(img) if img else None})
        if not variants: continue
        gallery = first["gallery"][:20]
        images.update(gallery)
        ksp = [text(li) for li in re.findall(r"<li>(.*?)</li>", a.get("key_selling_points") or "", re.S)]
        ksp = [x for x in ksp if not x.lower().startswith("giá bán")]
        specs = [f"{label}: {text(a[k])}" for k, label in SPECS if a.get(k) and text(a[k]) and text(a[k]) != "no_selection"]
        seenl, uniq = set(), []
        for s in specs:
            if s.split(":")[0] not in seenl: seenl.add(s.split(":")[0]); uniq.append(s)
        products.append({"group": g["group"], "name": g["name"], "slug": slugify(g["name"]), "rank": g["rank"],
                         "short": " · ".join(ksp[:3])[:600] or g["name"], "full": "\n".join(ksp + [""] + uniq).strip(),
                         "thumb": variants[0]["img"], "gallery": [local(u) for u in gallery], "variants": variants})

    # tải ảnh gốc (song song 6 luồng, bỏ qua ảnh đã có)
    os.makedirs(IMG_DIR, exist_ok=True)
    def dl(u):
        f = os.path.join(IMG_DIR, local(u))
        if os.path.exists(f) and os.path.getsize(f) > 0: return True
        try:
            r = urllib.request.Request(u, headers={"User-Agent": "Mozilla/5.0", "Referer": "https://cellphones.com.vn/"})
            b = urllib.request.urlopen(r, timeout=60).read()
            if len(b) < 500: return False
            open(f, "wb").write(b); return True
        except Exception:
            return False
    with ThreadPoolExecutor(6) as ex:
        ok = dict(zip(sorted(images), ex.map(dl, sorted(images))))
    have = {local(u) for u, v in ok.items() if v}
    print("ảnh:", len(have), "/", len(images))

    # sinh SQL (chạy lại được: xóa sản phẩm đã nhập lần trước theo SKU CPS-*)
    P = "/uploads/products/apple/"
    L = ["-- Sản phẩm Apple lấy từ CellphoneS (không gồm phụ kiện). Sinh bởi scratch/cellphones/build.py",
         "SET NAMES utf8mb4;", "START TRANSACTION;",
         "DELETE p FROM products p WHERE p.id IN (SELECT product_id FROM (SELECT DISTINCT product_id FROM product_variants WHERE sku LIKE 'CPS-%') t);"]
    for grp, (slug, name) in CATS.items():
        if name: L.append(f"INSERT INTO categories (name, slug, is_active) SELECT {q(name)}, {q(slug)}, 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = {q(slug)});")
    L.append("SET @brand = (SELECT id FROM brands WHERE slug = 'apple');")
    used = set()
    rank_in_group = {}
    for p in sorted(products, key=lambda x: (x["group"], x["rank"])):
        rank_in_group[p["group"]] = rank_in_group.get(p["group"], 0) + 1
        slug = p["slug"]; i = 2
        while slug in used: slug = f"{p['slug']}-{i}"; i += 1
        used.add(slug)
        vs = [v for v in p["variants"] if not v["img"] or v["img"] in have]
        if not vs: continue
        thumb = P + vs[0]["img"] if vs[0]["img"] else None
        featured = 1 if rank_in_group[p["group"]] <= FEATURED_PER_GROUP else 0
        L.append(f"INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) "
                 f"VALUES ((SELECT id FROM categories WHERE slug = {q(CATS[p['group']][0])}), @brand, {q(p['name'])}, {q('apple-' + slug if not slug.startswith(('apple', 'iphone', 'ipad', 'mac', 'airpods')) else slug)}, "
                 f"{q('CPS-' + slug[:90])}, {q(p['short'])}, {q(p['full'])}, {q(thumb)}, {min(v['sale'] or v['price'] for v in vs)}, {featured}, 1, {max(0, 1000 - p['rank'] * 10)});")
        L.append("SET @p = LAST_INSERT_ID();")
        for v in vs:
            L.append(f"INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES "
                     f"(@p, {q(v['sku'])}, {q(v['color'])}, {q(v['ver'])}, {v['price']}, {q(v['sale'])}, {v['stock']}, {q(P + v['img'] if v['img'] else None)}, 1);")
        for i, gimg in enumerate([g for g in p["gallery"] if g in have]):
            L.append(f"INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, {q(P + gimg)}, {q(p['name'])}, {i});")
    L.append("COMMIT;")
    os.makedirs(os.path.dirname(OUT_SQL), exist_ok=True)
    open(OUT_SQL, "w").write("\n".join(L) + "\n")
    print("sản phẩm:", len(products), "biến thể:", sum(len(p["variants"]) for p in products), "->", OUT_SQL)

if __name__ == "__main__":
    main()
