"""Crawl sản phẩm Apple (không gồm phụ kiện) từ CellphoneS -> scratch/cellphones/data.json
Chạy: python3 scratch/cellphones/crawl.py   (trang chi tiết được cache trong scratch/cellphones/pages/)"""
import json, os, re, time, html, urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
UA = {"User-Agent": "Mozilla/5.0", "Origin": "https://cellphones.com.vn", "Referer": "https://cellphones.com.vn/"}
# id danh mục bên CellphoneS -> nhóm của mình
CATS = {"132": "iphone", "944": "ipad", "5": "mac", "88": "watch", "384": "airpods"}

def api(cat, page):
    q = '''query{ products(filter:{static:{categories:["%s"],province_id:30,stock:{from:0},company_stock_id:[46,152,56,4920]},dynamic:{}},page:%d,size:100,sort:[{view:desc}]){
      general{product_id name url_path manufacturer attributes} filterable{price special_price thumbnail child_product} } }''' % (cat, page)
    r = urllib.request.Request("https://api.cellphones.com.vn/v2/graphql/query", data=json.dumps({"query": q, "variables": {}}).encode(),
                               headers={**UA, "Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(r, timeout=60))["data"]["products"] or []

def page(url_path):
    f = os.path.join(HERE, "pages", url_path)
    if not os.path.exists(f):
        os.makedirs(os.path.dirname(f), exist_ok=True)
        r = urllib.request.Request("https://cellphones.com.vn/" + url_path, headers={"User-Agent": "Mozilla/5.0"})
        open(f, "wb").write(urllib.request.urlopen(r, timeout=60).read())
        time.sleep(0.4)  # nhẹ tay với server của họ
    return open(f, encoding="utf-8", errors="ignore").read()

FULL = "https://cellphones.com.vn/media/catalog/product"

def parse_detail(s):
    colors = {}
    for m in re.finditer(r'<li data-product-id="(\d+)"(.{0,4000}?)</li>', s, re.S):
        cid, body = m.group(1), m.group(2)
        name = re.search(r'line-clamp-3[^>]*>([^<]+)<', body)
        price = re.search(r'text-xs text-neutral-500">([\d.]+)đ<', body)
        img = re.search(r'plain/(https://cellphones\.com\.vn/media/catalog/product[^"&]+)"', body)
        if name and cid not in colors:
            colors[cid] = {"id": cid, "color": html.unescape(name.group(1)).strip(),
                           "price": int(price.group(1).replace(".", "")) if price else None,
                           "image": img.group(1) if img else None}
    gallery = []
    for u in re.findall(r'data-src="(https://cellphones\.com\.vn/media/catalog/product/[^"]+)"', s):
        if u not in gallery: gallery.append(u)
    return list(colors.values()), gallery

def main():
    out = []
    for cat, group in CATS.items():
        rank, p = 0, 1
        while True:
            items = api(cat, p)
            for it in items:
                g, f = it["general"], it["filterable"]
                rank += 1
                name = g["name"]
                if group == "airpods" and not re.search(r"AirPods", name, re.I): continue  # bỏ Beats, EarPods
                if (g.get("manufacturer") or "").lower() != "apple" and "apple" not in name.lower() and group != "mac": continue
                try:
                    colors, gallery = parse_detail(page(g["url_path"]))
                except Exception as e:
                    print("  lỗi trang", g["url_path"], e); colors, gallery = [], []
                a = g.get("attributes") or {}
                out.append({"group": group, "rank": rank, "cps_id": g["product_id"], "name": name, "url": g["url_path"],
                            "price": int(f["price"] or 0), "special_price": int(f["special_price"] or 0) or None,
                            "thumbnail": FULL + f["thumbnail"] if f.get("thumbnail") else None,
                            "colors": colors, "gallery": gallery, "attributes": a})
                print(group, rank, name, len(colors), "màu", len(gallery), "ảnh")
            if len(items) < 100: break
            p += 1
    json.dump(out, open(os.path.join(HERE, "data.json"), "w"), ensure_ascii=False, indent=1)
    print("Tổng", len(out))

if __name__ == "__main__":
    main()
