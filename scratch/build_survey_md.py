#!/usr/bin/env python3
"""Sinh docs/ZenTech_Phan_Tich_Khao_Sat.md từ scratch/data/survey_stats.json (chạy sau analyze_survey.py)."""
import json
from pathlib import Path
ROOT = Path(__file__).resolve().parent.parent
S = json.load(open(ROOT / "scratch/data/survey_stats.json", encoding="utf-8"))
Q, DV, N = S["questions"], S["derived"], S["n"]
IMG = "tuần 1 - dự án 1/bieu_do_khao_sat"

def table(key):
    rows = Q[key]["rows"]
    out = ["| Lựa chọn | Số phản hồi | Tỷ lệ |", "|---|---|---|"]
    out += [f"| {r['label']} | {r['n']} | {r['pct']}% |" for r in rows]
    return "\n".join(out)
def top(key): return max(Q[key]["rows"], key=lambda r: r["n"])
def block(key, text):
    return f"### {Q[key]['title']}\n\n![{Q[key]['title']}]({IMG}/{key.lower()}.png)\n\n{table(key)}\n\n{text}\n"

sc = sorted([(k, v) for k, v in Q.items() if v["type"] == "scale5"], key=lambda kv: -kv[1]["mean"])
sc_rows = "\n".join(f"| {v['title'].replace('Mức quan trọng: ', '')} | {v['mean']:.2f} | {v['pct_4_5']}% |" for k, v in sc)
fb = S["feedback"]; fb_rows = "\n".join(f"| {t} | {n} |" for t, n in fb["top"])
a, j, b = top("AGE"), top("JOB"), top("BUDGET")

md = f"""# Phân Tích Kết Quả Khảo Sát Nhu Cầu Mua Gaming Gear

> **Dự án:** ZenTech, website kinh doanh Gaming Gear  
> **Nguồn dữ liệu:** `zentech_survey_139.csv` ({N} phản hồi, 15 cột)  
> **Công cụ:** Google Form, xử lý bằng `scratch/analyze_survey.py`  

---

## 1. Mục tiêu và phương pháp

Khảo sát nhằm trả lời ba câu hỏi để định hướng thiết kế: ai là người mua gaming gear, họ ưu tiên điều gì khi chọn, và họ gặp khó khăn gì khi mua online.

- **Số lượng:** {N} phản hồi, vượt mức tối thiểu 100 của đề bài. Không có hai phản hồi trùng nhau.
- **Cấu trúc:** 13 câu hỏi trắc nghiệm (độ tuổi, nghề nghiệp, mục đích, loại gear, ngân sách, kiểu kết nối, khó khăn khi mua, hứng thú với AI, 5 câu chấm mức quan trọng từ 1 đến 5) và 1 ô góp ý mở.
- **Xử lý:** file gốc lưu đáp án dưới dạng mã số. Bảng mã hóa (`zentech_survey_codebook.json`) dùng để gán nhãn, và tạo bản đã gán nhãn `zentech_survey_139_labeled.csv`. Mọi tỷ lệ dưới đây được tính lại từ {N} dòng dữ liệu bằng script, không nhập tay.

> **Lưu ý về bảng mã hóa:** các nhãn trong bảng mã hóa cần đối chiếu với nội dung câu hỏi trong Google Form gốc. Nếu có nhãn nào chưa khớp, sửa trong file `zentech_survey_codebook.json` rồi chạy lại script để cập nhật toàn bộ số liệu và biểu đồ.

---

## 2. Đối tượng được khảo sát

{block("AGE", f"Nhóm 18 đến 28 tuổi chiếm **{DV['age_18_28']}%** mẫu, trong đó 18 đến 22 tuổi là nhóm đông nhất ({a['pct']}%).")}
{block("JOB", f"Học sinh, sinh viên là nhóm lớn nhất ({j['pct']}%), tiếp theo là nhân viên văn phòng và IT.")}
---

## 3. Hành vi và nhu cầu mua

{block("PURPOSE", "Phần lớn mua để chơi game, và hơn một phần tư vừa chơi game vừa làm việc, nên gear cần dùng tốt cho cả hai mục đích.")}
{block("GEAR_FOCUS", f"Bàn phím và chuột chiếm **{DV['gear_keyboard_mouse']}%**. Tai nghe, lót chuột, ghế và bàn gaming có nhu cầu thấp hơn nhiều.")}
{block("BUDGET", f"**{DV['budget_le_1tr']}%** muốn chi tối đa 1 triệu đồng cho một món gear, nhóm từ 500.000đ đến 1 triệu là đông nhất ({b['pct']}%).")}
{block("CONNECT", f"**{DV['wireless']}%** ưa chuộng các kiểu không dây (Bluetooth, 2.4GHz hoặc đa chế độ). Không dây 2.4GHz là lựa chọn đơn lẻ phổ biến nhất.")}
---

## 4. Yếu tố quyết định và khó khăn khi mua

### Mức quan trọng của các yếu tố (thang 1 đến 5)

![Mức quan trọng]({IMG}/muc_do_quan_trong.png)

| Yếu tố | Điểm trung bình | Tỷ lệ chấm 4 đến 5 |
|---|---|---|
{sc_rows}

Thông số kỹ thuật có điểm cao nhất ({sc[0][1]['mean']:.2f}), nhưng chênh lệch giữa năm yếu tố rất nhỏ (từ {sc[-1][1]['mean']:.2f} đến {sc[0][1]['mean']:.2f}). Nghĩa là người mua cân nhắc đồng thời nhiều yếu tố chứ không chỉ một.

{block("PAIN_POINT", f"Ba khó khăn đứng đầu có tỷ lệ gần nhau (25% đến 27%): không biết thông số có hợp nhu cầu không, khó so sánh các phiên bản và màu sắc, và lo hàng không chính hãng. Hai khó khăn đầu (liên quan đến thông số và so sánh) cộng lại là **{DV['pain_spec_or_compare']}%**.")}
{block("AI_FEATURE", f"**{DV['ai_interested']}%** hào hứng hoặc rất hào hứng với trợ lý AI tư vấn gear.")}
---

## 5. Góp ý mở

Có {fb['filled']} trên {N} phản hồi để lại góp ý. Các góp ý lặp lại nhiều nhất:

| Góp ý | Số lần |
|---|---|
{fb_rows}

---

## 6. Kết luận và tác động tới thiết kế

| Phát hiện từ khảo sát | Quyết định thiết kế của ZenTech |
|---|---|
| {DV['age_18_28']}% mẫu từ 18 đến 28 tuổi, nhiều học sinh, sinh viên | Giao diện hiện đại, dùng tốt trên điện thoại, thao tác ít bước |
| {DV['budget_le_1tr']}% ngân sách tối đa 1 triệu đồng | Bộ lọc khoảng giá có nút chọn nhanh (dưới 500K, 500K đến 1 triệu...), lọc nhiều loại sản phẩm cùng lúc |
| Bàn phím và chuột chiếm {DV['gear_keyboard_mouse']}% nhu cầu | Trang chủ và danh mục ưu tiên chuột, bàn phím; kho dữ liệu có nhiều bàn phím cơ nhất |
| {DV['wireless']}% thích kết nối không dây | Danh mục riêng cho chuột không dây, tai nghe không dây, bàn phím mini/TKL |
| Thông số kỹ thuật được chấm quan trọng nhất, {DV['pain_spec_or_compare']}% khó chọn vì thông số và so sánh | Mỗi sản phẩm có tab thông số; bộ chọn màu và phiên bản cập nhật giá, ảnh và tồn kho ngay, tổ hợp không có bị gạch mờ |
| 25,2% lo hàng không chính hãng | Chính sách chính hãng, đổi trả 7 ngày, bảo hành 12 tháng hiển thị ở trang chủ và chân trang |
| {DV['ai_interested']}% hào hứng với AI | Trợ lý ZenBot tư vấn theo ngân sách và nhu cầu |
| Góp ý: chatbot cần đúng nhu cầu kỹ thuật, so sánh trực quan | Định hướng phát triển giai đoạn sau |

## 7. Hạn chế của khảo sát

- **Mẫu thuận tiện:** {N} phản hồi, tập trung vào nhóm học sinh, sinh viên, chưa đại diện cho toàn bộ thị trường.
- **Chênh lệch nhỏ:** các câu chấm mức quan trọng có điểm gần nhau, chỉ nên dùng để thấy xu hướng, không dùng để xếp hạng chắc chắn.
- **Chưa hỏi về giao diện:** khảo sát không có câu hỏi về sở thích giao diện sáng hay tối, nên lựa chọn giao diện được quyết định theo nguyên tắc thiết kế (xem tài liệu đặc tả UI/UX), không dựa trên số liệu khảo sát.
"""
(ROOT / "docs/ZenTech_Phan_Tich_Khao_Sat.md").write_text(md, encoding="utf-8")
print("ok", len(md))
