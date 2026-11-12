#!/usr/bin/env python3
"""
Tạo presentation.pptx (16:9, 24 slide) tóm tắt báo cáo Giai đoạn 1 của ZenTech.

Nguồn số liệu: scratch/data/survey_stats.json (khảo sát 139 phản hồi), scratch/data/flow_result.txt
(kết quả kiểm thử), và các con số đã ghi trong báo cáo (26 bảng, 29 khóa ngoại, 330 sản phẩm...).
Mọi ô chữ đều được đo bằng phông Arial; chữ dài sẽ tự giảm cỡ cho vừa khung, và script in cảnh báo
nếu vẫn không vừa. Chạy:  python3 scratch/make_presentation.py [đường_dẫn_ra]
"""
import json, re, sys
from collections import Counter
from pathlib import Path
from PIL import ImageFont
from pptx import Presentation
from pptx.chart.data import CategoryChartData
from pptx.dml.color import RGBColor
from pptx.enum.chart import XL_CHART_TYPE, XL_LABEL_POSITION, XL_LEGEND_POSITION
from pptx.enum.shapes import MSO_SHAPE
from pptx.enum.text import MSO_ANCHOR, PP_ALIGN
from pptx.util import Inches, Pt, Emu

ROOT = Path(__file__).resolve().parent.parent
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "presentation.pptx"
STATS = json.loads((ROOT / "scratch/data/survey_stats.json").read_text(encoding="utf-8"))["questions"]

# ---------- bảng màu: nền sáng, chữ đậm, một màu nhấn ----------
def rgb(h): return RGBColor.from_string(h.lstrip("#"))
BG, INK, MUTED = rgb("FFFFFF"), rgb("1D1D1F"), rgb("5F6368")
ACCENT, ACCENT_SOFT, ACCENT_MID = rgb("0F5DE0"), rgb("E8F0FE"), rgb("8FB3F2")
CARD, LINE, GRAY = rgb("F5F5F7"), rgb("E1E3E8"), rgb("B8BCC4")
FONT = "Arial"
F_REG = "/System/Library/Fonts/Supplemental/Arial.ttf"
F_BOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
_fc = {}
warnings = []


def _font(size, bold):
    k = (round(size * 4), bold)
    if k not in _fc: _fc[k] = ImageFont.truetype(F_BOLD if bold else F_REG, int(round(size * 4)))
    return _fc[k]


def text_height(text, size, bold, width_in, line_gap=1.2):
    """Chiều cao (inch) của đoạn chữ sau khi tự xuống dòng trong khung rộng width_in."""
    f, maxw, lines = _font(size, bold), width_in * 72 * 4, 0
    for para in text.split("\n"):
        cur = ""
        n = 1
        for w in para.split(" "):
            t = (cur + " " + w).strip()
            if f.getlength(t) <= maxw or not cur: cur = t
            else: n, cur = n + 1, w
        lines += n
    return lines * size * line_gap / 72


prs = Presentation()
prs.slide_width, prs.slide_height = Inches(13.333), Inches(7.5)
BLANK = prs.slide_layouts[6]
slide_no = [0]


def new_slide(title=None, kicker=None):
    s = prs.slides.add_slide(BLANK)
    slide_no[0] += 1
    s.background.fill.solid(); s.background.fill.fore_color.rgb = BG
    if title:
        if kicker:
            text(s, 0.6, 0.3, 9, 0.28, kicker.upper(), 11, True, ACCENT)
        text(s, 0.6, 0.62, 12.1, 0.8, title, 28, True, INK, anchor="top")
        s.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(0.6), Inches(1.42), Inches(0.9), Emu(38100)).fill.solid()
        bar = s.shapes[-1]; bar.fill.fore_color.rgb = ACCENT; bar.line.fill.background()
        text(s, 0.6, 7.02, 8, 0.3, "ZenTech  |  Báo cáo Giai đoạn 1  |  Nhóm 1 Dự án 1", 9, False, MUTED)
        text(s, 11.9, 7.02, 0.85, 0.3, str(slide_no[0]), 9, False, MUTED, align="right")
    return s


def text(s, x, y, w, h, t, size=14, bold=False, color=INK, align="left", anchor="middle", min_size=9, name=None):
    """Ô chữ tự giảm cỡ cho vừa khung (trừ lề 0.05 inch mỗi bên)."""
    tb = s.shapes.add_textbox(Inches(x), Inches(y), Inches(w), Inches(h))
    tf = tb.text_frame; tf.word_wrap = True
    tf.margin_left = tf.margin_right = Inches(0.05); tf.margin_top = tf.margin_bottom = Inches(0.02)
    tf.vertical_anchor = {"top": MSO_ANCHOR.TOP, "middle": MSO_ANCHOR.MIDDLE, "bottom": MSO_ANCHOR.BOTTOM}[anchor]
    sz = size
    while sz > min_size and text_height(t, sz, bold, w - 0.1) > h - 0.04: sz -= 0.5
    if text_height(t, sz, bold, w - 0.1) > h - 0.04:
        warnings.append(f"slide {slide_no[0]}: chữ có thể tràn ({t[:40]!r} cỡ {sz})")
    for i, line in enumerate(t.split("\n")):
        p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
        p.alignment = {"left": PP_ALIGN.LEFT, "center": PP_ALIGN.CENTER, "right": PP_ALIGN.RIGHT}[align]
        r = p.add_run(); r.text = line
        r.font.size = Pt(sz); r.font.bold = bold; r.font.color.rgb = color; r.font.name = FONT
    return tb


def box(s, x, y, w, h, fill=CARD, line=None, radius=True):
    sh = s.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE if radius else MSO_SHAPE.RECTANGLE, Inches(x), Inches(y), Inches(w), Inches(h))
    if radius: sh.adjustments[0] = 0.06
    sh.fill.solid(); sh.fill.fore_color.rgb = fill
    if line: sh.line.color.rgb = line; sh.line.width = Pt(0.75)
    else: sh.line.fill.background()
    sh.shadow.inherit = False
    return sh


def card(s, x, y, w, h, title, body, accent=False, tsize=16, bsize=13):
    box(s, x, y, w, h, ACCENT_SOFT if accent else CARD)
    text(s, x + 0.2, y + 0.15, w - 0.4, 0.5, title, tsize, True, ACCENT if accent else INK, anchor="top")
    text(s, x + 0.2, y + 0.7, w - 0.4, h - 0.85, body, bsize, False, INK if accent else MUTED, anchor="top")


def big(s, x, y, w, value, label, h=1.7, accent=True):
    box(s, x, y, w, h, ACCENT_SOFT if accent else CARD)
    text(s, x + 0.15, y + 0.15, w - 0.3, h * 0.52, value, 40, True, ACCENT if accent else INK, align="center")
    text(s, x + 0.15, y + h * 0.62, w - 0.3, h * 0.3, label, 13, False, MUTED, align="center", anchor="top")


def chart(s, kind, x, y, w, h, cats, vals, fmt='0.0"%"', colors=None, legend=False, label_size=12):
    cd = CategoryChartData(); cd.categories = cats; cd.add_series("S", vals)
    gf = s.shapes.add_chart(kind, Inches(x), Inches(y), Inches(w), Inches(h), cd); ch = gf.chart
    ch.has_title = False; ch.has_legend = legend
    ch.font.size = Pt(label_size); ch.font.name = FONT; ch.font.color.rgb = INK
    pl = ch.plots[0]; pl.has_data_labels = True
    dl = pl.data_labels; dl.number_format = fmt; dl.number_format_is_linked = False
    dl.font.size = Pt(label_size); dl.font.bold = True; dl.font.color.rgb = INK
    if kind == XL_CHART_TYPE.PIE:
        dl.position = XL_LABEL_POSITION.OUTSIDE_END
        pal = colors or [ACCENT, ACCENT_MID, GRAY, LINE]
        for i, pt_ in enumerate(pl.series[0].points):
            pt_.format.fill.solid(); pt_.format.fill.fore_color.rgb = pal[i % len(pal)]
        ch.has_legend = True; ch.legend.position = XL_LEGEND_POSITION.BOTTOM; ch.legend.include_in_layout = False
        ch.legend.font.size = Pt(label_size)
    else:
        pl.gap_width = 60
        ser = pl.series[0]; ser.format.fill.solid(); ser.format.fill.fore_color.rgb = ACCENT
        if colors:
            for i, c in enumerate(colors):
                pt_ = ser.points[i]; pt_.format.fill.solid(); pt_.format.fill.fore_color.rgb = c
        dl.position = XL_LABEL_POSITION.OUTSIDE_END
        va = ch.value_axis; va.visible = False; va.has_major_gridlines = False
        va.maximum_scale = max(vals) * 1.25; va.minimum_scale = 0
        ca = ch.category_axis; ca.format.line.color.rgb = LINE; ca.tick_labels.font.size = Pt(label_size)
        ca.has_major_gridlines = False
        if kind == XL_CHART_TYPE.BAR_CLUSTERED: ca.reverse_order = True
    return ch


def table(s, x, y, w, col_w, rows, row_h=0.62, header=True, size=13):
    n, m = len(rows), len(rows[0])
    gt = s.shapes.add_table(n, m, Inches(x), Inches(y), Inches(w), Inches(row_h * n))
    t = gt.table
    tblPr = gt._element.graphic.graphicData.tbl.tblPr
    tblPr.set("firstRow", "0"); tblPr.set("bandRow", "0")
    for j, cw in enumerate(col_w): t.columns[j].width = Inches(cw)
    for i, row in enumerate(rows):
        t.rows[i].height = Inches(row_h)
        for j, val in enumerate(row):
            c = t.cell(i, j); c.margin_left = c.margin_right = Inches(0.12); c.margin_top = c.margin_bottom = Inches(0.04)
            c.vertical_anchor = MSO_ANCHOR.MIDDLE
            c.fill.solid(); c.fill.fore_color.rgb = ACCENT if (header and i == 0) else (CARD if i % 2 else BG)
            tf = c.text_frame; tf.word_wrap = True
            hdr = header and i == 0
            bold = hdr or j == 0
            sz = size
            while sz > 9 and text_height(val, sz, bold, col_w[j] - 0.26) > row_h - 0.1: sz -= 0.5
            if text_height(val, sz, bold, col_w[j] - 0.26) > row_h - 0.1: warnings.append(f"slide {slide_no[0]}: ô bảng có thể tràn ({val[:30]!r})")
            r = tf.paragraphs[0].add_run(); r.text = val
            r.font.size = Pt(sz); r.font.bold = bold; r.font.name = FONT
            r.font.color.rgb = rgb("FFFFFF") if hdr else INK
    return t


def pct(q): return [r["pct"] for r in STATS[q]["rows"]]
def lab(q): return [r["label"] for r in STATS[q]["rows"]]


# =====================================================================
# 1. Bìa
s = new_slide()
box(s, 0, 0, 13.333, 7.5, ACCENT_SOFT, radius=False)
box(s, 0.9, 1.0, 0.18, 2.6, ACCENT, radius=False)
text(s, 1.35, 0.95, 10, 0.4, "BÁO CÁO GIAI ĐOẠN 1  |  MÔN DỰ ÁN 1, LẬP TRÌNH WEBSITE", 13, True, ACCENT)
text(s, 1.35, 1.5, 11, 1.2, "ZenTech", 66, True, INK)
text(s, 1.35, 2.7, 11, 0.9, "Website bán gaming gear: chọn theo thông số, đặt hàng an toàn", 26, False, INK)
text(s, 1.35, 4.3, 11, 0.4, "Nhóm 1 Dự án 1  |  Trưởng nhóm: Lê Thành Huy (PA00423)", 15, False, MUTED)
text(s, 1.35, 4.8, 11, 0.4, "PHP thuần (MVC)  ·  MySQL  ·  Tailwind CSS  ·  JavaScript", 15, False, MUTED)
text(s, 1.35, 6.5, 11, 0.4, "Hạn nộp Giai đoạn 1: 13/11/2026", 12, False, MUTED)

# 2. Nội dung
s = new_slide("Nội dung trình bày", "Mục lục")
items = [("1", "Quyết định đề tài", "Vấn đề, giải pháp, mục tiêu"), ("2", "Khảo sát Google Form", "139 phản hồi và phân tích"),
         ("3", "Thiết kế UI/UX", "Phong cách, luồng, màn hình"), ("4", "Thiết kế cơ sở dữ liệu", "26 bảng, đặt hàng an toàn"),
         ("5", "Kiểm thử và kết quả", "117/117 ca đạt"), ("6", "Bàn giao", "Sản phẩm và hướng phát triển")]
for i, (n_, t_, d_) in enumerate(items):
    x, y = 0.6 + (i % 3) * 4.1, 1.95 + (i // 3) * 2.45
    box(s, x, y, 3.85, 2.2)
    text(s, x + 0.25, y + 0.2, 0.8, 0.7, n_, 36, True, ACCENT, anchor="top")
    text(s, x + 0.25, y + 1.0, 3.35, 0.5, t_, 18, True, INK, anchor="top")
    text(s, x + 0.25, y + 1.5, 3.35, 0.5, d_, 13, False, MUTED, anchor="top")

# 3. Tóm tắt điều hành
s = new_slide("Tóm tắt điều hành: đủ 4 yêu cầu, sản phẩm chạy được", "Tổng quan")
for i, (v, l) in enumerate([("139", "phản hồi khảo sát\n(yêu cầu tối thiểu 100)"), ("26", "bảng cơ sở dữ liệu,\n29 khóa ngoại"),
                            ("330", "sản phẩm, hơn 570\nbiến thể, 1.800 ảnh"), ("117/117", "ca kiểm thử\ntự động đạt")]):
    big(s, 0.6 + i * 3.05, 1.9, 2.85, v, l, h=2.2)
card(s, 0.6, 4.4, 3.95, 2.3, "Đề tài", "ZenTech: gaming gear, chọn theo thông số, có trợ lý AI ZenBot", True)
card(s, 4.7, 4.4, 3.95, 2.3, "Thiết kế", "Giao diện sáng, tối giản; bộ lọc nhiều lựa chọn; 19 màn hình", False)
card(s, 8.8, 4.4, 3.95, 2.3, "Kỹ thuật", "MVC thuần, giao dịch khóa dòng, chống CSRF, mật khẩu bcrypt", False)

# 4. Đề tài
s = new_slide("Đề tài: giúp người mua chọn gaming gear theo thông số", "Quyết định đề tài")
card(s, 0.6, 1.95, 3.95, 4.7, "Vấn đề", "Khó biết thông số có hợp nhu cầu\n\nKhó so sánh phiên bản, màu sắc\n\nLo hàng không chính hãng", False)
card(s, 4.7, 1.95, 3.95, 4.7, "Giải pháp", "Trang chi tiết ghi rõ thông số, giá và tồn kho theo từng biến thể\n\nBộ lọc nhiều lựa chọn\n\nTrợ lý ZenBot gợi ý theo ngân sách", True)
card(s, 8.8, 1.95, 3.95, 4.7, "Đối tượng", "Học sinh, sinh viên, nhân viên văn phòng, người làm sáng tạo\n\n82,7% từ 18 đến 28 tuổi\n\nMua cho bản thân", False)

# 5. Mục tiêu
s = new_slide("Bốn mục tiêu của dự án", "Quyết định đề tài")
for i, (t_, b_) in enumerate([("Nghiệp vụ", "Kênh bán gear trực tuyến, giao diện sáng và gọn"), ("Trải nghiệm", "Chọn biến thể, xem giá và tồn kho ngay, không tải lại trang"),
                              ("Kỹ thuật", "MVC thuần, CSDL 3NF + EAV, giao dịch ACID"), ("Bảo mật", "CSRF, cố định phiên, bcrypt, truy vấn có tham số")]):
    card(s, 0.6 + (i % 2) * 6.2, 1.95 + (i // 2) * 2.45, 5.95, 2.2, t_, b_, i == 0, 18, 15)

# 6. Khảo sát: số lớn
s = new_slide("Khảo sát: 139 phản hồi, vượt yêu cầu 100", "Khảo sát Google Form")
for i, (v, l) in enumerate([("139", "phản hồi hợp lệ"), ("82,7%", "mẫu từ 18 đến 28 tuổi"), ("40,3%", "là học sinh, sinh viên"), ("9", "biểu đồ phân tích")]):
    big(s, 0.6 + i * 3.05, 1.95, 2.85, v, l, h=2.2)
text(s, 0.6, 4.5, 12.1, 0.5, "Nội dung khảo sát", 16, True, INK, anchor="top")
for i, t_ in enumerate(["Độ tuổi, nghề nghiệp", "Mục đích dùng gear", "Loại gear, ngân sách, kết nối", "Yếu tố quyết định, khó khăn khi mua", "Mức hứng thú với trợ lý AI"]):
    box(s, 0.6 + i * 2.45, 5.1, 2.3, 1.2); text(s, 0.7 + i * 2.45, 5.15, 2.1, 1.1, t_, 12.5, False, INK, align="center")

# 7. Độ tuổi
s = new_slide("Người mua chủ yếu từ 18 đến 22 tuổi (60,4%)", "Khảo sát: đối tượng")
chart(s, XL_CHART_TYPE.COLUMN_CLUSTERED, 0.6, 1.8, 7.6, 5.0, lab("AGE"), pct("AGE"), colors=[ACCENT_MID, ACCENT, ACCENT_MID, ACCENT_MID], label_size=13)
card(s, 8.6, 2.1, 4.15, 2.0, "18 đến 28 tuổi", "82,7% mẫu khảo sát", True)
card(s, 8.6, 4.4, 4.15, 2.0, "Quyết định", "Giao diện hiện đại, sáng, dùng được tốt trên điện thoại", False)

# 8. Nghề nghiệp
s = new_slide("Hơn một nửa là học sinh, sinh viên và nhân viên IT", "Khảo sát: đối tượng")
chart(s, XL_CHART_TYPE.BAR_CLUSTERED, 0.6, 1.8, 8.2, 5.0, lab("JOB"), pct("JOB"), colors=[ACCENT, ACCENT, ACCENT_MID, ACCENT_MID, ACCENT_MID, GRAY], label_size=12)
big(s, 9.2, 2.1, 3.55, "64,0%", "là học sinh, sinh viên hoặc\nnhân viên văn phòng, IT", h=2.4)
card(s, 9.2, 4.8, 3.55, 1.7, "Mục đích", "Chơi game 41,7%; vừa chơi vừa làm việc 25,9%", False, 15, 12)

# 9. Loại gear
s = new_slide("Bàn phím được quan tâm nhất (43,2%), tiếp theo là chuột", "Khảo sát: nhu cầu")
chart(s, XL_CHART_TYPE.COLUMN_CLUSTERED, 0.6, 1.8, 8.2, 5.0, lab("GEAR_FOCUS"), pct("GEAR_FOCUS"), colors=[ACCENT_MID, ACCENT, ACCENT_MID, GRAY, GRAY, GRAY], label_size=12)
card(s, 9.2, 2.1, 3.55, 2.1, "Chuột và bàn phím", "73,4% quan tâm một trong hai loại", True)
card(s, 9.2, 4.5, 3.55, 2.0, "Quyết định", "Danh mục chính: chuột, bàn phím, tai nghe, lót chuột", False)

# 10. Ngân sách
s = new_slide("Ngân sách phổ biến: dưới 1 triệu đồng (59,7%)", "Khảo sát: nhu cầu")
chart(s, XL_CHART_TYPE.COLUMN_CLUSTERED, 0.6, 1.8, 7.6, 5.0, lab("BUDGET"), pct("BUDGET"), colors=[ACCENT_MID, ACCENT, ACCENT_MID, GRAY], label_size=12)
big(s, 8.6, 2.1, 4.15, "43,9%", "chọn mức 500 nghìn đến 1 triệu đồng", h=2.2)
card(s, 8.6, 4.6, 4.15, 1.9, "Quyết định", "Bộ lọc giá có nút chọn nhanh, giá hiển thị dạng \"Từ ...\"", False)

# 11. Kết nối
s = new_slide("Không dây 2.4GHz và có dây gần ngang nhau", "Khảo sát: nhu cầu")
chart(s, XL_CHART_TYPE.PIE, 0.6, 1.7, 7.2, 5.2, lab("CONNECT"), pct("CONNECT"), colors=[ACCENT_MID, GRAY, LINE, ACCENT], label_size=12)
card(s, 8.3, 2.1, 4.45, 2.0, "67,6% dùng không dây", "Gồm 2.4GHz, Bluetooth và đa chế độ", True)
card(s, 8.3, 4.4, 4.45, 2.1, "Quyết định", "Biến thể có trường kết nối; lọc được theo loại không dây và có dây", False)

# 12. Yếu tố quyết định và khó khăn
s = new_slide("Thông số quyết định việc mua, và là điểm khó nhất", "Khảo sát: hành vi mua")
fs = [("F_SPEC", "Thông số"), ("F_BRAND", "Thương hiệu"), ("F_DESIGN", "Kiểu dáng"), ("F_WARRANTY", "Bảo hành"), ("F_PRICE", "Giá bán")]
text(s, 0.6, 1.75, 6, 0.4, "Yếu tố quyết định (% chấm 4 đến 5 sao)", 14, True, INK, anchor="top")
chart(s, XL_CHART_TYPE.BAR_CLUSTERED, 0.6, 2.15, 6.0, 4.6, [n for _, n in fs], [STATS[k]["pct_4_5"] for k, _ in fs], colors=[ACCENT, ACCENT_MID, ACCENT_MID, ACCENT_MID, ACCENT_MID], label_size=12)
text(s, 6.9, 1.75, 6, 0.4, "Khó khăn lớn nhất khi mua online (%)", 14, True, INK, anchor="top")
short = ["Khó biết thông số", "Khó so sánh phiên bản", "Lo hàng giả", "Giá cao, ít ưu đãi", "Bảo hành, đổi trả"]
vals = [26.6, 26.6, 25.2, 11.5, 10.1]
chart(s, XL_CHART_TYPE.BAR_CLUSTERED, 6.9, 2.15, 5.85, 4.6, short, vals, colors=[ACCENT, ACCENT, ACCENT_MID, GRAY, GRAY], label_size=12)

# 13. Khảo sát -> thiết kế
s = new_slide("Từ khảo sát đến quyết định thiết kế", "Khảo sát: kết luận")
table(s, 0.6, 1.9, 12.15, [5.2, 6.95], [
    ["Phát hiện", "Quyết định thiết kế"],
    ["Thông số quyết định (69,8% chấm 4 đến 5 sao)", "Bảng thông số rõ ràng ở trang chi tiết"],
    ["Khó so sánh phiên bản, màu (26,6%)", "Bộ chọn màu và phiên bản, cập nhật giá, tồn kho tức thì"],
    ["59,7% ngân sách tối đa 1 triệu đồng", "Bộ lọc khoảng giá có nút chọn nhanh"],
    ["67,6% hào hứng với trợ lý AI", "Trợ lý ZenBot gợi ý theo ngân sách và nhu cầu"],
    ["Lo hàng không chính hãng (25,2%)", "Nhấn mạnh bảo hành 12 tháng, đổi trả 7 ngày"]], row_h=0.78, size=14)

# 14. UI/UX: phong cách
s = new_slide("UI/UX: tối giản, sáng, một màu nhấn xanh dương", "Thiết kế UI/UX")
for i, (nm, hx, tx) in enumerate([("Nhấn", "0F5DE0", "FFFFFF"), ("Chữ chính", "1D1D1F", "FFFFFF"), ("Chữ phụ", "5F6368", "FFFFFF"), ("Nền thẻ", "F5F5F7", "1D1D1F"), ("Viền", "E1E3E8", "1D1D1F")]):
    x = 0.6 + i * 2.45
    sh = box(s, x, 1.95, 2.25, 1.6, rgb(hx), LINE if hx in ("F5F5F7", "E1E3E8") else None)
    text(s, x + 0.1, 2.35, 2.05, 0.4, nm, 14, True, rgb(tx)); text(s, x + 0.1, 2.8, 2.05, 0.4, "#" + hx, 12, False, rgb(tx))
card(s, 0.6, 3.9, 3.95, 2.75, "Chữ", "Be Vietnam Pro, hỗ trợ tiếng Việt\n\nĐộ tương phản chữ đạt chuẩn đọc", False)
card(s, 4.7, 3.9, 3.95, 2.75, "Thành phần", "Thẻ sản phẩm, bộ lọc cửa sổ, bộ chọn biến thể, tìm kiếm Ctrl K, thông báo", True)
card(s, 8.8, 3.9, 3.95, 2.75, "Thiết bị", "Máy tính và điện thoại, không có thanh cuộn ngang", False)

# 15. Màn hình
s = new_slide("19 màn hình cho khách hàng và quản trị", "Thiết kế UI/UX")
card(s, 0.6, 1.95, 3.95, 4.7, "Khách hàng", "Trang chủ\nDanh sách và bộ lọc\nChi tiết sản phẩm\nThương hiệu, Về ZenTech\nGiỏ hàng, thanh toán", True)
card(s, 4.7, 1.95, 3.95, 4.7, "Tài khoản", "Đăng nhập, đăng ký\nQuên và đặt lại mật khẩu\nThông tin, đổi mật khẩu\nSổ địa chỉ\nĐơn hàng của tôi", False)
card(s, 8.8, 1.95, 3.95, 4.7, "Quản trị", "Tổng quan\nQuản lý sản phẩm\nQuản lý đơn hàng\nQuản lý mã giảm giá\nBản mẫu Figma đầy đủ", False)

# 16. Chức năng
s = new_slide("Chức năng nổi bật đã chạy được", "Sản phẩm")
feats = [("Bộ lọc nhiều lựa chọn", "Nhiều loại, nhiều hãng, khoảng giá cùng lúc"), ("Bộ chọn biến thể", "Màu, phiên bản, giá, tồn kho tức thì"),
         ("Đặt hàng an toàn", "Giao dịch khóa dòng, không bán quá tồn kho"), ("Mã giảm giá", "Nút Áp dụng xem trước, hoàn lượt khi hủy"),
         ("Đánh giá sản phẩm", "Chỉ khách đã nhận hàng, mỗi sản phẩm một lần"), ("Trợ lý ZenBot", "Gợi ý gear theo ngân sách và nhu cầu")]
for i, (t_, b_) in enumerate(feats):
    card(s, 0.6 + (i % 3) * 4.1, 1.95 + (i // 3) * 2.45, 3.95, 2.2, t_, b_, i in (0, 3), 16, 13)

# 17. CSDL: số lớn
s = new_slide("Cơ sở dữ liệu: 26 bảng, chuẩn 3NF, thông số theo EAV", "Thiết kế cơ sở dữ liệu")
for i, (v, l) in enumerate([("26", "bảng"), ("29", "khóa ngoại"), ("330", "sản phẩm"), ("571", "biến thể"), ("1.848", "hình ảnh")]):
    big(s, 0.6 + i * 2.45, 1.95, 2.25, v, l, h=1.9)
card(s, 0.6, 4.2, 5.95, 2.45, "Mô hình EAV", "Thông số kỹ thuật lưu theo thuộc tính nên thêm loại gear mới không cần sửa bảng", True)
card(s, 6.8, 4.2, 5.95, 2.45, "Dữ liệu mẫu", "Lấy từ trang công khai của CellphoneS, 34 thương hiệu, ảnh lưu trên máy chủ", False)

# 18. Nhóm bảng
s = new_slide("Bảy nhóm bảng của cơ sở dữ liệu", "Thiết kế cơ sở dữ liệu")
table(s, 0.6, 1.9, 12.15, [3.2, 2.0, 6.95], [
    ["Nhóm", "Số bảng", "Bảng chính"],
    ["Tài khoản và phân quyền", "3", "roles, users, addresses"],
    ["Danh mục và thương hiệu", "2", "categories, brands"],
    ["Sản phẩm, biến thể, thông số", "9", "products, product_variants, product_attributes, variant_options..."],
    ["Giỏ hàng và đơn hàng", "6", "carts, orders, order_items, order_status_logs, order_coupons"],
    ["Đánh giá", "2", "reviews, review_images"],
    ["Trợ lý AI, khuyến mãi, bảo mật", "4", "ai_conversations, ai_messages, coupons, password_resets"]], row_h=0.66, size=14)

# 19. Đặt hàng an toàn
s = new_slide("Đặt hàng trong một giao dịch: lỗi ở bước nào cũng hoàn tác", "Thiết kế cơ sở dữ liệu")
steps = ["BEGIN", "Khóa dòng tồn kho\nFOR UPDATE", "Kiểm tra kho,\nmã giảm giá", "Tạo đơn,\ndòng hàng", "Trừ kho,\nghi log", "COMMIT"]
for i, t_ in enumerate(steps):
    x = 0.6 + i * 2.05
    sh = s.shapes.add_shape(MSO_SHAPE.CHEVRON if 0 < i < 5 else MSO_SHAPE.PENTAGON, Inches(x), Inches(2.4), Inches(2.0), Inches(1.5))
    sh.fill.solid(); sh.fill.fore_color.rgb = ACCENT if i in (0, 5) else ACCENT_SOFT; sh.line.fill.background(); sh.shadow.inherit = False
    text(s, x + 0.35, 2.55, 1.45, 1.2, t_, 12, True, rgb("FFFFFF") if i in (0, 5) else INK, align="center")
card(s, 0.6, 4.4, 5.95, 2.25, "Chống bán quá số lượng", "Hai người đặt cùng lúc: dòng tồn kho bị khóa, người sau phải chờ", True)
card(s, 6.8, 4.4, 5.95, 2.25, "Hoàn kho khi hủy", "Hủy hoặc trả hàng: cộng lại kho và trả lượt dùng mã giảm giá", False)

# 20. Kiểm thử
flow_areas = Counter(m.group(1) for l in (ROOT / "scratch/data/flow_result.txt").read_text(encoding="utf-8").splitlines()
                     if (m := re.match(r"PASS \[(.+?)\]", l)))
top = flow_areas.most_common(7)
s = new_slide("Kiểm thử tự động: 117 trên 117 ca đạt", "Kiểm thử")
for i, (v, l) in enumerate([("117", "tổng số ca"), ("57", "ca kiểm tra trang,\nbảo mật, quản trị"), ("60", "ca luồng nghiệp vụ")]):
    big(s, 0.6, 1.9 + i * 1.65, 3.4, v, l, h=1.5, accent=i == 0)
text(s, 4.4, 1.8, 8.3, 0.4, "Ca luồng nghiệp vụ theo nhóm chức năng", 14, True, INK, anchor="top")
chart(s, XL_CHART_TYPE.BAR_CLUSTERED, 4.4, 2.2, 8.35, 4.55, [a for a, _ in top], [n for _, n in top], fmt="0", label_size=12)

# 21. Bảo mật
s = new_slide("Bảo mật cơ bản được kiểm thử, không chỉ khai báo", "Kiểm thử")
sec = [("Chống CSRF", "Mọi biểu mẫu và yêu cầu AJAX đều có mã xác thực"), ("Cố định phiên", "Đổi mã phiên khi đăng nhập, đăng xuất, đổi mật khẩu"),
       ("Mật khẩu", "Băm bcrypt, token đặt lại chỉ lưu dạng băm, dùng một lần"), ("Truy vấn", "Câu lệnh có tham số (PDO), lọc dữ liệu đầu vào"),
       ("Giới hạn", "Khóa đăng nhập sai 5 lần, giới hạn lượt gọi ZenBot"), ("Phân quyền", "Khách không vào được khu quản trị")]
for i, (t_, b_) in enumerate(sec):
    card(s, 0.6 + (i % 3) * 4.1, 1.95 + (i // 3) * 2.45, 3.95, 2.2, t_, b_, False, 16, 13)

# 22. Kết luận
s = new_slide("Kết luận: hoàn thành đủ 4 yêu cầu Giai đoạn 1", "Kết luận")
table(s, 0.6, 1.9, 12.15, [4.2, 5.2, 2.75], [
    ["Yêu cầu của thầy", "Kết quả", "Trạng thái"],
    ["Quyết định đề tài", "ZenTech: website bán gaming gear", "Xong"],
    ["Google Form, ít nhất 100 phản hồi, có phân tích", "139 phản hồi, 9 biểu đồ, báo cáo phân tích", "Xong"],
    ["Thiết kế UI/UX", "Đặc tả, bản mẫu HTML, Figma, 19 màn hình", "Xong"],
    ["Thiết kế database", "26 bảng, ERD, từ điển dữ liệu, file SQL", "Xong"]], row_h=0.85, size=15)

# 23. Hướng phát triển
s = new_slide("Hướng phát triển tiếp theo", "Kết luận")
for i, (t_, b_) in enumerate([("Gửi email thật", "Nối SMTP cho quên mật khẩu và xác nhận đơn"), ("Thanh toán trực tuyến", "Cổng VNPay, MoMo thay cho COD và chuyển khoản"),
                              ("Kiểm duyệt đánh giá", "Trang admin duyệt và trả lời đánh giá"), ("Hiệu năng", "Bộ nhớ đệm, phân trang theo con trỏ cho 330 sản phẩm trở lên")]):
    card(s, 0.6 + (i % 2) * 6.2, 1.95 + (i // 2) * 2.45, 5.95, 2.2, t_, b_, i == 0, 18, 15)

# 24. Bàn giao
s = new_slide("Bàn giao và cảm ơn", "Bàn giao")
table(s, 0.6, 1.9, 12.15, [3.2, 8.95], [
    ["Sản phẩm", "Vị trí"],
    ["Mã nguồn", "github.com/huyfls/zentech-du-an-1"],
    ["Thiết kế giao diện", "Figma: ZenTech Gaming Gear Web Design"],
    ["Báo cáo Word, file SQL", "Thư mục NOP_BAI_GIAI_DOAN_1"],
    ["Dữ liệu khảo sát", "zentech_survey_139.xlsx và bộ mã câu hỏi"]], row_h=0.68, size=14)
text(s, 0.6, 5.55, 12.15, 0.9, "Xin cảm ơn thầy và các bạn đã lắng nghe", 28, True, ACCENT, align="center")
text(s, 0.6, 6.55, 12.15, 0.35, "Câu hỏi và thảo luận", 14, False, MUTED, align="center")

prs.save(OUT)
print(f"Đã lưu {OUT}  ({len(prs.slides)} slide)")
for w in warnings: print("CẢNH BÁO:", w)
if not warnings: print("Không có ô chữ nào tràn khung.")
