#!/usr/bin/env python3
"""Vẽ sơ đồ liên kết giữa các bảng (đọc khóa ngoại thật từ database) -> docs/erd_lien_ket_bang.png. Cần internet (mermaid) và Chrome."""
import subprocess
from pathlib import Path
from playwright.sync_api import sync_playwright
ROOT = Path(__file__).resolve().parent.parent
q = ("select table_name,column_name,referenced_table_name from information_schema.key_column_usage "
     "where table_schema='zentech_db' and referenced_table_name is not null order by 1,2")
rows = [l.split("\t") for l in subprocess.run(["/Applications/XAMPP/xamppfiles/bin/mysql", "-uroot", "-N", "-e", q], capture_output=True, text=True).stdout.strip().splitlines()]
groups = {
 "Tài khoản": ["roles", "users", "addresses", "password_resets"],
 "Danh mục và thương hiệu": ["categories", "brands"],
 "Sản phẩm, biến thể, thông số": ["products", "product_images", "product_variants", "attribute_groups", "attributes", "product_attributes", "variant_options", "variant_option_values", "variant_attribute_values"],
 "Giỏ hàng, đơn hàng, khuyến mãi": ["carts", "cart_items", "orders", "order_items", "order_status_logs", "coupons", "order_coupons"],
 "Đánh giá và trợ lý AI": ["reviews", "review_images", "ai_conversations", "ai_messages"],
}
cls = {"Tài khoản": "a", "Danh mục và thương hiệu": "b", "Sản phẩm, biến thể, thông số": "c", "Giỏ hàng, đơn hàng, khuyến mãi": "d", "Đánh giá và trợ lý AI": "e"}
m = ["flowchart TB"]
for i, (g, ts) in enumerate(groups.items()):
    m.append(f'  subgraph G{i}["{g}"]\n    direction TB')
    m += [f"    {t}[{t}]:::{cls[g]}" for t in ts]
    m.append("  end")
for child, col, parent in rows:
    m.append(f"  {parent} -- \"{col}\" --> {child}")
m += ["  classDef a fill:#E8F0FE,stroke:#0F5DE0,color:#1D1D1F", "  classDef b fill:#FFF4E5,stroke:#CC730D,color:#1D1D1F",
      "  classDef c fill:#E6F4EA,stroke:#097A3C,color:#1D1D1F", "  classDef d fill:#F3E8FD,stroke:#7846C8,color:#1D1D1F", "  classDef e fill:#FDE8E6,stroke:#D1281C,color:#1D1D1F"]
code = "\n".join(m)
(ROOT / "docs" / "erd_lien_ket_bang.mmd").write_text(code, encoding="utf-8")
PAGE = """<!doctype html><meta charset=utf-8><body style="margin:0;background:#fff"><div id=w style="display:inline-block;padding:30px"><pre class=mermaid>{code}</pre></div>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.3/dist/mermaid.min.js"></script>
<script>mermaid.initialize({{startOnLoad:true,theme:'neutral',securityLevel:'loose',flowchart:{{useMaxWidth:false,htmlLabels:true,curve:'basis',nodeSpacing:40,rankSpacing:70}},themeVariables:{{fontFamily:'Arial',fontSize:'16px'}}}});</script>"""
with sync_playwright() as p:
    br = p.chromium.launch(channel="chrome", headless=True)
    pg = br.new_page(viewport={"width": 2000, "height": 1200}, device_scale_factor=2)
    pg.set_content(PAGE.format(code=code.replace("&", "&amp;").replace("<", "&lt;")))
    pg.wait_for_selector("svg", timeout=60000); pg.wait_for_timeout(1500)
    pg.locator("#w").screenshot(path=str(ROOT / "docs" / "erd_lien_ket_bang.png"))
    br.close()
print(len(rows), "khóa ngoại ->", ROOT / "docs" / "erd_lien_ket_bang.png")
