#!/usr/bin/env python3
"""
Vẽ các khối ```mermaid trong docs/*.md thành ảnh PNG (docs/hinh_ve/<mã>.png) để đưa vào file Word.
Cần: pip install playwright (dùng Google Chrome có sẵn) và có internet (tải thư viện mermaid một lần).
Tên ảnh là mã băm nội dung khối, nên sửa sơ đồ rồi chạy lại là ảnh mới tự khớp.
"""
import hashlib, re
from pathlib import Path
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "docs" / "hinh_ve"; OUT.mkdir(exist_ok=True)
blocks = {}
for md in sorted((ROOT / "docs").glob("*.md")):
    for code in re.findall(r"```mermaid\n(.*?)```", md.read_text(encoding="utf-8"), re.S):
        code = code.rstrip()
        blocks[hashlib.md5(code.encode()).hexdigest()[:10]] = (md.name, code)

PAGE = """<!doctype html><meta charset=utf-8><body style="margin:0;background:#fff;font-family:'Be Vietnam Pro',Arial,sans-serif">
<div id=w style="display:inline-block;padding:24px"><pre class=mermaid>{code}</pre></div>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.3/dist/mermaid.min.js"></script>
<script>mermaid.initialize({{startOnLoad:true,theme:'neutral',securityLevel:'loose',themeVariables:{{fontFamily:'Arial'}},
 er:{{useMaxWidth:false}},flowchart:{{useMaxWidth:false,htmlLabels:true}},sequence:{{useMaxWidth:false}}}});</script>"""

with sync_playwright() as p:
    br = p.chromium.launch(channel="chrome", headless=True)
    for key, (name, code) in blocks.items():
        pg = br.new_page(viewport={"width": 1800, "height": 1000}, device_scale_factor=2)
        pg.set_content(PAGE.format(code=code.replace("&", "&amp;").replace("<", "&lt;")))
        try:
            pg.wait_for_selector("pre.mermaid svg", timeout=30000)
        except Exception:
            print("  LỖI vẽ:", name, key); pg.close(); continue
        pg.wait_for_timeout(400)
        pg.locator("#w").screenshot(path=str(OUT / f"{key}.png"))
        print("  ", name, key); pg.close()
    br.close()
print(len(list(OUT.glob("*.png"))), "/", len(blocks), "sơ đồ")
