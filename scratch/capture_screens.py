#!/usr/bin/env python3
"""
Chụp ảnh các màn hình chính của website để đưa vào báo cáo.
Cần: pip install playwright (dùng Google Chrome có sẵn, không tải trình duyệt), website chạy ở localhost:8001.
Ra: docs/tuần 1 - dự án 1/hinh_anh_giao_dien/*.png
Không đặt đơn hàng thật: giỏ hàng và thanh toán chỉ được mở để chụp.
"""
from pathlib import Path
from playwright.sync_api import sync_playwright

B = "http://localhost:8001"
OUT = Path(__file__).resolve().parent.parent / "docs" / "tuần 1 - dự án 1" / "hinh_anh_giao_dien"
OUT.mkdir(exist_ok=True)
import os
PW = "Password@123"
ADMIN_PW = os.environ.get("ZENTECH_ADMIN_PW", PW)
ADMIN_EMAIL = os.environ.get("ZENTECH_ADMIN_EMAIL", "admin@zentech.vn")
SLUG = "chuot-gaming-khong-day-logitech-g304-lightspeed"

def shot(pg, name, full=False):
    pg.wait_for_timeout(1200)
    pg.screenshot(path=str(OUT / f"{name}.png"), full_page=full)
    print("  ", name)

def login(pg, email):
    pw = ADMIN_PW if email == ADMIN_EMAIL else PW
    pg.goto(B + "/dang-nhap"); pg.fill('input[name=email]', email); pg.fill('input[name=password]', pw)
    pg.click('button[type=submit]'); pg.wait_for_load_state("networkidle")

def logout(pg):
    pg.evaluate("document.querySelector('form[action=\"/dang-xuat\"], form[action=\"/auth/logout\"]').submit()")
    pg.wait_for_load_state("networkidle")

with sync_playwright() as p:
    br = p.chromium.launch(channel="chrome", headless=True)

    # ---- Khách chưa đăng nhập, máy tính
    ctx = br.new_context(viewport={"width": 1440, "height": 900}); pg = ctx.new_page()
    pg.goto(B + "/"); shot(pg, "01_trang_chu", full=True)
    pg.goto(B + "/san-pham"); shot(pg, "02_danh_sach_san_pham")
    pg.click("#open-filter"); pg.wait_for_timeout(400)
    pg.click('#filter-dialog label:has-text("Logitech")'); pg.click('#filter-dialog label:has-text("Razer")')
    pg.click('#filter-dialog label:has-text("Chuột Không Dây")'); pg.click('#filter-dialog label:has-text("500K - 1 triệu")')
    shot(pg, "03_bo_loc_dang_cua_so")
    pg.click('#filter-dialog button[type=submit]'); pg.wait_for_load_state("networkidle"); shot(pg, "04_ket_qua_loc_nhieu_gia_tri")
    pg.goto(B + "/san-pham/" + SLUG); pg.click('#color-options button:has-text("Đen")'); shot(pg, "05_chi_tiet_san_pham")
    pg.evaluate("window.scrollTo(0, 650)"); shot(pg, "06_chi_tiet_thong_so")
    pg.goto(B + "/san-pham/dareu-ek87-pro"); pg.click('#color-options button:has-text("Trắng")'); pg.click('#version-options button:has-text("Brown")')
    shot(pg, "07_chon_bien_the_to_hop_khong_co")
    pg.goto(B + "/"); pg.keyboard.press("Control+k"); pg.keyboard.type("razer", delay=60); pg.wait_for_timeout(1500); shot(pg, "08_tim_kiem_nhanh")
    pg.goto(B + "/thuong-hieu"); shot(pg, "09_thuong_hieu")
    pg.goto(B + "/ve-chung-toi"); shot(pg, "10_ve_zentech")
    pg.goto(B + "/dang-nhap"); shot(pg, "11_dang_nhap")
    pg.goto(B + "/dang-ky"); shot(pg, "12_dang_ky")
    pg.goto(B + "/khong-co-trang-nay"); shot(pg, "13_trang_404")

    # ---- Khách hàng đã đăng nhập
    login(pg, "nguyenvanan@gmail.com")
    pg.goto(B + "/san-pham/" + SLUG); pg.click('button:has-text("Thêm vào giỏ hàng")'); pg.wait_for_timeout(900); shot(pg, "14_them_vao_gio_thong_bao")
    pg.goto(B + "/gio-hang"); shot(pg, "15_gio_hang")
    pg.goto(B + "/thanh-toan"); shot(pg, "16_thanh_toan", full=True)
    pg.goto(B + "/don-hang"); shot(pg, "17_lich_su_don_hang")
    logout(pg); ctx.close()

    # ---- Quản trị
    ctx = br.new_context(viewport={"width": 1440, "height": 900}); pg = ctx.new_page()
    login(pg, ADMIN_EMAIL)
    pg.goto(B + "/admin"); shot(pg, "18_admin_tong_quan")
    pg.goto(B + "/admin/products"); shot(pg, "19_admin_san_pham")
    pg.goto(B + "/admin/products/create"); shot(pg, "20_admin_them_san_pham", full=True)
    pg.goto(B + "/admin/orders"); shot(pg, "21_admin_don_hang")
    ctx.close()

    # ---- Điện thoại
    ctx = br.new_context(viewport={"width": 390, "height": 844}, device_scale_factor=2, is_mobile=True, has_touch=True); pg = ctx.new_page()
    pg.goto(B + "/"); shot(pg, "22_mobile_trang_chu")
    pg.goto(B + "/san-pham"); pg.click("#open-filter"); pg.wait_for_timeout(500); shot(pg, "23_mobile_bo_loc")
    pg.goto(B + "/san-pham/" + SLUG); shot(pg, "24_mobile_chi_tiet")
    ctx.close(); br.close()
print("Xong:", len(list(OUT.glob("*.png"))), "ảnh")
