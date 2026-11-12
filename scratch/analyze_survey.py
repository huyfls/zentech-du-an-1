#!/usr/bin/env python3
"""
Phân tích khảo sát ZenTech từ zentech_survey_139.csv + zentech_survey_codebook.json.
Ra: biểu đồ PNG, bảng gán nhãn (CSV), scratch/data/survey_stats.json.
Chạy lại sau khi sửa codebook để mọi số liệu và biểu đồ được cập nhật.
"""
import csv, json, collections as C
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
D = ROOT / "docs" / "tuần 1 - dự án 1"
CHARTS = D / "bieu_do_khao_sat"; CHARTS.mkdir(exist_ok=True)
(ROOT / "scratch" / "data").mkdir(exist_ok=True)
rows = list(csv.DictReader(open(D / "zentech_survey_139.csv", encoding="utf-8-sig")))
cb = json.load(open(D / "zentech_survey_codebook.json", encoding="utf-8"))["questions"]
N = len(rows)

F = "/System/Library/Fonts/Supplemental/Arial.ttf"; FB = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
INK, MUTED, BAR, BAR2, GRID = (29, 29, 31), (110, 110, 115), (15, 93, 224), (176, 205, 250), (232, 232, 237)

def bar_chart(path, title, items, maxv=None, note=None, right=110):
    """items: [(nhãn, giá trị, chữ hiển thị)] vẽ thanh ngang."""
    W, pad, rowh = 1000, 36, 46
    head = 78
    H = head + rowh * len(items) + 56
    im = Image.new("RGB", (W, H), "white"); d = ImageDraw.Draw(im)
    d.text((pad, 24), title, font=ImageFont.truetype(FB, 24), fill=INK)
    lab_w = 360; x0 = pad + lab_w; x1 = W - pad - right
    maxv = maxv or max(v for _, v, _ in items)
    top = max(items, key=lambda i: i[1])[1]
    for i, (lab, v, txt) in enumerate(items):
        y = head + i * rowh
        d.text((pad, y + 10), lab, font=ImageFont.truetype(F, 18), fill=INK)
        d.rectangle([x0, y + 8, x1, y + 34], fill=(245, 245, 247))
        w = int((x1 - x0) * v / maxv)
        d.rectangle([x0, y + 8, x0 + w, y + 34], fill=BAR if v == top else BAR2)
        d.text((x1 + 12, y + 10), txt, font=ImageFont.truetype(FB, 18), fill=INK)
    if note:
        d.text((pad, H - 34), note, font=ImageFont.truetype(F, 15), fill=MUTED)
    im.save(path)

stats = {"n": N, "questions": {}}
for key, q in cb.items():
    col = [r[key].strip() for r in rows]
    if q["type"] == "single":
        cnt = C.Counter(col)
        items = [(q["labels"].get(k, f"Mã {k}"), cnt.get(k, 0)) for k in q["labels"]]
        stats["questions"][key] = {"title": q["title"], "type": "single",
                                   "rows": [{"label": l, "n": n, "pct": round(100 * n / N, 1)} for l, n in items]}
        bar_chart(CHARTS / f"{key.lower()}.png", q["title"],
                  [(l, n, f"{n}  ({100*n/N:.1f}%)") for l, n in items], note=f"n = {N} phản hồi")
    else:
        vals = [int(v) for v in col if v]
        mean = sum(vals) / len(vals); hi = sum(v >= 4 for v in vals) / len(vals) * 100
        stats["questions"][key] = {"title": q["title"], "type": "scale5", "mean": round(mean, 2), "pct_4_5": round(hi, 1),
                                   "dist": {str(k): sum(v == k for v in vals) for k in range(1, 6)}}

# biểu đồ gộp: mức quan trọng của 5 yếu tố
sc = [(k, v) for k, v in stats["questions"].items() if v["type"] == "scale5"]
sc.sort(key=lambda kv: -kv[1]["mean"])
bar_chart(CHARTS / "muc_do_quan_trong.png", "Mức quan trọng khi mua gear (điểm trung bình, thang 1-5)",
          [(v["title"].replace("Mức quan trọng: ", ""), v["mean"], f"{v['mean']:.2f}  ({v['pct_4_5']:.0f}% chấm 4-5)") for k, v in sc],
          maxv=5, right=250, note=f"n = {N} phản hồi; các chênh lệch giữa 5 yếu tố khá nhỏ")

# nhãn hóa toàn bộ bảng trả lời
labeled = D / "zentech_survey_139_labeled.csv"
with open(labeled, "w", encoding="utf-8-sig", newline="") as f:
    w = csv.writer(f); head = ["ID"] + [cb[k]["title"] for k in cb] + ["Góp ý thêm"]; w.writerow(head)
    for r in rows:
        w.writerow([r["ID"]] + [cb[k]["labels"].get(r[k].strip(), r[k]) if cb[k]["type"] == "single" else r[k] for k in cb] + [r["FEEDBACK"]])

# vài phép gộp dùng trong báo cáo
def pct(keys, key): return round(100 * sum(1 for r in rows if r[key].strip() in keys) / N, 1)
stats["derived"] = {
    "age_18_28": pct({"2", "3"}, "AGE"),
    "budget_le_1tr": pct({"1", "2"}, "BUDGET"),
    "wireless": pct({"2", "3", "4"}, "CONNECT"),
    "ai_interested": pct({"1", "2"}, "AI_FEATURE"),
    "pain_spec_or_compare": pct({"1", "2"}, "PAIN_POINT"),
    "gear_keyboard_mouse": pct({"1", "2"}, "GEAR_FOCUS"),
}
fb = C.Counter(r["FEEDBACK"].strip() for r in rows if r["FEEDBACK"].strip())
stats["feedback"] = {"filled": sum(fb.values()), "top": fb.most_common(5)}
json.dump(stats, open(ROOT / "scratch" / "data" / "survey_stats.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(json.dumps(stats["derived"], ensure_ascii=False)); print(len(list(CHARTS.glob('*.png'))), "biểu đồ")
