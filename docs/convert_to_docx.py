import hashlib
import os
import re
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

def set_cell_background(cell, fill_hex):
    """Set background color of a table cell"""
    shading_elm = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    cell._tc.get_or_add_tcPr().append(shading_elm)

def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
    """Set padding in twips (1/20 of a pt)"""
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
        node = OxmlElement(f'w:{m}')
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)

def set_table_borders(table, color="CCCCCC", sz="4", val="single"):
    """Set subtle borders on table"""
    tblPr = table._tbl.tblPr
    borders = parse_xml(
        f'<w:tblBorders {nsdecls("w")}>\n'
        f'  <w:top w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>\n'
        f'  <w:bottom w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>\n'
        f'  <w:left w:val="none"/>\n'
        f'  <w:right w:val="none"/>\n'
        f'  <w:insideH w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>\n'
        f'  <w:insideV w:val="none"/>\n'
        f'</w:tblBorders>'
    )
    tblPr.append(borders)

def add_formatted_text(paragraph, text):
    """Parse inline markdown: **bold**, *italic*, `code`, math"""
    # Regex to capture bold, code, italic
    tokens = re.split(r'(\*\*.*?\*\*|`.*?`|\*.*?\*)', text)
    for token in tokens:
        if not token:
            continue
        if token.startswith('**') and token.endswith('**') and len(token) >= 4:
            run = paragraph.add_run(token[2:-2])
            run.bold = True
        elif token.startswith('`') and token.endswith('`') and len(token) >= 2:
            run = paragraph.add_run(token[1:-1])
            run.font.name = 'Consolas'
            run.font.size = Pt(9.5)
            run.font.color.rgb = RGBColor(15, 93, 224)  # Xanh hành động
        elif token.startswith('*') and token.endswith('*') and len(token) >= 2:
            run = paragraph.add_run(token[1:-1])
            run.italic = True
        else:
            paragraph.add_run(token)

def add_fitted_picture(doc, path, max_w=6.4, max_h=8.4):
    """Chèn ảnh căn giữa, vừa trong khổ giấy (giữ tỷ lệ)."""
    from PIL import Image
    w, h = Image.open(path).size
    scale = min(max_w / (w / 96), max_h / (h / 96), 1e9)
    width = min(max_w, max_h * w / h)
    doc.add_picture(path, width=Inches(width))
    doc.paragraphs[-1].alignment = WD_ALIGN_PARAGRAPH.CENTER


def md_to_docx(md_path, docx_path, doc_title=None):
    doc = Document()

    # Set page margins (1 inch)
    sections = doc.sections
    for section in sections:
        section.top_margin = Inches(1)
        section.bottom_margin = Inches(1)
        section.left_margin = Inches(1)
        section.right_margin = Inches(1)

    # Base styling
    normal_style = doc.styles['Normal']
    normal_style.font.name = 'Segoe UI'
    normal_style.font.size = Pt(10.5)
    normal_style.font.color.rgb = RGBColor(30, 41, 59)  # Slate-800

    with open(md_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    in_code_block = False
    code_lines = []
    code_lang = ""

    in_table = False
    table_rows = []

    in_quote = False
    quote_lines = []

    def flush_table():
        nonlocal in_table, table_rows
        if not table_rows:
            in_table = False
            return
        
        # Clean rows
        cleaned = []
        for r in table_rows:
            # Split by | and strip
            parts = [c.strip() for c in r.strip().strip('|').split('|')]
            # Skip separator rows like |---|---|
            if all(re.match(r'^:?-+:?$', p) for p in parts if p):
                continue
            if any(parts):
                cleaned.append(parts)
        
        if cleaned:
            col_count = max(len(row) for row in cleaned)
            # Normalize row lengths
            for row in cleaned:
                while len(row) < col_count:
                    row.append("")

            table = doc.add_table(rows=len(cleaned), cols=col_count)
            table.alignment = WD_TABLE_ALIGNMENT.CENTER
            set_table_borders(table, color="CBD5E1")

            for r_idx, row in enumerate(cleaned):
                for c_idx, cell_text in enumerate(row):
                    cell = table.cell(r_idx, c_idx)
                    set_cell_margins(cell, top=120, bottom=120, left=150, right=150)
                    p = cell.paragraphs[0]
                    p.paragraph_format.space_before = Pt(2)
                    p.paragraph_format.space_after = Pt(2)
                    p.paragraph_format.line_spacing = 1.15

                    if r_idx == 0:
                        set_cell_background(cell, "1D1D1F")  # Đầu bảng màu mực
                        run = p.add_run(cell_text)
                        run.bold = True
                        run.font.color.rgb = RGBColor(255, 255, 255)
                        run.font.size = Pt(9.5)
                    else:
                        if r_idx % 2 == 1:
                            set_cell_background(cell, "F8FAFC")  # Alternating row
                        else:
                            set_cell_background(cell, "FFFFFF")
                        add_formatted_text(p, cell_text)
                        for run in p.runs:
                            run.font.size = Pt(9.5)
            
            # Add spacer
            p_space = doc.add_paragraph()
            p_space.paragraph_format.space_before = Pt(0)
            p_space.paragraph_format.space_after = Pt(4)

        table_rows = []
        in_table = False

    def flush_code():
        nonlocal in_code_block, code_lines, code_lang
        if code_lines and code_lang == "mermaid":
            # Sơ đồ Mermaid: dùng ảnh đã vẽ bởi scratch/render_mermaid.py (tên ảnh là mã băm nội dung)
            key = hashlib.md5("".join(code_lines).rstrip().encode()).hexdigest()[:10]
            img_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "hinh_ve", key + ".png")
            if os.path.exists(img_path):
                add_fitted_picture(doc, img_path)
                code_lines = []; in_code_block = False; code_lang = ""
                return
        if code_lines:
            code_text = "".join(code_lines).rstrip()
            tbl = doc.add_table(rows=1, cols=1)
            tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
            set_table_borders(tbl, color="E2E8F0", sz="6")
            cell = tbl.cell(0, 0)
            set_cell_background(cell, "F1F5F9")  # Light gray
            set_cell_margins(cell, top=140, bottom=140, left=180, right=180)
            p = cell.paragraphs[0]
            p.paragraph_format.space_before = Pt(2)
            p.paragraph_format.space_after = Pt(2)
            p.paragraph_format.line_spacing = 1.15
            run = p.add_run(code_text)
            run.font.name = 'Consolas'
            run.font.size = Pt(9)
            run.font.color.rgb = RGBColor(15, 23, 42)

            p_sp = doc.add_paragraph()
            p_sp.paragraph_format.space_after = Pt(4)

        code_lines = []
        in_code_block = False
        code_lang = ""

    def flush_quote():
        nonlocal in_quote, quote_lines
        if quote_lines:
            tbl = doc.add_table(rows=1, cols=1)
            tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
            set_table_borders(tbl, color="0F5DE0", sz="16")  # Viền xanh
            cell = tbl.cell(0, 0)
            set_cell_background(cell, "EEF4FF")  # Nền xanh nhạt
            set_cell_margins(cell, top=120, bottom=120, left=180, right=180)
            p = cell.paragraphs[0]
            p.paragraph_format.space_before = Pt(2)
            p.paragraph_format.space_after = Pt(2)
            quote_text = " ".join([l.strip() for l in quote_lines])
            add_formatted_text(p, quote_text)
            for r in p.runs:
                r.italic = True
                r.font.size = Pt(9.5)
            
            p_sp = doc.add_paragraph()
            p_sp.paragraph_format.space_after = Pt(4)

        quote_lines = []
        in_quote = False

    for line in lines:
        raw_line = line.rstrip('\r\n')

        # Code block fence
        if raw_line.startswith('```'):
            if in_code_block:
                flush_code()
            else:
                if in_table:
                    flush_table()
                if in_quote:
                    flush_quote()
                in_code_block = True
                code_lang = raw_line[3:].strip()
            continue

        if in_code_block:
            code_lines.append(line)
            continue

        # Table row
        if raw_line.startswith('|') and raw_line.endswith('|'):
            if in_quote:
                flush_quote()
            in_table = True
            table_rows.append(raw_line)
            continue
        elif in_table:
            flush_table()

        # Blockquote / Callout
        if raw_line.startswith('>'):
            content = raw_line.lstrip('> ').strip()
            in_quote = True
            quote_lines.append(content)
            continue
        elif in_quote:
            flush_quote()

        # Blank line
        if not raw_line.strip():
            continue

        # Ảnh: ![mô tả](đường dẫn tương đối so với file md)
        img = re.match(r'^!\[(.*?)\]\((.*?)\)\s*$', raw_line.strip())
        if img:
            img_path = os.path.join(os.path.dirname(md_path), img.group(2))
            if os.path.exists(img_path):
                add_fitted_picture(doc, img_path)
            else:
                doc.add_paragraph(f"[Thiếu ảnh: {img.group(2)}]")
            continue

        # Headings
        if raw_line.startswith('# '):
            h = doc.add_heading(raw_line[2:].strip(), level=1)
            h.paragraph_format.space_before = Pt(14)
            h.paragraph_format.space_after = Pt(6)
            for r in h.runs:
                r.font.name = 'Segoe UI'
                r.font.size = Pt(18)
                r.font.color.rgb = RGBColor(15, 23, 42)  # Slate-900
                r.bold = True
        elif raw_line.startswith('## '):
            h = doc.add_heading(raw_line[3:].strip(), level=2)
            h.paragraph_format.space_before = Pt(12)
            h.paragraph_format.space_after = Pt(4)
            for r in h.runs:
                r.font.name = 'Segoe UI'
                r.font.size = Pt(14)
                r.font.color.rgb = RGBColor(15, 93, 224)  # Xanh hành động
                r.bold = True
        elif raw_line.startswith('### '):
            h = doc.add_heading(raw_line[4:].strip(), level=3)
            h.paragraph_format.space_before = Pt(10)
            h.paragraph_format.space_after = Pt(3)
            for r in h.runs:
                r.font.name = 'Segoe UI'
                r.font.size = Pt(12)
                r.font.color.rgb = RGBColor(29, 29, 31)  # Mực
                r.bold = True
        elif raw_line.startswith('#### '):
            h = doc.add_heading(raw_line[5:].strip(), level=4)
            h.paragraph_format.space_before = Pt(8)
            h.paragraph_format.space_after = Pt(2)
            for r in h.runs:
                r.font.size = Pt(11)
                r.bold = True

        # Horizontal Rule
        elif re.match(r'^-{3,}$', raw_line.strip()) or re.match(r'^\*{3,}$', raw_line.strip()):
            p = doc.add_paragraph()
            p.paragraph_format.space_before = Pt(6)
            p.paragraph_format.space_after = Pt(6)
            run = p.add_run("―" * 55)
            run.font.color.rgb = RGBColor(203, 213, 225)

        # Bullet List
        elif re.match(r'^\s*[-*+]\s+', raw_line):
            bullet_text = re.sub(r'^\s*[-*+]\s+', '', raw_line)
            p = doc.add_paragraph(style='List Bullet')
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(2)
            p.paragraph_format.line_spacing = 1.15
            add_formatted_text(p, bullet_text)

        # Numbered List
        elif re.match(r'^\s*\d+\.\s+', raw_line):
            num_text = re.sub(r'^\s*\d+\.\s+', '', raw_line)
            p = doc.add_paragraph(style='List Number')
            p.paragraph_format.space_before = Pt(1)
            p.paragraph_format.space_after = Pt(2)
            p.paragraph_format.line_spacing = 1.15
            add_formatted_text(p, num_text)

        # Normal Paragraph
        else:
            p = doc.add_paragraph()
            p.paragraph_format.space_before = Pt(2)
            p.paragraph_format.space_after = Pt(3)
            p.paragraph_format.line_spacing = 1.2
            add_formatted_text(p, raw_line)

    # Flush any remaining buffers
    if in_code_block:
        flush_code()
    if in_table:
        flush_table()
    if in_quote:
        flush_quote()

    doc.save(docx_path)
    print(f"✓ Converted: {os.path.basename(md_path)} -> {os.path.basename(docx_path)}")

def main():
    docs_dir = os.path.dirname(os.path.abspath(__file__))
    week1 = os.path.join(docs_dir, "tuần 1 - dự án 1")
    # (file md, tên file Word trong thư mục "tuần 1 - dự án 1"). File md trong docs/ là nguồn; Word chỉ nằm ở thư mục nộp.
    jobs = [
        ("ZenTech_Quyet_Dinh_De_Tai.md",   "01_Quyet_Dinh_De_Tai_ZenTech.docx"),
        ("ZenTech_UIUX_Specification.md",  "02_Dac_Ta_Thiet_Ke_UIUX_ZenTech.docx"),
        ("ZenTech_Database_Design.md",     "04_Thiet_Ke_Kien_Truc_Co_So_Du_Lieu.docx"),
        ("ZenTech_DataDictionary.md",      "05_Tu_Dien_Du_Lieu_Data_Dictionary.docx"),
        ("ZenTech_ERD_Mermaid.md",         "06_So_Do_Quan_He_Thuc_The_ERD.docx"),
        ("ZenTech_Phan_Tich_Khao_Sat.md",  "08_Phan_Tich_Khao_Sat_ZenTech.docx"),
        ("ZenTech_Bao_Cao_Kiem_Thu.md",    "09_Bao_Cao_Kiem_Thu_He_Thong_ZenTech.docx"),
        ("ZenTech_SQL_PHP_PDO.md",         "10_SQL_PHP_PDO_ZenTech.docx"),
    ]
    for md, out_week in jobs:
        md_file = os.path.join(docs_dir, md)
        if os.path.exists(md_file):
            md_to_docx(md_file, os.path.join(week1, out_week))

    # Báo cáo tổng hợp: đề tài, khảo sát, CSDL, ERD, từ điển dữ liệu, UI/UX, kiểm thử, mã nguồn truy vấn
    combined_md = os.path.join(docs_dir, "_temp_combined.md")
    with open(combined_md, "w", encoding="utf-8") as out_f:
        out_f.write("# Báo Cáo Môn Học Dự Án 1, Giai Đoạn 1\n\n")
        out_f.write("## Đề tài: Website kinh doanh Gaming Gear và phụ kiện công nghệ, ZenTech\n\n")
        out_f.write("> **Sinh viên thực hiện:** ZenTech Dev Team  \n")
        out_f.write("> **Kiến trúc:** PHP thuần (MVC), MySQL 8.0+ (InnoDB), Tailwind CSS, Vanilla JS, REST API trợ lý AI  \n\n---\n\n")
        for fname in ["ZenTech_Quyet_Dinh_De_Tai.md", "ZenTech_Phan_Tich_Khao_Sat.md", "ZenTech_UIUX_Specification.md",
                      "ZenTech_Database_Design.md", "ZenTech_ERD_Mermaid.md", "ZenTech_DataDictionary.md",
                      "ZenTech_SQL_PHP_PDO.md", "ZenTech_Bao_Cao_Kiem_Thu.md"]:
            fpath = os.path.join(docs_dir, fname)
            if os.path.exists(fpath):
                with open(fpath, "r", encoding="utf-8") as inf:
                    out_f.write(inf.read() + "\n\n---\n\n")
    md_to_docx(combined_md, os.path.join(week1, "00_BAO_CAO_TONG_HOP_GIAI_DOAN_1_ZENTECH.docx"))
    os.remove(combined_md)
    print("Đã tạo xong các file Word.")


if __name__ == '__main__':
    main()
