#!/usr/bin/env python3
"""
Thu thập sản phẩm từ CellphoneS cho đồ án ZenTech (chỉ dùng học tập, chạy local).

Quy tắc:
- Tôn trọng robots.txt của cellphones.com.vn: chỉ GET các địa chỉ KHÔNG có tham số `?`.
- Chậm: 2 giây giữa hai yêu cầu, cache HTML để không tải lại.
- Chỉ lấy dữ liệu công khai: tên, giá, giá gốc, ảnh (lưu URL, không tải ảnh), màu, thông số.

Chạy:  python3 scratch/crawl_cellphones.py [--max 400]
Ra:    scratch/data/cellphones_products.json
"""
import json, re, sys, time, hashlib, urllib.request, urllib.error
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CACHE = ROOT / "data" / "cache"
OUT = ROOT / "data" / "cellphones_products.json"
CACHE.mkdir(parents=True, exist_ok=True)

BASE = "https://cellphones.com.vn"
UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36 ZenTech-coursework-crawler"
DELAY = 2.0
MAX_PRODUCTS = int(sys.argv[sys.argv.index("--max") + 1]) if "--max" in sys.argv else 400

# Nhóm nguồn -> danh mục ZenTech. Danh mục ghế/bàn gaming không có trên CellphoneS nên bỏ.
HUBS = {
    "mouse":    ["/phu-kien/chuot-ban-phim-may-tinh/chuot.html"],
    "keyboard": ["/phu-kien/chuot-ban-phim-may-tinh/ban-phim.html"],
    "headset":  ["/thiet-bi-am-thanh/tai-nghe/gaming.html", "/thiet-bi-am-thanh/tai-nghe/co-day.html"],
    "pad":      ["/phu-kien/gaming-gear/pad.html"],
}
# Chỉ đi vào các trang con (theo hãng / loại) nằm dưới chính hub đó.
SUBPAGE_LIMIT = {"mouse": 24, "keyboard": 22, "headset": 18, "pad": 6}

_last = 0.0


def get(path_or_url: str):
    """GET có cache + giãn cách. Trả về HTML hoặc None."""
    global _last
    url = path_or_url if path_or_url.startswith("http") else BASE + path_or_url
    if "?" in url:
        return None  # robots.txt: Disallow: /*?*
    f = CACHE / (hashlib.md5(url.encode()).hexdigest() + ".html")
    if f.exists():
        return f.read_text(encoding="utf-8")
    wait = DELAY - (time.time() - _last)
    if wait > 0:
        time.sleep(wait)
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept-Language": "vi"})
    try:
        with urllib.request.urlopen(req, timeout=40) as r:
            html = r.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        print(f"  HTTP {e.code} {url}", flush=True)
        _last = time.time()
        return None
    except Exception as e:
        print(f"  ERR {e} {url}", flush=True)
        _last = time.time()
        return None
    _last = time.time()
    f.write_text(html, encoding="utf-8")
    return html


def money(s):
    d = re.sub(r"[^\d]", "", s or "")
    return int(d) if d else None


def parse_cards(html):
    cards = []
    for c in html.split('<div class="product-info-container product-item">')[1:]:
        m = re.search(r'href="(https://cellphones\.com\.vn/[a-z0-9-]+\.html)"', c)
        if not m:
            continue
        img = re.search(r'<img src="([^"]+)"', c)
        name = re.search(r"<h3>(.*?)</h3>", c, re.S)
        price = re.search(r'product__price--show">\s*([^<]+)<', c)
        old = re.search(r'product__price--through">\s*([^<]+)<', c)
        cards.append({
            "url": m.group(1),
            "name": re.sub(r"\s+", " ", name.group(1)).strip() if name else "",
            "img": img.group(1) if img else "",
            "price": money(price.group(1)) if price else None,
            "old": money(old.group(1)) if old else None,
        })
    return cards


def sub_pages(html, hub_path):
    prefix = BASE + hub_path[: -len(".html")] + "/"
    found = re.findall(r'https://cellphones\.com\.vn(' + re.escape(hub_path[: -len(".html")]) + r'/[a-z0-9-]+\.html)', html)
    return sorted(set(found))


def raw_image(u):
    """Lấy URL ảnh gốc trên cellphones.com.vn từ URL đã qua bộ resize cdn2."""
    m = re.search(r"/media/catalog/product/([^\s\"'?]+)", u or "")
    return "https://cellphones.com.vn/media/catalog/product/" + m.group(1) if m else u


def parse_detail(html, url):
    ld = None
    for m in re.finditer(r'<script data-n-head="ssr" type="application/ld\+json">(.*?)</script>', html, re.S):
        try:
            j = json.loads(m.group(1))
        except Exception:
            continue
        if isinstance(j, dict) and j.get("@type") == "Product":
            ld = j
    if not ld:
        return None
    offer = ld.get("offers") or {}
    if isinstance(offer, list):
        offer = offer[0] if offer else {}
    price = money(str(offer.get("price", "")))
    old = re.search(r'class="base-price">\s*([\d.,]+)', html)
    specs = {p["name"]: re.sub(r"\s+", " ", p["value"]).strip() for p in ld.get("additionalProperty", []) if p.get("name")}
    breadcrumb = []
    for m in re.finditer(r'<script data-n-head="ssr" type="application/ld\+json">(.*?)</script>', html, re.S):
        try:
            j = json.loads(m.group(1))
            if j.get("@type") == "BreadcrumbList":
                breadcrumb = [i["item"]["name"] for i in j["itemListElement"]]
        except Exception:
            pass
    # Gallery: ảnh /media/catalog/product/ không trùng, giữ thứ tự xuất hiện
    gallery, seen = [], set()
    for u in re.findall(r"https://cdn2\.cellphones\.com\.vn/[^\"\s]*?/media/catalog/product/[^\"\s]+", html):
        key = u.split("/media/catalog/product/")[1]
        if key not in seen and not re.search(r"(icon|badge|sticker|flash)", key, re.I):
            seen.add(key)
            gallery.append("https://cellphones.com.vn/media/catalog/product/" + key)
    # Biến thể màu: <li data-product-id ...><a title="Trắng"> ... <span class="item-variant-price"> 725.000₫
    variants = []
    for li in re.findall(r'<li data-product-id="\d+" class="item-variant[^"]*">(.*?)</li>', html, re.S):
        t = re.search(r'title="([^"]+)"', li)
        vp = re.search(r'item-variant-price">\s*([^<]+)<', li)
        vi = re.findall(r'<img src="(https://cdn2[^"]+/media/catalog/product/[^"]+)"', li)
        if t:
            variants.append({"color": t.group(1).strip(), "price": money(vp.group(1)) if vp else price,
                             "img": raw_image(vi[0]) if vi else None})
    # Phiên bản liên kết (box-linked): model khác nhau, mỗi cái một trang riêng -> chỉ ghi nhãn
    linked = re.findall(r'class="item-linked[^"]*"[^>]*>(.*?)</a>', html, re.S)
    desc_html = re.search(r'<div class="cps-block-content[^>]*>(.*?)</div>\s*<!---->', html, re.S)
    return {
        "url": url,
        "name": ld.get("name"),
        "sku": ld.get("sku"),
        "brand": (ld.get("brand") or {}).get("name"),
        "price": price,
        "old": money(old.group(1)) if old else None,
        "image": raw_image(ld.get("image", "")),
        "gallery": gallery[:8],
        "variants": variants,
        "specs": specs,
        "breadcrumb": breadcrumb,
        "linked": [re.sub(r"<[^>]+>", " ", x).strip() for x in linked][:6],
        "desc": (ld.get("description") or "").strip(),
        "rating": next(iter([r.get("reviewRating", {}).get("ratingValue") for r in ld.get("review", [])] or [None]), None),
        "review_count": len(ld.get("review", [])),
    }


def main():
    print("== 1. Danh sách theo nhóm ==", flush=True)
    listing = {}  # url -> card + group
    for group, hubs in HUBS.items():
        pages = list(hubs)
        for hub in hubs:
            html = get(hub)
            if not html:
                continue
            pages += sub_pages(html, hub)[: SUBPAGE_LIMIT[group]]
        for p in dict.fromkeys(pages):
            html = get(p)
            if not html:
                continue
            cards = parse_cards(html)
            new = 0
            for c in cards:
                if c["url"] not in listing:
                    c["group"] = group
                    listing[c["url"]] = c
                    new += 1
            print(f"  [{group}] {p}: {len(cards)} thẻ, {new} mới (tổng {len(listing)})", flush=True)
    urls = list(listing)[:MAX_PRODUCTS]
    print(f"== 2. Chi tiết {len(urls)} sản phẩm ==", flush=True)
    out = []
    for i, u in enumerate(urls, 1):
        html = get(u)
        d = parse_detail(html, u) if html else None
        if not d:
            print(f"  [{i}/{len(urls)}] bỏ qua {u}", flush=True)
            continue
        c = listing[u]
        d["group"] = c["group"]
        d["list_img"] = raw_image(c["img"])
        d["list_price"] = c["price"]
        d["list_old"] = c["old"]
        out.append(d)
        if i % 10 == 0:
            print(f"  [{i}/{len(urls)}] {d['name']} - {d['price']}", flush=True)
            OUT.write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
    OUT.write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"XONG: {len(out)} sản phẩm -> {OUT}", flush=True)


if __name__ == "__main__":
    main()
