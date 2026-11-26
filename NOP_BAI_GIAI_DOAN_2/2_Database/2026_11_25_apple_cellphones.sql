-- Sản phẩm Apple lấy từ CellphoneS (không gồm phụ kiện). Sinh bởi scratch/cellphones/build.py
SET NAMES utf8mb4;
START TRANSACTION;
DELETE p FROM products p WHERE p.id IN (SELECT product_id FROM (SELECT DISTINCT product_id FROM product_variants WHERE sku LIKE 'CPS-%') t);
INSERT INTO categories (name, slug, is_active) SELECT 'Điện Thoại', 'dien-thoai', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'dien-thoai');
INSERT INTO categories (name, slug, is_active) SELECT 'Máy Tính Bảng', 'may-tinh-bang', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'may-tinh-bang');
INSERT INTO categories (name, slug, is_active) SELECT 'Laptop & Máy Mac', 'laptop-may-mac', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'laptop-may-mac');
INSERT INTO categories (name, slug, is_active) SELECT 'Đồng Hồ Thông Minh', 'dong-ho-thong-minh', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'dong-ho-thong-minh');
SET @brand = (SELECT id FROM brands WHERE slug = 'apple');
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 'apple-airpods-5-2026-sac-co-day-mkfw4', 'CPS-apple-airpods-5-2026-sac-co-day-mkfw4', 'Chống ồn chủ động ANC mạnh hơn đến 1,5 lần. · Âm Thanh Thích Ứng.Tự cân bằng ANC và Xuyên Âm theo môi trường. · Siri AI & Dịch Trực Tiếp. Trợ lý rảnh tay, hỗ trợ giao tiếp đa ngôn ngữ.', 'Chống ồn chủ động ANC mạnh hơn đến 1,5 lần.
Âm Thanh Thích Ứng.Tự cân bằng ANC và Xuyên Âm theo môi trường.
Siri AI & Dịch Trực Tiếp. Trợ lý rảnh tay, hỗ trợ giao tiếp đa ngôn ngữ.
Bền bỉ chuẩn IP57. Kháng bụi, mồ hôi và nước tốt hơn.
Pin đến 20 giờ với hộp sạc, 4 giờ khi bật ANC, sạc nhanh 5 phút ≈ 1 giờ, USB-C

Chip: Chip tai nghe H2
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/a76897e5913aa90f.jpg', 3690000, 1, 1, 990);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141716', 'Trắng', 'Tiêu chuẩn', 3790000, 3690000, 20, '/uploads/products/apple/a76897e5913aa90f.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/320fbdcb3d9d35e5.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dac1265cc42c9362.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/20492dbdf7857581.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a5ee02f47ac96235.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6c668b36538a0631.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/543d3739f0efd3e0.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0d0b99837e39c49b.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/626fa470e5c8847a.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/87cf4e876513346b.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/71e07230b8944062.jpg', 'Apple AirPods 5 2026 Sạc Có Dây (MKFW4)', 9);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods 4', 'apple-airpods-4', 'CPS-apple-airpods-4', 'AirPods 4 được thiết kế mới với sự thoải mái vượt trội, thân ngắn hơn và các nút điều khiển tiện lợi, giúp bạn dễ dàng quản lý nhạc và cuộc gọi. · Chế độ Âm Thanh Không Gian Cá Nhân Hóa cùng tính năng theo dõi chuyển động đầu mang đến trải nghiệm âm thanh sống động, như trong rạp hát. · Chip H2 của Apple cải tiến chất lượng âm thanh và cuộc gọi, giúp tách biệt giọng nói trong môi trường ồn ào.', 'AirPods 4 được thiết kế mới với sự thoải mái vượt trội, thân ngắn hơn và các nút điều khiển tiện lợi, giúp bạn dễ dàng quản lý nhạc và cuộc gọi.
Chế độ Âm Thanh Không Gian Cá Nhân Hóa cùng tính năng theo dõi chuyển động đầu mang đến trải nghiệm âm thanh sống động, như trong rạp hát.
Chip H2 của Apple cải tiến chất lượng âm thanh và cuộc gọi, giúp tách biệt giọng nói trong môi trường ồn ào.
Với thời gian nghe lên đến 5 giờ và hộp sạc nhỏ gọn hỗ trợ sạc USB-C, AirPods 4 còn có khả năng chống bụi, mồ hôi và nước đạt chuẩn IP54, lý tưởng cho mọi hoạt động.

Chip: Chip tai nghe H2
Kích thước: Tai nghe: 30.2 x 18.3 x 18.1 mm, Hộp sạc: 46.2 x 50.1 x 21.2 mm
Trọng lượng: Tai nghe: 4.3g, Hộp sạc: 32.3g
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/071313af178e47f9.png', 3090000, 1, 1, 970);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90173', 'Trắng', 'Tiêu chuẩn', 3790000, 3090000, 20, '/uploads/products/apple/071313af178e47f9.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/54bee435b850ce21.png', 'Apple AirPods 4', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6718501d3f67129d.png', 'Apple AirPods 4', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a8bd1a8dcda40516.png', 'Apple AirPods 4', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0a593fae89391a7c.png', 'Apple AirPods 4', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/64984a98a7a35b06.png', 'Apple AirPods 4', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/21583eac268dc855.png', 'Apple AirPods 4', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0cd345bff3054bdd.png', 'Apple AirPods 4', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5d67c6f47c4200d9.jpg', 'Apple AirPods 4', 7);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods Pro 3 2025 Type-C', 'apple-airpods-pro-3-2025-type-c', 'CPS-apple-airpods-pro-3-2025-type-c', 'Khử tiếng ồn hiệu quả gấp 2 lần AirPods Pro 2 và 4 lần so với AirPods Pro. · Cảm biến nhịp tim hỗ trợ theo dõi sức khỏe khi tập luyện. · Khả năng chống nước, chống mồ hôi và chống bụi đạt chuẩn IP57.', 'Khử tiếng ồn hiệu quả gấp 2 lần AirPods Pro 2 và 4 lần so với AirPods Pro.
Cảm biến nhịp tim hỗ trợ theo dõi sức khỏe khi tập luyện.
Khả năng chống nước, chống mồ hôi và chống bụi đạt chuẩn IP57.
Hoạt động bền bỉ lên đến 8 giờ với chế độ khử ồn chủ động.
Phạm vi tìm kiếm chính xác hơn, tăng 1,5 lần so với trước.

Chip: Chip Apple H2
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/8f89c32ff591e854.png', 5890000, 1, 1, 960);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112591', 'Trắng', 'Tiêu chuẩn', 6790000, 5890000, 20, '/uploads/products/apple/8f89c32ff591e854.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9b24cb7e5e1d3e9d.png', 'Apple AirPods Pro 3 2025 Type-C', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e6484bdd39a59c32.png', 'Apple AirPods Pro 3 2025 Type-C', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6995b54dd068b206.png', 'Apple AirPods Pro 3 2025 Type-C', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5f8e7df875bfd7b4.png', 'Apple AirPods Pro 3 2025 Type-C', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/85278b46246efa9d.png', 'Apple AirPods Pro 3 2025 Type-C', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2ba612ec25577989.png', 'Apple AirPods Pro 3 2025 Type-C', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4930e10bfb258bef.png', 'Apple AirPods Pro 3 2025 Type-C', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5fa27cdffe10c963.png', 'Apple AirPods Pro 3 2025 Type-C', 7);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 'apple-airpods-5-2026-sac-khong-day-mkft4', 'CPS-apple-airpods-5-2026-sac-khong-day-mkft4', 'Chống ồn chủ động ANC mạnh hơn đến 1,5 lần. · Âm Thanh Thích Ứng. Tự cân bằng ANC và Xuyên Âm theo môi trường. · Pin đến 22 giờ với hộp sạc. Lên đến 5 giờ nghe khi bật ANC.', 'Chống ồn chủ động ANC mạnh hơn đến 1,5 lần.
Âm Thanh Thích Ứng. Tự cân bằng ANC và Xuyên Âm theo môi trường.
Pin đến 22 giờ với hộp sạc. Lên đến 5 giờ nghe khi bật ANC.
Sạc không dây linh hoạt, hỗ trợ Qi, bộ sạc Apple Watch và USB-C.
Kháng bụi, mồ hôi, nước IP57. Phù hợp sử dụng và tập luyện hằng ngày.

Chip: Chip tai nghe H2
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/78266a5e6bfc6f85.jpg', 4190000, 0, 1, 950);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141713', 'Trắng', 'Tiêu chuẩn', 4290000, 4190000, 20, '/uploads/products/apple/78266a5e6bfc6f85.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/48dfd214aead7c4b.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1ba3f6719a496cda.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/654553c02761f5e9.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dab69a5005bef7f8.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/22b66a420b56843a.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3e31f29aa06bd822.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8d4f21d98e55cfdb.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6fd314ec985bf836.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c513705d55114691.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0ff07c6f46e496d0.jpg', 'Apple AirPods 5 2026 Sạc Không Dây (MKFT4)', 9);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods 4 chống ồn chủ động', 'apple-airpods-4-chong-on-chu-dong', 'CPS-apple-airpods-4-chong-on-chu-dong', 'AirPods 4 được thiết kế mới với sự thoải mái tuyệt vời, thân ngắn hơn và các nút điều khiển tiện lợi giúp bạn quản lý nhạc và cuộc gọi dễ dàng. · Với tính năng Chủ Động Khử Tiếng Ồn, AirPods 4 giúp giảm thiểu tiếng ồn bên ngoài, cho phép bạn hoàn toàn đắm chìm trong âm thanh. · Chip H2 mạnh mẽ mang đến âm thanh thích ứng, kết hợp khả năng khử tiếng ồn và chế độ Xuyên Âm, giúp bạn tương tác với thế giới xung quanh mà không bị gián đoạn.', 'AirPods 4 được thiết kế mới với sự thoải mái tuyệt vời, thân ngắn hơn và các nút điều khiển tiện lợi giúp bạn quản lý nhạc và cuộc gọi dễ dàng.
Với tính năng Chủ Động Khử Tiếng Ồn, AirPods 4 giúp giảm thiểu tiếng ồn bên ngoài, cho phép bạn hoàn toàn đắm chìm trong âm thanh.
Chip H2 mạnh mẽ mang đến âm thanh thích ứng, kết hợp khả năng khử tiếng ồn và chế độ Xuyên Âm, giúp bạn tương tác với thế giới xung quanh mà không bị gián đoạn.
Chất lượng âm thanh và cuộc gọi được cải thiện đáng kể nhờ tính năng Tách Lời Nói, giúp giọng nói của bạn rõ ràng hơn ngay cả trong môi trường ồn ào.

Chip: Chip tai nghe H2
Kích thước: Tai nghe: 30.2 x 18.3 x 18.1 mm, Hộp sạc: 46.2 x 50.1 x 21.2 mm
Trọng lượng: Tai nghe: 4.3g, Hộp sạc: 34.7g
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/66f5bb2ad56a9803.png', 3990000, 0, 1, 940);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90168', 'Trắng', 'Tiêu chuẩn', 4990000, 3990000, 20, '/uploads/products/apple/66f5bb2ad56a9803.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c1ce0d1e3d6cb1d8.png', 'Apple AirPods 4 chống ồn chủ động', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a30ef1c1e8a80620.png', 'Apple AirPods 4 chống ồn chủ động', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/037034b2db9ce10f.png', 'Apple AirPods 4 chống ồn chủ động', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2e66b69b677d6c68.png', 'Apple AirPods 4 chống ồn chủ động', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2af04d1694c62ac6.png', 'Apple AirPods 4 chống ồn chủ động', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/31e74839e594c456.png', 'Apple AirPods 4 chống ồn chủ động', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2fb6f8af6fe9d886.png', 'Apple AirPods 4 chống ồn chủ động', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6346d103fe64dc74.png', 'Apple AirPods 4 chống ồn chủ động', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e1862b4eca251dfb.png', 'Apple AirPods 4 chống ồn chủ động', 8);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods Pro 2 2023 USB-C', 'apple-airpods-pro-2-2023-usb-c', 'CPS-apple-airpods-pro-2-2023-usb-c', 'AirPods Pro 2 mang đến âm thanh đột phá với tính năng Giảm Âm Thanh Lớn và Tăng Cường Hội Thoại. · Tính năng Chủ Động Khử Tiếng Ồn giảm tiếng ồn xung quanh gấp đôi, trong khi chế độ Xuyên Âm cho phép bạn nghe thấy thế giới xung quanh. · Chip H2 tạo ra âm thanh sống động, với âm cao sắc nét và âm trầm đầy đặn, cải thiện chất lượng cuộc gọi trong môi trường ồn ào.', 'AirPods Pro 2 mang đến âm thanh đột phá với tính năng Giảm Âm Thanh Lớn và Tăng Cường Hội Thoại.
Tính năng Chủ Động Khử Tiếng Ồn giảm tiếng ồn xung quanh gấp đôi, trong khi chế độ Xuyên Âm cho phép bạn nghe thấy thế giới xung quanh.
Chip H2 tạo ra âm thanh sống động, với âm cao sắc nét và âm trầm đầy đặn, cải thiện chất lượng cuộc gọi trong môi trường ồn ào.
Với bốn cặp đầu tai nghe silicon tùy chỉnh và khả năng chống bụi, mồ hôi, nước đạt tiêu chuẩn IP54, AirPods Pro 2 lý tưởng cho mọi hoạt động.

Kích thước: Tai nghe: 30.9 x 21.8 x 24 mm, Hộp sạc: 45.2 x 60.6 x 21.7mm
Trọng lượng: Tai nghe: 5.3g, Hộp sạc: 50.8g
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/df504cf05ead4235.png', 4990000, 0, 1, 920);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-70387', 'Trắng', 'Tiêu chuẩn', 6190000, 4990000, 20, '/uploads/products/apple/df504cf05ead4235.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dbab1a8a287a435e.jpg', 'Apple AirPods Pro 2 2023 USB-C', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/11768ea6b9e2be1f.jpg', 'Apple AirPods Pro 2 2023 USB-C', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/96a929b2a93f0aae.jpg', 'Apple AirPods Pro 2 2023 USB-C', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5a8ea7f8ec336b4e.jpg', 'Apple AirPods Pro 2 2023 USB-C', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/02df34155349b85a.jpg', 'Apple AirPods Pro 2 2023 USB-C', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0f8784d0820af5eb.jpg', 'Apple AirPods Pro 2 2023 USB-C', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c7969df5e01030c6.jpg', 'Apple AirPods Pro 2 2023 USB-C', 6);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods Max 2 2026', 'apple-airpods-max-2-2026', 'CPS-apple-airpods-max-2-2026', 'Thời gian nghe nhạc hoặc xem phim lên đến 20 giờ với một lần sạc khi bật tính năng Chủ Động Khử Tiếng Ồn và Âm Thanh Không Gian. · Được thiết kế với gọng đeo lưới đan thoáng khí, đệm tai bằng foam hoạt tính và vải tùy chỉnh, cùng các trục có thể điều chỉnh độ dài cho trải nghiệm tai nghe dạng chụp vừa vặn lạ thường. · Siêu mạnh mẽ với chip H2, AirPods Max 2 mang đến âm thanh có độ trung thực cao được cải tiến với âm trầm sâu lắng, âm trung rộng mở và âm cao sắc nét cho trải nghiệm nghe vô song.', 'Thời gian nghe nhạc hoặc xem phim lên đến 20 giờ với một lần sạc khi bật tính năng Chủ Động Khử Tiếng Ồn và Âm Thanh Không Gian.
Được thiết kế với gọng đeo lưới đan thoáng khí, đệm tai bằng foam hoạt tính và vải tùy chỉnh, cùng các trục có thể điều chỉnh độ dài cho trải nghiệm tai nghe dạng chụp vừa vặn lạ thường.
Siêu mạnh mẽ với chip H2, AirPods Max 2 mang đến âm thanh có độ trung thực cao được cải tiến với âm trầm sâu lắng, âm trung rộng mở và âm cao sắc nét cho trải nghiệm nghe vô song.
Tính năng Nhận Biết Cuộc Hội Thoại sẽ giảm âm lượng nội dung đang phát để bạn có thể dễ dàng nói chuyện với những người xung quanh.
Chủ Động Khử Tiếng Ồn hiệu quả hơn đến 1,5 lần so với thế hệ trước, giúp bạn đắm chìm hoàn toàn trong từng thanh âm.

Chip: Chip tai nghe Apple H2 (mỗi bên củ tai)
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/3bbdd14ff84dd9da.png', 14490000, 0, 1, 900);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127028', 'Xanh dương', 'Tiêu chuẩn', 14990000, 14490000, 20, '/uploads/products/apple/3bbdd14ff84dd9da.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127029', 'Tím', 'Tiêu chuẩn', 14990000, 14490000, 20, '/uploads/products/apple/4d048e057570dc67.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127031', 'Đen', 'Tiêu chuẩn', 14990000, 14490000, 20, '/uploads/products/apple/69b64f726ef17233.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127032', 'Trắng vàng', 'Tiêu chuẩn', 14990000, 14490000, 20, '/uploads/products/apple/321b2462c785ca85.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127033', 'Cam', 'Tiêu chuẩn', 14990000, 14490000, 20, '/uploads/products/apple/9498faaee6525062.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d0191aeef2f02966.png', 'Apple AirPods Max 2 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3b749fe2cb1742fc.png', 'Apple AirPods Max 2 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8b8c59c6d705b7fb.png', 'Apple AirPods Max 2 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/22233c8a621d53dc.png', 'Apple AirPods Max 2 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/26f9d6baa1f64c77.png', 'Apple AirPods Max 2 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/246b65cc25c0cf3d.png', 'Apple AirPods Max 2 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/de5614bf8f1b799c.png', 'Apple AirPods Max 2 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1385581df893c1fc.png', 'Apple AirPods Max 2 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3bbdd14ff84dd9da.png', 'Apple AirPods Max 2 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4d048e057570dc67.png', 'Apple AirPods Max 2 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/69b64f726ef17233.png', 'Apple AirPods Max 2 2026', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/321b2462c785ca85.png', 'Apple AirPods Max 2 2026', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9498faaee6525062.png', 'Apple AirPods Max 2 2026', 12);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'tai-nghe-khong-day'), @brand, 'Apple AirPods Max 2024', 'apple-airpods-max-2024', 'CPS-apple-airpods-max-2024', 'AirPods Max mang đến âm thanh cực đỉnh với trình điều khiển động do Apple thiết kế, cho âm thanh trung thực và độ trễ thấp qua USB-C. · Âm thanh không gian cá nhân hóa, phù hợp với hình dáng tai và tính năng theo dõi chuyển động đầu. · Tính năng Chủ Động Khử Tiếng Ồn giảm tiếng ồn xung quanh gấp đôi, trong khi chế độ Xuyên Âm cho phép bạn tương tác với thế giới xung quanh.', 'AirPods Max mang đến âm thanh cực đỉnh với trình điều khiển động do Apple thiết kế, cho âm thanh trung thực và độ trễ thấp qua USB-C.
Âm thanh không gian cá nhân hóa, phù hợp với hình dáng tai và tính năng theo dõi chuyển động đầu.
Tính năng Chủ Động Khử Tiếng Ồn giảm tiếng ồn xung quanh gấp đôi, trong khi chế độ Xuyên Âm cho phép bạn tương tác với thế giới xung quanh.
Thiết kế thoáng khí với đệm tai foam hoạt tính đảm bảo vừa vặn và kín âm, cùng khả năng sạc qua USB-C tiện lợi.

Chip: Chip tai nghe Apple H1
Pin: - Thời gian nghe nhạc, đàm thoại đến 20 giờ trong một lần sạc khi bật chế độ chống ồn hoặc Transparency , - 5 phút sạc cung cấp thời gian nghe khoảng 1.5 giờ
Kích thước: 168.6 x 187.3 x 83.4 mm
Trọng lượng: 386,2 gram
Bluetooth: Bluetooth 5.0
Bảo hành: Bảo hành 1 đổi 1 trong 30 ngày nếu có lỗi phần cứng từ nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành uỷ quyền CareS.vn', '/uploads/products/apple/d8fb3c7a0b059485.png', 11690000, 0, 1, 890);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-29017', 'Đen', 'Tiêu chuẩn', 14990000, 11690000, 20, '/uploads/products/apple/d8fb3c7a0b059485.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-29018', 'Trắng/Vàng', 'Tiêu chuẩn', 14990000, 11690000, 20, '/uploads/products/apple/bd9bb54a11271415.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-29019', 'Cam', 'Tiêu chuẩn', 14990000, 11690000, 20, '/uploads/products/apple/fa9bfbb00481b300.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-29020', 'Xanh dương', 'Tiêu chuẩn', 14990000, 11690000, 20, '/uploads/products/apple/f3863e171a66644d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-29022', 'Tím', 'Tiêu chuẩn', 14990000, 11690000, 20, '/uploads/products/apple/509c86ffeb04b9b7.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a0666b41853d960d.png', 'Apple AirPods Max 2024', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5541cc7427a9fd60.png', 'Apple AirPods Max 2024', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2db1c882c9f2f79c.png', 'Apple AirPods Max 2024', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2ab6b8295f2e757e.png', 'Apple AirPods Max 2024', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fd9de5adf5260aa2.png', 'Apple AirPods Max 2024', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e8d225513658c7a3.png', 'Apple AirPods Max 2024', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/89578ad179fab7b0.png', 'Apple AirPods Max 2024', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/493f5c1063efa0b7.png', 'Apple AirPods Max 2024', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2070b8497a699686.png', 'Apple AirPods Max 2024', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d8fb3c7a0b059485.png', 'Apple AirPods Max 2024', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bd9bb54a11271415.png', 'Apple AirPods Max 2024', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fa9bfbb00481b300.png', 'Apple AirPods Max 2024', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f3863e171a66644d.png', 'Apple AirPods Max 2024', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/509c86ffeb04b9b7.png', 'Apple AirPods Max 2024', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad A16 2025', 'ipad-a16-2025', 'CPS-ipad-a16-2025', 'Màn hình Liquid Retina mang đến trải nghiệm xem tuyệt vời, với công nghệ True Tone điều chỉnh ánh sáng cho sự thoải mái khi thưởng thức phim và sáng tạo. · Chip A16 siêu nhanh cung cấp hiệu suất mạnh mẽ, cho phép bạn chơi game và chỉnh sửa ảnh, video mượt mà với thời gian sử dụng pin cả ngày. · iPadOS hỗ trợ chạy nhiều ứng dụng cùng lúc và sử dụng Apple Pencil để ghi chú, cùng hàng triệu ứng dụng trên App Store.', 'Màn hình Liquid Retina mang đến trải nghiệm xem tuyệt vời, với công nghệ True Tone điều chỉnh ánh sáng cho sự thoải mái khi thưởng thức phim và sáng tạo.
Chip A16 siêu nhanh cung cấp hiệu suất mạnh mẽ, cho phép bạn chơi game và chỉnh sửa ảnh, video mượt mà với thời gian sử dụng pin cả ngày.
iPadOS hỗ trợ chạy nhiều ứng dụng cùng lúc và sử dụng Apple Pencil để ghi chú, cùng hàng triệu ứng dụng trên App Store.
Camera 12MP Center Stage ở phía trước hoàn hảo cho gọi video và selfie, trong khi camera sau Wide 12MP hỗ trợ scan tài liệu và quay video 4K.

Kích thước màn hình: 11 inches
Độ phân giải: 2360 x 1640 pixel
Chip: Chip A16
CPU: CPU 5 lõi
GPU: GPU 4 lõi, Neural Engine 16 lõi
Bộ nhớ trong: 128 GB
Camera sau: Camera góc rộng: 12MP, ƒ/1.8, Độ thu phóng kỹ thuật số lên đến 5x, Chụp ảnh toàn cảnh Panorama: 63MP
Camera trước: Camera 12MP, ƒ/2.4
Pin: Tích hợp pin sạc Li-Po 28,93 watt‑giờ
Hệ điều hành: iPadOS
Kích thước: 248,6 x 179,5 x 7 mm
Trọng lượng: 477g
Bluetooth: v5.3
Wi-Fi: Wi-Fi 6 (802.11ax) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/348624d3664a2ece.jpg', 12090000, 1, 1, 990);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101716', 'Bạc', 'Wifi 128GB', 12790000, 12090000, 20, '/uploads/products/apple/348624d3664a2ece.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101717', 'Xanh', 'Wifi 128GB', 12790000, 12090000, 20, '/uploads/products/apple/c8dac27812edc07f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101718', 'Vàng', 'Wifi 128GB', 12790000, 12090000, 20, '/uploads/products/apple/636f6e48520dbda0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101719', 'Hồng', 'Wifi 128GB', 12790000, 12090000, 20, '/uploads/products/apple/c0cfc722e9343eec.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101720', 'Bạc', 'Wifi 256GB', 15590000, 14890000, 20, '/uploads/products/apple/666bba6a4e0d0ce1.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101721', 'Xanh', 'Wifi 256GB', 15590000, 14890000, 20, '/uploads/products/apple/75c24f751d1ba2f2.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101722', 'Vàng', 'Wifi 256GB', 15590000, 14890000, 20, '/uploads/products/apple/d315218818a0d49a.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101723', 'Hồng', 'Wifi 256GB', 15590000, 14890000, 20, '/uploads/products/apple/e8ee6fde2e5ee11f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101632', 'Bạc', '5G 128GB', 16990000, 16290000, 20, '/uploads/products/apple/1fd9178119519ad4.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101633', 'Xanh', '5G 128GB', 16990000, 16290000, 20, '/uploads/products/apple/bd541ee9b6e7df90.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101634', 'Vàng', '5G 128GB', 16990000, 16290000, 20, '/uploads/products/apple/90003ed977269bf9.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101635', 'Hồng', '5G 128GB', 16990000, 16290000, 20, '/uploads/products/apple/dba838b876fca798.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101636', 'Bạc', '5G 256GB', 19790000, 19290000, 20, '/uploads/products/apple/9e53c1f9f433de04.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101637', 'Xanh', '5G 256GB', 19790000, 19290000, 20, '/uploads/products/apple/399c4ac7ad77d21f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101638', 'Vàng', '5G 256GB', 19790000, 19290000, 20, '/uploads/products/apple/885e1aee07fbdb6d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101639', 'Hồng', '5G 256GB', 19790000, 19290000, 20, '/uploads/products/apple/5a78a1ccb58d77cc.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d7e185f7ed29a27f.jpg', 'iPad A16 2025', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bf12523a0f4ea36f.jpg', 'iPad A16 2025', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2b1505d05e20735d.jpg', 'iPad A16 2025', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4d58c69e4e148b70.jpg', 'iPad A16 2025', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0b753cc972211eb8.jpg', 'iPad A16 2025', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/df65a06f4378456b.jpg', 'iPad A16 2025', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d4c96fe20e0c6476.jpg', 'iPad A16 2025', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9b57f70fb829101f.jpg', 'iPad A16 2025', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/348624d3664a2ece.jpg', 'iPad A16 2025', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c8dac27812edc07f.jpg', 'iPad A16 2025', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/636f6e48520dbda0.jpg', 'iPad A16 2025', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c0cfc722e9343eec.jpg', 'iPad A16 2025', 11);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Air 11 inch M4 2026', 'ipad-air-11-inch-m4-2026', 'CPS-ipad-air-11-inch-m4-2026', 'Chip Apple M4 mạnh mẽ cho hiệu năng vượt trội, xử lý mượt mà từ học tập, làm việc đến sáng tạo nội dung. · Màn hình Liquid Retina 11 inch sắc nét, hỗ trợ True Tone và dải màu P3 cho trải nghiệm hiển thị sống động. · Camera 12MP tích hợp Center Stage thông minh, tự động căn khung khi gọi video học online hay họp trực tuyến.', 'Chip Apple M4 mạnh mẽ cho hiệu năng vượt trội, xử lý mượt mà từ học tập, làm việc đến sáng tạo nội dung.
Màn hình Liquid Retina 11 inch sắc nét, hỗ trợ True Tone và dải màu P3 cho trải nghiệm hiển thị sống động.
Camera 12MP tích hợp Center Stage thông minh, tự động căn khung khi gọi video học online hay họp trực tuyến.
Touch ID tích hợp nút nguồn bảo mật nhanh chóng, kết hợp hệ sinh thái Apple đồng bộ và tiện lợi.

Kích thước màn hình: 11 inches
Độ phân giải: 2360 x 1640 pixel
Chip: Chip Apple M4
CPU: 8 lõi với 3 lõi hiệu năng và 5 lõi tiết kiệm điện
GPU: GPU 9 lõi, Neural Engine 16 lõi, Công nghệ dò tia tốc độ cao bằng phần cứng
Bộ nhớ trong: 128 GB
Camera sau: 12MP, f/1.8, Độ thu phóng kỹ thuật số lên đến 5x, Chụp ảnh toàn cảnh Panorama (lên đến 63MP)
Camera trước: 12MP Center Stage, ƒ/2.0
Pin: Tích hợp pin sạc Li-Po 28,93 watt‑giờ
Hệ điều hành: iPadOS
Kích thước: 247.6 x 178.5 x 6.1 mm
Trọng lượng: 464 g
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be) với 2x2 MIMO5
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/a617f9448d5a62f3.jpg', 19490000, 1, 1, 980);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125588', 'Xám', 'Wifi 128GB', 20990000, 19490000, 20, '/uploads/products/apple/a617f9448d5a62f3.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125589', 'Xanh dương', 'Wifi 128GB', 20990000, 19490000, 20, '/uploads/products/apple/59ea88cd12c67f3b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125590', 'Trắng vàng', 'Wifi 128GB', 20990000, 19490000, 20, '/uploads/products/apple/a79caa03a7cd5870.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125591', 'Tím', 'Wifi 128GB', 20990000, 19490000, 20, '/uploads/products/apple/1881aa8a7dd682cf.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125599', 'Xám', 'Wifi 256GB', 23790000, 21990000, 20, '/uploads/products/apple/8fc1e6c6c7a2dc4b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125600', 'Xanh dương', 'Wifi 256GB', 23790000, 21990000, 20, '/uploads/products/apple/68dcedd10893300e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125601', 'Trắng vàng', 'Wifi 256GB', 23790000, 21990000, 20, '/uploads/products/apple/13634b365a9adde5.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125603', 'Tím', 'Wifi 256GB', 23790000, 21990000, 20, '/uploads/products/apple/c6f89bc118597ea7.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125628', 'Xám không gian', '5G 128GB', 25190000, 23490000, 20, '/uploads/products/apple/a96fc2f9dcb8e85c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125629', 'Xanh dương', '5G 128GB', 25190000, 23490000, 20, '/uploads/products/apple/c9c003d4e619c3a5.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125630', 'Ánh sao', '5G 128GB', 25190000, 23490000, 20, '/uploads/products/apple/db476778f1e1025e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125631', 'Tím', '5G 128GB', 25190000, 23490000, 20, '/uploads/products/apple/2aecf11ccdb3f55e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125608', 'Xám', 'Wifi 512GB', 29390000, 27290000, 20, '/uploads/products/apple/96174f93bbc0c68a.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125609', 'Xanh dương', 'Wifi 512GB', 29390000, 27290000, 20, '/uploads/products/apple/36c636345abd5e33.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125611', 'Trắng vàng', 'Wifi 512GB', 29390000, 27290000, 20, '/uploads/products/apple/e29b3b2792788be5.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125612', 'Tím', 'Wifi 512GB', 29390000, 27290000, 20, '/uploads/products/apple/2602efa41430b344.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cd39f76b5a4ee1e5.png', 'iPad Air 11 inch M4 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/998f9bd923675642.png', 'iPad Air 11 inch M4 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/665e045f3c8f42c0.png', 'iPad Air 11 inch M4 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fc86e6772d669252.png', 'iPad Air 11 inch M4 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cda05a9fb817c948.png', 'iPad Air 11 inch M4 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0b31809d2bd49e62.png', 'iPad Air 11 inch M4 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b68940ff107055e2.png', 'iPad Air 11 inch M4 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5e298f8fd2eb79f9.png', 'iPad Air 11 inch M4 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/44869fb9796ba1b3.png', 'iPad Air 11 inch M4 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ce63e4d26c849483.png', 'iPad Air 11 inch M4 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a617f9448d5a62f3.jpg', 'iPad Air 11 inch M4 2026', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/59ea88cd12c67f3b.jpg', 'iPad Air 11 inch M4 2026', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a79caa03a7cd5870.jpg', 'iPad Air 11 inch M4 2026', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1881aa8a7dd682cf.jpg', 'iPad Air 11 inch M4 2026', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad mini (2026)', 'ipad-mini-2026', 'CPS-ipad-mini-2026', 'iPad mini (2026)', 'Kích thước màn hình: 8.5 inches
Chip: Apple A20 Pro
CPU: CPU 5 lõi với 2 lõi siêu xử lý và 3 lõi tiết kiệm điện
GPU: 7 lõi, Neural Engine 16 lõi
Bộ nhớ trong: 128 GB
Camera sau: 12 MP Wide, khẩu độ ƒ/1.8
Camera trước: 12 MP Center Stage, khẩu độ ƒ/2.0
Pin: Li-Po 18,9 Wh
Hệ điều hành: iPadOS
Kích thước: 195,3 x 132,6 x 5,4mm
Trọng lượng: 255g
SIM: 1 eSIM
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be), 2x2 MIMO, đồng thời hai băng tần
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/f9871e3613937b1d.jpg', 19490000, 1, 1, 970);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146209', 'Đêm Xanh Thẳm', 'Wifi 128GB', 19490000, NULL, 20, '/uploads/products/apple/f9871e3613937b1d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146210', 'Ánh sao', 'Wifi 128GB', 19490000, NULL, 20, '/uploads/products/apple/b7c213c555f73597.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146212', 'Đêm Xanh Thẳm', 'Wifi 256GB', 22290000, NULL, 20, '/uploads/products/apple/d94ee478ed76b5cb.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146213', 'Ánh sao', 'Wifi 256GB', 22290000, NULL, 20, '/uploads/products/apple/9a3e8d3fb4edce51.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146224', 'Đêm Xanh Thẳm', '5G 128GB', 23690000, NULL, 20, '/uploads/products/apple/395ca324526ae61e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146225', 'Ánh sao', '5G 128GB', 23690000, NULL, 20, '/uploads/products/apple/7c3e91e83082bfb7.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146221', 'Đêm Xanh Thẳm', 'Wifi 256GB Nano', 25090000, NULL, 20, '/uploads/products/apple/0ad0fb4b073e03c3.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146222', 'Ánh sao', 'Wifi 256GB Nano', 25090000, NULL, 20, '/uploads/products/apple/354dac21608ab538.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146227', 'Đêm Xanh Thẳm', '5G 256GB', 26490000, NULL, 20, '/uploads/products/apple/1c009deaf56e0ce0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146228', 'Ánh sao', '5G 256GB', 26490000, NULL, 20, '/uploads/products/apple/698fdda3f030e095.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146215', 'Đêm Xanh Thẳm', 'Wifi 512GB', 27890000, NULL, 20, '/uploads/products/apple/656d6e6f9d998fcd.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146216', 'Ánh sao', 'Wifi 512GB', 27890000, NULL, 20, '/uploads/products/apple/1445a6b00c607968.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146236', 'Đêm Xanh Thẳm', '5G 256GB Nano', 29290000, NULL, 20, '/uploads/products/apple/e2bebaee7a95b022.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146237', 'Ánh sao', '5G 256GB Nano', 29290000, NULL, 20, '/uploads/products/apple/665037320fe2d4db.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146218', 'Đêm Xanh Thẳm', 'Wifi 512GB Nano', 30690000, NULL, 20, '/uploads/products/apple/7e533ed97894e10b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146219', 'Ánh sao', 'Wifi 512GB Nano', 30690000, NULL, 20, '/uploads/products/apple/562f94cc2e137d1b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146230', 'Đêm Xanh Thẳm', '5G 512GB', 32090000, NULL, 20, '/uploads/products/apple/71591da410783b01.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146231', 'Ánh sao', '5G 512GB', 32090000, NULL, 20, '/uploads/products/apple/10adf99a80000ebf.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146233', 'Đêm Xanh Thẳm', '5G 512GB Nano', 34890000, NULL, 20, '/uploads/products/apple/b5c22e1b55c37bad.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146234', 'Ánh sao', '5G 512GB Nano', 34890000, NULL, 20, '/uploads/products/apple/7726286ec2707d74.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cb0948ec787a866f.jpg', 'iPad mini (2026)', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/eb21200f29875a16.jpg', 'iPad mini (2026)', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/415b131e743d6dcf.jpg', 'iPad mini (2026)', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/64055d15b4e4d62f.jpg', 'iPad mini (2026)', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/453fef0214720155.jpg', 'iPad mini (2026)', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7512c9fe27a0ea13.jpg', 'iPad mini (2026)', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/07edde678f379b0d.jpg', 'iPad mini (2026)', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b5a3767d804c141a.jpg', 'iPad mini (2026)', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/57f54eccf716edda.jpg', 'iPad mini (2026)', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0ebac21f501afde6.jpg', 'iPad mini (2026)', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f9871e3613937b1d.jpg', 'iPad mini (2026)', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b7c213c555f73597.jpg', 'iPad mini (2026)', 11);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Air 11 inch M3 2025', 'ipad-air-11-inch-m3-2025', 'CPS-ipad-air-11-inch-m3-2025', 'iPad Air sở hữu màn hình Liquid Retina 11 inch với dải màu rộng P3 và công nghệ True Tone, mang đến hình ảnh sắc nét và sống động. · Chip M3 mạnh mẽ cho phép bạn đa nhiệm mượt mà và chơi game đồ họa cao, cùng thời lượng pin kéo dài cả ngày để làm việc và giải trí. · Hệ điều hành iPadOS hỗ trợ chạy nhiều ứng dụng đồng thời, với tính năng sử dụng Apple Pencil để ghi chú và chỉnh sửa ảnh, giúp tăng cường năng suất.', 'iPad Air sở hữu màn hình Liquid Retina 11 inch với dải màu rộng P3 và công nghệ True Tone, mang đến hình ảnh sắc nét và sống động.
Chip M3 mạnh mẽ cho phép bạn đa nhiệm mượt mà và chơi game đồ họa cao, cùng thời lượng pin kéo dài cả ngày để làm việc và giải trí.
Hệ điều hành iPadOS hỗ trợ chạy nhiều ứng dụng đồng thời, với tính năng sử dụng Apple Pencil để ghi chú và chỉnh sửa ảnh, giúp tăng cường năng suất.
Tương thích với Apple Pencil và Magic Keyboard, iPad Air trở thành không gian sáng tạo tuyệt vời cho việc vẽ và ghi chú, đồng thời bảo vệ thiết bị khi di chuyển.

Kích thước màn hình: 11 inches
Độ phân giải: 2360 x 1640 pixel
Chip: Chip Apple M3
CPU: CPU 8 lõi với 4 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 9 lõi , Neural Engine 16 lõi, Công nghệ dò tia tốc độ cao bằng phần cứng
Bộ nhớ trong: 128 GB
Camera sau: Camera góc rộng: 12MP, ƒ/1.8, Độ thu phóng kỹ thuật số lên đến 5x, Chụp ảnh toàn cảnh Panorama: 63MP
Camera trước: Camera 12MP, ƒ/2.0
Pin: Tích hợp pin sạc Li-Po 28,93 watt‑giờ
Hệ điều hành: iPadOS
Kích thước: 247,6 x 178,5 x 6,1 mm
Trọng lượng: 460 gram
SIM: 1 eSIM
Bluetooth: v5.3
Wi-Fi: Wi-Fi 6E (802.11ax) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/5243a316873a8f6b.jpg', 16990000, 0, 1, 960);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101650', 'Xám', 'Wifi 128GB', 21490000, 16990000, 20, '/uploads/products/apple/5243a316873a8f6b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101651', 'Xanh dương', 'Wifi 128GB', 21490000, 16990000, 20, '/uploads/products/apple/ee07c2af53ef4fcb.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101652', 'Trắng vàng', 'Wifi 128GB', 21490000, 16990000, 20, '/uploads/products/apple/b567ce5a02b2cffb.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101653', 'Tím', 'Wifi 128GB', 21490000, 16990000, 20, '/uploads/products/apple/948b6b4c8b57cc22.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101666', 'Xám', '5G 128GB', 25290000, 18990000, 20, '/uploads/products/apple/4ba56873b0c54f83.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101667', 'Xanh dương', '5G 128GB', 25290000, 18990000, 20, '/uploads/products/apple/7f8da7663b8b446d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101668', 'Trắng vàng', '5G 128GB', 25290000, 18990000, 20, '/uploads/products/apple/792bd831b62b919a.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101669', 'Tím', '5G 128GB', 25290000, 18990000, 20, '/uploads/products/apple/6c3399442e2dc0e2.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c111cbb2181270c7.jpg', 'iPad Air 11 inch M3 2025', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/187d36aa8cbd4168.jpg', 'iPad Air 11 inch M3 2025', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/83e757d6d48a7b14.jpg', 'iPad Air 11 inch M3 2025', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8af7064cec2cbd9d.jpg', 'iPad Air 11 inch M3 2025', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/353fb45530a323cb.jpg', 'iPad Air 11 inch M3 2025', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f8a9132f13af4904.jpg', 'iPad Air 11 inch M3 2025', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/aa1265751be5fd4f.jpg', 'iPad Air 11 inch M3 2025', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1a2bb90bb8ce3756.jpg', 'iPad Air 11 inch M3 2025', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c8e3debe942d4cb2.jpg', 'iPad Air 11 inch M3 2025', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b0aeb4d16ed9f1e1.jpg', 'iPad Air 11 inch M3 2025', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5243a316873a8f6b.jpg', 'iPad Air 11 inch M3 2025', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ee07c2af53ef4fcb.jpg', 'iPad Air 11 inch M3 2025', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b567ce5a02b2cffb.jpg', 'iPad Air 11 inch M3 2025', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/948b6b4c8b57cc22.jpg', 'iPad Air 11 inch M3 2025', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad mini 7 2024', 'ipad-mini-7-2024', 'CPS-ipad-mini-7-2024', 'iPad mini sở hữu màn hình Liquid Retina 8,3 inch với công nghệ tiên tiến như dải màu rộng P3, True Tone, mang đến hình ảnh sắc nét và sống động. · Với chip A17 Pro, iPad mini cung cấp hiệu suất mạnh mẽ và đồ họa mượt mà, cùng thời lượng pin cả ngày, phù hợp cho mọi tác vụ và dự án. · Hệ điều hành iPadOS cho phép bạn chạy nhiều ứng dụng cùng lúc và sử dụng Apple Pencil để ghi chú hoặc vẽ, nâng cao hiệu suất làm việc và sáng tạo.', 'iPad mini sở hữu màn hình Liquid Retina 8,3 inch với công nghệ tiên tiến như dải màu rộng P3, True Tone, mang đến hình ảnh sắc nét và sống động.
Với chip A17 Pro, iPad mini cung cấp hiệu suất mạnh mẽ và đồ họa mượt mà, cùng thời lượng pin cả ngày, phù hợp cho mọi tác vụ và dự án.
Hệ điều hành iPadOS cho phép bạn chạy nhiều ứng dụng cùng lúc và sử dụng Apple Pencil để ghi chú hoặc vẽ, nâng cao hiệu suất làm việc và sáng tạo.
Camera 12MP Center Stage ở phía trước và camera sau 12MP với flash True Tone giúp bạn thực hiện các cuộc gọi video chất lượng cao và ghi lại những khoảnh khắc đáng nhớ.

Kích thước màn hình: 8.3 inches
Độ phân giải: 2266 x 1488 pixels
Chip: Chip A17 Pro
CPU: CPU 6 lõi với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 5 lõi , Neural Engine 16 lõi
Bộ nhớ trong: 128 GB
Camera sau: Camera Wide 12MP, khẩu độ ƒ/1.8
Camera trước: Camera trước Ultra Wide 12MP, Khẩu độ ƒ/2.4
Pin: Tích hợp pin sạc Li-Po 19,3 watt‑giờ
Hệ điều hành: iPadOS
Kích thước: 195.4 x 134.8 x 6.3 mm
Trọng lượng: 293 gram
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/e55e87baaacdfefd.jpg', 15990000, 0, 1, 950);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93177', 'Xanh dương', 'Wifi 128GB', 16490000, 15990000, 20, '/uploads/products/apple/e55e87baaacdfefd.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93178', 'Tím', 'Wifi 128GB', 16490000, 15990000, 20, '/uploads/products/apple/56e64ea56a698f77.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93179', 'Xám', 'Wifi 128GB', 16490000, 15990000, 20, '/uploads/products/apple/d8b4222047c5cc03.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93180', 'Trắng vàng', 'Wifi 128GB', 16490000, 15990000, 20, '/uploads/products/apple/8849528118eaa104.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93182', 'Trắng vàng', 'Wifi 256GB', 19290000, 18790000, 20, '/uploads/products/apple/578077855dc0dde6.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93183', 'Tím', 'Wifi 256GB', 19290000, 18790000, 20, '/uploads/products/apple/62a718e3633a33b6.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93188', 'Xanh dương', 'Wifi 256GB', 19290000, 18790000, 20, '/uploads/products/apple/17185ebea7d0bfdd.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93191', 'Xám', 'Wifi 256GB', 19290000, 18790000, 20, '/uploads/products/apple/1b0dbfb5a44bd7f2.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93206', 'Xanh dương', '5G 128GB', 20690000, 20290000, 20, '/uploads/products/apple/368a9b3df8e9c4ac.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93207', 'Tím', '5G 128GB', 20690000, 20290000, 20, '/uploads/products/apple/52715e73f0e6b0c6.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93208', 'Trắng vàng', '5G 128GB', 20690000, 20290000, 20, '/uploads/products/apple/dabac27a70b9f927.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93209', 'Xám', '5G 128GB', 20690000, 20290000, 20, '/uploads/products/apple/cead1396affffb52.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/55a209402d6600d6.png', 'iPad mini 7 2024', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f44cf4260a4f20f4.jpg', 'iPad mini 7 2024', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c8a8690920f89894.jpg', 'iPad mini 7 2024', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ee8922581e689062.jpg', 'iPad mini 7 2024', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/97aa527fdc62cec7.jpg', 'iPad mini 7 2024', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4406c20243f54486.jpg', 'iPad mini 7 2024', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b54191791886b263.jpg', 'iPad mini 7 2024', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ebba264988069af9.jpg', 'iPad mini 7 2024', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7e5e64e02d5c774e.jpg', 'iPad mini 7 2024', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6b253487192c5056.jpg', 'iPad mini 7 2024', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e55e87baaacdfefd.jpg', 'iPad mini 7 2024', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/56e64ea56a698f77.jpg', 'iPad mini 7 2024', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d8b4222047c5cc03.jpg', 'iPad mini 7 2024', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8849528118eaa104.jpg', 'iPad mini 7 2024', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Pro chip M5 11 inch', 'ipad-pro-chip-m5-11-inch', 'CPS-ipad-pro-chip-m5-11-inch', 'Chip M5 đem lại hiệu năng nhanh và ổn định, xử lý mượt mà các tác vụ hàng ngày và các ứng dụng AI mà không cần cấu hình dung lượng cao. · iPadOS 26 hỗ trợ hệ cửa sổ Liquid Glass mới, tăng sự linh hoạt khi thao tác và tối ưu việc chuyển đổi giữa nhiều ứng dụng. · Apple Intelligence hỗ trợ viết, tóm tắt và sắp xếp thông tin thông minh, đồng thời duy trì quyền riêng tư nhờ xử lý trực tiếp trên thiết bị.', 'Chip M5 đem lại hiệu năng nhanh và ổn định, xử lý mượt mà các tác vụ hàng ngày và các ứng dụng AI mà không cần cấu hình dung lượng cao.
iPadOS 26 hỗ trợ hệ cửa sổ Liquid Glass mới, tăng sự linh hoạt khi thao tác và tối ưu việc chuyển đổi giữa nhiều ứng dụng.
Apple Intelligence hỗ trợ viết, tóm tắt và sắp xếp thông tin thông minh, đồng thời duy trì quyền riêng tư nhờ xử lý trực tiếp trên thiết bị.
Màn hình Ultra Retina XDR 11" mang đến độ sáng cao và màu sắc chuẩn xác với ProMotion và True Tone, phù hợp làm việc lẫn giải trí.
Kết nối Wi-Fi 7 cho tốc độ mạng vượt trội, giúp tải nhanh và đồng bộ dữ liệu tức thì khi làm việc với tệp đa phương tiện dung lượng lớn.

Kích thước màn hình: 11 inches
Độ phân giải: 2420x1668 pixel
Chip: Apple M5
CPU: CPU 9 lõi với 3 lõi hiệu năng và 6 lõi tiết kiệm điện
GPU: Apple GPU 10 nhân
Bộ nhớ trong: 256 GB
Camera sau: Camera 12MP Wide, Khẩu độ ƒ/1.8
Camera trước: Camera 12MP Center Stage trên cạnh ngang, Khẩu độ ƒ/2.0
Pin: Pin sạc Li-Po 31.29 Wh
Hệ điều hành: iPadOS
Kích thước: 24.97 x 17.75 x 0.53 cm
Trọng lượng: 444gram
Bluetooth: Bluetooth 6
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/35fdf03496c0963e.png', 33690000, 0, 1, 920);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115969', 'Đen Không Gian', 'Wifi 256GB', 35590000, 33690000, 20, '/uploads/products/apple/35fdf03496c0963e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115970', 'Bạc', 'Wifi 256GB', 35590000, 33690000, 20, '/uploads/products/apple/e581f2418d7fe36b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115973', 'Đen Không Gian', 'Wifi 512GB', 41190000, 39490000, 20, '/uploads/products/apple/4881921cc1a7cde6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115974', 'Bạc', 'Wifi 512GB', 41190000, 39490000, 20, '/uploads/products/apple/659655461f127dac.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115986', 'Đen Không Gian', '5G 256GB', 41490000, 39490000, 20, '/uploads/products/apple/3a2e3df070caeaea.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115987', 'Bạc', '5G 256GB', 41490000, 39490000, 20, '/uploads/products/apple/af7e983ef45e9b2f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116000', 'Đen Không Gian', '5G 512GB', 46490000, 45490000, 20, '/uploads/products/apple/9e5a01b429e2086b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116001', 'Bạc', '5G 512GB', 46490000, 45490000, 20, '/uploads/products/apple/0afc335b348846a3.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115978', 'Đen Không Gian', 'Wifi 1TB', 52390000, 49990000, 20, '/uploads/products/apple/1700e65839a93f77.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115979', 'Bạc', 'Wifi 1TB', 52390000, 49990000, 20, '/uploads/products/apple/50a43d46ad17ecf6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116007', 'Đen Không Gian', '5G 1TB', 57990000, 55490000, 20, '/uploads/products/apple/bc38f903d887c51d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116008', 'Bạc', '5G 1TB', 57990000, 55490000, 20, '/uploads/products/apple/04469394b166d91a.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115982', 'Đen Không Gian', 'Wifi 2TB', 66390000, 62990000, 20, '/uploads/products/apple/9d991447440cb9a2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115983', 'Bạc', 'Wifi 2TB', 66390000, 62990000, 20, '/uploads/products/apple/4c8b31bedd28c7b8.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-117149', 'Bạc', 'Wifi 2TB Nano', 69190000, 64990000, 20, '/uploads/products/apple/f254581a7356581c.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-117150', 'Đen Không Gian', 'Wifi 2TB Nano', 69190000, 64990000, 20, '/uploads/products/apple/8d5d543e5d56b2df.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f392179c41e3fb3a.jpg', 'iPad Pro chip M5 11 inch', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1589f5eee63c63c7.jpg', 'iPad Pro chip M5 11 inch', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/55e7d5ec19bdb9ed.png', 'iPad Pro chip M5 11 inch', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/74913af2ad9bdffe.png', 'iPad Pro chip M5 11 inch', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/96825958d2d46192.png', 'iPad Pro chip M5 11 inch', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6e1986ac608c5727.png', 'iPad Pro chip M5 11 inch', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b9e6514159b810d9.png', 'iPad Pro chip M5 11 inch', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a30b90c14a1afd15.png', 'iPad Pro chip M5 11 inch', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b936a4abe1cf5ccd.png', 'iPad Pro chip M5 11 inch', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/35fdf03496c0963e.png', 'iPad Pro chip M5 11 inch', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e581f2418d7fe36b.png', 'iPad Pro chip M5 11 inch', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Air 13 inch M4 2026', 'ipad-air-13-inch-m4-2026', 'CPS-ipad-air-13-inch-m4-2026', 'Màn hình Liquid Retina 13 inch độ phân giải cao, màu sắc chân thực và độ sáng ấn tượng, mang đến không gian hiển thị rộng rãi, đã mắt khi làm việc lẫn giải trí. · Chipset Apple M4 mạnh mẽ, xử lý mượt mà từ tác vụ văn phòng đến chỉnh sửa ảnh, dựng video hay chơi game nặng. · Hệ điều hành iPadOS tối ưu cho đa nhiệm thông minh, hỗ trợ chia màn hình, Stage Manager và nhiều tính năng nâng cao hiệu suất.', 'Màn hình Liquid Retina 13 inch độ phân giải cao, màu sắc chân thực và độ sáng ấn tượng, mang đến không gian hiển thị rộng rãi, đã mắt khi làm việc lẫn giải trí.
Chipset Apple M4 mạnh mẽ, xử lý mượt mà từ tác vụ văn phòng đến chỉnh sửa ảnh, dựng video hay chơi game nặng.
Hệ điều hành iPadOS tối ưu cho đa nhiệm thông minh, hỗ trợ chia màn hình, Stage Manager và nhiều tính năng nâng cao hiệu suất.
Kết nối 5G tốc độ cao cùng camera 12MP Center Stage và khả năng tương thích Apple Pencil, Magic Keyboard, giúp học tập và làm việc linh hoạt mọi lúc mọi nơi.

Kích thước màn hình: 13 inches
Độ phân giải: 2732 x 2048 pixels
Chip: Chip Apple M4
CPU: 8 lõi với 3 lõi hiệu năng và 5 lõi tiết kiệm điện
GPU: GPU 9 lõi, Neural Engine 16 lõi, Công nghệ dò tia tốc độ cao bằng phần cứng
Bộ nhớ trong: 128 GB
Camera sau: 12MP, f/1.8, Độ thu phóng kỹ thuật số lên đến 5x, Chụp ảnh toàn cảnh Panorama (lên đến 63MP)
Camera trước: 12MP Center Stage, ƒ/2.0
Pin: Tích hợp pin sạc Li-Po 36,59 watt‑giờ
Hệ điều hành: iPadOS
Kích thước: 280,6 x 214,9 x 6,1 mm
Trọng lượng: 617 g
SIM: 1 eSIM
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be) với 2x2 MIMO5
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/b02416e27eeaf2e3.png', 24890000, 0, 1, 880);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125602', 'Xám', 'Wifi 128GB', 26490000, 24890000, 20, '/uploads/products/apple/b02416e27eeaf2e3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125604', 'Xanh dương', 'Wifi 128GB', 26490000, 24890000, 20, '/uploads/products/apple/ed8593fc46efed95.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125605', 'Trắng vàng', 'Wifi 128GB', 26490000, 24890000, 20, '/uploads/products/apple/74c825441e7389c3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125606', 'Tím', 'Wifi 128GB', 26490000, 24890000, 20, '/uploads/products/apple/2bde70927e73c8fc.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125659', 'Xám', 'Wifi 256GB', 29290000, 27490000, 20, '/uploads/products/apple/9ea3a73d20706a3b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125660', 'Xanh dương', 'Wifi 256GB', 29290000, 27490000, 20, '/uploads/products/apple/957b808dbe3c0470.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125661', 'Trắng vàng', 'Wifi 256GB', 29290000, 27490000, 20, '/uploads/products/apple/5823960d569b9c56.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125662', 'Tím', 'Wifi 256GB', 29290000, 27490000, 20, '/uploads/products/apple/07ac6a8dddbbb0ae.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125595', 'Xám không gian', '5G 128GB', 30690000, 28390000, 20, '/uploads/products/apple/846e969de7b1375d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125596', 'Xanh dương', '5G 128GB', 30690000, 28390000, 20, '/uploads/products/apple/17a2d56a6098e7b7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125597', 'Ánh sao', '5G 128GB', 30690000, 28390000, 20, '/uploads/products/apple/7b49f2402bbfc8f5.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125598', 'Tím', '5G 128GB', 30690000, 28390000, 20, '/uploads/products/apple/6661b2d0b6adafc6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125648', 'Xám', 'Wifi 512GB', 34890000, 32690000, 20, '/uploads/products/apple/bb66f6f2864ceb16.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125649', 'Xanh dương', 'Wifi 512GB', 34890000, 32690000, 20, '/uploads/products/apple/10c62c0d9ae3196a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125650', 'Trắng vàng', 'Wifi 512GB', 34890000, 32690000, 20, '/uploads/products/apple/1969eeadba79d4bf.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125652', 'Tím', 'Wifi 512GB', 34890000, 32690000, 20, '/uploads/products/apple/b690b08671bf4646.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125632', 'Xám không gian', '5G 512GB', 39090000, 36890000, 20, '/uploads/products/apple/3782c59f9ab2b89e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125634', 'Xanh dương', '5G 512GB', 39090000, 36890000, 20, '/uploads/products/apple/585e4fec7e0a96d9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125635', 'Ánh sao', '5G 512GB', 39090000, 36890000, 20, '/uploads/products/apple/cde90dcccde9182d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125636', 'Tím', '5G 512GB', 39090000, 36890000, 20, '/uploads/products/apple/de20700cc7931173.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125637', 'Xám', 'Wifi 1TB', 43290000, 40990000, 20, '/uploads/products/apple/90a4a855c3490f41.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125638', 'Xanh dương', 'Wifi 1TB', 43290000, 40990000, 20, '/uploads/products/apple/cc07e6b2c7af300e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125639', 'Trắng vàng', 'Wifi 1TB', 43290000, 40990000, 20, '/uploads/products/apple/e9c7647a83d0a3df.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125640', 'Tím', 'Wifi 1TB', 43290000, 40990000, 20, '/uploads/products/apple/66481257b0c8ffc1.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0b113899031edca3.png', 'iPad Air 13 inch M4 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ae048910a22ba3e9.png', 'iPad Air 13 inch M4 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b24383e42f0184f9.png', 'iPad Air 13 inch M4 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9e8511a27946bd4b.png', 'iPad Air 13 inch M4 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d0924a71b532e34f.png', 'iPad Air 13 inch M4 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3165326e2c7d122c.png', 'iPad Air 13 inch M4 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/575d1fb66e56cd43.png', 'iPad Air 13 inch M4 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/22d696baf188ad02.png', 'iPad Air 13 inch M4 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/750e2564647d850e.png', 'iPad Air 13 inch M4 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/42a7b0508da72456.png', 'iPad Air 13 inch M4 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/846e969de7b1375d.png', 'iPad Air 13 inch M4 2026', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/17a2d56a6098e7b7.png', 'iPad Air 13 inch M4 2026', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7b49f2402bbfc8f5.png', 'iPad Air 13 inch M4 2026', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6661b2d0b6adafc6.png', 'iPad Air 13 inch M4 2026', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Pro chip M5 13 inch', 'ipad-pro-chip-m5-13-inch', 'CPS-ipad-pro-chip-m5-13-inch', 'Chip M5 cho hiệu năng mạnh mẽ cùng khả năng xử lý AI trên thiết bị, tối ưu cho đa nhiệm và các tác vụ sáng tạo hàng ngày. · iPadOS 26 cung cấp giao diện Liquid Glass trực quan và hệ thống cửa sổ linh hoạt, giúp tổ chức công việc mạch lạc hơn. · Apple Intelligence hỗ trợ xử lý ngôn ngữ, sáng tạo và hoàn thành tác vụ nhanh hơn với bảo mật dựa trên quyền riêng tư vượt trội.', 'Chip M5 cho hiệu năng mạnh mẽ cùng khả năng xử lý AI trên thiết bị, tối ưu cho đa nhiệm và các tác vụ sáng tạo hàng ngày.
iPadOS 26 cung cấp giao diện Liquid Glass trực quan và hệ thống cửa sổ linh hoạt, giúp tổ chức công việc mạch lạc hơn.
Apple Intelligence hỗ trợ xử lý ngôn ngữ, sáng tạo và hoàn thành tác vụ nhanh hơn với bảo mật dựa trên quyền riêng tư vượt trội.
Màn hình Ultra Retina XDR 13 inch hiển thị màu sắc chuẩn xác, độ sáng cao, ProMotion và True Tone cho trải nghiệm giải trí sắc nét.
Kết nối Wi-Fi 7 tốc độ cao giúp truyền tệp lớn nhanh chóng, đảm bảo kết nối mượt mà khi học tập hoặc làm việc trực tuyến.

Kích thước màn hình: 13 inches
Độ phân giải: 2752x2064 pixels
Chip: Apple M5
CPU: CPU 9 lõi với 3 lõi hiệu năng và 6 lõi tiết kiệm điện
GPU: Apple GPU 10 nhân
Bộ nhớ trong: 256 GB
Pin: Pin sạc Li-Po 38.99 Wh
Hệ điều hành: iOS
Kích thước: 28.16 x 21.55 x 0.51 cm
Trọng lượng: 579 gram
Bluetooth: Bluetooth 6
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/4ae3d1918c72a981.png', 43290000, 0, 1, 810);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115976', 'Đen Không Gian', 'Wifi 256GB', 45590000, 43290000, 20, '/uploads/products/apple/4ae3d1918c72a981.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115977', 'Bạc', 'Wifi 256GB', 45590000, 43290000, 20, '/uploads/products/apple/fa090efa3bba32de.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115984', 'Đen Không Gian', 'Wifi 512GB', 51190000, 49590000, 20, '/uploads/products/apple/80f6a806df7bb0bc.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115985', 'Bạc', 'Wifi 512GB', 51190000, 49590000, 20, '/uploads/products/apple/f4a85851f66d0956.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115995', 'Đen Không Gian', '5G 256GB', 51190000, 48990000, 20, '/uploads/products/apple/9d94808d007c63c9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115996', 'Bạc', '5G 256GB', 51190000, 48990000, 20, '/uploads/products/apple/94ffbb0c0b6d722c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115998', 'Đen Không Gian', '5G 512GB', 56790000, 55490000, 20, '/uploads/products/apple/c158d7b72087775b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115999', 'Bạc', '5G 512GB', 56790000, 55490000, 20, '/uploads/products/apple/5132d97bc0f35546.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116013', 'Đen Không Gian', '5G 2TB', 81990000, 77990000, 20, '/uploads/products/apple/2b1a5d4a3dbc0595.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116014', 'Bạc', '5G 2TB', 81990000, 77990000, 20, '/uploads/products/apple/c3c7bf22afc3c441.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/201ba8a963a46336.png', 'iPad Pro chip M5 13 inch', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/71a631be51f2e914.jpg', 'iPad Pro chip M5 13 inch', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/74e4c2b951ee5d41.png', 'iPad Pro chip M5 13 inch', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a49521a14dddc364.png', 'iPad Pro chip M5 13 inch', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cae6d88a5825706f.png', 'iPad Pro chip M5 13 inch', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b9285ca295e8535c.png', 'iPad Pro chip M5 13 inch', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5dd6d19cf3addc22.png', 'iPad Pro chip M5 13 inch', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3faba2e1a0c707ce.png', 'iPad Pro chip M5 13 inch', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0eab2844159ebf0e.png', 'iPad Pro chip M5 13 inch', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4ae3d1918c72a981.png', 'iPad Pro chip M5 13 inch', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fa090efa3bba32de.png', 'iPad Pro chip M5 13 inch', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Pro M4 11 inch', 'ipad-pro-m4-11-inch', 'CPS-ipad-pro-m4-11-inch', 'Thiết kế siêu mỏng, gọn nhẹ để mang đi khắp nơi · Màn hình Ultra Retina XDR sử dụng công nghệ OLED hai lớp · Chip Apple M4 mạnh mẽ kết hợp nhiều tính năng AI hiện đại', 'Thiết kế siêu mỏng, gọn nhẹ để mang đi khắp nơi
Màn hình Ultra Retina XDR sử dụng công nghệ OLED hai lớp
Chip Apple M4 mạnh mẽ kết hợp nhiều tính năng AI hiện đại
Magic Keyboard có thiết kế mới, mỏng và mượt hơn

Kích thước màn hình: 11 inches
Độ phân giải: 2420x1668 pixel
Chip: Apple M4
CPU: CPU 9 lõi với 3 lõi hiệu năng và 6 lõi tiết kiệm điện
GPU: Apple GPU 10 nhân
Bộ nhớ trong: 2 TB
Camera sau: Camera góc siêu rộng 12MP, ƒ/2.4
Camera trước: Camera góc rộng: 12MP, ƒ/1.8
Pin: 31.29 Wh
Hệ điều hành: iPadOS
Kích thước: 249.7 x 177.5 x 5.3 mm
Trọng lượng: 444gram
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax) với MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/a90eb551e9a04414.png', 41990000, 0, 1, 790);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81934', 'Đen', 'Wifi 2TB', 65490000, 41990000, 20, '/uploads/products/apple/a90eb551e9a04414.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81935', 'Bạc', 'Wifi 2TB', 65490000, 41990000, 20, '/uploads/products/apple/5fa56ab903e2ee5b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84403', 'Đen', 'Wifi 2TB Nano', 68290000, 42990000, 20, '/uploads/products/apple/624b535a9c0acc1e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84404', 'Bạc', 'Wifi 2TB Nano', 68290000, 42990000, 20, '/uploads/products/apple/808b18a6cc273aa7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81942', 'Đen', '5G 2TB', 69990000, 43490000, 20, '/uploads/products/apple/329185ca639c53eb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81943', 'Bạc', '5G 2TB', 69990000, 43490000, 20, '/uploads/products/apple/d580dec3c4af4843.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84407', 'Đen', '5G 2TB Nano', 73990000, 44490000, 20, '/uploads/products/apple/8db704e2833f257b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84409', 'Bạc', '5G 2TB Nano', 73990000, 44490000, 20, '/uploads/products/apple/849e3a89844f5031.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/009bb62c52f8d155.png', 'iPad Pro M4 11 inch', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/268574dd91ddfff4.png', 'iPad Pro M4 11 inch', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/be9a1f4190895e81.png', 'iPad Pro M4 11 inch', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3afe7a671ff2319f.png', 'iPad Pro M4 11 inch', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bdf21f77bb20287f.png', 'iPad Pro M4 11 inch', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ebb1972bdf4d20e0.png', 'iPad Pro M4 11 inch', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bd64f212627e5d52.png', 'iPad Pro M4 11 inch', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d902a232ee797574.png', 'iPad Pro M4 11 inch', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2634a1d7ed00ddfc.png', 'iPad Pro M4 11 inch', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/624b535a9c0acc1e.png', 'iPad Pro M4 11 inch', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/808b18a6cc273aa7.png', 'iPad Pro M4 11 inch', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Pro M4 13 inch', 'ipad-pro-m4-13-inch', 'CPS-ipad-pro-m4-13-inch', 'iPad Pro M4 hoạt động trên nền tảng iPadOS, thúc đẩy hiệu suất làm việc với khả năng chạy đồng thời nhiều ứng dụng. · Tính năng Viết Chữ cho phép bạn dùng Apple Pencil để ghi chú trực tiếp vào bất kỳ ô văn bản nào, đồng thời dễ dàng chỉnh sửa và chia sẻ hình ảnh. · Quản Lý Màn Hình giúp việc đa nhiệm trở nên thuận tiện hơn với các ứng dụng có thể thay đổi kích thước và xếp chồng lên nhau.', 'iPad Pro M4 hoạt động trên nền tảng iPadOS, thúc đẩy hiệu suất làm việc với khả năng chạy đồng thời nhiều ứng dụng.
Tính năng Viết Chữ cho phép bạn dùng Apple Pencil để ghi chú trực tiếp vào bất kỳ ô văn bản nào, đồng thời dễ dàng chỉnh sửa và chia sẻ hình ảnh.
Quản Lý Màn Hình giúp việc đa nhiệm trở nên thuận tiện hơn với các ứng dụng có thể thay đổi kích thước và xếp chồng lên nhau.
iPad Pro còn cung cấp hơn một triệu ứng dụng được thiết kế riêng cho iPad trên App Store, bao gồm các ứng dụng quan trọng như Safari, Tin Nhắn và Keynote.

Kích thước màn hình: 13 inches
Độ phân giải: 2752x2064 pixels
Chip: Apple M4
CPU: CPU 10 lõi với 4 lõi hiệu năng và 6 lõi tiết kiệm điện
GPU: Apple GPU 10 nhân
Bộ nhớ trong: 2 TB
Camera sau: Camera góc siêu rộng 12MP, ƒ/2.4
Camera trước: Camera góc rộng: 12MP, ƒ/1.8
Pin: 38.99 Wh
Hệ điều hành: iPadOS
Kích thước: 281.6 x 215.5 x 5.1 mm
Trọng lượng: 579gram
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax) với MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/f365b9ee19d98d09.png', 42990000, 0, 1, 750);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81950', 'Đen', 'Wifi 2TB', 74490000, 42990000, 20, '/uploads/products/apple/f365b9ee19d98d09.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81951', 'Bạc', 'Wifi 2TB', 74490000, 42990000, 20, '/uploads/products/apple/a73e0ea26eb598ca.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84408', 'Đen', 'Wifi 2TB Nano', 77290000, 43990000, 20, '/uploads/products/apple/3433898e78997655.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84410', 'Bạc', 'Wifi 2TB Nano', 77290000, 43990000, 20, '/uploads/products/apple/9d8cf2c1e3dc3e80.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81958', 'Đen', '5G 2TB', 79990000, 44990000, 20, '/uploads/products/apple/4b7628f4c4a3e71f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-81959', 'Bạc', '5G 2TB', 79990000, 45990000, 20, '/uploads/products/apple/84c353070e3db787.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84399', 'Đen', '5G 2TB Nano', 82490000, 46990000, 20, '/uploads/products/apple/61c3fb3cf139c291.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-84400', 'Bạc', '5G 2TB Nano', 82490000, 46990000, 20, '/uploads/products/apple/ccfdc6538fe4ed9c.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2abed9dfd6849800.png', 'iPad Pro M4 13 inch', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/22f5d82480cec54f.png', 'iPad Pro M4 13 inch', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/03d2153862634896.png', 'iPad Pro M4 13 inch', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/372e58f939a8551e.png', 'iPad Pro M4 13 inch', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a2cdf7f8a88ed098.png', 'iPad Pro M4 13 inch', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0795b8287b52f573.png', 'iPad Pro M4 13 inch', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/66200f7d3044736e.png', 'iPad Pro M4 13 inch', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a2e2b9c39fa9fde4.png', 'iPad Pro M4 13 inch', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5b3f6f4c2fd88f30.png', 'iPad Pro M4 13 inch', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3433898e78997655.png', 'iPad Pro M4 13 inch', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9d8cf2c1e3dc3e80.png', 'iPad Pro M4 13 inch', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'may-tinh-bang'), @brand, 'iPad Air 13 inch M3 2025', 'ipad-air-13-inch-m3-2025', 'CPS-ipad-air-13-inch-m3-2025', 'iPad Air sở hữu camera trước 12MP Center Stage, lý tưởng cho các cuộc gọi video và chụp ảnh selfie sắc nét. · Camera sau Wide 12MP cho phép bạn quét tài liệu, chụp ảnh và quay video 4K chất lượng cao, mang đến trải nghiệm hình ảnh ấn tượng. · Với kết nối Wi-Fi 6E, bạn có thể nhanh chóng chuyển ảnh và tài liệu, trong khi khả năng kết nối di động 5G giúp duy trì kết nối mọi lúc mọi nơi.', 'iPad Air sở hữu camera trước 12MP Center Stage, lý tưởng cho các cuộc gọi video và chụp ảnh selfie sắc nét.
Camera sau Wide 12MP cho phép bạn quét tài liệu, chụp ảnh và quay video 4K chất lượng cao, mang đến trải nghiệm hình ảnh ấn tượng.
Với kết nối Wi-Fi 6E, bạn có thể nhanh chóng chuyển ảnh và tài liệu, trong khi khả năng kết nối di động 5G giúp duy trì kết nối mọi lúc mọi nơi.
Tính năng Touch ID tích hợp vào nút nguồn cho phép bạn mở khóa iPad Air và thanh toán an toàn qua Apple Pay chỉ bằng một cái chạm.

Kích thước màn hình: 13 inches
Độ phân giải: 2732 x 2048 pixels
Chip: Chip Apple M3
CPU: CPU 8 lõi với 4 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 9 lõi , Neural Engine 16 lõi, Công nghệ dò tia tốc độ cao bằng phần cứng
Bộ nhớ trong: 128 GB
Camera sau: Camera góc rộng: 12MP, ƒ/1.8, Độ thu phóng kỹ thuật số lên đến 5x, Chụp ảnh toàn cảnh Panorama: 63MP
Camera trước: Camera 12MP, ƒ/2.0
Pin: Tích hợp pin sạc Li-Po 36,59 watt‑giờ
Hệ điều hành: iPadOS
Kích thước: 280,6 x 214,9 x 6,1 mm
Trọng lượng: 617 gram
SIM: 1 eSIM
Bluetooth: v5.3
Wi-Fi: Wi‑Fi 6E (802.11ax) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/7cac9beced61fb54.jpg', 21590000, 0, 1, 660);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101683', 'Xám', 'Wifi 128GB', 26990000, 21590000, 20, '/uploads/products/apple/7cac9beced61fb54.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101684', 'Xanh dương', 'Wifi 128GB', 26990000, 21590000, 20, '/uploads/products/apple/7e931a164ad6fde7.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101685', 'Trắng vàng', 'Wifi 128GB', 26990000, 21590000, 20, '/uploads/products/apple/53fdd980ce08a7c1.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101686', 'Tím', 'Wifi 128GB', 26990000, 21590000, 20, '/uploads/products/apple/99f30034418b3ad1.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101687', 'Xám', 'Wifi 256GB', 29490000, 24490000, 20, '/uploads/products/apple/7ecf4dafbfbc6aa0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101688', 'Xanh dương', 'Wifi 256GB', 29490000, 24490000, 20, '/uploads/products/apple/1ec0a599f5b87f91.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101689', 'Trắng vàng', 'Wifi 256GB', 29490000, 24490000, 20, '/uploads/products/apple/cc02409dc6d99f15.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101690', 'Tím', 'Wifi 256GB', 29490000, 24490000, 20, '/uploads/products/apple/9e37c2ff9636da83.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101700', 'Xám', '5G 128GB', 30990000, 24990000, 20, '/uploads/products/apple/b94ce723e5ff6e3e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101701', 'Xanh dương', '5G 128GB', 30990000, 24990000, 20, '/uploads/products/apple/b0af4823f11d997d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101702', 'Trắng vàng', '5G 128GB', 30990000, 24990000, 20, '/uploads/products/apple/6cda22998b223350.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101703', 'Tím', '5G 128GB', 30990000, 23990000, 20, '/uploads/products/apple/1a7617376fdef934.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/38f8cca401bf63bf.jpg', 'iPad Air 13 inch M3 2025', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9eb242634c46e47d.jpg', 'iPad Air 13 inch M3 2025', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/50c6261b67ba56ea.jpg', 'iPad Air 13 inch M3 2025', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1f33bd17b1c6c6ea.jpg', 'iPad Air 13 inch M3 2025', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/46484068a3c20e81.jpg', 'iPad Air 13 inch M3 2025', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c8cfb9c81491fe19.jpg', 'iPad Air 13 inch M3 2025', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b712cf8c3c4ca8b3.jpg', 'iPad Air 13 inch M3 2025', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b61308efaee275b5.jpg', 'iPad Air 13 inch M3 2025', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b5d92621036d5441.jpg', 'iPad Air 13 inch M3 2025', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/78deac757091c39d.jpg', 'iPad Air 13 inch M3 2025', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b94ce723e5ff6e3e.jpg', 'iPad Air 13 inch M3 2025', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b0af4823f11d997d.jpg', 'iPad Air 13 inch M3 2025', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6cda22998b223350.jpg', 'iPad Air 13 inch M3 2025', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1a7617376fdef934.jpg', 'iPad Air 13 inch M3 2025', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 18 Pro', 'iphone-18-pro', 'CPS-iphone-18-pro', 'Màn hình: OLED Super Retina XDR 6,3 inch, ProMotion 120Hz, độ sáng tối đa 3.000 nit. · Hiệu năng: Chip A20 Pro tiến trình 2nm, GPU 7 lõi, hỗ trợ AI. · Camera: Bộ 3 camera sau 48MP, zoom quang học 4x, quay video 4K Dolby Vision 120 fps; camera trước 18MP.', 'Màn hình: OLED Super Retina XDR 6,3 inch, ProMotion 120Hz, độ sáng tối đa 3.000 nit.
Hiệu năng: Chip A20 Pro tiến trình 2nm, GPU 7 lõi, hỗ trợ AI.
Camera: Bộ 3 camera sau 48MP, zoom quang học 4x, quay video 4K Dolby Vision 120 fps; camera trước 18MP.
Pin và sạc: Xem video đến 34 giờ, sạc 50% trong khoảng 15 phút.
Thiết kế: Khung nhôm nguyên khối, Ceramic Shield 2, kháng nước IP68, trọng lượng 211g.
Kết nối và tính năng: 5G, Wi-Fi 7, Bluetooth 6, Face ID, Apple Intelligence hỗ trợ tiếng Việt.

Kích thước màn hình: 6.3 inches
Độ phân giải: 2622 x 1206 pixels
Chip: A20 Pro
CPU: CPU 6 lõi với 2 siêu lõi và 4 lõi hiệu suất
GPU: GPU 7 lõi
Bộ nhớ trong: 256 GB
Camera sau: 48 MP Fusion Main, f/1,48 / f/1,8 / f/2,8 / f/4,0, 48 MP Fusion Ultra Wide, f/2,2, 48 MP Fusion Telephoto, f/2,8, Telephoto 2x chất lượng quang học 12 MP, Telephoto 8x chất lượng quang học 12 MP, f/2,8
Camera trước: 18 MP Center Stage, f/1,9 Tự động lấy nét theo pha Focus Pixels
Pin: Pin lithium-ion tích hợp
Hệ điều hành: iOS
Kích thước: 150 × 71,9 × 8,75 mm
Trọng lượng: 211 g
SIM: Nano-SIM + eSIM
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be), 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/1350837750caa750.jpg', 38690000, 1, 1, 990);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141671', 'Đỏ Burgundy', '256GB', 38990000, NULL, 20, '/uploads/products/apple/1350837750caa750.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141674', 'Băng Thanh', '256GB', 38990000, NULL, 20, '/uploads/products/apple/e4defdcec24b63ac.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141681', 'Bạc', '256GB', 38990000, NULL, 20, '/uploads/products/apple/b14f8efcf85877e2.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141682', 'Đen', '256GB', 38990000, 38690000, 20, '/uploads/products/apple/da464d3c9ef40eaf.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141665', 'Đỏ Burgundy', '512GB', 45490000, NULL, 20, '/uploads/products/apple/d8bd516ae537c21a.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141666', 'Băng Thanh', '512GB', 45490000, NULL, 20, '/uploads/products/apple/eeac8e4706373da7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141667', 'Đen', '512GB', 45490000, NULL, 20, '/uploads/products/apple/e8902b27b4ad5dda.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141668', 'Bạc', '512GB', 45490000, NULL, 20, '/uploads/products/apple/28fe45ad8b4895c9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141672', 'Đỏ Burgundy', '1TB', 58490000, 55990000, 20, '/uploads/products/apple/f161b26453be8330.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141676', 'Băng Thanh', '1TB', 58490000, 55990000, 20, '/uploads/products/apple/6eb1fb1dd8f45f3b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141678', 'Đen', '1TB', 58490000, 55490000, 20, '/uploads/products/apple/996efc2cdd408147.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141680', 'Bạc', '1TB', 58490000, 55990000, 20, '/uploads/products/apple/0b5300443f55f7a3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141691', 'Đỏ Burgundy', '2TB', 77990000, 74990000, 20, '/uploads/products/apple/283918c440f63385.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141695', 'Băng Thanh', '2TB', 77990000, 74990000, 20, '/uploads/products/apple/9c68b89321a63d51.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141696', 'Đen', '2TB', 77990000, 74990000, 20, '/uploads/products/apple/fc3f963d257032c6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141697', 'Bạc', '2TB', 77990000, 74990000, 20, '/uploads/products/apple/7b3eb246b3c5da70.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8d02f768f7f50c91.jpg', 'iPhone 18 Pro', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a341b472ffe861ed.jpg', 'iPhone 18 Pro', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/923b7d0043dbd753.jpg', 'iPhone 18 Pro', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ae3ca3f7385fbbf6.jpg', 'iPhone 18 Pro', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b2d2db961f74a727.jpg', 'iPhone 18 Pro', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/02bb21e3350b2a4b.jpg', 'iPhone 18 Pro', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bba8f18cec5b91f2.jpg', 'iPhone 18 Pro', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fa4c99185ac98238.jpg', 'iPhone 18 Pro', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e4c1b65164dbdb21.jpg', 'iPhone 18 Pro', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f7e967030e64eb82.jpg', 'iPhone 18 Pro', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ad7394d676a5ab2b.jpg', 'iPhone 18 Pro', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1350837750caa750.jpg', 'iPhone 18 Pro', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e4defdcec24b63ac.jpg', 'iPhone 18 Pro', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b14f8efcf85877e2.jpg', 'iPhone 18 Pro', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/da464d3c9ef40eaf.jpg', 'iPhone 18 Pro', 14);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 18 Pro Max', 'iphone-18-pro-max', 'CPS-iphone-18-pro-max', 'Màn hình: OLED Super Retina XDR 6,9 inch, ProMotion 120Hz, độ sáng tối đa 3.000 nit. · Hiệu năng: Chip A20 Pro 2nm, GPU 7 lõi, tản nhiệt buồng hơi, hỗ trợ AI. · Camera: Bộ 3 camera sau 48MP, zoom quang học 4x, zoom số 40x, quay video 4K Dolby Vision 120 fps; camera trước 18MP.', 'Màn hình: OLED Super Retina XDR 6,9 inch, ProMotion 120Hz, độ sáng tối đa 3.000 nit.
Hiệu năng: Chip A20 Pro 2nm, GPU 7 lõi, tản nhiệt buồng hơi, hỗ trợ AI.
Camera: Bộ 3 camera sau 48MP, zoom quang học 4x, zoom số 40x, quay video 4K Dolby Vision 120 fps; camera trước 18MP.
Pin và sạc: Xem video đến 43 giờ, sạc 50% trong khoảng 15 phút, hỗ trợ MagSafe và Qi2 25W.
Thiết kế: Khung nhôm nguyên khối, Ceramic Shield 2, kháng nước IP68, trọng lượng 249g.
Kết nối và tính năng: 5G, Wi-Fi 7, Bluetooth 6, SIM kép, Face ID, Apple Intelligence hỗ trợ tiếng Việt.

Kích thước màn hình: 6.9 inches
Độ phân giải: 2868 x 1320 pixels
Chip: Apple A20 Pro
CPU: CPU 6 lõi với 2 siêu lõi và 4 lõi hiệu suất
GPU: GPU 7 lõi
Bộ nhớ trong: 256 GB
Camera sau: 48 MP Fusion Main, f/1,48 / f/1,8 / f/2,8 / f/4,0, 48 MP Fusion Ultra Wide, f/2,2, 48 MP Fusion Telephoto, f/2,8, Telephoto 2x chất lượng quang học 12 MP, Telephoto 8x chất lượng quang học 12 MP, f/2,8
Camera trước: 18 MP Center Stage, f/1,9, Tự động lấy nét theo pha Focus Pixels
Pin: Pin lithium-ion tích hợp
Hệ điều hành: iOS
Kích thước: 163,4 x 78 x 8,75 mm
Trọng lượng: 249 g
SIM: Nano-SIM + eSIM
Bluetooth: Bluetooth 6.0
Wi-Fi: Wi-Fi 7 (802.11be) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/46848d9071a81423.jpg', 41690000, 1, 1, 980);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141687', 'Đỏ Burgundy', '256GB', 41990000, NULL, 20, '/uploads/products/apple/46848d9071a81423.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141689', 'Băng Thanh', '256GB', 41990000, NULL, 20, '/uploads/products/apple/0117d0e24b3498d8.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141690', 'Đen', '256GB', 41990000, 41690000, 20, '/uploads/products/apple/cb36d786b399ad96.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141693', 'Bạc', '256GB', 41990000, NULL, 20, '/uploads/products/apple/00a91cb3ce6473d5.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141673', 'Đỏ Burgundy', '512GB', 48490000, NULL, 20, '/uploads/products/apple/918829c743b59810.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141675', 'Băng Thanh', '512GB', 48490000, NULL, 20, '/uploads/products/apple/5a5c2066fa5a31c1.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141677', 'Đen', '512GB', 48490000, NULL, 20, '/uploads/products/apple/40cb6c684015d535.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141679', 'Bạc', '512GB', 48490000, NULL, 20, '/uploads/products/apple/0f9505bbbef31818.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141702', 'Đỏ Burgundy', '1TB', 61490000, 59990000, 20, '/uploads/products/apple/ae020c4747759a50.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141703', 'Băng Thanh', '1TB', 61490000, 59990000, 20, '/uploads/products/apple/edcce5341dcca7d0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141704', 'Đen', '1TB', 61490000, 59490000, 20, '/uploads/products/apple/9906fc55beb666e3.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141705', 'Bạc', '1TB', 61490000, 59990000, 20, '/uploads/products/apple/f45137193c0698ba.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141709', 'Đỏ Burgundy', '2TB', 80990000, 78990000, 20, '/uploads/products/apple/396b362dd3037d25.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141710', 'Băng Thanh', '2TB', 80990000, 78990000, 20, '/uploads/products/apple/87835757735f1de5.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141711', 'Đen', '2TB', 80990000, 77990000, 20, '/uploads/products/apple/0cce3aece00cbf75.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141712', 'Bạc', '2TB', 80990000, 78990000, 20, '/uploads/products/apple/f3337efc4027c114.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1db32b46efb1df95.jpg', 'iPhone 18 Pro Max', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/16a6d8f5c83523f3.jpg', 'iPhone 18 Pro Max', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f08f3b3aa8419c11.jpg', 'iPhone 18 Pro Max', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c8592b7c91988a80.jpg', 'iPhone 18 Pro Max', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ed16badc97642da5.jpg', 'iPhone 18 Pro Max', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b3d529839cb9490e.jpg', 'iPhone 18 Pro Max', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/092880eed7c50d74.jpg', 'iPhone 18 Pro Max', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5b0aaecdd05f5873.jpg', 'iPhone 18 Pro Max', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7a526896b3023c76.jpg', 'iPhone 18 Pro Max', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fa027a2e31366f20.jpg', 'iPhone 18 Pro Max', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/745dd3bd3ff89fc2.jpg', 'iPhone 18 Pro Max', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/46848d9071a81423.jpg', 'iPhone 18 Pro Max', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0117d0e24b3498d8.jpg', 'iPhone 18 Pro Max', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cb36d786b399ad96.jpg', 'iPhone 18 Pro Max', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/00a91cb3ce6473d5.jpg', 'iPhone 18 Pro Max', 14);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 17 Pro Max', 'iphone-17-pro-max', 'CPS-iphone-17-pro-max', 'Thiết kế iPhone 17 Pro Max nguyên khối nhôm rèn nhiệt mang đến sức mạnh vượt trội và dung lượng pin lớn hơn bao giờ hết · Ceramic Shield bền chắc bảo vệ mặt trước và sau chống nứt gấp 4 lần và chống trầy xước gấp 3 lần · Hệ thống camera pro fusion 48MP và camera trước 18MP hỗ trợ thu phóng quang học 8x cùng nhiều tính năng quay chụp thông minh', 'Thiết kế iPhone 17 Pro Max nguyên khối nhôm rèn nhiệt mang đến sức mạnh vượt trội và dung lượng pin lớn hơn bao giờ hết
Ceramic Shield bền chắc bảo vệ mặt trước và sau chống nứt gấp 4 lần và chống trầy xước gấp 3 lần
Hệ thống camera pro fusion 48MP và camera trước 18MP hỗ trợ thu phóng quang học 8x cùng nhiều tính năng quay chụp thông minh
Chip A19 Pro với tản nhiệt hơi nước hiệu năng mạnh mẽ nhất từ trước đến nay duy trì ổn định hơn đến 40%
Thời lượng pin dài nhất từng có trên iPhone xem video liên tục 37 giờ và sạc nhanh 50% trong 20 phút

Kích thước màn hình: 6.9 inches
Độ phân giải: 2868 x 1320 pixels
Chip: Chip A19 Pro
CPU: CPU 6 lõi với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 6 lõi với Neural Accelerator
Bộ nhớ trong: 256 GB
Camera sau: Chính: 48MP khẩu độ ƒ/1.6 OIS hỗ trợ chụp 24MP hoặc 48MP, Góc Siêu Rộng: 48MP khẩu độ ƒ/2.2 góc nhìn 120°, Telephoto: 48MP khẩu độ ƒ/2.8 OIS zoom quang học lên đến 8x
Camera trước: Camera 18MP Center Stage Khẩu độ ƒ/1.9
Hệ điều hành: iOS
Kích thước: 163,4 x 78,0 x 8,75 mm
Trọng lượng: 231 g
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 6
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO11
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/c4b02696f4c1e6a0.jpg', 34990000, 1, 1, 970);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112613', 'Bạc', '256GB', 39990000, 34990000, 20, '/uploads/products/apple/c4b02696f4c1e6a0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112615', 'Cam Vũ Trụ', '256GB', 39990000, 34990000, 20, '/uploads/products/apple/15dab0f9d55391ea.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112617', 'Xanh đậm', '256GB', 39990000, 34990000, 20, '/uploads/products/apple/9f7867f2f6d4fc6e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112621', 'Bạc', '512GB', 46490000, 44490000, 20, '/uploads/products/apple/b969381d21ac92c9.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112623', 'Cam Vũ Trụ', '512GB', 46490000, 41490000, 20, '/uploads/products/apple/0c2d85ff14f397a0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112624', 'Xanh Đậm', '512GB', 46490000, 41390000, 20, '/uploads/products/apple/b8acaae099e2c700.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112629', 'Bạc', '1TB', 50990000, 47490000, 20, '/uploads/products/apple/f4f3424b916b91ec.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112630', 'Cam Vũ Trụ', '1TB', 50990000, 47490000, 20, '/uploads/products/apple/2df660ec29073de6.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112632', 'Xanh Đậm', '1TB', 50990000, 47490000, 20, '/uploads/products/apple/53ed0809bce2a6c9.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112633', 'Bạc', '2TB', 63990000, 60290000, 20, '/uploads/products/apple/b3095b3dbf014be6.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112635', 'Cam Vũ Trụ', '2TB', 63990000, 60290000, 20, '/uploads/products/apple/ea64b79f7f30dbaf.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112637', 'Xanh Đậm', '2TB', 63990000, 60290000, 20, '/uploads/products/apple/88a2b81e6c650e43.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4274885697a8536c.jpg', 'iPhone 17 Pro Max', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/094795e0412a29f0.jpg', 'iPhone 17 Pro Max', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dd6bf6f3908cd9ef.jpg', 'iPhone 17 Pro Max', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/feda2234b8f809ff.jpg', 'iPhone 17 Pro Max', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/12454764282ab275.jpg', 'iPhone 17 Pro Max', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d35892b6677f3acb.jpg', 'iPhone 17 Pro Max', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/462f025d90ce0c38.jpg', 'iPhone 17 Pro Max', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e73cb1676d02b729.jpg', 'iPhone 17 Pro Max', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4d19c352692b4e30.jpg', 'iPhone 17 Pro Max', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b90b424c3e775f6f.jpg', 'iPhone 17 Pro Max', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e6e9eab22a4c70d8.jpg', 'iPhone 17 Pro Max', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c4b02696f4c1e6a0.jpg', 'iPhone 17 Pro Max', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/15dab0f9d55391ea.jpg', 'iPhone 17 Pro Max', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9f7867f2f6d4fc6e.jpg', 'iPhone 17 Pro Max', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 17 Pro', 'iphone-17-pro', 'CPS-iphone-17-pro', 'Thiết kế điện thoại iPhone 17 pro 256GB nguyên khối cho sức mạnh vượt trội nhôm rèn nhiệt tạo nên chiếc iphone mạnh mẽ nhất từng được chế tác · Ceramic shield bền chắc mặt trước và sau bảo vệ chống nứt gấp 4 lần và chống trầy xước gấp 3 lần · Hệ thống camera 48MP pro fusion và camera trước 18MP thu phóng quang học 8x cùng nhiều tính năng quay chụp thông minh', 'Thiết kế điện thoại iPhone 17 pro 256GB nguyên khối cho sức mạnh vượt trội nhôm rèn nhiệt tạo nên chiếc iphone mạnh mẽ nhất từng được chế tác
Ceramic shield bền chắc mặt trước và sau bảo vệ chống nứt gấp 4 lần và chống trầy xước gấp 3 lần
Hệ thống camera 48MP pro fusion và camera trước 18MP thu phóng quang học 8x cùng nhiều tính năng quay chụp thông minh
Chip A19 Pro với tản nhiệt hơi nước hiệu năng mạnh mẽ nhất từ trước đến nay duy trì ổn định hơn đến 40%
Thời lượng pin đột phá xem video liên tục đến 31 giờ và sạc nhanh 50% chỉ trong 20 phút

Kích thước màn hình: 6.3 inches
Độ phân giải: 2622 x 1206 pixels
Chip: Chip A19 Pro
CPU: CPU 6 lõi với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 6 lõi với Neural Accelerator
Bộ nhớ trong: 256 GB
Camera sau: Chính: 48MP khẩu độ ƒ/1.6 OIS hỗ trợ chụp 24MP hoặc 48MP, Góc Siêu Rộng: 48MP khẩu độ ƒ/2.2 góc nhìn 120°, Telephoto: 48MP khẩu độ ƒ/2.8 OIS zoom quang học lên đến 8x
Camera trước: Camera 18MP Center Stage Khẩu độ ƒ/1.9
Hệ điều hành: iOS
Kích thước: 150 x 71.9 x 8.75 mm
Trọng lượng: 204g
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 6
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO11
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/fa420c77b33e3e62.jpg', 31990000, 0, 1, 960);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112596', 'Bạc', '256GB', 34990000, 31990000, 20, '/uploads/products/apple/fa420c77b33e3e62.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112597', 'Cam Vũ Trụ', '256GB', 34990000, 31990000, 20, '/uploads/products/apple/007e84b479452194.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112599', 'Xanh Đậm', '256GB', 34990000, 31990000, 20, '/uploads/products/apple/e405f73cc7fe728e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112603', 'Bạc', '512GB', 41490000, 38490000, 20, '/uploads/products/apple/93806e39564156f5.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112604', 'Cam Vũ Trụ', '512GB', 41490000, 38490000, 20, '/uploads/products/apple/17a92517c30ff649.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112605', 'Xanh Đậm', '512GB', 41490000, 38490000, 20, '/uploads/products/apple/7889085d4017ce76.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112606', 'Bạc', '1TB', 47990000, 44790000, 20, '/uploads/products/apple/99c653e2a0c90d67.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112607', 'Cam Vũ Trụ', '1TB', 47990000, 44790000, 20, '/uploads/products/apple/39cefe2915927e9f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112609', 'Xanh Đậm', '1TB', 47990000, 44690000, 20, '/uploads/products/apple/c9982f244e662f15.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9443793669411227.png', 'iPhone 17 Pro', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/accbbf4dcd355132.jpg', 'iPhone 17 Pro', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d69e4a18086cafcd.jpg', 'iPhone 17 Pro', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9df43159dc0ee75a.jpg', 'iPhone 17 Pro', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ff6202100d5d2b60.jpg', 'iPhone 17 Pro', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8e3d933aa5f5530c.jpg', 'iPhone 17 Pro', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/529c2c0d7dddf5f9.jpg', 'iPhone 17 Pro', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e49d9e620851d1cb.jpg', 'iPhone 17 Pro', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a8838319260eabb7.jpg', 'iPhone 17 Pro', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f54ca134ee024c6d.jpg', 'iPhone 17 Pro', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f419bf2dc3168490.jpg', 'iPhone 17 Pro', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fa420c77b33e3e62.jpg', 'iPhone 17 Pro', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/007e84b479452194.jpg', 'iPhone 17 Pro', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e405f73cc7fe728e.jpg', 'iPhone 17 Pro', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone Duo', 'iphone-duo', 'CPS-iphone-duo', 'iPhone Duo giá từ 64.990.000đ: Điện thoại gập đầu tiên của Apple, đặt trước từ 16/10/2026, mở bán 23/10/2026. Bản 256GB, màu Trắng Ánh Sao và Trời Đêm. · Thiết kế gập titan cấp 5: Dày 5,2mm khi mở, 11,3mm khi gập, nặng 254g, kháng nước IP68. · Màn hình kép 120Hz: Màn hình trong 7,6 inch, màn hình ngoài 5,4 inch Super Retina XDR OLED, độ sáng tối đa 3.000 nit.', 'iPhone Duo giá từ 64.990.000đ: Điện thoại gập đầu tiên của Apple, đặt trước từ 16/10/2026, mở bán 23/10/2026. Bản 256GB, màu Trắng Ánh Sao và Trời Đêm.
Thiết kế gập titan cấp 5: Dày 5,2mm khi mở, 11,3mm khi gập, nặng 254g, kháng nước IP68.
Màn hình kép 120Hz: Màn hình trong 7,6 inch, màn hình ngoài 5,4 inch Super Retina XDR OLED, độ sáng tối đa 3.000 nit.
Hiệu năng mạnh mẽ: Chip A20 Pro 2nm, CPU 6 lõi, GPU 7 lõi, tản nhiệt buồng hơi.
Camera 48MP: Camera kép 48MP, zoom 2x; camera trước 12MP Center Stage và camera ẩn dưới màn hình.
Pin và sạc: Xem video đến 44 giờ, sạc 50% trong 20 phút với củ sạc 60W, hỗ trợ MagSafe 25W.
Tiện ích: Touch ID, eSIM kép, 5G, Wi-Fi 7, iOS 27.0.1, Apple Intelligence tiếng Việt và hỗ trợ Apple Pencil (USB-C) qua cập nhật.

Kích thước màn hình: Trong 7.6 inches - Ngoài 5.4 inches
Độ phân giải: Trong 1878 x 2670 pixel - Ngoài 1398 x 2034 pixel
Chip: Chip A20 Pro
CPU: CPU 6 lõi với 2 lõi siêu xử lý và 4 lõi tiết kiệm điện
GPU: GPU 7 lõi với Neural Accelerators
Bộ nhớ trong: 256 GB
Camera sau: 48 MP, f/1,6 Fusion Main, 12 MP, f/1,6 Telephoto 2x chất lượng quang học, 48 MP, f/2,2 Fusion Ultra Wide, góc nhìn 120°
Camera trước: Bên ngoài: 12 MP Center Stage, ƒ/2.2, Flash Retina, Bên trong: Camera FaceTime dưới màn hình, ƒ/1.8
Pin: Tích hợp hai pin sạc lithium-ion
Hệ điều hành: iOS
Kích thước: Mở: 164,6 x 117,8 x 5,2 mm, Đóng: 84,1 x 117,8 x 11,3 mm
Trọng lượng: 254 g
SIM: 2 eSIM
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be), 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/a689267718492564.jpg', 64990000, 0, 1, 950);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141714', 'Trắng Ánh Sao', '256GB', 64990000, NULL, 20, '/uploads/products/apple/a689267718492564.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141715', 'Trời Đêm', '256GB', 64990000, NULL, 20, '/uploads/products/apple/6245c846cd3759cb.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141685', 'Trắng Ánh Sao', '512GB', 71490000, NULL, 20, '/uploads/products/apple/d9bc77ae21614445.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141686', 'Trời Đêm', '512GB', 71490000, NULL, 20, '/uploads/products/apple/d12d2e7a5e37ed46.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141698', 'Trắng Ánh Sao', '1TB', 84490000, NULL, 20, '/uploads/products/apple/b61fade5f0d1b838.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141700', 'Trời Đêm', '1TB', 84490000, NULL, 20, '/uploads/products/apple/dcb3069c4c398f82.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141706', 'Trắng Ánh Sao', '2TB', 103990000, NULL, 20, '/uploads/products/apple/186f30fae1c2a8b4.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141707', 'Trời Đêm', '2TB', 103990000, NULL, 20, '/uploads/products/apple/91e35f013e86a667.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4087a4b83d5c0a9a.jpg', 'iPhone Duo', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a6b919f1bc699c3b.jpg', 'iPhone Duo', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c319ff6ec0025d5e.jpg', 'iPhone Duo', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a7013a9fec84e975.jpg', 'iPhone Duo', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/33a673d6eaa04e04.jpg', 'iPhone Duo', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/00474bd9996af5c5.jpg', 'iPhone Duo', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5202ff9b379f6d29.jpg', 'iPhone Duo', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bd6ec9b1ce12791d.jpg', 'iPhone Duo', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4a89f03b7639afde.jpg', 'iPhone Duo', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a689267718492564.jpg', 'iPhone Duo', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6245c846cd3759cb.jpg', 'iPhone Duo', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 17', 'iphone-17', 'CPS-iphone-17', 'Thiết kế bền bỉ với thời gian năm màu sắc nổi bật màn hình 6,3 inch sáng hơn và Ceramic shield 2 chống trầy gấp 3 lần · Màn hình 6,3 inch với promotion hỗ trợ 120Hz độ sáng đỉnh 3000 nit hiển thị ngoài trời rõ ràng và ít phản chiếu hơn · Hệ thống camera iPhone 17 thường tiên tiến camera sau 48MP dual fusion với zoom quang học 2x camera ultra wide 48MP và camera trước 18MP center stage', 'Thiết kế bền bỉ với thời gian năm màu sắc nổi bật màn hình 6,3 inch sáng hơn và Ceramic shield 2 chống trầy gấp 3 lần
Màn hình 6,3 inch với promotion hỗ trợ 120Hz độ sáng đỉnh 3000 nit hiển thị ngoài trời rõ ràng và ít phản chiếu hơn
Hệ thống camera iPhone 17 thường tiên tiến camera sau 48MP dual fusion với zoom quang học 2x camera ultra wide 48MP và camera trước 18MP center stage
Chip A19 hiệu năng mạnh mẽ năng lượng dồi dào gpu 5 lõi và neural engine cải tiến hỗ trợ quay video chơi game và đa nhiệm mượt mà
Pin dùng cả ngày sạc nhanh tiện lợi xem video đến 30 giờ và sạc 50% chỉ trong 20 phút

Kích thước màn hình: 6.3 inches
Độ phân giải: 2622 x 1206 pixels
Chip: Apple A19
CPU: 6 lõi (2 hiệu năng + 4 tiết kiệm điện)
GPU: GPU 5 lõi với Neural Accelerator
Bộ nhớ trong: 256 GB
Camera sau: 48MP Fusion Main f/1.6 OIS, 12MP Tele 2x f/1.6 OIS, 48MP Ultra Wide f/2.2 120°
Camera trước: 18MP Center Stage, f/1.9, PDAF
Pin: Xem video: 30 giờ, Xem video trực tuyến: 27 giờ
Hệ điều hành: iOS
Kích thước: 149.6 × 71.5 × 7.95 mm
Trọng lượng: 177 g
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 6
Wi-Fi: Wi‑Fi 7
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/3356b31c07822b7b.jpg', 28490000, 0, 1, 930);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112595', 'Đen', '256GB', 28990000, 28690000, 20, '/uploads/products/apple/3356b31c07822b7b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112598', 'Trắng', '256GB', 28990000, 28690000, 20, '/uploads/products/apple/9896e7d31d065b4f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112600', 'Xanh Lam Khói', '256GB', 28990000, 28690000, 20, '/uploads/products/apple/20cef4a8d8ae1cec.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112601', 'Tím Oải Hương', '256GB', 28990000, 28690000, 20, '/uploads/products/apple/b5bb84caa7c68c1b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112602', 'Xanh Lá Xô Thơm', '256GB', 28990000, 28490000, 20, '/uploads/products/apple/66def3b9bd12554e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112614', 'Đen', '512GB', 35490000, 33990000, 20, '/uploads/products/apple/1810722690de2098.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112616', 'Trắng', '512GB', 35490000, 33990000, 20, '/uploads/products/apple/bdcebb3454cbd90d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112619', 'Xanh Lam Khói', '512GB', 35490000, 33990000, 20, '/uploads/products/apple/9324d77962c89808.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112620', 'Tím Oải Hương', '512GB', 35490000, 33990000, 20, '/uploads/products/apple/a9e6cd56816baa62.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112622', 'Xanh Lá Xô Thơm', '512GB', 35490000, 33990000, 20, '/uploads/products/apple/4a8fb16ae9aae707.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6b1d6f1c01efb3dc.jpg', 'iPhone 17', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6e9b5dbcf0d94fc9.jpg', 'iPhone 17', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/10e28339a6c198f3.jpg', 'iPhone 17', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ccc1e3dec5f7c298.jpg', 'iPhone 17', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9702da95e9973c10.jpg', 'iPhone 17', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0f190835705dc405.jpg', 'iPhone 17', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ffd742b3e01fa0fb.jpg', 'iPhone 17', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/203cc31bb6480b30.jpg', 'iPhone 17', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3d6f75b651cc22ea.jpg', 'iPhone 17', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/769f588070d85e39.jpg', 'iPhone 17', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dde7e2e98c376771.jpg', 'iPhone 17', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3356b31c07822b7b.jpg', 'iPhone 17', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9896e7d31d065b4f.jpg', 'iPhone 17', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/20cef4a8d8ae1cec.jpg', 'iPhone 17', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b5bb84caa7c68c1b.jpg', 'iPhone 17', 14);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/66def3b9bd12554e.jpg', 'iPhone 17', 15);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone Air', 'iphone-air', 'CPS-iphone-air', 'Siêu mỏng nhẹ mạnh mẽ iPhone Air mỏng nhất từng có chỉ 5,6 mm nhưng vẫn sở hữu sức mạnh chip pro · Bền chắc vượt trội khung titan siêu nhẹ kết hợp Ceramic Shield bảo vệ chống nứt gấp 4 lần và chống trầy xước gấp 3 lần · Hệ thống camera tiên tiến camera sau 48MP fusion với zoom quang học 2x và camera trước 18MP center stage linh hoạt thông minh', 'Siêu mỏng nhẹ mạnh mẽ iPhone Air mỏng nhất từng có chỉ 5,6 mm nhưng vẫn sở hữu sức mạnh chip pro
Bền chắc vượt trội khung titan siêu nhẹ kết hợp Ceramic Shield bảo vệ chống nứt gấp 4 lần và chống trầy xước gấp 3 lần
Hệ thống camera tiên tiến camera sau 48MP fusion với zoom quang học 2x và camera trước 18MP center stage linh hoạt thông minh
Chip A19 Pro siêu tốc độ siêu hiệu quả mang đến hiệu năng pro mạnh mẽ cùng khả năng tiết kiệm điện trong thiết kế mỏng nhẹ
Thời lượng pin cả ngày xem video liên tục đến 27 giờ cùng khả năng sạc nhanh tiện lợi

Kích thước màn hình: 6.5 inches
Độ phân giải: 2736 x 1260 pixels
Chip: Chip A19 Pro
CPU: 6 lõi (2 hiệu năng + 4 tiết kiệm điện)
GPU: GPU 5 lõi với Neural Accelerator
Bộ nhớ trong: 256 GB
Camera sau: 48MP Fusion Main f/1.6
Camera trước: 18MP Center Stage f/1.6
Pin: Xem video: 27 giờ, Xem video trực tuyến: 22 giờ
Hệ điều hành: iOS
Kích thước: 156.2 × 74.7 × 5.6 mm
Trọng lượng: 165 g
SIM: 2 eSIM
Bluetooth: Bluetooth 6
Wi-Fi: Wi‑Fi 7
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/a17233e81cd5caf2.jpg', 23390000, 0, 1, 910);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112634', 'Đen Không Gian', '256GB', 31990000, 23890000, 20, '/uploads/products/apple/a17233e81cd5caf2.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112636', 'Trắng Mây', '256GB', 31990000, 23890000, 20, '/uploads/products/apple/f63899c7a346f787.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112638', 'Vàng Nhạt', '256GB', 31990000, 23390000, 20, '/uploads/products/apple/9007fc7e11d53bfa.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112639', 'Xanh Da Trời', '256GB', 31990000, 23890000, 20, '/uploads/products/apple/a51586ede160fc64.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d0345888c566ea1f.jpg', 'iPhone Air', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a73811191a434106.jpg', 'iPhone Air', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/83cf471b03eb6912.jpg', 'iPhone Air', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a645f6628bf760b8.jpg', 'iPhone Air', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8f215e99740a4fab.jpg', 'iPhone Air', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9011c7bd7511bf0f.jpg', 'iPhone Air', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5874409b2efeb60f.jpg', 'iPhone Air', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8b9a89efe15e3de1.jpg', 'iPhone Air', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2aff5347469e4e0a.jpg', 'iPhone Air', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fcf64e8c924665b5.jpg', 'iPhone Air', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e2359acaa9d25d97.jpg', 'iPhone Air', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a17233e81cd5caf2.jpg', 'iPhone Air', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f63899c7a346f787.jpg', 'iPhone Air', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9007fc7e11d53bfa.jpg', 'iPhone Air', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a51586ede160fc64.jpg', 'iPhone Air', 14);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 16e', 'iphone-16e', 'CPS-iphone-16e', 'Chip A18 mạnh mẽ không chỉ mang đến hiệu suất vượt trội mà còn đảm bảo thời lượng pin cả ngày dài, cùng với các bản cập nhật iOS thường xuyên giúp thiết bị luôn giữ được sự mới mẻ. · Với khả năng xem video lên đến 26 giờ, iPhone 16e khẳng định vị thế là chiếc smartphone 6,1 inch có thời lượng pin ấn tượng nhất. · Hệ thống camera hai trong một với camera Fusion 48MP và Telephoto 2x cho bạn những bức ảnh cực kỳ sắc nét, trong khi camera trước 12MP hoàn hảo cho những bức selfie đẹp lung linh.', 'Chip A18 mạnh mẽ không chỉ mang đến hiệu suất vượt trội mà còn đảm bảo thời lượng pin cả ngày dài, cùng với các bản cập nhật iOS thường xuyên giúp thiết bị luôn giữ được sự mới mẻ.
Với khả năng xem video lên đến 26 giờ, iPhone 16e khẳng định vị thế là chiếc smartphone 6,1 inch có thời lượng pin ấn tượng nhất.
Hệ thống camera hai trong một với camera Fusion 48MP và Telephoto 2x cho bạn những bức ảnh cực kỳ sắc nét, trong khi camera trước 12MP hoàn hảo cho những bức selfie đẹp lung linh.
Thiết kế bền bỉ kết hợp với màn hình OLED 6,1 inch tuyệt đẹp được bảo vệ bằng Ceramic Shield, cùng tính năng Phát Hiện Va Chạm giúp bạn an tâm hơn trong mọi hành trình.

Kích thước màn hình: 6.1 inches
Độ phân giải: 2532 x 1170 pixels
Chip: Chip A18
CPU: CPU 6 lõi mới với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 4 lõi mới, Neural Engine 16 lõi mới
Bộ nhớ trong: 128 GB
Camera sau: Hệ thống camera 2 trong 1, Fusion 48MP: 26 mm, khẩu độ ƒ/1.6, chống rung quang học, Hybrid Focus Pixels, ảnh có độ phân giải siêu cao (24MP và 48MP), Đồng thời hỗ trợ Telephoto 2x 12MP: 52 mm, khẩu độ ƒ/1.6, chống rung quang học, Hybrid Focus Pixels
Camera trước: Camera 12MP Khẩu độ ƒ/1.9 , Camera TrueDepth hỗ trợ nhận diện khuôn mặt
Pin: Thời gian xem video Lên đến 26 giờ , Thời gian xem video (trực tuyến) Lên đến 21 giờ, Thời gian nghe nhạc Lên đến 90 giờ,
Hệ điều hành: iOS
Kích thước: Rộng: 71.5 mm - Cao: 146.7 mm - Dày: 7.80 mm
Trọng lượng: 167 gram
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6 (802.11ax) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/8c50659880d09264.png', 14290000, 0, 1, 870);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-100813', 'Đen', '128GB', 14290000, NULL, 20, '/uploads/products/apple/8c50659880d09264.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-100814', 'Trắng', '128GB', 14290000, NULL, 20, '/uploads/products/apple/64e6fb00187415da.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b1a44408475edb79.png', 'iPhone 16e', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/410418b51820c1a1.png', 'iPhone 16e', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4662d1680140da96.png', 'iPhone 16e', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1775fd088b986c9f.png', 'iPhone 16e', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/62822d04e8f52bec.png', 'iPhone 16e', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a9404306e23ed59d.png', 'iPhone 16e', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0e68bec74353d509.png', 'iPhone 16e', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/27083469bb68a47f.png', 'iPhone 16e', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a42fd942cd9bd241.png', 'iPhone 16e', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8c50659880d09264.png', 'iPhone 16e', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/64e6fb00187415da.png', 'iPhone 16e', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 15', 'iphone-15', 'CPS-iphone-15', 'iPhone 15 thường có Dynamic Island hiển thị linh hoạt các cảnh báo và hoạt động trực tiếp, giúp bạn không bỏ lỡ thông tin quan trọng. · Thiết kế bằng kính pha màu và nhôm bền bỉ, cùng khả năng chống nước và bụi, với màn hình Super Retina XDR 6,1” sáng gấp đôi dưới ánh nắng. · Camera chính 48MP với Telephoto 2x cho phép chụp ảnh cận cảnh chi tiết và ảnh chân dung sống động, dễ dàng chuyển tiêu điểm giữa các chủ thể.', 'iPhone 15 thường có Dynamic Island hiển thị linh hoạt các cảnh báo và hoạt động trực tiếp, giúp bạn không bỏ lỡ thông tin quan trọng.
Thiết kế bằng kính pha màu và nhôm bền bỉ, cùng khả năng chống nước và bụi, với màn hình Super Retina XDR 6,1” sáng gấp đôi dưới ánh nắng.
Camera chính 48MP với Telephoto 2x cho phép chụp ảnh cận cảnh chi tiết và ảnh chân dung sống động, dễ dàng chuyển tiêu điểm giữa các chủ thể.
Chip A16 Bionic mạnh mẽ tiết kiệm pin và hỗ trợ nhiều tính năng tiên tiến, bao gồm Phát Hiện Va Chạm để đảm bảo an toàn cho người dùng.

Kích thước màn hình: 6.1 inches
Độ phân giải: 2556 x 1179 pixels
Chip: Apple A16 Bionic 6 nhân
CPU: CPU 6 lõi với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: 5‑core GPU
Bộ nhớ trong: 128 GB
Camera sau: Chính 48 MP & Phụ 12 MP
Camera trước: 12MP, ƒ/1.9
Pin: 3349 mAh
Hệ điều hành: iOS
Kích thước: 147.6 x 71.6 x 7.80 mm
Trọng lượng: 171g
SIM: 2 SIM (nano‑SIM và eSIM)
Bluetooth: v5.3
Wi-Fi: Wi-Fi MIMO, Wi-Fi 6, Wi-Fi 802.11 a/b/g/n/ac/ax
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/b01797b1049bb67c.png', 21490000, 0, 1, 850);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68887', 'Xanh dương', '128GB', 22990000, 21690000, 20, '/uploads/products/apple/b01797b1049bb67c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68889', 'Xanh lá', '128GB', 22990000, 21990000, 20, '/uploads/products/apple/f5efed82cd207225.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68892', 'Hồng', '128GB', 22990000, 21790000, 20, '/uploads/products/apple/dd2b0f2892a7610c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68893', 'Vàng', '128GB', 22990000, 21990000, 20, '/uploads/products/apple/318a30b24f2c6d21.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68894', 'Đen', '128GB', 22990000, 21490000, 20, '/uploads/products/apple/54411175f0f60aba.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68911', 'Xanh dương', '256GB', 25990000, 24990000, 20, '/uploads/products/apple/5e9f3e260840ee7f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68912', 'Xanh lá', '256GB', 25990000, 24990000, 20, '/uploads/products/apple/7b82e0bde502300e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68913', 'Hồng', '256GB', 25990000, 24990000, 20, '/uploads/products/apple/99e62862186efce3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68915', 'Vàng', '256GB', 25990000, 24990000, 20, '/uploads/products/apple/982a59c72f5949c6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-68916', 'Đen', '256GB', 25990000, 24490000, 20, '/uploads/products/apple/c7e878c563c8eb92.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0d69ece5b5dcab0c.png', 'iPhone 15', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/72aaf58fcc11cf9b.jpg', 'iPhone 15', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5455c73c9b962617.jpg', 'iPhone 15', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f227c078c7078b65.jpg', 'iPhone 15', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e52d237fffcc273b.jpg', 'iPhone 15', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0275ee3ff68ede0f.jpg', 'iPhone 15', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0cb7acdd3987e145.jpg', 'iPhone 15', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4df1ffe6bb6afe2d.jpg', 'iPhone 15', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1a6b58e485c99629.jpg', 'iPhone 15', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b01797b1049bb67c.png', 'iPhone 15', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f5efed82cd207225.png', 'iPhone 15', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dd2b0f2892a7610c.png', 'iPhone 15', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/318a30b24f2c6d21.png', 'iPhone 15', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/54411175f0f60aba.png', 'iPhone 15', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 13', 'iphone-13', 'CPS-iphone-13', 'iPhone 13 trang bị màn hình Super Retina XDR 6,1 inch mang đến hình ảnh sắc nét và sống động. · Chế độ Điện Ảnh cho phép thêm độ sâu trường ảnh nông và tự động chuyển tiêu điểm trong video, tạo ra những thước phim nghệ thuật. · Hệ thống camera kép với camera Chính 12MP và camera Ultra Wide cùng camera trước TrueDepth 12MP cho phép chụp ảnh chất lượng cao.', 'iPhone 13 trang bị màn hình Super Retina XDR 6,1 inch mang đến hình ảnh sắc nét và sống động.
Chế độ Điện Ảnh cho phép thêm độ sâu trường ảnh nông và tự động chuyển tiêu điểm trong video, tạo ra những thước phim nghệ thuật.
Hệ thống camera kép với camera Chính 12MP và camera Ultra Wide cùng camera trước TrueDepth 12MP cho phép chụp ảnh chất lượng cao.
Chip A15 Bionic mang lại hiệu năng thần tốc, trong khi mạng 5G cho phép tải về siêu nhanh và họp trực tuyến chất lượng cao.

Kích thước màn hình: 6.1 inches
Độ phân giải: 2532 x 1170 pixels
Chip: Apple A15
CPU: 3.22 GHz
GPU: Apple GPU 4 nhân
Bộ nhớ trong: 128 GB
Camera sau: Camera góc rộng: 12MP, f/1.6 , Camera góc siêu rộng: 12MP, ƒ/2.4
Camera trước: 12MP, f/2.2
Pin: 3240mAh
Hệ điều hành: iOS
Kích thước: 146,7 x 71,5 x 7,65mm
Trọng lượng: 173g
SIM: 2 SIM (nano‑SIM và eSIM)
Bluetooth: v5.0
Wi-Fi: Wi‑Fi 6 (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/1a75756ed8589604.jpg', 13490000, 0, 1, 840);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-36520', 'Trắng', '128GB', 15990000, 15290000, 20, '/uploads/products/apple/1a75756ed8589604.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-36522', 'Đỏ', '128GB', 15990000, 13490000, 20, '/uploads/products/apple/c03f594e81f83fc5.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-36523', 'Hồng', '128GB', 15990000, 13490000, 20, '/uploads/products/apple/24e2dc7aefa26322.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-36524', 'Xanh dương', '128GB', 15990000, 13490000, 20, '/uploads/products/apple/702d243c631b8f20.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-36527', 'Đen', '128GB', 15990000, 15290000, 20, '/uploads/products/apple/f0756507bd8b8462.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-44643', 'Xanh lá', '128GB', 15990000, 13490000, 20, '/uploads/products/apple/cb8b6933d2a2f0ea.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/71f56472c8978c81.jpg', 'iPhone 13', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/17748fa39ce09c7b.png', 'iPhone 13', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fa6e8a5718c2fc82.png', 'iPhone 13', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/00a001389c489f68.png', 'iPhone 13', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4cf3505166088a68.png', 'iPhone 13', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4c519660b16d408c.png', 'iPhone 13', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fca08efdd0621853.png', 'iPhone 13', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/859022514acfae60.png', 'iPhone 13', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/936461fa16737699.png', 'iPhone 13', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/db47a4117e5b155f.png', 'iPhone 13', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1a75756ed8589604.jpg', 'iPhone 13', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c03f594e81f83fc5.jpg', 'iPhone 13', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/24e2dc7aefa26322.jpg', 'iPhone 13', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/702d243c631b8f20.jpg', 'iPhone 13', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f0756507bd8b8462.jpg', 'iPhone 13', 14);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cb8b6933d2a2f0ea.png', 'iPhone 13', 15);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 16 Plus', 'iphone-16-plus', 'CPS-iphone-16-plus', 'iPhone 16 Plus cho phép bạn điều khiển camera và truy cập nhanh các công cụ như thu phóng, giúp chụp ảnh dễ dàng hơn. · Camera Ultra Wide với lấy nét tự động ghi hình cận cảnh sắc nét, trong khi camera Fusion 48MP mang lại độ phân giải cao cho bức ảnh sống động. · Phong Cách Nhiếp Ảnh mới giúp bạn sáng tạo, biến mỗi bức ảnh thành tác phẩm độc đáo và dễ dàng thay đổi phong cách.', 'iPhone 16 Plus cho phép bạn điều khiển camera và truy cập nhanh các công cụ như thu phóng, giúp chụp ảnh dễ dàng hơn.
Camera Ultra Wide với lấy nét tự động ghi hình cận cảnh sắc nét, trong khi camera Fusion 48MP mang lại độ phân giải cao cho bức ảnh sống động.
Phong Cách Nhiếp Ảnh mới giúp bạn sáng tạo, biến mỗi bức ảnh thành tác phẩm độc đáo và dễ dàng thay đổi phong cách.
Chip A18 mang đến hiệu suất vượt trội cho chụp ảnh, quay video và chơi game, cùng thời lượng pin lên đến 27 giờ để bạn luôn sẵn sàng khám phá.

Kích thước màn hình: 6.7 inches
Độ phân giải: 2796 x 1290-pixel
Chip: Apple A18
CPU: CPU 6 lõi mới với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 5 lõi mới
Bộ nhớ trong: 128 GB
Camera sau: Camera chính: 48MP, f/1.6, 26mm, Focus Pixels 100%, hỗ trợ ảnh có độ phân giải siêu cao, Camera góc siêu rộng: 12MP, ƒ/2.2, 13 mm, Focus Pixels 100%, Độ phóng đại quang học 2x, độ thu nhỏ quang học 2x; phạm vi thu phóng quang học 4x Độ thu phóng kỹ thu
Camera trước: 12MP, ƒ/1.9, Tự động lấy nét theo pha Focus Pixels
Hệ điều hành: iOS
Kích thước: 160,9 x 77,8 x 7,80 mm
Trọng lượng: 199 gram
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO7
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/1c782e2257eea996.png', 24990000, 0, 1, 830);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90140', 'Đen', '128GB', 27990000, 24990000, 20, '/uploads/products/apple/1c782e2257eea996.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90141', 'Trắng', '128GB', 27990000, 24990000, 20, '/uploads/products/apple/909d7dacc3a296e0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90142', 'Hồng', '128GB', 27990000, 24990000, 20, '/uploads/products/apple/01c6a883af13d994.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90143', 'Xanh Mòng Két', '128GB', 27990000, 24990000, 20, '/uploads/products/apple/cb013e2bb4fdb299.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90144', 'Xanh Lưu Ly', '128GB', 27990000, 24990000, 20, '/uploads/products/apple/addf3cacdd7ff45b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90150', 'Đen', '256GB', 30990000, 27890000, 20, '/uploads/products/apple/6a3b0d568d25a3dc.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90151', 'Trắng', '256GB', 30990000, 27890000, 20, '/uploads/products/apple/1ebdbcfb4acb49b7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90152', 'Hồng', '256GB', 30990000, 27890000, 20, '/uploads/products/apple/d9eec9a4c641c7bb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90153', 'Xanh Mòng Két', '256GB', 30990000, 27890000, 20, '/uploads/products/apple/2cf9f356624c492d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90154', 'Xanh Lưu Ly', '256GB', 30990000, 27890000, 20, '/uploads/products/apple/8a3588d3777b0899.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/92b95432cd44d2bd.png', 'iPhone 16 Plus', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2b75af467d81864d.png', 'iPhone 16 Plus', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7724541025bdfc1b.png', 'iPhone 16 Plus', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4b2ebef55c1432e9.png', 'iPhone 16 Plus', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0a28db019d8a7308.png', 'iPhone 16 Plus', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/00e1ce5a2f84cd3c.png', 'iPhone 16 Plus', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1bb4e12b8232eef6.png', 'iPhone 16 Plus', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f9c4ce2cbee44cb8.png', 'iPhone 16 Plus', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0ed8daedff5a42dd.png', 'iPhone 16 Plus', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e6a7a0258409ad0a.png', 'iPhone 16 Plus', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1c782e2257eea996.png', 'iPhone 16 Plus', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/909d7dacc3a296e0.png', 'iPhone 16 Plus', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/01c6a883af13d994.png', 'iPhone 16 Plus', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cb013e2bb4fdb299.png', 'iPhone 16 Plus', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/addf3cacdd7ff45b.png', 'iPhone 16 Plus', 14);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 17e', 'iphone-17e', 'CPS-iphone-17e', 'Màn hình Iphone 17e Super Retina XDR OLED 6,1 inch với HDR, True Tone và lớp phủ chống phản chiếu cho hình ảnh rực rỡ, rõ nét ngoài trời. · Chip A19 mạnh mẽ với CPU 6 lõi và Apple Intelligence, mang lại hiệu năng vượt trội cho đa nhiệm, AI và chơi game. · Camera 48MP Fusion hỗ trợ zoom tele 2x chất lượng quang học, Photonic Engine và quay video 4K Dolby Vision.', 'Màn hình Iphone 17e Super Retina XDR OLED 6,1 inch với HDR, True Tone và lớp phủ chống phản chiếu cho hình ảnh rực rỡ, rõ nét ngoài trời.
Chip A19 mạnh mẽ với CPU 6 lõi và Apple Intelligence, mang lại hiệu năng vượt trội cho đa nhiệm, AI và chơi game.
Camera 48MP Fusion hỗ trợ zoom tele 2x chất lượng quang học, Photonic Engine và quay video 4K Dolby Vision.
Thiết kế nhôm bền bỉ với Ceramic Shield, pin dùng cả ngày, hỗ trợ MagSafe, sạc nhanh và Face ID bảo mật.

Kích thước màn hình: 6.1 inches
Độ phân giải: 2532 x 1170 pixels
Chip: Apple A19
CPU: 6 lõi với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: 4 lõi với Neural Accelerators
Bộ nhớ trong: 256 GB
Camera sau: 48MP, ƒ/1.6, Telephoto 2x: 12MP, ƒ/1.6
Camera trước: 12MP, ƒ/1.9
Pin: Xem video: 26 giờ, Xem video trực tuyến: 21 giờ
Hệ điều hành: iOS
Kích thước: 146.7 x 71.5 x 7.8 mm
Trọng lượng: 170 g
SIM: 2 SIM (nano‑SIM và eSIM)
Bluetooth: 5.3
Wi-Fi: Wi‑Fi 6 (802.11ax) với 2x2 MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/a2c1c87196b0d89e.jpg', 20990000, 0, 1, 800);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125582', 'Đen', '256GB', 21990000, 20990000, 20, '/uploads/products/apple/a2c1c87196b0d89e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125583', 'Trắng', '256GB', 21990000, 20990000, 20, '/uploads/products/apple/995a4d38c34a3297.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125584', 'Hồng', '256GB', 21990000, 20990000, 20, '/uploads/products/apple/5cffb5066f048c6d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125585', 'Đen', '512GB', 28490000, 26990000, 20, '/uploads/products/apple/e82f3dfe7a8a51df.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125586', 'Trắng', '512GB', 28490000, 26990000, 20, '/uploads/products/apple/cc3e11c944ae1617.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125587', 'Hồng', '512GB', 28490000, 26990000, 20, '/uploads/products/apple/7cc4fcb31293cf07.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ee52e7f1c16a6cb5.png', 'iPhone 17e', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bb6b68f79137d04b.png', 'iPhone 17e', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3028e4722573e5bf.png', 'iPhone 17e', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/66efc4e61bc3f470.png', 'iPhone 17e', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/647b7bb19fc306e6.png', 'iPhone 17e', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6104bb6e34a4c616.png', 'iPhone 17e', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6be0dc32a5fa6204.png', 'iPhone 17e', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8ffab75fb997c1bc.png', 'iPhone 17e', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a2c1c87196b0d89e.jpg', 'iPhone 17e', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/995a4d38c34a3297.jpg', 'iPhone 17e', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5cffb5066f048c6d.jpg', 'iPhone 17e', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 16', 'iphone-16', 'CPS-iphone-16', 'iPhone 16 thường trang bị hệ thống camera tiên tiến cho phép truy cập nhanh các công cụ như thu phóng và độ sâu trường ảnh, giúp ghi lại khoảnh khắc hoàn hảo chỉ trong chớp mắt. · Camera Ultra Wide với lấy nét tự động giúp chụp ảnh cận cảnh ấn tượng, trong khi camera Fusion 48MP mang lại độ phân giải tuyệt đẹp cho mọi bức hình. · Phong Cách Nhiếp Ảnh mới mang đến sự linh hoạt, giúp bạn dễ dàng biến mỗi bức ảnh thành tác phẩm nghệ thuật độc đáo.', 'iPhone 16 thường trang bị hệ thống camera tiên tiến cho phép truy cập nhanh các công cụ như thu phóng và độ sâu trường ảnh, giúp ghi lại khoảnh khắc hoàn hảo chỉ trong chớp mắt.
Camera Ultra Wide với lấy nét tự động giúp chụp ảnh cận cảnh ấn tượng, trong khi camera Fusion 48MP mang lại độ phân giải tuyệt đẹp cho mọi bức hình.
Phong Cách Nhiếp Ảnh mới mang đến sự linh hoạt, giúp bạn dễ dàng biến mỗi bức ảnh thành tác phẩm nghệ thuật độc đáo.
Chip A18 mạnh mẽ tối ưu hóa chụp ảnh và quay video, tiết kiệm năng lượng và kéo dài thời gian sử dụng pin lên đến 22 giờ cho những cuộc phiêu lưu không ngừng nghỉ.

Kích thước màn hình: 6.1 inches
Độ phân giải: 2556 x 1179 pixels
Chip: Apple A18
CPU: CPU 6 lõi mới với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 5 lõi mới
Bộ nhớ trong: 128 GB
Camera sau: Camera chính: 48MP, f/1.6, 26mm, Focus Pixels 100%, hỗ trợ ảnh có độ phân giải siêu cao, Camera góc siêu rộng: 12MP, ƒ/2.2, 13 mm, Focus Pixels 100%, Độ phóng đại quang học 2x, độ thu nhỏ quang học 2x; phạm vi thu phóng quang học 4x Độ thu phóng kỹ thu
Camera trước: 12MP, ƒ/1.9, Tự động lấy nét theo pha Focus Pixels
Pin: 4.300 mAh
Hệ điều hành: iOS
Kích thước: 147,6 x 71,6 x 7,80 mm
Trọng lượng: 170 gram
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO7
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/917f33f073c5235b.png', 24490000, 0, 1, 790);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90122', 'Đen', '128GB', 24990000, 24490000, 20, '/uploads/products/apple/917f33f073c5235b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90123', 'Trắng', '128GB', 24990000, 24690000, 20, '/uploads/products/apple/0cb86e5993145690.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90124', 'Hồng', '128GB', 24990000, 24690000, 20, '/uploads/products/apple/5055c996bc8641f9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90125', 'Xanh Mòng Két', '128GB', 24990000, 24690000, 20, '/uploads/products/apple/c20af883d7d32783.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90126', 'Xanh Lưu Ly', '128GB', 24990000, 24690000, 20, '/uploads/products/apple/bae8c15886fb4b4d.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/78c2384ee719a3ed.png', 'iPhone 16', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/df780d213aa165e8.png', 'iPhone 16', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/297d0529d77048f1.png', 'iPhone 16', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f7fdead7c228a258.png', 'iPhone 16', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d216a63cf34ca1c9.png', 'iPhone 16', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/244ab360337ce06b.png', 'iPhone 16', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3125edccd9aa5d03.png', 'iPhone 16', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/38c758e04564dc36.png', 'iPhone 16', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f43364df72444af0.png', 'iPhone 16', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b350c8ae4f2042f6.png', 'iPhone 16', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/917f33f073c5235b.png', 'iPhone 16', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0cb86e5993145690.png', 'iPhone 16', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5055c996bc8641f9.png', 'iPhone 16', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c20af883d7d32783.png', 'iPhone 16', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bae8c15886fb4b4d.png', 'iPhone 16', 14);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 16 Pro Max', 'iphone-16-pro-max', 'CPS-iphone-16-pro-max', 'iPhone 16 Pro Max mang đến thiết kế titan vừa nhẹ vừa bền, với màn hình Super Retina XDR 6,9 inch ấn tượng. · Tính năng Điều Khiển Camera cho phép bạn nhanh chóng truy cập vào các công cụ như thu phóng và điều chỉnh độ sâu, giúp việc chụp ảnh trở nên thuận tiện hơn. · Camera Ultra Wide 48MP giúp bạn ghi lại những chi tiết tinh xảo, trong khi camera Telephoto 5x cho phép chụp từ khoảng cách xa một cách dễ dàng.', 'iPhone 16 Pro Max mang đến thiết kế titan vừa nhẹ vừa bền, với màn hình Super Retina XDR 6,9 inch ấn tượng.
Tính năng Điều Khiển Camera cho phép bạn nhanh chóng truy cập vào các công cụ như thu phóng và điều chỉnh độ sâu, giúp việc chụp ảnh trở nên thuận tiện hơn.
Camera Ultra Wide 48MP giúp bạn ghi lại những chi tiết tinh xảo, trong khi camera Telephoto 5x cho phép chụp từ khoảng cách xa một cách dễ dàng.
Hơn nữa, khả năng quay video 4K Dolby Vision ở 120 fps cùng micrô chất lượng studio sẽ mang đến cho bạn những sản phẩm video chuyên nghiệp ngay trong tay.

Kích thước màn hình: 6.9 inches
Độ phân giải: 2868 x 1320 pixels
Chip: Apple A18 Pro
CPU: CPU 6 lõi mới với 2 lõi hiệu năng và 4 lõi hiệu suất
GPU: GPU 6 lõi mới
Bộ nhớ trong: 512 GB
Camera sau: Camera chính: 48MP, f/1.78, 24mm, 2µm, chống rung quang học dịch chuyển cảm biến thế hệ thứ hai, Focus Pixels 100%, Telephoto 2x 12MP: 52 mm, ƒ/1.6, Camera góc siêu rộng: 48MP, 13 mm,ƒ/2.2 và trường ảnh 120°, Hybrid Focus Pixels, ảnh có độ phân giải
Camera trước: 12MP, ƒ/1.9, Tự động lấy nét theo pha Focus Pixels
Hệ điều hành: iOS
Kích thước: 163 x 77,6 x 8,25 mm
Trọng lượng: 227 gram
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO7
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/f9c523b4e5571e92.png', 37990000, 0, 1, 780);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90174', 'Titan Đen', '512GB', 40990000, 37990000, 20, '/uploads/products/apple/f9c523b4e5571e92.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90175', 'Titan Trắng', '512GB', 40990000, 37990000, 20, '/uploads/products/apple/865888288ef27f37.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90176', 'Titan Tự Nhiên', '512GB', 40990000, 37990000, 20, '/uploads/products/apple/5023cfa8dcb70ee1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90177', 'Titan Sa Mạc', '512GB', 40990000, 38990000, 20, '/uploads/products/apple/ab65987750bcc326.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90178', 'Titan Đen', '1TB', 46990000, 42990000, 20, '/uploads/products/apple/f2200b3b1951a4b8.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90179', 'Titan Trắng', '1TB', 46990000, 42990000, 20, '/uploads/products/apple/cab0b20575b364da.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90180', 'Titan Tự Nhiên', '1TB', 46990000, 42990000, 20, '/uploads/products/apple/30906c099849a318.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90181', 'Titan Sa Mạc', '1TB', 46990000, 42990000, 20, '/uploads/products/apple/3181bd7543c9fb73.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a4923272dfab1f95.png', 'iPhone 16 Pro Max', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2f3ce559ac2bffd3.png', 'iPhone 16 Pro Max', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/71ba54d53b88f4fa.png', 'iPhone 16 Pro Max', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/88ab0161de9403a3.png', 'iPhone 16 Pro Max', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e3275820902a7365.png', 'iPhone 16 Pro Max', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7409c382e50fdab9.png', 'iPhone 16 Pro Max', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/320ad25d2ee767e5.png', 'iPhone 16 Pro Max', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e9c4a8059e73abcf.png', 'iPhone 16 Pro Max', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3340b169213ede6f.png', 'iPhone 16 Pro Max', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/90fafd54313903f1.png', 'iPhone 16 Pro Max', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f9c523b4e5571e92.png', 'iPhone 16 Pro Max', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/865888288ef27f37.png', 'iPhone 16 Pro Max', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5023cfa8dcb70ee1.png', 'iPhone 16 Pro Max', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ab65987750bcc326.png', 'iPhone 16 Pro Max', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 14', 'iphone-14', 'CPS-iphone-14', 'iPhone 14 trang bị màn hình Super Retina XDR 6,1 inch cho trải nghiệm hình ảnh sắc nét và sống động. · Thời lượng pin cả ngày cho phép bạn xem video lên đến 20 giờ, luôn sẵn sàng cho những ngày làm việc dài. · Với các tính năng độ bền như Ceramic Shield và khả năng chống nước, iPhone 14 đảm bảo an toàn trong mọi tình huống.', 'iPhone 14 trang bị màn hình Super Retina XDR 6,1 inch cho trải nghiệm hình ảnh sắc nét và sống động.
Thời lượng pin cả ngày cho phép bạn xem video lên đến 20 giờ, luôn sẵn sàng cho những ngày làm việc dài.
Với các tính năng độ bền như Ceramic Shield và khả năng chống nước, iPhone 14 đảm bảo an toàn trong mọi tình huống.
Chip A15 Bionic với GPU 5 lõi mang lại hiệu suất siêu nhanh, cùng mạng di động 5G cho khả năng làm việc từ xa và họp trực tuyến chất lượng cao.

Kích thước màn hình: 6.1 inches
Độ phân giải: 2532 x 1170 pixels
Chip: Apple A15 Bionic 6 nhân
CPU: 3.22 GHz
GPU: Apple GPU 5 nhân
Bộ nhớ trong: 128 GB
Camera sau: Camera góc rộng: 12MP, ƒ/1.5, Camera góc siêu rộng: 12MP, ƒ/2.4
Camera trước: 12MP, ƒ/1.9
Pin: 3,279mAh
Hệ điều hành: iOS
Kích thước: 146.7 x 71.5 x 7.8 mm
Trọng lượng: 172 g
SIM: 2 SIM (nano‑SIM và eSIM)
Bluetooth: v5.3, A2DP, LE
Wi-Fi: Wi-Fi MIMO, Dual-band (2.4 GHz/5 GHz), Wi-Fi 802.11 a/b/g/n/ac/ax, Wi-Fi hotspot
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/08e2ec9bbfd0b308.jpg', 16990000, 0, 1, 750);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-52353', 'Xanh', '128GB', 17990000, 16990000, 20, '/uploads/products/apple/08e2ec9bbfd0b308.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-52376', 'Đen', '128GB', 17990000, 16990000, 20, '/uploads/products/apple/ff1ba761bbc2849c.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-52377', 'Đỏ', '128GB', 17990000, 16990000, 20, '/uploads/products/apple/5707fd20970e9d74.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-52379', 'Tím', '128GB', 17990000, 16990000, 20, '/uploads/products/apple/eeaaa50a428253c5.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-52380', 'Trắng', '128GB', 17990000, 16990000, 20, '/uploads/products/apple/4fadb5ecb5b13e8f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-60934', 'Vàng', '128GB', 17990000, 16990000, 20, '/uploads/products/apple/46ffba5d99a1ec6f.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/65b382b824a07a7e.jpg', 'iPhone 14', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2ed4674acb760fec.png', 'iPhone 14', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1e3fe5bd61073878.png', 'iPhone 14', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bd183fc709d96bff.png', 'iPhone 14', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0c893a83c0125f13.png', 'iPhone 14', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cb6e12914ad98de7.png', 'iPhone 14', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/188971f3fe672954.png', 'iPhone 14', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ad13653438460ccf.png', 'iPhone 14', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/30b4a26f4e67bab9.png', 'iPhone 14', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1b0fbb1f6c668574.png', 'iPhone 14', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/08e2ec9bbfd0b308.jpg', 'iPhone 14', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ff1ba761bbc2849c.jpg', 'iPhone 14', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5707fd20970e9d74.jpg', 'iPhone 14', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/eeaaa50a428253c5.jpg', 'iPhone 14', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4fadb5ecb5b13e8f.jpg', 'iPhone 14', 14);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/46ffba5d99a1ec6f.jpg', 'iPhone 14', 15);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 14 Pro Max', 'iphone-14-pro-max', 'CPS-iphone-14-pro-max', 'Màn hình Dynamic Island - Sự biến mất của màn hình tai thỏ thay thế bằng thiết kế viên thuốc, OLED 6,7 inch, hỗ trợ always-on display · Cấu hình iPhone 14 Pro Max mạnh mẽ, hiệu năng cực khủng từ chipset A16 Bionic · Làm chủ công nghệ nhiếp ảnh - Camera sau 48MP, cảm biến TOF sống động', 'Màn hình Dynamic Island - Sự biến mất của màn hình tai thỏ thay thế bằng thiết kế viên thuốc, OLED 6,7 inch, hỗ trợ always-on display
Cấu hình iPhone 14 Pro Max mạnh mẽ, hiệu năng cực khủng từ chipset A16 Bionic
Làm chủ công nghệ nhiếp ảnh - Camera sau 48MP, cảm biến TOF sống động
Pin liền lithium-ion kết hợp cùng công nghệ sạc nhanh cải tiến

Kích thước màn hình: 6.7 inches
Độ phân giải: 2796 x 1290-pixel
Chip: Apple A16 Bionic 6 nhân
CPU: 3.46 GHz
GPU: Apple GPU 5 nhân
Bộ nhớ trong: 256 GB
Camera sau: Camera chính: 48 MP, f/1.8, 24mm, OIS , Camera góc siêu rộng: 12 MP, f/2.2, 13mm, 120˚, Camera tele: 12 MP, f/2.8, 77mm, OIS, 3x optical zoom
Camera trước: Camera selfie: 12 MP, f/1.9, 23mm, PDAF
Pin: 4323 mAh
Hệ điều hành: iOS
Kích thước: 160.7 x 77.6 x 7.9 mm
Trọng lượng: 240 gr
SIM: 2 SIM (nano‑SIM và eSIM)
Bluetooth: A2DP, LE, v5.3
Wi-Fi: Dual-band (2.4 GHz/5 GHz), Wi-Fi 802.11 a/b/g/n/ac/ax, Wi-Fi hotspot, Wi-Fi MIMO
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/46a02b712f3c210b.png', 19190000, 0, 1, 720);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-58645', 'Tím', '256GB', 32990000, 19190000, 20, '/uploads/products/apple/46a02b712f3c210b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-60516', 'Vàng', '256GB', 32990000, 19190000, 20, '/uploads/products/apple/39d9afb7ace4f398.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-63327', 'Đen', '256GB', 32990000, 19190000, 20, '/uploads/products/apple/d3b6629163f345f9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-63491', 'Bạc', '256GB', 32990000, 19190000, 20, '/uploads/products/apple/1ccacc63bf419377.png', 1);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dien-thoai'), @brand, 'iPhone 16 Pro', 'iphone-16-pro', 'CPS-iphone-16-pro', 'Màn hình Super Retina XDR 6,3 inch lớn hơn có viền mỏng hơn, đem đến cảm giác tuyệt vời khi cầm trên tay. · Điều khiển Camera - Chỉ cần trượt ngón tay để điều chỉnh camera giúp chụp ảnh hoặc quay video đẹp hoàn hảo và siêu nhanh. · Tính năng quay video đẳng cấp với 4K Dolby Vision tốc độ 120 fps — độ phân giải và tốc độ khung hình cao nhất hiện nay của Apple.', 'Màn hình Super Retina XDR 6,3 inch lớn hơn có viền mỏng hơn, đem đến cảm giác tuyệt vời khi cầm trên tay.
Điều khiển Camera - Chỉ cần trượt ngón tay để điều chỉnh camera giúp chụp ảnh hoặc quay video đẹp hoàn hảo và siêu nhanh.
Tính năng quay video đẳng cấp với 4K Dolby Vision tốc độ 120 fps — độ phân giải và tốc độ khung hình cao nhất hiện nay của Apple.
iPhone 16 Pro được cài đặt sẵn hệ điều hành iOS 18, cho giao diện trực quan, dễ sử dụng và nhiều tính năng hữu ích.

Kích thước màn hình: 6.3 inches
Độ phân giải: 2622 x 1206 pixels
Chip: Apple A18 Pro
CPU: CPU 6 lõi mới với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
GPU: GPU 6 lõi mới
Bộ nhớ trong: 1 TB
Camera sau: Camera chính: 48MP, f/1.78, 24mm, chống rung quang học dịch chuyển cảm biến thế hệ thứ hai, Focus Pixels 100%, hỗ trợ ảnh có độ phân giải siêu cao, Hỗ trợ Telephoto 2x 12MP: 52 mm, ƒ/1.6, Camera góc siêu rộng: 48MP, 13 mm, ƒ/2.2 và trường ảnh 120°, H
Camera trước: 12MP, ƒ/1.9, Tự động lấy nét theo pha Focus Pixels
Hệ điều hành: iOS
Kích thước: Rộng: 71,5 mm Cao: 149,6 mm Dày: 8,25 mm
Trọng lượng: 199 gram
SIM: Sim kép (nano-Sim và e-Sim) - Hỗ trợ 2 e-Sim
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 7 (802.11be) với 2x2 MIMO7
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/5a881a8bf832f466.png', 35990000, 0, 1, 680);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90164', 'Titan Đen', '1TB', 43990000, 35990000, 20, '/uploads/products/apple/5a881a8bf832f466.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90165', 'Titan Trắng', '1TB', 43990000, 35990000, 20, '/uploads/products/apple/8be62a923ce6a065.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90166', 'Titan Tự Nhiên', '1TB', 43990000, 35990000, 20, '/uploads/products/apple/f3a406d113eb8bd2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90167', 'Titan Sa Mạc', '1TB', 43990000, 35990000, 20, '/uploads/products/apple/1d67f8af1575e4b3.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/11d5cb77efd9aa55.png', 'iPhone 16 Pro', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/512e41d67b79050d.png', 'iPhone 16 Pro', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/84a1065c9011efa4.png', 'iPhone 16 Pro', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ee1a502e2c85cf5f.png', 'iPhone 16 Pro', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/06ced7de039944ad.png', 'iPhone 16 Pro', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fe78bb24ed600939.png', 'iPhone 16 Pro', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2ef34a58a9b19811.png', 'iPhone 16 Pro', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2e14b308393716cb.png', 'iPhone 16 Pro', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/db922d6b5e13f306.png', 'iPhone 16 Pro', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7035c210900660cf.png', 'iPhone 16 Pro', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5a881a8bf832f466.png', 'iPhone 16 Pro', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8be62a923ce6a065.png', 'iPhone 16 Pro', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f3a406d113eb8bd2.png', 'iPhone 16 Pro', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1d67f8af1575e4b3.png', 'iPhone 16 Pro', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Neo 13 inch A18 Pro 2026', 'macbook-neo-13-inch-a18-pro-2026', 'CPS-macbook-neo-13-inch-a18-pro-2026', 'Máy tính xách tay thiết kế nhôm siêu nhẹ và bền, 4 màu thời thượng (Bạc, Hồng Phớt, Vàng Citrus, Xanh Indigo) kèm bàn phím cùng tông hoàn hảo để mang theo học tập mọi lúc mọi nơi. · Màn hình Liquid Retina 13 inch sắc nét (2408 x 1506, 500 nit, hỗ trợ 1 tỷ màu) cho hình ảnh sống động và văn bản hiển thị cực kỳ rõ ràng. · Pin dùng cả ngày lên đến 16 giờ, giúp bạn yên tâm từ giờ học buổi sáng đến buổi ôn thi muộn mà không lo cạn năng lượng.', 'Máy tính xách tay thiết kế nhôm siêu nhẹ và bền, 4 màu thời thượng (Bạc, Hồng Phớt, Vàng Citrus, Xanh Indigo) kèm bàn phím cùng tông hoàn hảo để mang theo học tập mọi lúc mọi nơi.
Màn hình Liquid Retina 13 inch sắc nét (2408 x 1506, 500 nit, hỗ trợ 1 tỷ màu) cho hình ảnh sống động và văn bản hiển thị cực kỳ rõ ràng.
Pin dùng cả ngày lên đến 16 giờ, giúp bạn yên tâm từ giờ học buổi sáng đến buổi ôn thi muộn mà không lo cạn năng lượng.
Hiệu năng mạnh mẽ với chip A18 Pro và tính năng AI tích hợp, cộng thêm camera 1080p, mic kép và hệ thống loa stereo với Âm Thanh Không Gian sẵn sàng cho học tập, họp trực tuyến và giải trí.

Kích thước màn hình: 13 inches
Độ phân giải: 2408 x 1506 pixels
CPU: Chip Apple A18 Pro , CPU 6 lõi với 2 lõi hiệu năng và 4 lõi tiết kiệm điện
Pin: Thời gian xem video trực tuyến lên đến 16 giờ, Thời gian duyệt web trên mạng không dây lên đến 11 giờ, Pin lithium-ion 36.5 watt‑giờ tích hợp
Kích thước: 1.27 x 29.75 x 20.64 cm (Cao x Rộng x Dài)
Trọng lượng: 1.23 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/7b1be159402d1777.png', 18690000, 1, 1, 990);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125875', 'Bạc', '6CPU 5GPU 8GB 256GB', 19490000, 19190000, 20, '/uploads/products/apple/7b1be159402d1777.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125876', 'Vàng Citrus', '6CPU 5GPU 8GB 256GB', 19490000, 18690000, 20, '/uploads/products/apple/82af537cb7d3ceb6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125877', 'Xanh Indigo', '6CPU 5GPU 8GB 256GB', 19490000, 18690000, 20, '/uploads/products/apple/ab7379c5b5a9023a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125878', 'Hồng Phớt', '6CPU 5GPU 8GB 256GB', 19490000, 19390000, 20, '/uploads/products/apple/b51391ce208d0137.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125881', 'Bạc', '6CPU 5GPU 8GB 512GB Touch ID', 21990000, 21690000, 20, '/uploads/products/apple/d4912900d70ad112.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125882', 'Vàng Citrus', '6CPU 5GPU 8GB 512GB Touch ID', 21990000, 21290000, 20, '/uploads/products/apple/24c15637fa8625f3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125883', 'Xanh Indigo', '6CPU 5GPU 8GB 512GB Touch ID', 21990000, 21490000, 20, '/uploads/products/apple/8fc6e05bc20de13d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125884', 'Hồng Phớt', '6CPU 5GPU 8GB 512GB Touch ID', 21990000, 21690000, 20, '/uploads/products/apple/672cd80d7224c2e9.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2df1c66ff0771b79.png', 'MacBook Neo 13 inch A18 Pro 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/746078c42834337e.png', 'MacBook Neo 13 inch A18 Pro 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a6f894ae48f0d0c7.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b356204debca1f8d.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d20ba7bf5b1d39e6.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d905b60557eb2daf.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5f8502798e2dbbac.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fc55fb5eb04c4596.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cee1064cf56fa1b7.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/287c17cd11a96b8f.jpg', 'MacBook Neo 13 inch A18 Pro 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7b1be159402d1777.png', 'MacBook Neo 13 inch A18 Pro 2026', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/82af537cb7d3ceb6.png', 'MacBook Neo 13 inch A18 Pro 2026', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ab7379c5b5a9023a.png', 'MacBook Neo 13 inch A18 Pro 2026', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b51391ce208d0137.png', 'MacBook Neo 13 inch A18 Pro 2026', 13);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Air M4 13 inch 2025', 'macbook-air-m4-13-inch-2025', 'CPS-macbook-air-m4-13-inch-2025', 'MacBook Air M4 13 inch được trang bị chip M4 mạnh mẽ, mang lại tốc độ và mượt mà cho mọi tác vụ từ đa nhiệm đến chơi game đồ họa cao. · Với thời lượng pin lên đến 18 giờ, máy duy trì hiệu suất ổn định cả khi sử dụng pin hoặc cắm sạc. · Thiết kế nhẹ và mỏng dưới nửa inch giúp máy dễ dàng mang theo, lý tưởng cho phong cách sống năng động.', 'MacBook Air M4 13 inch được trang bị chip M4 mạnh mẽ, mang lại tốc độ và mượt mà cho mọi tác vụ từ đa nhiệm đến chơi game đồ họa cao.
Với thời lượng pin lên đến 18 giờ, máy duy trì hiệu suất ổn định cả khi sử dụng pin hoặc cắm sạc.
Thiết kế nhẹ và mỏng dưới nửa inch giúp máy dễ dàng mang theo, lý tưởng cho phong cách sống năng động.
Màn hình Liquid Retina 13,6 inch hiển thị một tỷ màu sắc rực rỡ, kết hợp với âm thanh sống động từ bốn loa và camera 12MP Center Stage, tạo ra trải nghiệm hình ảnh và âm thanh tuyệt vời.

Kích thước màn hình: 13.6 inches
Độ phân giải: 2560 x 1664 pixels
CPU: CPU 10 lõi với 4 lõi hiệu năng và 6 lõi tiết kiệm điện
Pin: Thời gian xem video trực tuyến lên đến 18 giờ, Thời gian duyệt web trên mạng không dây lên đến 15 giờ, Pin Li-Po 53.8 watt‑giờ tích hợp
Kích thước: Cao: 1.13 cm x Rộng: 30.41 cm x Dài: 21.5 cm
Trọng lượng: 1.24 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi-Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/f7c2ebf20e74f197.png', 24990000, 1, 1, 980);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101835', 'Xanh da trời', '10CPU 8GPU 16GB 256GB', 26990000, 24990000, 20, '/uploads/products/apple/f7c2ebf20e74f197.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101836', 'Bạc', '10CPU 8GPU 16GB 256GB', 26990000, 24990000, 20, '/uploads/products/apple/fd723f28d9df5e67.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101837', 'Ánh sao', '10CPU 8GPU 16GB 256GB', 26990000, 24990000, 20, '/uploads/products/apple/437fd313a084179b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101838', 'Đêm xanh thẳm', '10CPU 8GPU 16GB 256GB', 26990000, 24990000, 20, '/uploads/products/apple/337adfb6baa01cd3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-102820', 'Xanh da trời', '10CPU 10GPU 24GB 512GB Sạc 70W', 39990000, 38490000, 20, '/uploads/products/apple/9416e0e950484b83.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-102821', 'Bạc', '10CPU 10GPU 24GB 512GB Sạc 70W', 39990000, 37990000, 20, '/uploads/products/apple/4f7553304c08232b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-102822', 'Ánh sao', '10CPU 10GPU 24GB 512GB Sạc 70W', 39990000, 37990000, 20, '/uploads/products/apple/e96d05eee2af24ba.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-102823', 'Đêm xanh thẳm', '10CPU 10GPU 24GB 512GB Sạc 70W', 39990000, 37990000, 20, '/uploads/products/apple/ec00388decbc03d3.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c93f5a73b237c1dc.png', 'MacBook Air M4 13 inch 2025', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2cb27eca40e02356.png', 'MacBook Air M4 13 inch 2025', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7a0232ac6af17dd2.png', 'MacBook Air M4 13 inch 2025', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/81f3d2a6dd9a9ce5.png', 'MacBook Air M4 13 inch 2025', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f1e451a4a9334c02.png', 'MacBook Air M4 13 inch 2025', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a40bf5dfec25d59f.png', 'MacBook Air M4 13 inch 2025', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ba35396d2161671a.png', 'MacBook Air M4 13 inch 2025', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a79d03ef888eacd9.png', 'MacBook Air M4 13 inch 2025', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7c1c3db213f6ab03.png', 'MacBook Air M4 13 inch 2025', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fffcad914293997b.png', 'MacBook Air M4 13 inch 2025', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d02c1d9d723a1459.png', 'MacBook Air M4 13 inch 2025', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f7c2ebf20e74f197.png', 'MacBook Air M4 13 inch 2025', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fd723f28d9df5e67.png', 'MacBook Air M4 13 inch 2025', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/437fd313a084179b.png', 'MacBook Air M4 13 inch 2025', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/337adfb6baa01cd3.png', 'MacBook Air M4 13 inch 2025', 14);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Air M5 13 inch 2026', 'macbook-air-m5-13-inch-2026', 'CPS-macbook-air-m5-13-inch-2026', 'Hiệu năng đột phá với chip M5 và Neural Engine mạnh mẽ tối ưu hóa các tác vụ AI cùng khả năng đa nhiệm mượt mà cho mọi quy trình sáng tạo. · Hệ thống trí tuệ cá nhân Apple Intelligence hỗ trợ viết lách và xử lý công việc thông minh đi kèm cơ chế bảo vệ quyền riêng tư tuyệt đối. · Trải nghiệm thị giác sống động trên màn hình Liquid Retina 13.6 inch rực rỡ kết hợp thời lượng pin ấn tượng lên đến 18 giờ sử dụng liên tục.', 'Hiệu năng đột phá với chip M5 và Neural Engine mạnh mẽ tối ưu hóa các tác vụ AI cùng khả năng đa nhiệm mượt mà cho mọi quy trình sáng tạo.
Hệ thống trí tuệ cá nhân Apple Intelligence hỗ trợ viết lách và xử lý công việc thông minh đi kèm cơ chế bảo vệ quyền riêng tư tuyệt đối.
Trải nghiệm thị giác sống động trên màn hình Liquid Retina 13.6 inch rực rỡ kết hợp thời lượng pin ấn tượng lên đến 18 giờ sử dụng liên tục.
Kết nối hiện đại với Wi-Fi 7 và cổng Thunderbolt 4 cùng hệ thống camera 12MP Center Stage mang lại chất lượng cuộc gọi video chuyên nghiệp.

Kích thước màn hình: 13.6 inches
Độ phân giải: 2560 x 1664 pixels
CPU: Chip Apple M5 , CPU 10 lõi với 4 lõi siêu xử lý và 6 lõi tiết kiệm điện
Pin: Pin Li-Po 53,8 watt‑giờ tích hợp, Thời gian xem video trực tuyến lên đến 18 giờ, Thời gian duyệt web trên mạng không dây lên đến 15 giờ
Kích thước: 1.13 x 30.41 cm x 21.5 cm (Dày x Rộng x Dài)
Trọng lượng: 1.23 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/837fb48e730cf833.png', 32990000, 1, 1, 970);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125700', 'Bạc', '10CPU 8GPU 16GB 512GB', 35990000, 33690000, 20, '/uploads/products/apple/837fb48e730cf833.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125701', 'Ánh sao', '10CPU 8GPU 16GB 512GB', 35990000, 33490000, 20, '/uploads/products/apple/efea1db27a3d4bbd.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125702', 'Đêm xanh thẳm', '10CPU 8GPU 16GB 512GB', 35990000, 33490000, 20, '/uploads/products/apple/1780ad2da1deebea.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125703', 'Xanh da trời', '10CPU 8GPU 16GB 512GB', 35990000, 33490000, 20, '/uploads/products/apple/4270e23ea32c7783.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129219', 'Bạc', '10CPU 8GPU 16GB 512GB Sạc 70W', 36590000, 33990000, 20, '/uploads/products/apple/94907241d27ca568.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129220', 'Đêm xanh thẳm', '10CPU 8GPU 16GB 512GB Sạc 70W', 36590000, 33890000, 20, '/uploads/products/apple/31e143a95a4a593c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129221', 'Ánh sao', '10CPU 8GPU 16GB 512GB Sạc 70W', 36590000, 33890000, 20, '/uploads/products/apple/63936a436e5b3cf2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129222', 'Xanh da trời', '10CPU 8GPU 16GB 512GB Sạc 70W', 36590000, 32990000, 20, '/uploads/products/apple/0bdf601159fc6325.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-135144', 'Bạc', '10CPU 10GPU 16GB 512GB Sạc 30W', 38750000, 37790000, 20, '/uploads/products/apple/332ec8f49a8f4037.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-135145', 'Đêm xanh thẳm', '10CPU 10GPU 16GB 512GB Sạc 30W', 38750000, 37790000, 20, '/uploads/products/apple/b1e4ce0163b1d21c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-135146', 'Ánh sao', '10CPU 10GPU 16GB 512GB Sạc 30W', 38750000, 37790000, 20, '/uploads/products/apple/5b12a0a4ecaf40ae.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-135147', 'Xanh da trời', '10CPU 10GPU 16GB 512GB Sạc 30W', 38750000, 37790000, 20, '/uploads/products/apple/0c16d3596507dddf.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129207', 'Bạc', '10CPU 10GPU 24GB 512GB Sạc 70W', 41490000, 39590000, 20, '/uploads/products/apple/dc05207d3536a3e7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129208', 'Đêm xanh thẳm', '10CPU 10GPU 24GB 512GB Sạc 70W', 41490000, 39590000, 20, '/uploads/products/apple/f0422e2dad58644a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129209', 'Ánh sao', '10CPU 10GPU 24GB 512GB Sạc 70W', 41490000, 39590000, 20, '/uploads/products/apple/fadbf766294eec88.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129210', 'Xanh da trời', '10CPU 10GPU 24GB 512GB Sạc 70W', 41490000, 39590000, 20, '/uploads/products/apple/3271510ca3cbb878.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125705', 'Ánh sao', '10CPU 10GPU 16GB 1TB', 44250000, 40590000, 20, '/uploads/products/apple/a3fa7fd57e8bb007.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125706', 'Bạc', '10CPU 10GPU 16GB 1TB', 44250000, 40790000, 20, '/uploads/products/apple/8959e69ddd99dad7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125707', 'Đêm xanh thẳm', '10CPU 10GPU 16GB 1TB', 44250000, 40590000, 20, '/uploads/products/apple/90b7798ac30016d1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125708', 'Xanh da trời', '10CPU 10GPU 16GB 1TB', 44250000, 39890000, 20, '/uploads/products/apple/7fc2bd12b5a2e4a0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129194', 'Bạc', '10CPU 10GPU 16GB 1TB Sạc 70W', 44250000, 40790000, 20, '/uploads/products/apple/55e31462c29080c1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129196', 'Đêm xanh thẳm', '10CPU 10GPU 16GB 1TB Sạc 70W', 44250000, 40790000, 20, '/uploads/products/apple/476562139c95a592.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129197', 'Ánh sao', '10CPU 10GPU 16GB 1TB Sạc 70W', 44250000, 40790000, 20, '/uploads/products/apple/d944e3b594056433.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129198', 'Xanh da trời', '10CPU 10GPU 16GB 1TB Sạc 70W', 44250000, 40790000, 20, '/uploads/products/apple/ce434f68cd636d72.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125710', 'Bạc', '10CPU 10GPU 24GB 1TB', 49750000, 45990000, 20, '/uploads/products/apple/28e692f7051f8819.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125711', 'Ánh sao', '10CPU 10GPU 24GB 1TB', 49750000, 45990000, 20, '/uploads/products/apple/6a8d16c804a3e8d1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125712', 'Đêm xanh thẳm', '10CPU 10GPU 24GB 1TB', 49750000, 45990000, 20, '/uploads/products/apple/baa48d4a396eb6be.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125713', 'Xanh dương', '10CPU 10GPU 24GB 1TB', 49750000, 45990000, 20, '/uploads/products/apple/83a1ec2cfe96cf10.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129201', 'Bạc', '10CPU 10GPU 24GB 1TB Sạc 70W', 49750000, 45990000, 20, '/uploads/products/apple/7203bcadc7d37c41.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129202', 'Đêm xanh thẳm', '10CPU 10GPU 24GB 1TB Sạc 70W', 49750000, 45990000, 20, '/uploads/products/apple/63ab69d8327a5a44.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129203', 'Ánh sao', '10CPU 10GPU 24GB 1TB Sạc 70W', 49750000, 45990000, 20, '/uploads/products/apple/536d565956e36974.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129204', 'Xanh da trời', '10CPU 10GPU 24GB 1TB Sạc 70W', 49750000, 45990000, 20, '/uploads/products/apple/22f2f9ef576096fe.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f045e53c6cd9d681.png', 'MacBook Air M5 13 inch 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6309fc3361186ccc.png', 'MacBook Air M5 13 inch 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6e29180ffb371b43.jpg', 'MacBook Air M5 13 inch 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7f55bad1cfcf2021.jpg', 'MacBook Air M5 13 inch 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/86fe7dfdb85cd4f0.jpg', 'MacBook Air M5 13 inch 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9f420dcc85ae4ef7.jpg', 'MacBook Air M5 13 inch 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bd84d8523a7fb3f9.jpg', 'MacBook Air M5 13 inch 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c16c8709aa0ffa14.jpg', 'MacBook Air M5 13 inch 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/156ecbaab70d2f0a.jpg', 'MacBook Air M5 13 inch 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/837fb48e730cf833.png', 'MacBook Air M5 13 inch 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/efea1db27a3d4bbd.png', 'MacBook Air M5 13 inch 2026', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1780ad2da1deebea.png', 'MacBook Air M5 13 inch 2026', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4270e23ea32c7783.png', 'MacBook Air M5 13 inch 2026', 12);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Pro 14 M5', 'macbook-pro-14-m5', 'CPS-macbook-pro-14-m5', 'M5 được trang bị CPU và GPU mạnh mẽ hơn với Neural Accelerator tích hợp, mang lại hiệu suất AI vượt trội giúp bạn xử lý công việc nặng nhanh chóng. · Hệ thống Apple Intelligence hỗ trợ bạn hoàn thành công việc và bảo vệ quyền riêng tư với tính năng an toàn. · MacBook Pro 14 inch cung cấp hiệu suất liên tục, cho phép làm việc không ngừng nghỉ, bất kể khi cắm sạc hay sử dụng pin.', 'M5 được trang bị CPU và GPU mạnh mẽ hơn với Neural Accelerator tích hợp, mang lại hiệu suất AI vượt trội giúp bạn xử lý công việc nặng nhanh chóng.
Hệ thống Apple Intelligence hỗ trợ bạn hoàn thành công việc và bảo vệ quyền riêng tư với tính năng an toàn.
MacBook Pro 14 inch cung cấp hiệu suất liên tục, cho phép làm việc không ngừng nghỉ, bất kể khi cắm sạc hay sử dụng pin.
Với nhiều cổng Thunderbolt 4 và khả năng đồng bộ hóa liền mạch với iPhone, bạn dễ dàng chia sẻ dữ liệu giữa các thiết bị Apple.

Kích thước màn hình: 14.2 inches
Độ phân giải: 3024 x 1964 pixels
CPU: Chip Apple M5 10 lõi với 4 lõi hiệu năng và 6 lõi tiết kiệm điện
Pin: Thời gian xem video trực tuyến lên đến 24 giờ, Thời gian duyệt web trên mạng không dây lên đến 16 giờ, Pin Li-Po 72.4 watt-giờ
Kích thước: 1.55 x 31.26 x 22.12 cm (Cao x Rộng x Dài)
Trọng lượng: 1.55 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/633567a385d38d65.png', 46890000, 0, 1, 940);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116623', 'Bạc', '10CPU 10GPU 24GB 512GB', 46890000, NULL, 20, '/uploads/products/apple/633567a385d38d65.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-116624', 'Đen Không Gian', '10CPU 10GPU 24GB 512GB', 46890000, NULL, 20, '/uploads/products/apple/e096868cdedb8907.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115964', 'Đen Không Gian', '10CPU 10GPU 16GB 1TB', 54990000, 52990000, 20, '/uploads/products/apple/88c51742601494f1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115965', 'Bạc', '10CPU 10GPU 16GB 1TB', 54990000, 52990000, 20, '/uploads/products/apple/d1c5e8688ccf43c5.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-135922', 'Bạc', '10CPU 10GPU 16GB 1TB Sạc 96W', 55490000, 52990000, 20, '/uploads/products/apple/5008e1e3df14fead.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-135923', 'Đen Không Gian', '10CPU 10GPU 16GB 1TB Sạc 96W', 55490000, 52990000, 20, '/uploads/products/apple/7d53d928e615b36b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115967', 'Đen Không Gian', '10CPU 10GPU 24GB 1TB', 60490000, 58990000, 20, '/uploads/products/apple/2cae40150daaf6a2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-115968', 'Bạc', '10CPU 10GPU 24GB 1TB', 60490000, 57990000, 20, '/uploads/products/apple/ac675952af05a48f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-128643', 'Bạc', '10CPU 10GPU 32GB 1TB Sạc 70W', 65990000, 63990000, 20, '/uploads/products/apple/66fd4bccd07c7155.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-128644', 'Đen Không Gian', '10CPU 10GPU 32GB 1TB Sạc 70W', 65990000, 63990000, 20, '/uploads/products/apple/c0257b5942197456.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-128636', 'Bạc', '10CPU 10GPU 32GB 1TB Nano Sạc 70W', 70190000, 68990000, 20, '/uploads/products/apple/e6369f460ee24ae5.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-128637', 'Đen Không Gian', '10CPU 10GPU 32GB 1TB Nano Sạc 70W', 70190000, 68990000, 20, '/uploads/products/apple/ab48b33b184c54bd.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/717301b527141b76.png', 'MacBook Pro 14 M5', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c84386d2cee6218e.png', 'MacBook Pro 14 M5', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7fc995b13233d3a4.png', 'MacBook Pro 14 M5', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/312833ad92326d5a.png', 'MacBook Pro 14 M5', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9281e132bfebb153.png', 'MacBook Pro 14 M5', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1de942c59de64014.png', 'MacBook Pro 14 M5', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/32e344924f6bce7a.png', 'MacBook Pro 14 M5', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cbc2e2ad4192801a.png', 'MacBook Pro 14 M5', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/aeb060127cf8b41d.png', 'MacBook Pro 14 M5', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/88c51742601494f1.png', 'MacBook Pro 14 M5', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d1c5e8688ccf43c5.png', 'MacBook Pro 14 M5', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple Mac mini M6 2026', 'apple-mac-mini-m6-2026', 'CPS-apple-mac-mini-m6-2026', 'Thiết kế siêu nhỏ gọn, dễ dàng đặt gọn bên dưới màn hình hoặc linh hoạt thiết lập ở bất cứ không gian làm việc nào. · Hiệu năng mạnh mẽ từ chip Apple M6 tích hợp Neural Accelerator trong từng lõi GPU và Neural Engine 16 lõi kép, xử lý AI nhanh hơn đến 4.8x, tối ưu chạy các agent riêng và đa nhiệm mượt mà cùng Apple Intelligence, Siri AI. · Bộ nhớ thống nhất lên đến 32GB (băng thông 170GB/s) cùng ổ lưu trữ nhanh hơn đến 2x, đáp ứng truy xuất tập tin đa phương tiện lớn và xử lý các khối lượng công việc AI chuyên sâu.', 'Thiết kế siêu nhỏ gọn, dễ dàng đặt gọn bên dưới màn hình hoặc linh hoạt thiết lập ở bất cứ không gian làm việc nào.
Hiệu năng mạnh mẽ từ chip Apple M6 tích hợp Neural Accelerator trong từng lõi GPU và Neural Engine 16 lõi kép, xử lý AI nhanh hơn đến 4.8x, tối ưu chạy các agent riêng và đa nhiệm mượt mà cùng Apple Intelligence, Siri AI.
Bộ nhớ thống nhất lên đến 32GB (băng thông 170GB/s) cùng ổ lưu trữ nhanh hơn đến 2x, đáp ứng truy xuất tập tin đa phương tiện lớn và xử lý các khối lượng công việc AI chuyên sâu.
Hệ thống kết nối đa dạng (3 cổng Thunderbolt 4, HDMI, Ethernet 2.5Gb mặt sau; 2 cổng USB-C, jack tai nghe mặt trước), hỗ trợ xuất tối đa 3 màn hình ngoài, Wi-Fi 7, Bluetooth 6 qua chip N1 và đồng bộ liền mạch với iPhone trên macOS.

CPU: Chip Apple M6 , CPU 12 lõi với 2 lõi siêu xử lý, 4 lõi hiệu năng và 6 lõi tiết kiệm điện , Neural Accelerators , Công nghệ dò tia tốc độ cao bằng phần cứng, Băng thông bộ nhớ 153GB/s
Kích thước: 12.7 x 12.7 x 5.0 cm (Dài x Rộng x Dày)
Trọng lượng: 0.67 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be) , Chip mạng không dây Apple N1, Công nghệ mạng Thread
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/c4ce1f294970f2d4.png', 24090000, 0, 1, 930);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-140420', 'Bạc', '12CPU 12GPU 16GB 256GB', 24990000, 24090000, 20, '/uploads/products/apple/c4ce1f294970f2d4.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142104', 'Bạc', '12CPU 12GPU 24GB 256GB', 30490000, NULL, 20, '/uploads/products/apple/41693fb7650a715a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-140422', 'Bạc', '12CPU 12GPU 16GB 512GB', 30490000, 29990000, 20, '/uploads/products/apple/8a06d8b49b1bea1b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-140424', 'Bạc', '12CPU 12GPU 24GB 512GB', 35990000, NULL, 20, '/uploads/products/apple/383b772123ffb52e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142139', 'Bạc', '12CPU 12GPU 16GB 1TB', 38750000, NULL, 20, '/uploads/products/apple/a667add520ae6af6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142106', 'Bạc', '12CPU 12GPU 24GB 1TB', 44250000, NULL, 20, '/uploads/products/apple/ca86b3aed802fc1a.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b6cc09921064ad30.png', 'Apple Mac mini M6 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dc8fefd90003d82b.jpg', 'Apple Mac mini M6 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d39bbd0e6a844a16.jpg', 'Apple Mac mini M6 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6275282067c473c7.jpg', 'Apple Mac mini M6 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9bd5aec827570c25.jpg', 'Apple Mac mini M6 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ce5c8b19502ff4e8.jpg', 'Apple Mac mini M6 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f7e199b6ad2899cd.jpg', 'Apple Mac mini M6 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5eba13da867a7d32.jpg', 'Apple Mac mini M6 2026', 7);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Pro M5 Pro 14 inch 2026', 'macbook-pro-m5-pro-14-inch-2026', 'CPS-macbook-pro-m5-pro-14-inch-2026', 'Hiệu năng bứt phá với M5 Pro & M5 Max, GPU thế hệ mới cùng Neural Accelerator trên từng lõi mang lại sức mạnh AI vượt trội, xử lý mượt mà các tác vụ nặng và sáng tạo chuyên sâu. · Tối ưu cho AI & Apple Intelligence thiết kế dành riêng cho suy luận và đào tạo AI trên thiết bị, hỗ trợ làm việc thông minh hơn, nhanh hơn mà vẫn đảm bảo quyền riêng tư tối đa. · Pin cả ngày, hiệu năng không đổi duy trì sức mạnh ấn tượng dù cắm sạc hay dùng pin, giúp bạn làm việc liên tục mà không bị gián đoạn.', 'Hiệu năng bứt phá với M5 Pro & M5 Max, GPU thế hệ mới cùng Neural Accelerator trên từng lõi mang lại sức mạnh AI vượt trội, xử lý mượt mà các tác vụ nặng và sáng tạo chuyên sâu.
Tối ưu cho AI & Apple Intelligence thiết kế dành riêng cho suy luận và đào tạo AI trên thiết bị, hỗ trợ làm việc thông minh hơn, nhanh hơn mà vẫn đảm bảo quyền riêng tư tối đa.
Pin cả ngày, hiệu năng không đổi duy trì sức mạnh ấn tượng dù cắm sạc hay dùng pin, giúp bạn làm việc liên tục mà không bị gián đoạn.
Màn hình XDR & hệ thống âm thanh cao cấp Liquid Retina XDR siêu sáng, tương phản cực cao kết hợp camera 12MP và âm thanh Dolby Atmos mang đến trải nghiệm hình ảnh và hội họp đỉnh cao.

Kích thước màn hình: 14.2 inches
Độ phân giải: 3024 x 1964 pixels
CPU: Chip Apple M5 Pro, CPU 15 lõi với 5 lõi siêu xử lý và 10 lõi hiệu năng
Pin: Pin Li-Po 72,4 watt-giờ, Thời gian xem video trực tuyến lên đến 22 giờ, Thời gian duyệt web trên mạng không dây lên đến 14 giờ
Kích thước: 1.55 x 31.26 x 22.12 cm (Cao x Rộng x Dài)
Trọng lượng: 1.60 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/cde37ece7a8b5d3d.png', 66990000, 0, 1, 920);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125730', 'Bạc', '15CPU 16GPU 24GB 1TB', 68990000, 66990000, 20, '/uploads/products/apple/cde37ece7a8b5d3d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125731', 'Đen Không Gian', '15CPU 16GPU 24GB 1TB', 68990000, 66990000, 20, '/uploads/products/apple/023d1e59c2a27ffe.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129224', 'Bạc', '15CPU 16GPU 24GB 1TB Sạc 96W', 69490000, 66990000, 20, '/uploads/products/apple/6530fb0c3bc9777f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-129225', 'Đen Không Gian', '15CPU 16GPU 24GB 1TB Sạc 96W', 69490000, 66990000, 20, '/uploads/products/apple/9db9149512e9b614.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125733', 'Bạc', '15CPU 16GPU 24GB 2TB', 82750000, 79990000, 20, '/uploads/products/apple/e3b5ce5ea9192ac3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125734', 'Đen Không Gian', '15CPU 16GPU 24GB 2TB', 82750000, 79990000, 20, '/uploads/products/apple/a3846a41ff0376d3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125736', 'Bạc', '18CPU 20GPU 24GB 2TB', 88990000, 87990000, 20, '/uploads/products/apple/ecef7be9a64f95d6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125737', 'Đen Không Gian', '18CPU 20GPU 24GB 2TB', 88990000, 87990000, 20, '/uploads/products/apple/af887b18d7441cca.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/96ae6630fd197c6d.png', 'MacBook Pro M5 Pro 14 inch 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1a691ca71d4aad46.png', 'MacBook Pro M5 Pro 14 inch 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/73ba6174c0fa9a9b.jpg', 'MacBook Pro M5 Pro 14 inch 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4de5e73475822c07.jpg', 'MacBook Pro M5 Pro 14 inch 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/13ef0e16027bb599.jpg', 'MacBook Pro M5 Pro 14 inch 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4bfa6a1cff914a96.jpg', 'MacBook Pro M5 Pro 14 inch 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/12c88f24f48ab626.jpg', 'MacBook Pro M5 Pro 14 inch 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9d8516fbceb93d2e.jpg', 'MacBook Pro M5 Pro 14 inch 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/95f5211c3ea39eab.jpg', 'MacBook Pro M5 Pro 14 inch 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cde37ece7a8b5d3d.png', 'MacBook Pro M5 Pro 14 inch 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/023d1e59c2a27ffe.png', 'MacBook Pro M5 Pro 14 inch 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple iMac 24 2026 M6', 'apple-imac-24-2026-m6', 'CPS-apple-imac-24-2026-m6', 'Thiết kế tất cả trong một mỏng ấn tượng với 7 màu rực rỡ, sẵn sàng hoạt động ngay khi mở hộp, đi kèm màn hình Retina 4.5K 24 inch sáng 500 nit, hiển thị 1 tỷ màu và tùy chọn mặt kính Nano-texture giảm phản chiếu. · Sức mạnh vượt trội từ chip Apple M6 cùng bộ nhớ thống nhất lên đến 32GB, tối ưu chạy mô hình AI cục bộ, lập trình, chỉnh sửa ảnh/video mượt mà và tích hợp Apple Intelligence bảo vệ quyền riêng tư. · Trang bị camera 12MP Center Stage, 3 micrô chuẩn studio, 6 loa Âm Thanh Không Gian, cổng Thunderbolt 4, Wi-Fi 7, Bluetooth 6, hỗ trợ 2 màn hình ngoài 6K, bảo mật Touch ID và đồng bộ liền', 'Thiết kế tất cả trong một mỏng ấn tượng với 7 màu rực rỡ, sẵn sàng hoạt động ngay khi mở hộp, đi kèm màn hình Retina 4.5K 24 inch sáng 500 nit, hiển thị 1 tỷ màu và tùy chọn mặt kính Nano-texture giảm phản chiếu.
Sức mạnh vượt trội từ chip Apple M6 cùng bộ nhớ thống nhất lên đến 32GB, tối ưu chạy mô hình AI cục bộ, lập trình, chỉnh sửa ảnh/video mượt mà và tích hợp Apple Intelligence bảo vệ quyền riêng tư.
Trang bị camera 12MP Center Stage, 3 micrô chuẩn studio, 6 loa Âm Thanh Không Gian, cổng Thunderbolt 4, Wi-Fi 7, Bluetooth 6, hỗ trợ 2 màn hình ngoài 6K, bảo mật Touch ID và đồng bộ liền mạch với iPhone trên macOS.
Lựa chọn máy tính để bàn gọn nhẹ, toàn diện lý tưởng cho gia đình, chủ doanh nghiệp nhỏ và chuyên gia sáng tạo.

Kích thước màn hình: 24 inches
Độ phân giải: 4480 x 2520 (4.5K)
CPU: Chip Apple M6 , CPU 10 lõi với 2 lõi siêu xử lý, 3 lõi hiệu năng và 5 lõi tiết kiệm điện
Kích thước: 54.7 x 46.1 x 14.7 cm (Rộng x Cao x Dày)
Trọng lượng: 4.42 kg
Bluetooth: Bluetooth 6, Công nghệ mạng Thread
Wi-Fi: Chip mạng không dây Apple N1 , Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/2f9047b5d808438a.jpg', 41490000, 0, 1, 900);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146328', 'Bạc', '10CPU 10GPU 16GB 256GB', 41490000, NULL, 20, '/uploads/products/apple/2f9047b5d808438a.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146329', 'Xanh lá', '10CPU 10GPU 16GB 256GB', 41490000, NULL, 20, '/uploads/products/apple/d22539454aa5003a.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146330', 'Xanh dương', '10CPU 10GPU 16GB 256GB', 41490000, NULL, 20, '/uploads/products/apple/ece917aaaf6fd23b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146331', 'Hồng', '10CPU 10GPU 16GB 256GB', 41490000, NULL, 20, '/uploads/products/apple/32f4fc0b2bc5f394.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146333', 'Bạc', '12CPU 12GPU 16GB 256GB', 46990000, NULL, 20, '/uploads/products/apple/e4c70bcf5ade2bc0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146334', 'Xanh lá', '12CPU 12GPU 16GB 256GB', 46990000, NULL, 20, '/uploads/products/apple/c584ae7386b96882.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146335', 'Xanh dương', '12CPU 12GPU 16GB 256GB', 46990000, NULL, 20, '/uploads/products/apple/e95724a1d16d0549.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146336', 'Hồng', '12CPU 12GPU 16GB 256GB', 46990000, NULL, 20, '/uploads/products/apple/7987ff13506bf3c8.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146338', 'Bạc', '12CPU 12GPU 16GB 512GB', 52490000, NULL, 20, '/uploads/products/apple/5303cab19ee27435.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146339', 'Xanh lá', '12CPU 12GPU 16GB 512GB', 52490000, NULL, 20, '/uploads/products/apple/0fe25e9d2ce41b77.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146340', 'Xanh dương', '12CPU 12GPU 16GB 512GB', 52490000, NULL, 20, '/uploads/products/apple/5f69ad256d97b5ed.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146341', 'Hồng', '12CPU 12GPU 16GB 512GB', 52490000, NULL, 20, '/uploads/products/apple/15a285b6b9420a27.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146343', 'Bạc', '12CPU 12GPU 16GB 256GB Nano', 52490000, NULL, 20, '/uploads/products/apple/e97c861cd32518fd.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146345', 'Bạc', '12CPU 12GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/ac6a1da3f18bf04d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146346', 'Xanh lá', '12CPU 12GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/c9da33826135aeb4.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146347', 'Xanh dương', '12CPU 12GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/4e7df9da8e23077e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146348', 'Hồng', '12CPU 12GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/ec136950130b56d2.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6f62d7de164df493.jpg', 'Apple iMac 24 2026 M6', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7f8938b95cf27157.jpg', 'Apple iMac 24 2026 M6', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a2f77c4be56c422e.jpg', 'Apple iMac 24 2026 M6', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/35ba288ca3018f50.jpg', 'Apple iMac 24 2026 M6', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/05bff70fa542c85e.jpg', 'Apple iMac 24 2026 M6', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5c8d18751a64d428.jpg', 'Apple iMac 24 2026 M6', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0ce2915604540bcf.jpg', 'Apple iMac 24 2026 M6', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7a00e2c87341cde5.jpg', 'Apple iMac 24 2026 M6', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/894bf79e0e252b96.jpg', 'Apple iMac 24 2026 M6', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2f9047b5d808438a.jpg', 'Apple iMac 24 2026 M6', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d22539454aa5003a.jpg', 'Apple iMac 24 2026 M6', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ece917aaaf6fd23b.jpg', 'Apple iMac 24 2026 M6', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/32f4fc0b2bc5f394.jpg', 'Apple iMac 24 2026 M6', 12);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Air M5 15 inch 2026', 'macbook-air-m5-15-inch-2026', 'CPS-macbook-air-m5-15-inch-2026', 'MacBook Air mỏng nhẹ ấn tượng, thiết kế gọn để mang theo mọi nơi, đồng thời làm từ hơn 50% vật liệu tái chế. · Pin lên đến 18 giờ giúp bạn làm việc, học tập và giải trí lâu dài; sạc nhanh tới 50% trong 30 phút để bắt kịp tiến độ. · Hiệu năng cho AI nhanh hơn nhờ chip M5 (GPU + Neural Engine) và Neural Accelerator giúp tối ưu tác vụ từ xử lý hình ảnh đến chạy LLM hiệu quả.', 'MacBook Air mỏng nhẹ ấn tượng, thiết kế gọn để mang theo mọi nơi, đồng thời làm từ hơn 50% vật liệu tái chế.
Pin lên đến 18 giờ giúp bạn làm việc, học tập và giải trí lâu dài; sạc nhanh tới 50% trong 30 phút để bắt kịp tiến độ.
Hiệu năng cho AI nhanh hơn nhờ chip M5 (GPU + Neural Engine) và Neural Accelerator giúp tối ưu tác vụ từ xử lý hình ảnh đến chạy LLM hiệu quả.
Màn hình 500 nits, dải màu P3, True Tone cùng âm thanh hỗ trợ Dolby Atmos/Âm Thanh Không Gian mang lại trải nghiệm xem–nghe sống động và thoải mái.

Kích thước màn hình: 15.3 inches
Độ phân giải: 2880 x 1864 pixels
CPU: Chip Apple M5 , CPU 10 lõi với 4 lõi siêu xử lý và 6 lõi tiết kiệm điện
Pin: Pin Li-Po 66,5 watt‑giờ tích hợp, Thời gian xem video trực tuyến lên đến 18 giờ, Thời gian duyệt web trên mạng không dây lên đến 15 giờ
Kích thước: 1.15 x 34.04 cm x 23.76 cm (Dày x Rộng x Dài)
Trọng lượng: 1.51 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/61edd5cf1316a856.png', 38690000, 0, 1, 890);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125715', 'Bạc', '10CPU 10GPU 16GB 512GB', 41990000, 39490000, 20, '/uploads/products/apple/61edd5cf1316a856.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125716', 'Ánh sao', '10CPU 10GPU 16GB 512GB', 41990000, 38690000, 20, '/uploads/products/apple/a4a76704ded329ed.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125717', 'Đêm xanh thẳm', '10CPU 10GPU 16GB 512GB', 41990000, 38690000, 20, '/uploads/products/apple/0df908d0eeb8e649.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125718', 'Xanh da trời', '10CPU 10GPU 16GB 512GB', 41990000, 39490000, 20, '/uploads/products/apple/7d14afe4eb311670.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127597', 'Bạc', '10CPU 10GPU 16GB 512GB Sạc 70W', 41990000, 39490000, 20, '/uploads/products/apple/03cefd2d0f07d49f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127598', 'Ánh sao', '10CPU 10GPU 16GB 512GB Sạc 70W', 41990000, 38990000, 20, '/uploads/products/apple/8eec7641c3517885.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127600', 'Đêm xanh thẳm', '10CPU 10GPU 16GB 512GB Sạc 70W', 41990000, 38990000, 20, '/uploads/products/apple/74da2ac52d3d09ae.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127601', 'Xanh da trời', '10CPU 10GPU 16GB 512GB Sạc 70W', 41990000, 39490000, 20, '/uploads/products/apple/84343618829f0d13.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127606', 'Bạc', '10CPU 10GPU 24GB 512GB Sạc 70W', 48990000, 44790000, 20, '/uploads/products/apple/142e7731cccf465f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127607', 'Ánh sao', '10CPU 10GPU 24GB 512GB Sạc 70W', 48990000, 44790000, 20, '/uploads/products/apple/52368f3a20c505e9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127608', 'Đêm xanh thẳm', '10CPU 10GPU 24GB 512GB Sạc 70W', 48990000, 44790000, 20, '/uploads/products/apple/a6adfda3d0cdcd17.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127609', 'Xanh da trời', '10CPU 10GPU 24GB 512GB Sạc 70W', 48990000, 44790000, 20, '/uploads/products/apple/c50dde3a823f9e64.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125720', 'Bạc', '10CPU 10GPU 16GB 1TB', 50250000, 46090000, 20, '/uploads/products/apple/d748246b4f956c8e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125721', 'Ánh sao', '10CPU 10GPU 16GB 1TB', 50250000, 46090000, 20, '/uploads/products/apple/0f08104c54460e17.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125722', 'Đêm xanh thẳm', '10CPU 10GPU 16GB 1TB', 50250000, 46090000, 20, '/uploads/products/apple/6dcb09a01d0f6979.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125723', 'Xanh da trời', '10CPU 10GPU 16GB 1TB', 50250000, 49090000, 20, '/uploads/products/apple/981850a0be1aae9c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125725', 'Bạc', '10CPU 10GPU 24GB 1TB', 55750000, 51590000, 20, '/uploads/products/apple/6ae646c30bf8fbe4.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125726', 'Ánh sao', '10CPU 10GPU 24GB 1TB', 55750000, 51590000, 20, '/uploads/products/apple/0e3c29e2b278110b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125727', 'Đêm xanh thẳm', '10CPU 10GPU 24GB 1TB', 55750000, 51590000, 20, '/uploads/products/apple/14eb5d212008b8d6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125728', 'Xanh da trời', '10CPU 10GPU 24GB 1TB', 55750000, 51590000, 20, '/uploads/products/apple/6b3309177af4a615.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127618', 'Bạc', '10CPU 10GPU 24GB 1TB Sạc 70W', 55750000, 51590000, 20, '/uploads/products/apple/7820364502927ce9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127619', 'Ánh sao', '10CPU 10GPU 24GB 1TB Sạc 70W', 55750000, 51590000, 20, '/uploads/products/apple/999af9c3e7a776ef.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127620', 'Đêm xanh thẳm', '10CPU 10GPU 24GB 1TB Sạc 70W', 55750000, 51590000, 20, '/uploads/products/apple/6fe1166647e74446.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-127621', 'Xanh da trời', '10CPU 10GPU 24GB 1TB Sạc 70W', 55750000, 51590000, 20, '/uploads/products/apple/a9067f5de6b933eb.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fb66fec50959c4d2.png', 'MacBook Air M5 15 inch 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/aefe03b2e0d959c3.png', 'MacBook Air M5 15 inch 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2bec4051511cc18b.jpg', 'MacBook Air M5 15 inch 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ad41ef5e2744ba99.jpg', 'MacBook Air M5 15 inch 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4ba9ea48ec651a7f.jpg', 'MacBook Air M5 15 inch 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/33a204c78951c49d.jpg', 'MacBook Air M5 15 inch 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d2fe26141e39a3ae.jpg', 'MacBook Air M5 15 inch 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3652f74fc8a2ea44.jpg', 'MacBook Air M5 15 inch 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0129d2f978858e46.jpg', 'MacBook Air M5 15 inch 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/61edd5cf1316a856.png', 'MacBook Air M5 15 inch 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a4a76704ded329ed.png', 'MacBook Air M5 15 inch 2026', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0df908d0eeb8e649.png', 'MacBook Air M5 15 inch 2026', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7d14afe4eb311670.png', 'MacBook Air M5 15 inch 2026', 12);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple MacBook Air M2 2024', 'apple-macbook-air-m2-2024', 'CPS-apple-macbook-air-m2-2024', 'MacBook Air M2 được trang bị chip M2 mạnh mẽ, mang lại hiệu năng vượt trội cho việc học. · Thiết kế siêu mỏng chỉ 1,24 kg giúp bạn dễ dàng mang theo, trong khi bộ nhớ 16GB đảm bảo mọi tác vụ diễn ra nhanh chóng và mượt mà. · Màn hình Liquid Retina 13,6 inch với độ sáng 500 nit cung cấp hình ảnh sống động, cùng với thời lượng pin lên đến 18 giờ cho cả ngày làm việc.', 'MacBook Air M2 được trang bị chip M2 mạnh mẽ, mang lại hiệu năng vượt trội cho việc học.
Thiết kế siêu mỏng chỉ 1,24 kg giúp bạn dễ dàng mang theo, trong khi bộ nhớ 16GB đảm bảo mọi tác vụ diễn ra nhanh chóng và mượt mà.
Màn hình Liquid Retina 13,6 inch với độ sáng 500 nit cung cấp hình ảnh sống động, cùng với thời lượng pin lên đến 18 giờ cho cả ngày làm việc.
Máy còn có camera FaceTime HD 1080p, hệ thống âm thanh bốn loa và bàn phím Magic Keyboard với Touch ID, mang lại trải nghiệm sử dụng tuyệt vời.

Kích thước màn hình: 13.6 inches
Độ phân giải: 2560 x 1664 pixels
CPU: Apple M2 8 nhân
Pin: 52,6 Wh
Kích thước: Dày: 1,13cm - Chiều dài: 30,41cm Chiều rộng: 21,5cm
Trọng lượng: 1.27 kg
Bluetooth: 5.0
Wi-Fi: 802.11ax Wi-Fi 6
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/67170e8a68ccef4d.png', 18590000, 0, 1, 820);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-86459', 'Bạc', '8CPU 8GPU 16GB 256GB', 24990000, 19490000, 20, '/uploads/products/apple/67170e8a68ccef4d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-86460', 'Xám', '8CPU 8GPU 16GB 256GB', 24990000, 19490000, 20, '/uploads/products/apple/8b25399d72f140b6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-86461', 'Trắng vàng', '8CPU 8GPU 16GB 256GB', 24990000, 18590000, 20, '/uploads/products/apple/c99c702c53a5bbd2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-86462', 'Đen', '8CPU 8GPU 16GB 256GB', 24990000, 18590000, 20, '/uploads/products/apple/b5d10d86bc83e7d5.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3216d934ca2a83ae.jpg', 'Apple MacBook Air M2 2024', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5505e77c8fe7d0b1.jpg', 'Apple MacBook Air M2 2024', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c9040ce036b4d32b.jpg', 'Apple MacBook Air M2 2024', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/779aaa85a75ef8b2.jpg', 'Apple MacBook Air M2 2024', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2b820f1550a79cb6.jpg', 'Apple MacBook Air M2 2024', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/db6a6a8f42dab417.jpg', 'Apple MacBook Air M2 2024', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7f7c65f47b12d9a1.jpg', 'Apple MacBook Air M2 2024', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5b00103bb08391c7.jpg', 'Apple MacBook Air M2 2024', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fd7a009d8db6f3d1.jpg', 'Apple MacBook Air M2 2024', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/73d28425b31d53b8.jpg', 'Apple MacBook Air M2 2024', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c930c772cbc1147c.jpg', 'Apple MacBook Air M2 2024', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/67170e8a68ccef4d.png', 'Apple MacBook Air M2 2024', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8b25399d72f140b6.png', 'Apple MacBook Air M2 2024', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c99c702c53a5bbd2.png', 'Apple MacBook Air M2 2024', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b5d10d86bc83e7d5.png', 'Apple MacBook Air M2 2024', 14);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Pro 14 M4 Pro', 'macbook-pro-14-m4-pro', 'CPS-macbook-pro-14-m4-pro', 'MacBook Pro 14 inch được trang bị màn hình Nano-texture giúp giảm độ phản chiếu và chói, mang lại trải nghiệm xem tuyệt vời trong mọi điều kiện ánh sáng. · Với khả năng chạy các ứng dụng yêu thích như Microsoft 365 và Adobe Creative Cloud nhanh chóng, máy giúp tăng năng suất làm việc. · Thời gian khởi động nhanh chóng nhờ vào ổ SSD siêu nhanh, giúp bạn tiết kiệm thời gian khi mở máy và truy cập ứng dụng.', 'MacBook Pro 14 inch được trang bị màn hình Nano-texture giúp giảm độ phản chiếu và chói, mang lại trải nghiệm xem tuyệt vời trong mọi điều kiện ánh sáng.
Với khả năng chạy các ứng dụng yêu thích như Microsoft 365 và Adobe Creative Cloud nhanh chóng, máy giúp tăng năng suất làm việc.
Thời gian khởi động nhanh chóng nhờ vào ổ SSD siêu nhanh, giúp bạn tiết kiệm thời gian khi mở máy và truy cập ứng dụng.
Khả năng hỗ trợ lên đến hai màn hình ngoài với M4 Pro tạo ra không gian làm việc linh hoạt và hiệu quả hơn.

Kích thước màn hình: 14.2 inches
Độ phân giải: 3024 x 1964 pixels
CPU: Apple M4 Pro 14 lõi với 10 lõi hiệu năng và 4 lõi tiết kiệm điện
Pin: Pin Li-Po 72.4 watt-giờ, Thời gian xem video trực tuyến lên đến 22 giờ, Thời gian duyệt web trên mạng không dây lên đến 14 giờ
Kích thước: Dài: 22.12 cm x Cao: 1.55 cm x Rộng: 31.26 cm
Trọng lượng: 1.60 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/c166fcdde3a234f2.png', 64990000, 0, 1, 790);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-97064', 'Bạc', '14CPU 20GPU 24GB 512GB Nano', 70990000, 64990000, 20, '/uploads/products/apple/c166fcdde3a234f2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-97065', 'Đen', '14CPU 20GPU 24GB 512GB Nano', 70990000, 64990000, 20, '/uploads/products/apple/1b4569b73005cd0c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-97067', 'Bạc', '14CPU 20GPU 24GB 1TB Nano', 75990000, 66990000, 20, '/uploads/products/apple/b87e1faddd469ffb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-97068', 'Đen', '14CPU 20GPU 24GB 1TB Nano', 75990000, 66990000, 20, '/uploads/products/apple/05593c08ea5b5601.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/999c21bc6a125f83.png', 'MacBook Pro 14 M4 Pro', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/67d8dcb750f6cbe4.jpg', 'MacBook Pro 14 M4 Pro', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/702faea88dda2d69.jpg', 'MacBook Pro 14 M4 Pro', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5ca698ffddd9d8cb.jpg', 'MacBook Pro 14 M4 Pro', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/aa9a1654f94d8846.jpg', 'MacBook Pro 14 M4 Pro', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ec54a0397e789244.jpg', 'MacBook Pro 14 M4 Pro', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2bc700d43b984352.jpg', 'MacBook Pro 14 M4 Pro', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4dabe5d529d3e5fc.jpg', 'MacBook Pro 14 M4 Pro', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c166fcdde3a234f2.png', 'MacBook Pro 14 M4 Pro', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1b4569b73005cd0c.png', 'MacBook Pro 14 M4 Pro', 9);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Pro M5 Pro 16 inch 2026', 'macbook-pro-m5-pro-16-inch-2026', 'CPS-macbook-pro-m5-pro-16-inch-2026', 'Hiệu năng bứt phá với M5 Pro & M5 Max, GPU thế hệ mới cùng Neural Accelerator trên từng lõi mang lại sức mạnh AI vượt trội, xử lý mượt mà các tác vụ nặng và sáng tạo chuyên sâu. · Tối ưu cho AI & Apple Intelligence thiết kế dành riêng cho suy luận và đào tạo AI trên thiết bị, hỗ trợ làm việc thông minh hơn, nhanh hơn mà vẫn đảm bảo quyền riêng tư tối đa. · Pin cả ngày, hiệu năng không đổi duy trì sức mạnh ấn tượng dù cắm sạc hay dùng pin, giúp bạn làm việc liên tục mà không bị gián đoạn.', 'Hiệu năng bứt phá với M5 Pro & M5 Max, GPU thế hệ mới cùng Neural Accelerator trên từng lõi mang lại sức mạnh AI vượt trội, xử lý mượt mà các tác vụ nặng và sáng tạo chuyên sâu.
Tối ưu cho AI & Apple Intelligence thiết kế dành riêng cho suy luận và đào tạo AI trên thiết bị, hỗ trợ làm việc thông minh hơn, nhanh hơn mà vẫn đảm bảo quyền riêng tư tối đa.
Pin cả ngày, hiệu năng không đổi duy trì sức mạnh ấn tượng dù cắm sạc hay dùng pin, giúp bạn làm việc liên tục mà không bị gián đoạn.
Màn hình XDR & hệ thống âm thanh cao cấp Liquid Retina XDR siêu sáng, tương phản cực cao kết hợp camera 12MP và âm thanh Dolby Atmos mang đến trải nghiệm hình ảnh và hội họp đỉnh cao.

Kích thước màn hình: 16.2 inches
Độ phân giải: 3456 x 2234 pixels
CPU: Chip Apple M5 Pro, CPU 18 lõi với 6 lõi siêu xử lý và 12 lõi hiệu năng
Pin: Pin Li-Po 100 watt-giờ, Thời gian xem video trực tuyến lên đến 24 giờ, Thời gian duyệt web trên mạng không dây lên đến 17 giờ
Kích thước: 1.68 x 35.57 x 24.81 cm (Cao x Rộng x Dài)
Trọng lượng: 2.14 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/448269cfbe3c8f05.png', 78990000, 0, 1, 780);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125742', 'Bạc', '18CPU 20GPU 24GB 1TB', 81990000, 78990000, 20, '/uploads/products/apple/448269cfbe3c8f05.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125743', 'Đen Không Gian', '18CPU 20GPU 24GB 1TB', 81990000, 78990000, 20, '/uploads/products/apple/92be249bb25a792a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125745', 'Bạc', '18CPU 20GPU 48GB 1TB Sạc 140W', 98490000, 97990000, 20, '/uploads/products/apple/3d5fd871ee5fdb12.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125746', 'Đen Không Gian', '18CPU 20GPU 48GB 1TB Sạc 140W', 98490000, 97990000, 20, '/uploads/products/apple/a7ec7d96fbfbfce8.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/91e0fd9c719c1a11.png', 'MacBook Pro M5 Pro 16 inch 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5dde57a934a3ce70.png', 'MacBook Pro M5 Pro 16 inch 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e198ba68e9570df8.jpg', 'MacBook Pro M5 Pro 16 inch 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c889cf95be12bffe.jpg', 'MacBook Pro M5 Pro 16 inch 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f25eab8015df97d4.jpg', 'MacBook Pro M5 Pro 16 inch 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bece84450c278d70.jpg', 'MacBook Pro M5 Pro 16 inch 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/90591e11fe0a7684.jpg', 'MacBook Pro M5 Pro 16 inch 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6d58d3a1541aa25a.jpg', 'MacBook Pro M5 Pro 16 inch 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5b7671f83ebfaae3.jpg', 'MacBook Pro M5 Pro 16 inch 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/448269cfbe3c8f05.png', 'MacBook Pro M5 Pro 16 inch 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/92be249bb25a792a.png', 'MacBook Pro M5 Pro 16 inch 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Mac mini M4 2024', 'mac-mini-m4-2024', 'CPS-mac-mini-m4-2024', 'Mac mini có thiết kế nhỏ gọn với kích thước chỉ 5x5 inch, dễ dàng bố trí ở bất kỳ đâu trong không gian làm việc của bạn. · Chip M4 mạnh mẽ mang lại hiệu năng vượt trội, giúp các ứng dụng như Microsoft Excel, Adobe Photoshop và Zoom chạy nhanh chóng và mượt mà. · Mac mini đồng bộ hóa liền mạch với các thiết bị Apple khác, cho phép bạn xem và điều khiển iPhone từ máy Mac một cách dễ dàng.', 'Mac mini có thiết kế nhỏ gọn với kích thước chỉ 5x5 inch, dễ dàng bố trí ở bất kỳ đâu trong không gian làm việc của bạn.
Chip M4 mạnh mẽ mang lại hiệu năng vượt trội, giúp các ứng dụng như Microsoft Excel, Adobe Photoshop và Zoom chạy nhanh chóng và mượt mà.
Mac mini đồng bộ hóa liền mạch với các thiết bị Apple khác, cho phép bạn xem và điều khiển iPhone từ máy Mac một cách dễ dàng.
Với các cổng Thunderbolt, HDMI và Gigabit Ethernet ở mặt sau, cùng với cổng USB-C và jack cắm tai nghe ở mặt trước, Mac mini cung cấp kết nối linh hoạt cho mọi nhu cầu của bạn.

CPU: Apple M4 10 lõi với 4 lõi hiệu năng và 6 lõi tiết kiệm điện, Neural Engine 16 lõi
Kích thước: Cao: 5.0 cm x Rộng: 12.7 cm x Dài: 12.7 cm
Trọng lượng: 0.67 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/e6e0a3e91ed0903c.jpg', 21990000, 0, 1, 770);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93963', 'Bạc', '10CPU 10GPU 16GB 256GB', 21990000, NULL, 20, '/uploads/products/apple/e6e0a3e91ed0903c.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93965', 'Bạc', '10CPU 10GPU 16GB 512GB', 27490000, 24990000, 20, '/uploads/products/apple/d848f92cd6ec89a4.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-101354', 'Bạc', '10CPU 10GPU 24GB 256GB', 28490000, 27990000, 20, '/uploads/products/apple/b368a7987e563d9a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93966', 'Bạc', '10CPU 10GPU 24GB 512GB', 33990000, 32590000, 20, '/uploads/products/apple/2c6d7ba378a2f2d8.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-118710', 'Bạc', '10CPU 10GPU 16GB 1TB', 35790000, 33990000, 20, '/uploads/products/apple/1f254a0a7acf72da.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-98619', 'Bạc', '10CPU 10GPU 24GB 1TB', 42990000, 39990000, 20, '/uploads/products/apple/448333b40ab77475.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/501dcd0a31b6c0f1.jpg', 'Mac mini M4 2024', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9491cc814ab49d7c.jpg', 'Mac mini M4 2024', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b0c8f3175a1508ba.jpg', 'Mac mini M4 2024', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4fac6c1ff19cf133.jpg', 'Mac mini M4 2024', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c10bba908f323e3e.jpg', 'Mac mini M4 2024', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b4562bdfb43c4c3b.jpg', 'Mac mini M4 2024', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e031266a010529fe.jpg', 'Mac mini M4 2024', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1b97dad65c719522.jpg', 'Mac mini M4 2024', 7);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Pro M5 Max 16 inch 2026', 'macbook-pro-m5-max-16-inch-2026', 'CPS-macbook-pro-m5-max-16-inch-2026', 'Hiệu năng bứt phá với M5 Pro & M5 Max, GPU thế hệ mới cùng Neural Accelerator trên từng lõi mang lại sức mạnh AI vượt trội, xử lý mượt mà các tác vụ nặng và sáng tạo chuyên sâu. · Tối ưu cho AI & Apple Intelligence thiết kế dành riêng cho suy luận và đào tạo AI trên thiết bị, hỗ trợ làm việc thông minh hơn, nhanh hơn mà vẫn đảm bảo quyền riêng tư tối đa. · Pin cả ngày, hiệu năng không đổi duy trì sức mạnh ấn tượng dù cắm sạc hay dùng pin, giúp bạn làm việc liên tục mà không bị gián đoạn.', 'Hiệu năng bứt phá với M5 Pro & M5 Max, GPU thế hệ mới cùng Neural Accelerator trên từng lõi mang lại sức mạnh AI vượt trội, xử lý mượt mà các tác vụ nặng và sáng tạo chuyên sâu.
Tối ưu cho AI & Apple Intelligence thiết kế dành riêng cho suy luận và đào tạo AI trên thiết bị, hỗ trợ làm việc thông minh hơn, nhanh hơn mà vẫn đảm bảo quyền riêng tư tối đa.
Pin cả ngày, hiệu năng không đổi duy trì sức mạnh ấn tượng dù cắm sạc hay dùng pin, giúp bạn làm việc liên tục mà không bị gián đoạn.
Màn hình XDR & hệ thống âm thanh cao cấp Liquid Retina XDR siêu sáng, tương phản cực cao kết hợp camera 12MP và âm thanh Dolby Atmos mang đến trải nghiệm hình ảnh và hội họp đỉnh cao.

Kích thước màn hình: 16.2 inches
Độ phân giải: 3456 x 2234 pixels
CPU: Chip Apple M5 Max, CPU 18 lõi với 6 lõi siêu xử lý và 12 lõi hiệu năng
Pin: Pin Li-Po 100 watt-giờ, Thời gian xem video trực tuyến lên đến 22 giờ, Thời gian duyệt web trên mạng không dây lên đến 16 giờ
Kích thước: 1.68 x 35.57 x 24.81 cm (Cao x Rộng x Dài)
Trọng lượng: 2.15 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/bd69398e37096523.png', 117490000, 0, 1, 750);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125748', 'Bạc', '18CPU 32GPU 36GB 2TB Sạc 140W', 119990000, 117490000, 20, '/uploads/products/apple/bd69398e37096523.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125749', 'Đen Không Gian', '18CPU 32GPU 36GB 2TB Sạc 140W', 119990000, 117490000, 20, '/uploads/products/apple/51ed95642b49df0f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125751', 'Bạc', '18CPU 40GPU 48GB 2TB Sạc 140W', 134990000, 132990000, 20, '/uploads/products/apple/e6a2c6e71c13e2c6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125752', 'Đen Không Gian', '18CPU 40GPU 48GB 2TB Sạc 140W', 134990000, 132990000, 20, '/uploads/products/apple/f6842073fca67aef.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c42d98a891f179a4.png', 'MacBook Pro M5 Max 16 inch 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/57f2d95badd667c2.png', 'MacBook Pro M5 Max 16 inch 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/24f3d65367259b48.jpg', 'MacBook Pro M5 Max 16 inch 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/342d7807328d7d74.jpg', 'MacBook Pro M5 Max 16 inch 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b6fe71c8a1f8f77d.jpg', 'MacBook Pro M5 Max 16 inch 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/53d5567695d28205.jpg', 'MacBook Pro M5 Max 16 inch 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d48b35e3cb658a89.jpg', 'MacBook Pro M5 Max 16 inch 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/772bb7a26a80c8e4.jpg', 'MacBook Pro M5 Max 16 inch 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/33be38e05dc42484.jpg', 'MacBook Pro M5 Max 16 inch 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e6a2c6e71c13e2c6.png', 'MacBook Pro M5 Max 16 inch 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f6842073fca67aef.png', 'MacBook Pro M5 Max 16 inch 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple Mac Studio M5 Max 2026', 'apple-mac-studio-m5-max-2026', 'CPS-apple-mac-studio-m5-max-2026', 'Thiết kế nhỏ gọn kích thước vuông 7.7 inch đặt gọn dưới màn hình, tích hợp hệ thống tản nhiệt tiên tiến giúp vận hành êm ái ngay cả khi xử lý các tác vụ chuyên sâu. · Hiệu năng đột phá từ chip Apple M5 Max với công nghệ dò tia thế hệ thứ ba và Neural Accelerator trong từng lõi GPU, tối ưu dựng hình thời gian thực, chạy mô hình LLM đồ sộ trên thiết bị cùng Apple Intelligence và Siri AI. · Bộ nhớ thống nhất lên đến 128GB (băng thông 614GB/s) cùng ổ lưu trữ nhanh hơn đến 2x, xử lý mượt mà tập dữ liệu khổng lồ, cảnh 3D phức tạp và truyền tải dự án dung lượng lớn.', 'Thiết kế nhỏ gọn kích thước vuông 7.7 inch đặt gọn dưới màn hình, tích hợp hệ thống tản nhiệt tiên tiến giúp vận hành êm ái ngay cả khi xử lý các tác vụ chuyên sâu.
Hiệu năng đột phá từ chip Apple M5 Max với công nghệ dò tia thế hệ thứ ba và Neural Accelerator trong từng lõi GPU, tối ưu dựng hình thời gian thực, chạy mô hình LLM đồ sộ trên thiết bị cùng Apple Intelligence và Siri AI.
Bộ nhớ thống nhất lên đến 128GB (băng thông 614GB/s) cùng ổ lưu trữ nhanh hơn đến 2x, xử lý mượt mà tập dữ liệu khổng lồ, cảnh 3D phức tạp và truyền tải dự án dung lượng lớn.
Kết nối siêu mạnh mẽ với 4 cổng Thunderbolt 5 (hỗ trợ liên kết AI theo cụm hoặc mở rộng PCIe), 2 USB-C, 2 USB-A, HDMI, khe SDXC, xuất tối đa 5 màn hình ngoài, Wi-Fi 7, Bluetooth 6 qua chip N1 và đồng bộ liền mạch với iPhone trên macOS.

CPU: Chip Apple M5 Max, CPU 18 lõi với 6 lõi siêu xử lý và 12 lõi hiệu năng, Neural Accelerators, Công nghệ dò tia tốc độ cao bằng phần cứng, Băng thông bộ nhớ 460GB/s
Kích thước: 19.7 x 19.7 x 9.5 cm (Dài x Rộng x Dày)
Trọng lượng: 2.7 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be) , Chip mạng không dây Apple N1, Công nghệ mạng Thread
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/479a2cd01ea6b9fd.png', 69990000, 0, 1, 690);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-140428', 'Bạc', '18CPU 32GPU 36GB 512GB', 69990000, NULL, 20, '/uploads/products/apple/479a2cd01ea6b9fd.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142364', 'Bạc', '18CPU 32GPU 36GB 1TB', 78250000, NULL, 20, '/uploads/products/apple/60aaf41d4a3d7af4.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142362', 'Bạc', '18CPU 40GPU 48GB 1TB', 94750000, NULL, 20, '/uploads/products/apple/c86d830935743c73.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142360', 'Bạc', '18CPU 40GPU 64GB 1TB', 105750000, NULL, 20, '/uploads/products/apple/9681cf949fec738e.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e42b53a626a87f78.jpg', 'Apple Mac Studio M5 Max 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/751b70b8cbf40d37.jpg', 'Apple Mac Studio M5 Max 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/026355532b37a58c.jpg', 'Apple Mac Studio M5 Max 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8d9ca1ae56246eda.jpg', 'Apple Mac Studio M5 Max 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b457fe5a5e4afdbe.jpg', 'Apple Mac Studio M5 Max 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1f15f4eac67fe89e.jpg', 'Apple Mac Studio M5 Max 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/982b2b530df03f62.jpg', 'Apple Mac Studio M5 Max 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dad68d05e2bcf024.jpg', 'Apple Mac Studio M5 Max 2026', 7);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple Mac mini M5 Pro 2026', 'apple-mac-mini-m5-pro-2026', 'CPS-apple-mac-mini-m5-pro-2026', 'Thiết kế siêu nhỏ gọn, dễ dàng đặt gọn bên dưới màn hình hoặc linh hoạt thiết lập ở bất cứ không gian làm việc nào. · Sức mạnh vượt trội từ chip Apple M5 Pro tích hợp Neural Accelerator trong mỗi lõi GPU, mang lại hiệu năng AI nhanh hơn đến 4x, tối ưu chạy mô hình LLM ngay trên thiết bị cùng Apple Intelligence và Siri AI. · Băng thông bộ nhớ lên đến 307GB/s cùng ổ lưu trữ nhanh hơn đến 2x, đáp ứng kết xuất nhanh và xử lý mượt mà các tập dữ liệu tùy chỉnh lớn hay tập tin video ProRes RAW chuyên nghiệp.', 'Thiết kế siêu nhỏ gọn, dễ dàng đặt gọn bên dưới màn hình hoặc linh hoạt thiết lập ở bất cứ không gian làm việc nào.
Sức mạnh vượt trội từ chip Apple M5 Pro tích hợp Neural Accelerator trong mỗi lõi GPU, mang lại hiệu năng AI nhanh hơn đến 4x, tối ưu chạy mô hình LLM ngay trên thiết bị cùng Apple Intelligence và Siri AI.
Băng thông bộ nhớ lên đến 307GB/s cùng ổ lưu trữ nhanh hơn đến 2x, đáp ứng kết xuất nhanh và xử lý mượt mà các tập dữ liệu tùy chỉnh lớn hay tập tin video ProRes RAW chuyên nghiệp.
Hệ thống kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, Ethernet 2.5Gb mặt sau; 2 cổng USB-C, jack tai nghe mặt trước), hỗ trợ xuất tối đa 3 màn hình ngoài, Wi-Fi 7, Bluetooth 6 qua chip N1 và đồng bộ liền mạch với iPhone trên macOS.

CPU: Chip Apple M5 Pro , CPU 15 lõi với 5 lõi siêu xử lý và 10 lõi hiệu năng, Neural Accelerators , Công nghệ dò tia tốc độ cao bằng phần cứng, Băng thông bộ nhớ 307GB/s
Kích thước: 12.7 x 12.7 x 5.0 cm (Dài x Rộng x Dày)
Trọng lượng: 0.73 kg
Bluetooth: Bluetooth 6
Wi-Fi: Wi-Fi 7 (802.11be) , Chip mạng không dây Apple N1, Công nghệ mạng Thread
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/09053201f92fb7ca.png', 46990000, 0, 1, 630);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-140426', 'Bạc', '15CPU 16GPU 24GB 512GB', 47990000, 46990000, 20, '/uploads/products/apple/09053201f92fb7ca.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142154', 'Bạc', '15CPU 16GPU 24GB 1TB', 56250000, NULL, 20, '/uploads/products/apple/dd54350e08cd39cb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142152', 'Bạc', '15CPU 16GPU 48GB 512GB', 64490000, NULL, 20, '/uploads/products/apple/74d08d6a7007897a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142156', 'Bạc', '15CPU 16GPU 64GB 1TB', 83750000, NULL, 20, '/uploads/products/apple/49390ec0bac7ca7a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-142163', 'Bạc', '18CPU 20GPU 64GB 1TB', 89250000, NULL, 20, '/uploads/products/apple/8e8fca2b8bb6eaf3.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/51b26a2318fdae59.png', 'Apple Mac mini M5 Pro 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8c4ccd9a6c5677b0.jpg', 'Apple Mac mini M5 Pro 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bd07ce79aca1b30b.jpg', 'Apple Mac mini M5 Pro 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/02f5985dc32fe85a.jpg', 'Apple Mac mini M5 Pro 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4dc5c8db538d4404.jpg', 'Apple Mac mini M5 Pro 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/60ca90d69578af51.jpg', 'Apple Mac mini M5 Pro 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e6d3654807b9d653.jpg', 'Apple Mac mini M5 Pro 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b63a222b22f12d4e.jpg', 'Apple Mac mini M5 Pro 2026', 7);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'iMac M4 2024 24 inch', 'apple-imac-m4-2024-24-inch', 'CPS-imac-m4-2024-24-inch', 'iMac với thiết kế mỏng ấn tượng và bảy màu sắc rực rỡ, mang đến phong cách hoàn hảo cho mọi không gian. · Chip Apple M4 siêu mạnh mẽ giúp bạn dễ dàng xử lý mọi tác vụ từ chỉnh sửa ảnh đến chơi game. · Màn hình Retina 4,5K 24 inch với độ sáng 500 nit và hỗ trợ lên đến 1 tỷ màu, mang lại trải nghiệm hình ảnh sống động và sắc nét.', 'iMac với thiết kế mỏng ấn tượng và bảy màu sắc rực rỡ, mang đến phong cách hoàn hảo cho mọi không gian.
Chip Apple M4 siêu mạnh mẽ giúp bạn dễ dàng xử lý mọi tác vụ từ chỉnh sửa ảnh đến chơi game.
Màn hình Retina 4,5K 24 inch với độ sáng 500 nit và hỗ trợ lên đến 1 tỷ màu, mang lại trải nghiệm hình ảnh sống động và sắc nét.
Camera 12MP Center Stage và âm thanh chất lượng studio với sáu loa tạo ra trải nghiệm truyền hình và hội nghị tuyệt vời.

Kích thước màn hình: 24 inches
Độ phân giải: 4480 x 2520 (4.5K)
CPU: Apple M4 8 lõi với 4 lõi hiệu năng và 4 lõi tiết kiệm điện, Neural Engine 16 lõi
Kích thước: Rộng: 54.7 cm - Cao: 46.1 cm - Độ dày chân đế: 14.7 cm
Trọng lượng: 4.42 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi-Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/9d756ce94f913ebe.jpg', 38990000, 0, 1, 600);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93865', 'Bạc', '8CPU 8GPU 16GB 256GB', 41490000, 38990000, 20, '/uploads/products/apple/9d756ce94f913ebe.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93869', 'Xanh', '8CPU 8GPU 16GB 256GB', 41490000, 38990000, 20, '/uploads/products/apple/41b7cc32a5052ca3.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93870', 'Hồng', '8CPU 8GPU 16GB 256GB', 41490000, 38990000, 20, '/uploads/products/apple/763946b99bb9e47d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93871', 'Xanh lá', '8CPU 8GPU 16GB 256GB', 41490000, 38990000, 20, '/uploads/products/apple/d23ab81618afdd6d.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93872', 'Vàng', '8CPU 8GPU 16GB 256GB', 41490000, 38990000, 20, '/uploads/products/apple/c8289817d839adc6.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93873', 'Tím', '8CPU 8GPU 16GB 256GB', 41490000, 38990000, 20, '/uploads/products/apple/ba0f932aa8eb96db.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93874', 'Cam', '8CPU 8GPU 16GB 256GB', 41490000, 38990000, 20, '/uploads/products/apple/7b414b36c6a228bd.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93883', 'Bạc', '10CPU 10GPU 16GB 256GB', 46990000, 41990000, 20, '/uploads/products/apple/0a25d75eda38e5b8.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93884', 'Xanh', '10CPU 10GPU 16GB 256GB', 46990000, 41990000, 20, '/uploads/products/apple/7c8dab67221d5f21.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93885', 'Hồng', '10CPU 10GPU 16GB 256GB', 46990000, 41990000, 20, '/uploads/products/apple/59521ebdeb3608c0.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93886', 'Xanh lá', '10CPU 10GPU 16GB 256GB', 46990000, 41990000, 20, '/uploads/products/apple/f39122849d5c8833.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93887', 'Vàng', '10CPU 10GPU 16GB 256GB', 46990000, 41990000, 20, '/uploads/products/apple/d9a208a2bcfe4232.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93888', 'Tím', '10CPU 10GPU 16GB 256GB', 46990000, 41990000, 20, '/uploads/products/apple/3e7c7d4c354c79d3.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93889', 'Cam', '10CPU 10GPU 16GB 256GB', 46990000, 41990000, 20, '/uploads/products/apple/5809395a0c412ebb.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93876', 'Bạc', '8CPU 8GPU 16GB 512GB', 46990000, 43590000, 20, '/uploads/products/apple/1b5b9e8cf15016f4.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93877', 'Xanh', '8CPU 8GPU 16GB 512GB', 46990000, 43590000, 20, '/uploads/products/apple/2eb1304b27fb72a6.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93878', 'Hồng', '8CPU 8GPU 16GB 512GB', 46990000, 43590000, 20, '/uploads/products/apple/895d15454e99593b.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93879', 'Xanh lá', '8CPU 8GPU 16GB 512GB', 46990000, 43590000, 20, '/uploads/products/apple/85fdf2d2691fa90e.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93880', 'Vàng', '8CPU 8GPU 16GB 512GB', 46990000, 43590000, 20, '/uploads/products/apple/9f1eb2cb38515502.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93881', 'Tím', '8CPU 8GPU 16GB 512GB', 46990000, 43590000, 20, '/uploads/products/apple/b23d87a9787d118f.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-93882', 'Cam', '8CPU 8GPU 16GB 512GB', 46990000, 43590000, 20, '/uploads/products/apple/9e90f8fa4a12f698.jpg', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-96013', 'Bạc', '10CPU 10GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/e59b1a93bdcd4265.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-96014', 'Xanh lá', '10CPU 10GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/1c069e481a412aa7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-96015', 'Xanh', '10CPU 10GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/0304f18adba86be1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-96016', 'Hồng', '10CPU 10GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/313a5b10e16eae63.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-96340', 'Cam', '10CPU 10GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/9b3226c2f956e05c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-96341', 'Tím', '10CPU 10GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/25e91819e67850b0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-96342', 'Vàng', '10CPU 10GPU 24GB 512GB', 57990000, NULL, 20, '/uploads/products/apple/9c4393471bfd7bbe.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/44f387e4fec21f2b.jpg', 'iMac M4 2024 24 inch', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/722c3cbaa63dcd28.jpg', 'iMac M4 2024 24 inch', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d70e7fe552af5e3b.jpg', 'iMac M4 2024 24 inch', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c90385bf547d8a9e.jpg', 'iMac M4 2024 24 inch', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d6310b51baf69e54.jpg', 'iMac M4 2024 24 inch', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c1ca151ddff66bf3.jpg', 'iMac M4 2024 24 inch', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/587b917b470d193f.jpg', 'iMac M4 2024 24 inch', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/36e9c07f93f7eccd.jpg', 'iMac M4 2024 24 inch', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bd1599c4e43557ab.jpg', 'iMac M4 2024 24 inch', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9d756ce94f913ebe.jpg', 'iMac M4 2024 24 inch', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/41b7cc32a5052ca3.jpg', 'iMac M4 2024 24 inch', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/763946b99bb9e47d.jpg', 'iMac M4 2024 24 inch', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d23ab81618afdd6d.jpg', 'iMac M4 2024 24 inch', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c8289817d839adc6.jpg', 'iMac M4 2024 24 inch', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ba0f932aa8eb96db.jpg', 'iMac M4 2024 24 inch', 14);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7b414b36c6a228bd.jpg', 'iMac M4 2024 24 inch', 15);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Pro 16 M4 Max', 'macbook-pro-16-m4-max', 'CPS-macbook-pro-16-m4-max', 'MacBook Pro có thời lượng pin lên đến 24 giờ, cho phép bạn làm việc suốt cả ngày mà không cần lo lắng về việc sạc. · Màn hình Liquid Retina XDR với độ tương phản 1.000.000:1 mang đến hình ảnh sắc nét và màu sắc sống động, lý tưởng cho các dự án sáng tạo. · Với khả năng chạy mượt mà các ứng dụng như Microsoft 365 và Adobe Creative Cloud, máy giúp nâng cao hiệu suất công việc đáng kể.', 'MacBook Pro có thời lượng pin lên đến 24 giờ, cho phép bạn làm việc suốt cả ngày mà không cần lo lắng về việc sạc.
Màn hình Liquid Retina XDR với độ tương phản 1.000.000:1 mang đến hình ảnh sắc nét và màu sắc sống động, lý tưởng cho các dự án sáng tạo.
Với khả năng chạy mượt mà các ứng dụng như Microsoft 365 và Adobe Creative Cloud, máy giúp nâng cao hiệu suất công việc đáng kể.
Tính năng bảo mật tích hợp với các bản cập nhật miễn phí giúp bảo vệ máy Mac của bạn trước các mối đe dọa, giữ cho dữ liệu cá nhân luôn an toàn.

Kích thước màn hình: 16.2 inches
Độ phân giải: 3456 x 2234 pixels
CPU: Apple M4 Max 16 lõi với 12 lõi hiệu năng và 4 lõi tiết kiệm điện
Pin: Pin Li-Po 100 watt-giờ, Thời gian xem video trực tuyến lên đến 21 giờ, Thời gian duyệt web trên mạng không dây lên đến 14 giờ
Kích thước: Dài: 24.81 cm x Rộng: 35.57 cm x Cao: 1.68 cm
Trọng lượng: 2.15 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/36e28638fa093368.png', 95990000, 0, 1, 490);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-94116', 'Bạc', '16CPU 40GPU 48GB 1TB', 103740000, 95990000, 20, '/uploads/products/apple/36e28638fa093368.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-94117', 'Đen', '16CPU 40GPU 48GB 1TB', 103740000, 95990000, 20, '/uploads/products/apple/557df97d7edbcc05.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e7249d1bdac5a8fd.png', 'MacBook Pro 16 M4 Max', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/940e90d2dd9e2469.jpg', 'MacBook Pro 16 M4 Max', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a15cce94ef9f7c21.jpg', 'MacBook Pro 16 M4 Max', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/88bfacd6d0a90eae.jpg', 'MacBook Pro 16 M4 Max', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/06e6af2815f13a2e.jpg', 'MacBook Pro 16 M4 Max', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a62c71ef0b4706b6.jpg', 'MacBook Pro 16 M4 Max', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7da8c10f49b3c74a.jpg', 'MacBook Pro 16 M4 Max', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/63dfee032c6be60a.jpg', 'MacBook Pro 16 M4 Max', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/36e28638fa093368.png', 'MacBook Pro 16 M4 Max', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/557df97d7edbcc05.png', 'MacBook Pro 16 M4 Max', 9);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Pro 16 M4 Pro', 'macbook-pro-16-m4-pro', 'CPS-macbook-pro-16-m4-pro', 'MacBook Pro sở hữu âm thanh tiên tiến với sáu loa và chế độ Âm Thanh Không Gian hỗ trợ Dolby Atmos, mang đến trải nghiệm nghe tuyệt vời. · Chip M4 Pro cho phép xử lý các luồng công việc phức tạp một cách nhanh chóng, lý tưởng cho các chuyên gia trong lĩnh vực sáng tạo. · Với thời lượng pin lên đến 24 giờ, máy đảm bảo bạn có đủ năng lượng để làm việc suốt cả ngày mà không cần sạc.', 'MacBook Pro sở hữu âm thanh tiên tiến với sáu loa và chế độ Âm Thanh Không Gian hỗ trợ Dolby Atmos, mang đến trải nghiệm nghe tuyệt vời.
Chip M4 Pro cho phép xử lý các luồng công việc phức tạp một cách nhanh chóng, lý tưởng cho các chuyên gia trong lĩnh vực sáng tạo.
Với thời lượng pin lên đến 24 giờ, máy đảm bảo bạn có đủ năng lượng để làm việc suốt cả ngày mà không cần sạc.
Sự kết nối linh hoạt với ba cổng Thunderbolt 5 và khe cắm thẻ nhớ SDXC giúp bạn mở rộng không gian làm việc một cách dễ dàng.

Kích thước màn hình: 16.2 inches
Độ phân giải: 3456 x 2234 pixels
CPU: Apple M4 Pro 14 lõi với 10 lõi hiệu năng và 4 lõi tiết kiệm điện
Pin: Pin Li-Po 100 watt-giờ, Thời gian xem video trực tuyến lên đến 24 giờ, Thời gian duyệt web trên mạng không dây lên đến 17 giờ
Kích thước: Dài: 24.81 cm x Rộng: 35.57 cm x Cao: 1.68 cm
Trọng lượng: 2.14 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi‑Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/65596abeb858eac5.png', 69990000, 0, 1, 430);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-107525', 'Bạc', '14CPU 20GPU 24GB 1TB Sạc 140W', 77990000, 69990000, 20, '/uploads/products/apple/65596abeb858eac5.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-107526', 'Đen', '14CPU 20GPU 24GB 1TB Sạc 140W', 77990000, 71990000, 20, '/uploads/products/apple/5b9370682a56a834.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0cc9604c0459f3b3.png', 'MacBook Pro 16 M4 Pro', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1585ff4f35d071b5.jpg', 'MacBook Pro 16 M4 Pro', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4b59d3125bbdbb74.jpg', 'MacBook Pro 16 M4 Pro', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3507d5a74181dde3.jpg', 'MacBook Pro 16 M4 Pro', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c9d19f771ff032a9.jpg', 'MacBook Pro 16 M4 Pro', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e2e52a450d130271.jpg', 'MacBook Pro 16 M4 Pro', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1b7b7fd77146875a.jpg', 'MacBook Pro 16 M4 Pro', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/18267e09f13ec449.jpg', 'MacBook Pro 16 M4 Pro', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/65596abeb858eac5.png', 'MacBook Pro 16 M4 Pro', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5b9370682a56a834.png', 'MacBook Pro 16 M4 Pro', 9);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 'apple-studio-display-27-5k-chan-de-co-dinh-2026', 'CPS-apple-studio-display-27-5k-chan-de-co-dinh-2026', 'Thiết kế linh hoạt với các tùy chọn chân đế điều chỉnh độ nghiêng, chân đế điều chỉnh độ nghiêng và độ cao hoặc ngàm kết nối VESA, đi kèm lớp phủ chống phản chiếu tiêu chuẩn và tùy chọn mặt kính Nano-texture giảm chói. · Màn hình độ phân giải 14.7 triệu pixel sắc nét, độ sáng 600 nit, hiển thị 1 tỷ màu sống động cùng dải màu rộng P3 tái hiện chi tiết chính xác. · Tích hợp camera 12MP Center Stage (Desk View), dãy 3 micrô chuẩn studio, hệ thống 6 loa Âm Thanh Không Gian cùng 2 cổng Thunderbolt 5 (sạc nhanh MacBook, kết nối chuỗi tối đa 4 màn hình) và 2 cổng USB-C.', 'Thiết kế linh hoạt với các tùy chọn chân đế điều chỉnh độ nghiêng, chân đế điều chỉnh độ nghiêng và độ cao hoặc ngàm kết nối VESA, đi kèm lớp phủ chống phản chiếu tiêu chuẩn và tùy chọn mặt kính Nano-texture giảm chói.
Màn hình độ phân giải 14.7 triệu pixel sắc nét, độ sáng 600 nit, hiển thị 1 tỷ màu sống động cùng dải màu rộng P3 tái hiện chi tiết chính xác.
Tích hợp camera 12MP Center Stage (Desk View), dãy 3 micrô chuẩn studio, hệ thống 6 loa Âm Thanh Không Gian cùng 2 cổng Thunderbolt 5 (sạc nhanh MacBook, kết nối chuỗi tối đa 4 màn hình) và 2 cổng USB-C.
Giải pháp màn hình toàn diện lý tưởng cho studio sáng tạo, làm việc đa nhiệm và giải trí chất lượng cao.

Kích thước màn hình: 27 inches
Độ phân giải: 5120 x 2880 pixels
Kích thước: Studio Display với chân đế có thể điều chỉnh độ nghiêng: 47.9 x 62.3 x 20.7 cm (Cao x Rộng x Dày) , Studio Display với ngàm kết nối VESA: 36.2 x 62.3 x 3.1 cm (Cao x Rộng x Dày)
Trọng lượng: Studio Display với chân đế có thể điều chỉnh độ nghiêng: 6.3 kg, Studio Display với ngàm kết nối VESA: 5.4 kg
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/7d4953156bdd67f8.jpg', 42990000, 0, 1, 400);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125761', 'Bạc', 'Tiêu chuẩn', 44990000, 42990000, 20, '/uploads/products/apple/7d4953156bdd67f8.jpg', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/92e992ddf1f636b1.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8f22ff6fe8867742.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ad0af20bc702e7a6.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ebf97665988b075d.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3363881c0bfef165.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c0f7002bdab1a3cc.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/757e489749e9772a.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7072526098ae0d64.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7a4d888406a549f6.jpg', 'Apple Studio Display 27 5K Chân Đế Cố Định 2026', 8);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple Mac Studio M4 Max', 'apple-mac-studio-m4-max', 'CPS-apple-mac-studio-m4-max', 'Mac Studio chạy nhanh như bay với hàng loạt ứng dụng chuyên nghiệp, bao gồm DaVinci Resolve Studio, Final Cut Pro và Adobe Photoshop, sẵn sàng hỗ trợ AI cho công việc sáng tạo. · Chip M4 Max mang đến sức mạnh vượt trội cho các luồng công việc phức tạp, từ đồ họa 3D đến hiệu ứng hình ảnh. · Thiết kế nhỏ gọn chỉ 7,7 inch giúp Mac Studio dễ dàng nằm gọn dưới hầu hết các màn hình, tối ưu hóa không gian làm việc.', 'Mac Studio chạy nhanh như bay với hàng loạt ứng dụng chuyên nghiệp, bao gồm DaVinci Resolve Studio, Final Cut Pro và Adobe Photoshop, sẵn sàng hỗ trợ AI cho công việc sáng tạo.
Chip M4 Max mang đến sức mạnh vượt trội cho các luồng công việc phức tạp, từ đồ họa 3D đến hiệu ứng hình ảnh.
Thiết kế nhỏ gọn chỉ 7,7 inch giúp Mac Studio dễ dàng nằm gọn dưới hầu hết các màn hình, tối ưu hóa không gian làm việc.
Hệ thống tản nhiệt được tối ưu đảm bảo máy vận hành êm ái, cho phép bạn xử lý các tác vụ nặng mà không bị gián đoạn.

CPU: CPU 16 lõi
Kích thước: Cao: 9.5 cm x Rộng: 19.7 cm x Dài: 19.7 cm
Trọng lượng: 2.74 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi-Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/9d25e0702fa85b62.png', 96990000, 0, 1, 380);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-131809', 'Bạc', '16CPU 40GPU 48GB 512GB', 99490000, 96990000, 20, '/uploads/products/apple/9d25e0702fa85b62.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-131820', 'Bạc', '16CPU 40GPU 48GB 1TB', 108990000, 105990000, 20, '/uploads/products/apple/3aed42685872783c.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a09f84ae23a3fdb4.png', 'Apple Mac Studio M4 Max', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b26012db17ad6e70.png', 'Apple Mac Studio M4 Max', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9321985a006a3a70.png', 'Apple Mac Studio M4 Max', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e6e7018e1b67d658.png', 'Apple Mac Studio M4 Max', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1160ea28a32263af.png', 'Apple Mac Studio M4 Max', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/78d0f1dc67e602c2.png', 'Apple Mac Studio M4 Max', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/441bb6b1711a9c84.png', 'Apple Mac Studio M4 Max', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/08b1f8758fc1c94c.png', 'Apple Mac Studio M4 Max', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/40735b228a48af51.png', 'Apple Mac Studio M4 Max', 8);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 'apple-studio-display-xdr-27-5k-ngam-vesa-2026', 'CPS-apple-studio-display-xdr-27-5k-ngam-vesa-2026', 'Thiết kế chuyên nghiệp với tùy chọn chân đế điều chỉnh nghiêng 30°, cao 105 mm hoặc ngàm VESA, tích hợp lớp phủ chống phản chiếu và tùy chọn mặt kính Nano-texture. · Màn hình mini-LED 2304 vùng làm tối, độ sáng SDR 1000 nit và đỉnh HDR 2000 nit, tần số quét 120Hz (Đồng Bộ Hóa Thích Ứng) cùng dải màu P3, Adobe RGB chuẩn tham chiếu. · Trang bị camera 12MP Center Stage (Desk View), 3 micrô chuẩn studio, 6 loa Âm Thanh Không Gian, 2 cổng Thunderbolt 5 (sạc nhanh Mac, kết nối chuỗi màn hình thứ hai) và 2 cổng USB-C.', 'Thiết kế chuyên nghiệp với tùy chọn chân đế điều chỉnh nghiêng 30°, cao 105 mm hoặc ngàm VESA, tích hợp lớp phủ chống phản chiếu và tùy chọn mặt kính Nano-texture.
Màn hình mini-LED 2304 vùng làm tối, độ sáng SDR 1000 nit và đỉnh HDR 2000 nit, tần số quét 120Hz (Đồng Bộ Hóa Thích Ứng) cùng dải màu P3, Adobe RGB chuẩn tham chiếu.
Trang bị camera 12MP Center Stage (Desk View), 3 micrô chuẩn studio, 6 loa Âm Thanh Không Gian, 2 cổng Thunderbolt 5 (sạc nhanh Mac, kết nối chuỗi màn hình thứ hai) và 2 cổng USB-C.
Màn hình tham chiếu cao cấp lý tưởng cho nhà làm phim, nhiếp ảnh gia và chuyên gia thiết kế đồ họa.

Kích thước màn hình: 27 inches
Độ phân giải: 5120 x 2880 pixels
Kích thước: Studio Display XDR với chân đế có thể điều chỉnh độ nghiêng và độ cao: 47.8 x 62.3 x 21.4 cm (Cao x Rộng x Dày) , Studio Display XDR với ngàm kết nối VESA: 36.2 x 62.3 x 3.3 cm (Cao x Rộng x Dày)
Trọng lượng: Studio Display XDR với chân đế có thể điều chỉnh độ nghiêng và độ cao: 8.5 kg, Studio Display XDR với ngàm kết nối VESA: 6.3 kg
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/bb85184b8f87ad7c.png', 79990000, 0, 1, 370);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-125755', 'Bạc', 'Tiêu chuẩn', 89990000, 79990000, 20, '/uploads/products/apple/bb85184b8f87ad7c.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/aa15aefd9aacbb04.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7ac1b79b38343ed5.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/302e23e5883d5167.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6412f8ba2d66518e.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/be432b2c415b910d.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/60db6af1bf7c85cf.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/75ad94f0bec94eb7.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ef01c118cf7a8eb1.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/258c3f722872cc92.jpg', 'Apple Studio Display XDR 27 5K Ngàm VESA 2026', 8);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'MacBook Air M2 2024', 'macbook-air-m2-2024', 'CPS-macbook-air-m2-2024', 'Thiết kế sang trọng, lịch lãm - siêu mỏng 11.3mm, chỉ 1.24kg · Hiệu năng hàng đầu - Chip Apple M2, 10 nhân GPU, hỗ trợ tốt các phần mềm như Word, Axel, Adoble Premier · Đa nhiệm mượt mà - Ram 16GB, SSD 512GB cho phép vừa làm việc, vừa nghe nhạc', 'Thiết kế sang trọng, lịch lãm - siêu mỏng 11.3mm, chỉ 1.24kg
Hiệu năng hàng đầu - Chip Apple M2, 10 nhân GPU, hỗ trợ tốt các phần mềm như Word, Axel, Adoble Premier
Đa nhiệm mượt mà - Ram 16GB, SSD 512GB cho phép vừa làm việc, vừa nghe nhạc
Màn hình sắc nét - Độ phân giải 2560 x 1664 cùng độ sáng 500 nits
Âm thanh sống động - 4 loa trang bị công nghệ dolby atmos và âm thanh đa chiều

Kích thước màn hình: 13.6 inches
Độ phân giải: 2560 x 1664 pixels
CPU: Apple M2 8 nhân
Pin: 52,6 Wh
Kích thước: Dày: 1,13cm - Chiều dài: 30,41cm Chiều rộng: 21,5cm
Trọng lượng: 1.24 kg
Bluetooth: 5.3
Wi-Fi: 802.11ax Wi-Fi 6
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/b9352875cf56bdd9.png', 29990000, 0, 1, 290);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-86456', 'Bạc', '8CPU 10 GPU 16GB 512GB Sạc 35W', 34990000, 29990000, 20, '/uploads/products/apple/b9352875cf56bdd9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-86457', 'Đen', '8CPU 10 GPU 16GB 512GB Sạc 35W', 34990000, 29990000, 20, '/uploads/products/apple/b52aafb317d7cfe2.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b001aab06eeaaa71.png', 'MacBook Air M2 2024', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/837f68019d8ca6c1.png', 'MacBook Air M2 2024', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/efd11395624427f8.png', 'MacBook Air M2 2024', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9816b721b15df0b1.png', 'MacBook Air M2 2024', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/025db839dbc82b51.png', 'MacBook Air M2 2024', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8be929a1318c7cd9.png', 'MacBook Air M2 2024', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1b76070f025da089.png', 'MacBook Air M2 2024', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ca301563e9ece6a5.png', 'MacBook Air M2 2024', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7b9d548b50642363.jpg', 'MacBook Air M2 2024', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8079ba8f91ff05f6.jpg', 'MacBook Air M2 2024', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ab1dcd1997e5f925.jpg', 'MacBook Air M2 2024', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/43cdbeb3729f0b73.png', 'MacBook Air M2 2024', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/31e9aae24a03b35b.jpg', 'MacBook Air M2 2024', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/929dbd07e75ffb5c.png', 'MacBook Air M2 2024', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dda28caa327ee6e5.png', 'MacBook Air M2 2024', 14);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1259c8afe9176f3c.png', 'MacBook Air M2 2024', 15);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7f13d256c20b1237.png', 'MacBook Air M2 2024', 16);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d87d014992f623e5.png', 'MacBook Air M2 2024', 17);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/de021570b7e191d4.png', 'MacBook Air M2 2024', 18);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2373ad80d7d49775.png', 'MacBook Air M2 2024', 19);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple Macbook Air M2 2022', 'apple-macbook-air-m2-2022', 'CPS-apple-macbook-air-m2-2022', 'Thiết kế sang trọng, lịch lãm - siêu mỏng 11.3mm, chỉ 1.24kg · Hiệu năng hàng đầu - Chip Apple m2, 8 nhân GPU, hỗ trợ tốt các phần mềm như Word, Axel, Adoble Premier · Ram lên đến 24GB - Tốc độ khởi động ứng dụng nhanh chóng, cho phép chạy máy ảo mở cùng lúc nhiều ứng dụng', 'Thiết kế sang trọng, lịch lãm - siêu mỏng 11.3mm, chỉ 1.24kg
Hiệu năng hàng đầu - Chip Apple m2, 8 nhân GPU, hỗ trợ tốt các phần mềm như Word, Axel, Adoble Premier
Ram lên đến 24GB - Tốc độ khởi động ứng dụng nhanh chóng, cho phép chạy máy ảo mở cùng lúc nhiều ứng dụng
Màn hình sắc nét - Độ phân giải 2560 x 1664 cùng độ sáng 500 nits
Âm thanh sống động - 4 loa tramg bị công nghệ dolby atmos và âm thanh đa chiều

Kích thước màn hình: 13.6 inches
Độ phân giải: 2560 x 1664 pixels
CPU: Apple M2
Pin: 52,6 Wh
Kích thước: Dày: 1,13cm - Chiều dài: 30,41cm Chiều rộng: 21,5cm
Trọng lượng: 1.27 kg
Bluetooth: 5.0
Wi-Fi: 802.11ax Wi-Fi 6
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/529985aedee48110.png', 33990000, 0, 1, 280);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-56196', 'Mặc định', '24GB 256GB', 34990000, 33990000, 0, '/uploads/products/apple/529985aedee48110.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/896705366290284a.jpg', 'Apple Macbook Air M2 2022', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/19386f2c37af4ad3.jpg', 'Apple Macbook Air M2 2022', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/529985aedee48110.png', 'Apple Macbook Air M2 2022', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c7c7c74eb7e3a8a5.jpg', 'Apple Macbook Air M2 2022', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/861d10f31643b5e8.jpg', 'Apple Macbook Air M2 2022', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2912d4ebebe0dd4e.png', 'Apple Macbook Air M2 2022', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/077fda3192dce8ba.jpg', 'Apple Macbook Air M2 2022', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2c8f7986af048b3e.png', 'Apple Macbook Air M2 2022', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/209ed5350111b806.png', 'Apple Macbook Air M2 2022', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8578800f624b3f0c.png', 'Apple Macbook Air M2 2022', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e36893376b13e69a.png', 'Apple Macbook Air M2 2022', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/130ea05ebcd2a70b.png', 'Apple Macbook Air M2 2022', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4a923f639cf4a5a3.png', 'Apple Macbook Air M2 2022', 12);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b3e3fbe6809f1658.png', 'Apple Macbook Air M2 2022', 13);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d7ca6f61875ce23e.png', 'Apple Macbook Air M2 2022', 14);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8f02546251df3228.png', 'Apple Macbook Air M2 2022', 15);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c845c0472889e848.png', 'Apple Macbook Air M2 2022', 16);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Macbook Pro 16 M3 Max', 'macbook-pro-16-m3-max', 'CPS-macbook-pro-16-m3-max', 'Macbook Pro 16 M3 Max', 'Kích thước màn hình: 16.2 inches
Độ phân giải: 3024 x 1964 pixels
CPU: Apple M3 Max 16 nhân
Pin: 140Wh
Kích thước: Cao 1,55 - Rộng 31,26 - Dài 22,12 cm
Trọng lượng: 1,55 kg
Bluetooth: Bluetooth 5.3
Wi-Fi: Wi-Fi 6E (802.11ax)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/211f093e19f1ee26.png', 102490000, 0, 1, 270);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-71772', 'Mặc định', '128GB - 8TB', 102490000, NULL, 0, '/uploads/products/apple/211f093e19f1ee26.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/211f093e19f1ee26.png', 'Macbook Pro 16 M3 Max', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2def19fedd0f115d.jpg', 'Macbook Pro 16 M3 Max', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9612779ea8fb7840.jpg', 'Macbook Pro 16 M3 Max', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7b1658b1a654773d.jpg', 'Macbook Pro 16 M3 Max', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5b9100f11f4ea14a.jpg', 'Macbook Pro 16 M3 Max', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/de06aec30a5dc7e8.jpg', 'Macbook Pro 16 M3 Max', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ae108b3811e60ceb.jpg', 'Macbook Pro 16 M3 Max', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/abee4fdfe3786f21.jpg', 'Macbook Pro 16 M3 Max', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ffc21bf9c74d27dc.jpg', 'Macbook Pro 16 M3 Max', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7d23233b9b4b7c09.jpg', 'Macbook Pro 16 M3 Max', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a6946bcf06866bba.jpg', 'Macbook Pro 16 M3 Max', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Macbook Pro 14 inch 2021 M1 Max', 'macbook-pro-14-inch-2021-m1-max', 'CPS-macbook-pro-14-inch-2021-m1-max', 'Macbook Pro 14 inch 2021 M1 Max', 'Kích thước màn hình: 14.2 inches
Độ phân giải: 3024 x 1964 pixels
CPU: Apple M1 Max
Pin: Khoảng 10 tiếng
Kích thước: Dài 312.6 mm - Rộng 221.2 mm - Dày 15.5 mm
Trọng lượng: 1.6 kg
Bluetooth: v5.0
Wi-Fi: 802.11ax
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/b6f2ef10994ad873.png', 70990000, 0, 1, 230);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-41960', 'Mặc định', '10 CPU - 24 GPU 32GB 1TB sạc 97W', 70990000, NULL, 0, '/uploads/products/apple/b6f2ef10994ad873.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b6f2ef10994ad873.png', 'Macbook Pro 14 inch 2021 M1 Max', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c857f8b34cc1dd5f.jpg', 'Macbook Pro 14 inch 2021 M1 Max', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/470319711b93d4f6.jpg', 'Macbook Pro 14 inch 2021 M1 Max', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9b484afaa8b7f5b8.jpg', 'Macbook Pro 14 inch 2021 M1 Max', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/eb896213eb1fbe1f.jpg', 'Macbook Pro 14 inch 2021 M1 Max', 4);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 'apple-macbook-pro-proled-xdr-14-m5-pro-2026', 'CPS-apple-macbook-pro-proled-xdr-14-m5-pro-2026', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 14.2 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu P3 và Adobe RGB chuẩn tham chiếu. · Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI. · Thời lượng pin lên đến 22 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đ', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 14.2 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu P3 và Adobe RGB chuẩn tham chiếu.
Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI.
Thời lượng pin lên đến 22 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đa 3–4 màn hình ngoài và bảo mật Touch ID.
Cỗ máy trạm di động đỉnh cao lý tưởng cho nhà làm phim, chuyên gia đồ họa 3D, lập trình viên AI và nhà nghiên cứu khoa học.

Kích thước màn hình: 14.2 inches
Độ phân giải: 3024 x 1986 pixels
CPU: Chip Apple M5 Pro , CPU 15 lõi với: , 5 lõi siêu xử lý , 10 lõi hiệu năng
Pin: Xem video trực tuyến đến 22 giờ, duyệt web không dây đến 14 giờ, Pin Li-Po 72.6 Wh, Sạc USB-C / USB PD (khuyến nghị tối thiểu 70W), Hỗ trợ sạc nhanh với nguồn điện USB PD từ 96W trở lên
Kích thước: Cao: 1.50 cm x Rộng: 31.08 cm x Dài: 21.63 cm
Trọng lượng: 1.38 kg
Bluetooth: Bluetooth 6 , Công nghệ mạng Thread
Wi-Fi: Chip mạng không dây Apple N1 , Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/b422a3ff2f912257.png', 79990000, 0, 1, 220);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146413', 'Bạc', '15CPU 16GPU 24GB 1TB', 79990000, NULL, 20, '/uploads/products/apple/b422a3ff2f912257.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146414', 'Đen Không Gian', '15CPU 16GPU 24GB 1TB', 79990000, NULL, 20, '/uploads/products/apple/140e874a1bc464b4.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146416', 'Bạc', '18CPU 20GPU 48GB 1TB', 102749000, NULL, 20, '/uploads/products/apple/a6a40e783384c365.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146417', 'Đen Không Gian', '18CPU 20GPU 48GB 1TB', 102749000, NULL, 20, '/uploads/products/apple/b1902f75b9e6855e.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/281959ea6aae6743.png', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cf521b3100ccee79.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e781f1a5f3021c87.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/53dcc66951fa4f40.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1108b277496731bf.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3b8005a87029a06b.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/713eab550ee6dbc3.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/63647db426929bf2.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4d1e0f9ca9aae6cf.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b422a3ff2f912257.png', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/140e874a1bc464b4.png', 'Apple MacBook Pro PROLED XDR 14 M5 PRO 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 'apple-macbook-pro-proled-xdr-16-m5-max-2026', 'CPS-apple-macbook-pro-proled-xdr-16-m5-max-2026', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 16.3 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu rộng P3 và Adobe RGB chuẩn tham chiếu. · Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI. · Thời lượng pin lên đến 24 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất ', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 16.3 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu rộng P3 và Adobe RGB chuẩn tham chiếu.
Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI.
Thời lượng pin lên đến 24 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đa 3–4 màn hình ngoài và bảo mật Touch ID.
Cỗ máy trạm di động màn hình lớn đỉnh cao lý tưởng cho nhà làm phim, chuyên gia đồ họa 3D, lập trình viên AI và nhà nghiên cứu khoa học.

Kích thước màn hình: 16.3 inches
Độ phân giải: 3472 x 2266 pixels
CPU: Chip Apple M5 Max, CPU 18 lõi với:, 6 lõi siêu xử lý, 12 lõi hiệu năng
Pin: Xem video trực tuyến đến 22 giờ, duyệt web không dây đến 16 giờ, Pin Li-Po 100 Wh, Sạc USB-C / USB PD (khuyến nghị tối thiểu 94W), Hỗ trợ sạc nhanh với nguồn điện USB PD từ 140W trở lên
Kích thước: Cao: 1.60 cm x Rộng: 35.55 cm x Dài: 24.42 cm
Trọng lượng: 1.84 kg
Bluetooth: Bluetooth 6 , Công nghệ mạng Thread
Wi-Fi: Chip mạng không dây Apple N1 , Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/244296eeb49c47c1.png', 130990000, 0, 1, 210);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146425', 'Bạc', '18CPU 32GPU 36GB 2TB', 130990000, NULL, 20, '/uploads/products/apple/244296eeb49c47c1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146426', 'Đen Không Gian', '18CPU 32GPU 36GB 2TB', 130990000, NULL, 20, '/uploads/products/apple/3084935abff2e56f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146428', 'Bạc', '18CPU 40GPU 48GB 2TB', 145990000, NULL, 20, '/uploads/products/apple/8af1b58654198435.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146429', 'Đen Không Gian', '18CPU 40GPU 48GB 2TB', 145990000, NULL, 20, '/uploads/products/apple/f845cc0679e36c7f.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e559926571a7ca74.png', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d47056c1559a501c.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/53077a1c2fa0fe8c.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/19ab09449315eff5.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ed62f0ebc723367b.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c9dd69ec55aa6848.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/92996af6a65e7b35.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1500455c54acdb62.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/89179f59edb18f05.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/244296eeb49c47c1.png', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3084935abff2e56f.png', 'Apple MacBook Pro PROLED XDR 16 M5 MAX 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 'apple-macbook-pro-proled-xdr-14-m5-max-2026', 'CPS-apple-macbook-pro-proled-xdr-14-m5-max-2026', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 14.2 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu P3 và Adobe RGB chuẩn tham chiếu. · Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI. · Thời lượng pin lên đến 22 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đ', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 14.2 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu P3 và Adobe RGB chuẩn tham chiếu.
Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI.
Thời lượng pin lên đến 22 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đa 3–4 màn hình ngoài và bảo mật Touch ID.
Cỗ máy trạm di động đỉnh cao lý tưởng cho nhà làm phim, chuyên gia đồ họa 3D, lập trình viên AI và nhà nghiên cứu khoa học.

Kích thước màn hình: 14.2 inches
Độ phân giải: 3024 x 1986 pixels
CPU: Chip Apple M5 Max, CPU 18 lõi với:, 6 lõi siêu xử lý, 12 lõi hiệu năng
Pin: Xem video trực tuyến đến 20 giờ, duyệt web không dây đến 13 giờ, Pin Li-Po 72.6 Wh, Sạc USB-C / USB PD (khuyến nghị tối thiểu 70W), Hỗ trợ sạc nhanh với nguồn điện USB PD từ 96W trở lên
Kích thước: Cao: 1.50 cm x Rộng: 31.08 cm x Dài: 21.63 cm
Trọng lượng: 1.40 kg
Bluetooth: Bluetooth 6 , Công nghệ mạng Thread
Wi-Fi: Chip mạng không dây Apple N1 , Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/0fa56801060d2a57.png', 123990000, 0, 1, 180);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146419', 'Bạc', '18CPU 32GPU 36GB 2TB', 123990000, NULL, 20, '/uploads/products/apple/0fa56801060d2a57.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146420', 'Đen Không Gian', '18CPU 32GPU 36GB 2TB', 123990000, NULL, 20, '/uploads/products/apple/cb4315f10fab9357.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/68cee147567b7387.png', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b75bef68d5d20d5e.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1f0b9752051a4ffe.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8b8db72fbe414ddd.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/098acfbcc50b19c6.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5a39bc8919c9d5bb.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b03dd84df36120ea.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4af842322de3ff24.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3ec7a7ae0aba73ae.jpg', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0fa56801060d2a57.png', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cb4315f10fab9357.png', 'Apple MacBook Pro PROLED XDR 14 M5 MAX 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple MacBook Pro 14 M6 2026', 'apple-macbook-pro-14-m6-2026', 'CPS-apple-macbook-pro-14-m6-2026', 'Thiết kế chuyên nghiệp, màn hình Liquid Retina XDR 14.2 inch sắc nét với độ sáng đỉnh 1600 nit, độ sáng liên tục 1000 nit và độ tương phản 1.000.000:1. · Hiệu năng mạnh mẽ từ chip Apple M6 tích hợp Neural Accelerator trong từng lõi GPU và Bộ Đôi Neural Engine 16 lõi, tăng tốc xử lý AI nhanh gấp 13x so với M1, vận hành mượt mà mô hình ngôn ngữ lớn (LLM) cùng Apple Intelligence, Siri AI. · Thời lượng pin lên đến 24 giờ, hệ thống 6 loa Âm Thanh Không Gian Dolby Atmos, camera 12MP Center Stage, kết nối đầy đủ (3 cổng Thunderbolt 4/5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đa 2 màn h', 'Thiết kế chuyên nghiệp, màn hình Liquid Retina XDR 14.2 inch sắc nét với độ sáng đỉnh 1600 nit, độ sáng liên tục 1000 nit và độ tương phản 1.000.000:1.
Hiệu năng mạnh mẽ từ chip Apple M6 tích hợp Neural Accelerator trong từng lõi GPU và Bộ Đôi Neural Engine 16 lõi, tăng tốc xử lý AI nhanh gấp 13x so với M1, vận hành mượt mà mô hình ngôn ngữ lớn (LLM) cùng Apple Intelligence, Siri AI.
Thời lượng pin lên đến 24 giờ, hệ thống 6 loa Âm Thanh Không Gian Dolby Atmos, camera 12MP Center Stage, kết nối đầy đủ (3 cổng Thunderbolt 4/5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đa 2 màn hình ngoài và bảo mật Touch ID.
Cỗ máy trạm di động lý tưởng cho nhà sáng tạo nội dung, lập trình viên AI, thiết kế đồ họa và người dùng chuyên nghiệp.

Kích thước màn hình: 14.2 inches
Độ phân giải: 3024 x 1964 pixels
CPU: Chip Apple M6, CPU 12 lõi với:, 2 lõi siêu xử lý, 4 lõi hiệu năng, 6 lõi tiết kiệm điện
Pin: Lên đến 24 giờ xem video trực tuyến, 16 giờ duyệt web không dây, Dung lượng pin Li-Po 72.4 Wh, Hỗ trợ sạc qua bộ tiếp hợp nguồn USB-C hoặc nguồn điện chuẩn USB PD (khuyến nghị công suất 60W), Hỗ trợ sạc nhanh với USB PD từ 96W trở lên
Kích thước: Cao: 1.55 cm x Rộng: 31.26 cm x Dài: 22.12 cm
Trọng lượng: 1.55 kg
Bluetooth: Bluetooth 6, Công nghệ mạng Thread
Wi-Fi: Wi-Fi 7 (802.11be), Chip mạng không dây Apple N1
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/fdeb50238660ffce.png', 54990000, 0, 1, 170);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146319', 'Bạc', '12 CPU 12 GPU 16GB 1TB', 54990000, NULL, 20, '/uploads/products/apple/fdeb50238660ffce.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146320', 'Đen Không Gian', '12 CPU 12 GPU 16GB 1TB', 54990000, NULL, 20, '/uploads/products/apple/b13ab3c4a23fd772.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146322', 'Bạc', '12 CPU 12 GPU 24GB 1TB', 60490000, NULL, 20, '/uploads/products/apple/eb7ec5a268d33471.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146323', 'Đen Không Gian', '12 CPU 12 GPU 24GB 1TB', 60490000, NULL, 20, '/uploads/products/apple/cbde5a766baa2a39.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146325', 'Bạc', '12 CPU 12 GPU 32GB 1TB', 65990000, NULL, 20, '/uploads/products/apple/b745a7b78a1b2f11.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146326', 'Đen Không Gian', '12 CPU 12 GPU 32GB 1TB', 65990000, NULL, 20, '/uploads/products/apple/62b865faa3c1a125.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/22a90e919ec9c203.png', 'Apple MacBook Pro 14 M6 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a64966d7969443e2.jpg', 'Apple MacBook Pro 14 M6 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/7401a33e61a0508c.jpg', 'Apple MacBook Pro 14 M6 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/85d29595fefc975d.jpg', 'Apple MacBook Pro 14 M6 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b88d140a4d867f08.jpg', 'Apple MacBook Pro 14 M6 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3b8f5c176ac61a1a.jpg', 'Apple MacBook Pro 14 M6 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/04fb9eb5ea81bdde.jpg', 'Apple MacBook Pro 14 M6 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4f040b786e31af86.jpg', 'Apple MacBook Pro 14 M6 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ce1568543b3b85ef.jpg', 'Apple MacBook Pro 14 M6 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b745a7b78a1b2f11.png', 'Apple MacBook Pro 14 M6 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/62b865faa3c1a125.png', 'Apple MacBook Pro 14 M6 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'laptop-may-mac'), @brand, 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 'apple-macbook-pro-proled-xdr-16-m5-pro-2026', 'CPS-apple-macbook-pro-proled-xdr-16-m5-pro-2026', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 16.3 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu rộng P3 và Adobe RGB chuẩn tham chiếu. · Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI. · Thời lượng pin lên đến 24 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất ', 'Thiết kế chuyên nghiệp tích hợp Dynamic Island, màn hình cảm ứng PROLED XDR 16.3 inch (tandem OLED) hỗ trợ Multi-Touch, độ sáng đỉnh 2000 nit, tương phản 10.000.000:1 cùng dải màu rộng P3 và Adobe RGB chuẩn tham chiếu.
Hiệu năng đột phá từ chip Apple M5 Pro / M5 Max tích hợp Neural Accelerator trong từng lõi GPU, tối ưu xử lý AI chuyên sâu, chạy mô hình ngôn ngữ lớn (LLM) và đồ họa nặng cùng Apple Intelligence, Siri AI.
Thời lượng pin lên đến 24 giờ, hệ thống 6 loa cao cấp, camera 12MP Center Stage, kết nối toàn diện (3 cổng Thunderbolt 5, HDMI, SDXC, MagSafe 3, Wi-Fi 7, Bluetooth 6) xuất tối đa 3–4 màn hình ngoài và bảo mật Touch ID.
Cỗ máy trạm di động màn hình lớn đỉnh cao lý tưởng cho nhà làm phim, chuyên gia đồ họa 3D, lập trình viên AI và nhà nghiên cứu khoa học.

Kích thước màn hình: 16.3 inches
Độ phân giải: 3472 x 2266 pixels
CPU: Chip Apple M5 Pro, CPU 18 lõi với:, 6 lõi siêu xử lý, 12 lõi hiệu năng
Pin: Xem video trực tuyến đến 24 giờ, duyệt web không dây đến 17 giờ, Pin Li-Po 100 Wh, Sạc USB-C / USB PD (khuyến nghị tối thiểu 94W), Hỗ trợ sạc nhanh với nguồn điện USB PD từ 140W trở lên
Kích thước: Cao: 1.60 cm x Rộng: 35.55 cm x Dài: 24.42 cm
Trọng lượng: 1.82 kg
Bluetooth: Bluetooth 6 , Công nghệ mạng Thread
Wi-Fi: Chip mạng không dây Apple N1 , Wi-Fi 7 (802.11be)
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/177d1230f0c0e4e3.png', 92990000, 0, 1, 120);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146422', 'Bạc', '18CPU 20GPU 24GB 1TB', 92990000, NULL, 20, '/uploads/products/apple/177d1230f0c0e4e3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146423', 'Đen Không Gian', '18CPU 20GPU 24GB 1TB', 92990000, NULL, 20, '/uploads/products/apple/5394c2cbbc7bf037.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146431', 'Bạc', '18CPU 20GPU 48GB 1TB', 109490000, NULL, 20, '/uploads/products/apple/160e7db04efd8793.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-146432', 'Đen Không Gian', '18CPU 20GPU 48GB 1TB', 109490000, NULL, 20, '/uploads/products/apple/8164d299d0420b70.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/df4c45c93b1dab7d.png', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a25e222c873a7a63.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3210ef4247394b15.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c23c9206207e5dcd.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/57bea4fa3f7672e5.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b36663391debac9d.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1b766ff15d8f7304.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8bf2eeb522bf562c.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f695eccbc4c8f7f6.jpg', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/177d1230f0c0e4e3.png', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5394c2cbbc7bf037.png', 'Apple MacBook Pro PROLED XDR 16 M5 PRO 2026', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dong-ho-thong-minh'), @brand, 'Apple Watch Series 12', 'apple-watch-series-12', 'CPS-apple-watch-series-12', 'Apple Watch Series 12', 'Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/fb7c5ab7dbbadb36.png', 9990000, 1, 1, 990);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141775', 'Viền Xám / Dây Xanh', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, 9990000, 20, '/uploads/products/apple/fb7c5ab7dbbadb36.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141776', 'Viền Đen / Dây Đen', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, 9990000, 20, '/uploads/products/apple/15d272b95971a275.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141777', 'Viền Vàng / Dây Vàng', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, 9990000, 20, '/uploads/products/apple/4168648eebd27d59.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141778', 'Viền Vàng Đồng / Dây Xanh', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, 9990000, 20, '/uploads/products/apple/9984ab186e49efcd.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141770', 'Viền Xám / Dây Xanh', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, 9990000, 20, '/uploads/products/apple/734dcbad6f37d03e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141771', 'Viền Đen / Dây Đen', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, 9990000, 20, '/uploads/products/apple/e85f750f8d797876.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141772', 'Viền Vàng / Dây Vàng', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, 9990000, 20, '/uploads/products/apple/65a2e1635aa2a38b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141773', 'Viền Vàng Đồng / Dây Xanh', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, 9990000, 20, '/uploads/products/apple/c5cabba20631800d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141733', 'Viền Xám / Dây Xanh', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12990000, 11490000, 20, '/uploads/products/apple/1524604a2e688ffd.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141734', 'Viền Đen / Dây Đen', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12990000, 11490000, 20, '/uploads/products/apple/21327d6a4712951e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141735', 'Viền Vàng / Dây Vàng', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12990000, 11490000, 20, '/uploads/products/apple/4af8cf505c4d66f9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141736', 'Viền Vàng Đồng / Dây Xanh', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12990000, 11490000, 20, '/uploads/products/apple/7d47c6f6bb2e9e61.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141729', 'Viền Vàng Đồng / Dây Đồng', '42mm (GPS) Viền Nhôm Dây Thép', 12990000, 11490000, 20, '/uploads/products/apple/baeb82968a8d39a8.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141721', 'Viền Xám / Dây Xanh', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12990000, 11490000, 20, '/uploads/products/apple/a7bb4b99cecadb1a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141723', 'Viền Đen / Dây Đen', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12990000, 11490000, 20, '/uploads/products/apple/7c32260350640657.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141724', 'Viền Vàng / Dây Vàng', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12990000, 11490000, 20, '/uploads/products/apple/71696ecd45d3389b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141725', 'Viền Vàng Đồng / Dây Xanh', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12990000, 11490000, 20, '/uploads/products/apple/2fec4b20e2d3fc8b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141743', 'Viền Xám / Dây Xanh', '42mm (5G) Viền Nhôm Dây Cao Su Size M/L', 14490000, 12890000, 20, '/uploads/products/apple/de083da5ef1a5942.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141744', 'Viền Đen / Dây Đen', '42mm (5G) Viền Nhôm Dây Cao Su Size M/L', 14490000, 12890000, 20, '/uploads/products/apple/4dfe36976a2d9c7c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141745', 'Viền Vàng / Dây Vàng', '42mm (5G) Viền Nhôm Dây Cao Su Size M/L', 14490000, 12890000, 20, '/uploads/products/apple/6fafeb2d017aadd4.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141746', 'Viền Vàng Đồng / Dây Xanh', '42mm (5G) Viền Nhôm Dây Cao Su Size M/L', 14490000, 12890000, 20, '/uploads/products/apple/f27f750541b623d0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141737', 'Viền Xám / Dây Xanh', '42mm (5G) Viền Nhôm Dây Cao Su Size S/M', 14490000, 12890000, 20, '/uploads/products/apple/66427dbc0b490160.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141738', 'Viền Đen / Dây Đen', '42mm (5G) Viền Nhôm Dây Cao Su Size S/M', 14490000, 12890000, 20, '/uploads/products/apple/f51c1ec0c327c3a7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141739', 'Viền Vàng / Dây Vàng', '42mm (5G) Viền Nhôm Dây Cao Su Size S/M', 14490000, 12890000, 20, '/uploads/products/apple/4c30a113ca31c5fb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141740', 'Viền Vàng Đồng / Dây Xanh', '42mm (5G) Viền Nhôm Dây Cao Su Size S/M', 14490000, 12890000, 20, '/uploads/products/apple/a7201291e8f2bcb8.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141755', 'Viền Vàng Đồng / Dây Đồng', '46mm (GPS) Viền Nhôm Dây Thép Size M/L', 14490000, 12990000, 20, '/uploads/products/apple/fa2d8e69d43a8f24.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141750', 'Viền Vàng Đồng / Dây Đồng', '46mm (GPS) Viền Nhôm Dây Thép Size S/M', 14490000, 12990000, 20, '/uploads/products/apple/80f42a2b136475d2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141824', 'Viền Vàng Đồng / Dây Đồng', '42mm (5G) Viền Nhôm Dây Thép', 15990000, 14390000, 20, '/uploads/products/apple/52593145ec0cccdf.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141761', 'Viền Xám / Dây Xanh', '46mm (5G) Viền Nhôm Dây Cao Su Size M/L', 15990000, 14390000, 20, '/uploads/products/apple/12072b3e2e4da0d1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141762', 'Viền Đen / Dây Đen', '46mm (5G) Viền Nhôm Dây Cao Su Size M/L', 15990000, 14390000, 20, '/uploads/products/apple/86ea2e283758b6ff.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141763', 'Viền Vàng / Dây Vàng', '46mm (5G) Viền Nhôm Dây Cao Su Size M/L', 15990000, 14390000, 20, '/uploads/products/apple/ce497016cb153372.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141765', 'Viền Đồng / Dây Xanh', '46mm (5G) Viền Nhôm Dây Cao Su Size M/L', 15990000, 14390000, 20, '/uploads/products/apple/b1a0564d25ae2730.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141749', 'Viền Xám / Dây Xanh', '46mm (5G) Viền Nhôm Dây Cao Su Size S/M', 15990000, 14390000, 20, '/uploads/products/apple/779cf22af6fae4d7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141751', 'Viền Đen / Dây Đen', '46mm (5G) Viền Nhôm Dây Cao Su Size S/M', 15990000, 14390000, 20, '/uploads/products/apple/97314175758e47fb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141752', 'Viền Vàng / Dây Vàng', '46mm (5G) Viền Nhôm Dây Cao Su Size S/M', 15990000, 14390000, 20, '/uploads/products/apple/9951365230aba560.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141753', 'Viền Vàng Đồng / Dây Xanh', '46mm (5G) Viền Nhôm Dây Cao Su Size S/M', 15990000, 14390000, 20, '/uploads/products/apple/44abad5483fe0152.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141826', 'Viền Vàng Đồng / Dây Đồng', '46mm (5G) Viền Nhôm Dây Thép Size S/M', 17490000, 15890000, 20, '/uploads/products/apple/4efb66002d27a130.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141758', 'Viền Titan Tự Nhiên / Dây Xanh', '42mm (5G) Viền Titan Dây Cao Su Size S/M', 20990000, 19390000, 20, '/uploads/products/apple/2bc2010a78239915.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141759', 'Viền Titan Vàng / Dây Đỏ', '42mm (5G) Viền Titan Dây Cao Su Size S/M', 20990000, 19390000, 20, '/uploads/products/apple/1889c92731f49bc8.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141768', 'Viền Titan Tự Nhiên / Dây Tự Nhiên', '42mm (5G) Viền Titan Dây Thép', 22490000, 20890000, 20, '/uploads/products/apple/670ff5a6344b5113.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141769', 'Viền Titan Vàng / Dây Vàng', '42mm (5G) Viền Titan Dây Thép', 22490000, 20890000, 20, '/uploads/products/apple/bf718538c3b3739d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141802', 'Viền Titan Tự Nhiên / Dây Xanh', '46mm (5G) Viền Titan Dây Cao Su Size M/L', 22490000, 20890000, 20, '/uploads/products/apple/789294f14d0414e0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141803', 'Viền Titan Vàng / Dây Đỏ', '46mm (5G) Viền Titan Dây Cao Su Size M/L', 22490000, 20890000, 20, '/uploads/products/apple/9366091a76d48be2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141809', 'Viền Titan Tự Nhiên / Dây Tự Nhiên', '46mm (5G) Viền Titan Dây Thép Size M/L', 23990000, 22390000, 20, '/uploads/products/apple/579ceaed2b4d2b2e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141811', 'Viền Titan Vàng / Dây Vàng', '46mm (5G) Viền Titan Dây Thép Size M/L', 23990000, 22390000, 20, '/uploads/products/apple/b1d7cbaaf698bd2b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141792', 'Viền Titan Tự Nhiên / Dây Titan Tự Nhiên', '46mm (5G) Viền Titan Dây Thép Size S/M', 23990000, 22390000, 20, '/uploads/products/apple/8dd924c3c7589326.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141794', 'Viền Titan Vàng / Dây Vàng', '46mm (5G) Viền Titan Dây Thép Size S/M', 23990000, 22390000, 20, '/uploads/products/apple/8e0d204f036b90a3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141816', 'Viền Trắng / Dây Vàng', '42mm (5G) Viền Gốm Dây Cao Su Size S/M', 26790000, 25190000, 20, '/uploads/products/apple/e8fda263ac992869.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141818', 'Viền Xanh / Dây Xanh', '42mm (5G) Viền Gốm Dây Cao Su Size S/M', 26790000, 25190000, 20, '/uploads/products/apple/309e6cb00c12e2af.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141817', 'Viền Trắng / Dây Vàng', '42mm (5G) Viền Gốm Dây Cao Su Size M/L', 26790000, 25190000, 20, '/uploads/products/apple/472f64ad8d93934e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141819', 'Viền Xanh / Dây Xanh', '42mm (5G) Viền Gốm Dây Cao Su Size M/L', 26790000, 25190000, 20, '/uploads/products/apple/41b3cfdce8d066da.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141812', 'Viền Trắng / Dây Vàng', '46mm (5G) Viền Gốm Dây Cao Su Size S/M', 28290000, 26690000, 20, '/uploads/products/apple/bfae4e760155473c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141814', 'Viền Xanh / Dây Xanh', '46mm (5G) Viền Gốm Dây Cao Su Size S/M', 28290000, 26690000, 20, '/uploads/products/apple/a72e2438a488f290.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141821', 'Viền Trắng / Dây Vàng', '46mm (5G) Viền Gốm Dây Cao Su Size M/L', 28290000, 26690000, 20, '/uploads/products/apple/e4022b97854ab913.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141822', 'Viền Xanh / Dây Xanh', '46mm (5G) Viền Gốm Dây Cao Su Size M/L', 28290000, 26690000, 20, '/uploads/products/apple/4d7c94e7d1e20390.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/02018b757d0070cd.png', 'Apple Watch Series 12', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b27bfaeee97a0758.png', 'Apple Watch Series 12', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ffe0953fbf501b92.jpg', 'Apple Watch Series 12', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dae8a1ffaf697057.jpg', 'Apple Watch Series 12', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f76402ed9adfebf6.jpg', 'Apple Watch Series 12', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dacaed425bcf9e7a.jpg', 'Apple Watch Series 12', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5b9f69a7d12b033d.jpg', 'Apple Watch Series 12', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0d152ef351bd113c.jpg', 'Apple Watch Series 12', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/65521b12443e5717.jpg', 'Apple Watch Series 12', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fb7c5ab7dbbadb36.png', 'Apple Watch Series 12', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/15d272b95971a275.png', 'Apple Watch Series 12', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4168648eebd27d59.png', 'Apple Watch Series 12', 11);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9984ab186e49efcd.png', 'Apple Watch Series 12', 12);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dong-ho-thong-minh'), @brand, 'Apple Watch SE 3', 'apple-watch-se-3', 'CPS-apple-watch-se-3', 'Màn hình Luôn Bật mới, hiển thị rõ ràng thông tin ngay cả khi cổ tay hạ xuống. · Chip S10 mạnh mẽ, hỗ trợ cử chỉ chạm hai lần và Siri xử lý trực tiếp trên đồng hồ. · Theo dõi sức khỏe toàn diện, từ nhịp tim, giấc ngủ đến thông báo ngưng thở khi ngủ.', 'Màn hình Luôn Bật mới, hiển thị rõ ràng thông tin ngay cả khi cổ tay hạ xuống.
Chip S10 mạnh mẽ, hỗ trợ cử chỉ chạm hai lần và Siri xử lý trực tiếp trên đồng hồ.
Theo dõi sức khỏe toàn diện, từ nhịp tim, giấc ngủ đến thông báo ngưng thở khi ngủ.
Các tính năng an toàn quan trọng như SOS khẩn cấp, Phát hiện Ngã, Va chạm và Quay Về (Backtrack).

Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/5c1782261c246dea.png', 6090000, 1, 1, 980);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112722', 'Ánh sao - Dây trắng', '40mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 6990000, 6090000, 20, '/uploads/products/apple/5c1782261c246dea.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112726', 'Đêm xanh thẳm - Dây đen', '40mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 6990000, 6090000, 20, '/uploads/products/apple/f3513d362b06f0a3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143380', 'Đêm xanh thẳm - Dây Xanh', '40mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 6990000, 6090000, 20, '/uploads/products/apple/712687164c06cf0c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143381', 'Ánh sao - Dây Vàng Cát', '40mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 6990000, 6090000, 20, '/uploads/products/apple/d376b2eee6f3d07f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112724', 'Ánh sao - Dây trắng', '40mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 6990000, 6090000, 20, '/uploads/products/apple/b35c87730afb259c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112725', 'Đêm xanh thẳm - Dây đen', '40mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 6990000, 6090000, 20, '/uploads/products/apple/4094d025f5ad0a09.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143377', 'Đêm xanh thẳm - Dây Xanh', '40mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 6990000, 6090000, 20, '/uploads/products/apple/cbd62a410136decb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143378', 'Ánh sao - Dây Vàng Cát', '40mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 6990000, 6090000, 20, '/uploads/products/apple/e424c7fe819d1b87.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112728', 'Ánh sao - Dây trắng', '44mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 7840000, 6790000, 20, '/uploads/products/apple/d9d0b02e134f1843.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112729', 'Đêm xanh thẳm - Dây đen', '44mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 7840000, 6790000, 20, '/uploads/products/apple/025b99b63852a170.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143389', 'Đêm xanh thẳm - Dây Xanh', '44mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 7840000, 6790000, 20, '/uploads/products/apple/55060d7771565a00.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143390', 'Ánh sao - Dây Vàng Cát', '44mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 7840000, 6790000, 20, '/uploads/products/apple/591fa8e684ff1fc2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112731', 'Ánh sao - Dây trắng', '44mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 7840000, 6790000, 20, '/uploads/products/apple/8f28bdc91c0e8c22.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112732', 'Đêm xanh thẳm - Dây đen', '44mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 7840000, 6690000, 20, '/uploads/products/apple/bfdd9034815ffb49.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143387', 'Đêm xanh thẳm - Dây Xanh', '44mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 7840000, 6790000, 20, '/uploads/products/apple/46d01f661aa7a2fb.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143388', 'Ánh sao - Dây Vàng Cát', '44mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 7840000, 6790000, 20, '/uploads/products/apple/e6b2c6ed19c950b9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112734', 'Ánh sao - Dây trắng', '40mm (5G) Viền Nhôm Dây Cao Su Size S/M', 8490000, 7590000, 20, '/uploads/products/apple/38ef2c239e1bd0de.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112735', 'Đêm xanh thẳm - Dây đen', '40mm (5G) Viền Nhôm Dây Cao Su Size S/M', 8490000, 7490000, 20, '/uploads/products/apple/c5e920cb99077fb8.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143372', 'Đêm xanh thẳm - Dây Xanh', '40mm (5G) Viền Nhôm Dây Cao Su Size S/M', 8490000, 7490000, 20, '/uploads/products/apple/26207ac8bf3562c3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143375', 'Ánh sao - Dây Vàng Cát', '40mm (5G) Viền Nhôm Dây Cao Su Size S/M', 8490000, 7590000, 20, '/uploads/products/apple/c39ff3d17217abb0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112737', 'Ánh sao - Dây trắng', '40mm (5G) Viền Nhôm Dây Cao Su Size M/L', 8490000, 7590000, 20, '/uploads/products/apple/aec1f4d8e6d82661.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112738', 'Đêm xanh thẳm - Dây đen', '40mm (5G) Viền Nhôm Dây Cao Su Size M/L', 8490000, 7490000, 20, '/uploads/products/apple/0302c6270243092c.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143370', 'Đêm xanh thẳm - Dây Xanh', '40mm (5G) Viền Nhôm Dây Cao Su Size M/L', 8490000, 7490000, 20, '/uploads/products/apple/ff33784439b8a768.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143376', 'Ánh sao - Dây Vàng Cát', '40mm (5G) Viền Nhôm Dây Cao Su Size M/L', 8490000, 7590000, 20, '/uploads/products/apple/f14901d487fc5091.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112743', 'Ánh sao - Dây trắng', '44mm (5G) Viền Nhôm Dây Cao Su Size M/L', 9340000, 8390000, 20, '/uploads/products/apple/21dd87c0eedfe8d6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112744', 'Đêm xanh thẳm - Dây đen', '44mm (5G) Viền Nhôm Dây Cao Su Size M/L', 9340000, 8390000, 20, '/uploads/products/apple/b369735bf52d60d3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143382', 'Đêm xanh thẳm - Dây Xanh', '44mm (5G) Viền Nhôm Dây Cao Su Size M/L', 9340000, 8390000, 20, '/uploads/products/apple/0f0053ddac8413cc.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143383', 'Ánh sao - Dây Vàng Cát', '44mm (5G) Viền Nhôm Dây Cao Su Size M/L', 9340000, 8390000, 20, '/uploads/products/apple/9e0f8cc4535868e9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112740', 'Ánh sao - Dây trắng', '44mm (5G) Viền Nhôm Dây Cao Su Size S/M', 9340000, 8390000, 20, '/uploads/products/apple/242def49b8fd92e9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112741', 'Đêm xanh thẳm - Dây đen', '44mm (5G) Viền Nhôm Dây Cao Su Size S/M', 9340000, 8390000, 20, '/uploads/products/apple/c92b8c6591cb6d58.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143384', 'Đêm xanh thẳm - Dây Xanh', '44mm (5G) Viền Nhôm Dây Cao Su Size S/M', 9340000, 8390000, 20, '/uploads/products/apple/b809f0d9ff983e55.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-143385', 'Ánh sao - Dây Vàng Cát', '44mm (5G) Viền Nhôm Dây Cao Su Size S/M', 9340000, 8390000, 20, '/uploads/products/apple/01063d1fce44c53f.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e89864f24e2fcbad.png', 'Apple Watch SE 3', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ff54a1e54096ae4e.png', 'Apple Watch SE 3', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/6ba41948918b4905.png', 'Apple Watch SE 3', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8907df1ddbd28e67.png', 'Apple Watch SE 3', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3ba0e6d79c83cd0c.png', 'Apple Watch SE 3', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/137978c7c35e0e05.png', 'Apple Watch SE 3', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/caf6d8a5e66ac843.png', 'Apple Watch SE 3', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fd259cd725508798.png', 'Apple Watch SE 3', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5c1782261c246dea.png', 'Apple Watch SE 3', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f3513d362b06f0a3.png', 'Apple Watch SE 3', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/712687164c06cf0c.png', 'Apple Watch SE 3', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d376b2eee6f3d07f.png', 'Apple Watch SE 3', 11);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dong-ho-thong-minh'), @brand, 'Apple Watch Ultra 4', 'apple-watch-ultra-4', 'CPS-apple-watch-ultra-4', 'Apple Watch Ultra 4', 'Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/dcdf5fcb5f96217f.png', 23490000, 1, 1, 960);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141791', 'Viền Titan Tự Nhiên / Dây Xám', '49mm (5G) Viền Titan Dây Ocean', 23990000, 23490000, 20, '/uploads/products/apple/dcdf5fcb5f96217f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141793', 'Viền Titan Đen / Dây Đen', '49mm (5G) Viền Titan Dây Ocean', 23990000, 23490000, 20, '/uploads/products/apple/aed3c6d00176c87d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141804', 'Viền Titan Tự Nhiên / Dây Nâu', '49mm (5G) Viền Titan Dây Trail Size M/L', 23990000, 23490000, 20, '/uploads/products/apple/c0844d59d44f43b2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141805', 'Viền Titan Đen / Dây Đỏ', '49mm (5G) Viền Titan Dây Trail Size M/L', 23990000, 23490000, 20, '/uploads/products/apple/9fc5050f1149669b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141798', 'Viền Titan Tự Nhiên / Dây Vàng', '49mm (5G) Viền Titan Dây Alphine Size M', 23990000, 23490000, 20, '/uploads/products/apple/425960cb6a689854.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141799', 'Viền Titan Đen / Dây Đỏ', '49mm (5G) Viền Titan Dây Alphine Size M', 23990000, 23490000, 20, '/uploads/products/apple/5431df69f1ae7164.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141807', 'Viền Titan Tự Nhiên / Dây Nâu', '49mm (5G) Viền Titan Dây Trail Size S/M', 23990000, 23490000, 20, '/uploads/products/apple/61c20af44f3ef86e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141808', 'Viền Titan Đen / Dây Đỏ', '49mm (5G) Viền Titan Dây Trail Size S/M', 23990000, 23490000, 20, '/uploads/products/apple/05b0d53621048cf1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141800', 'Viền Titan Tự Nhiên / Dây Vàng', '49mm (5G) Viền Titan Dây Alphine Size L', 23990000, 23490000, 20, '/uploads/products/apple/26a36be7e837d23d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141801', 'Viền Titan Đen / Dây Đỏ', '49mm (5G) Viền Titan Dây Alphine Size L', 23990000, 23490000, 20, '/uploads/products/apple/cfe397f5f88429d4.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141789', 'Viền Titan Tự Nhiên / Dây Titan Tự Nhiên', '49mm (5G) Viền Titan Dây Titan Size L', 26990000, 26490000, 20, '/uploads/products/apple/298f8ccbd2d1773d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141790', 'Viền Titan Đen / Dây Đen', '49mm (5G) Viền Titan Dây Titan Size L', 26990000, 26490000, 20, '/uploads/products/apple/1444a45f0edd3e87.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141785', 'Viền Titan Tự Nhiên / Dây Titan Tự Nhiên', '49mm (5G) Viền Titan Dây Titan Size M', 26990000, 26490000, 20, '/uploads/products/apple/c0ec3654450f2533.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-141786', 'Viền Titan Đen / Dây Titan Tự Nhiên', '49mm (5G) Viền Titan Dây Titan Size M', 26990000, 26490000, 20, '/uploads/products/apple/2bb7721525c04622.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3185eac153892884.png', 'Apple Watch Ultra 4', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4b6980e239d1f002.png', 'Apple Watch Ultra 4', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/022ed75256a1bc64.jpg', 'Apple Watch Ultra 4', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/8120ef8b311038e7.jpg', 'Apple Watch Ultra 4', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fdc2f1946b512191.jpg', 'Apple Watch Ultra 4', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/47e025feaa3eb1e1.jpg', 'Apple Watch Ultra 4', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ab2d1bb62c2deff5.jpg', 'Apple Watch Ultra 4', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dd957afa183aee5d.jpg', 'Apple Watch Ultra 4', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5ccdf2a1ac0b697e.jpg', 'Apple Watch Ultra 4', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/dcdf5fcb5f96217f.png', 'Apple Watch Ultra 4', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/aed3c6d00176c87d.png', 'Apple Watch Ultra 4', 10);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dong-ho-thong-minh'), @brand, 'Apple Watch Series 11', 'apple-watch-series-11', 'CPS-apple-watch-series-11', 'Chăm sóc sức khỏe toàn diện với điểm số giấc ngủ, theo dõi ngưng thở khi ngủ, ECG, đo SpO₂, nhịp tim và ứng dụng Sinh Hiệu. · Tập luyện thông minh với GPS chuẩn xác, bài tập tùy chỉnh, phân tích tải luyện tập và nhắc nhở hoàn thành vòng Hoạt Động. · Pin bền bỉ lên đến 24 giờ, sạc nhanh 15 phút dùng cả đêm, thoải mái đeo xuyên suốt ngày và đêm.', 'Chăm sóc sức khỏe toàn diện với điểm số giấc ngủ, theo dõi ngưng thở khi ngủ, ECG, đo SpO₂, nhịp tim và ứng dụng Sinh Hiệu.
Tập luyện thông minh với GPS chuẩn xác, bài tập tùy chỉnh, phân tích tải luyện tập và nhắc nhở hoàn thành vòng Hoạt Động.
Pin bền bỉ lên đến 24 giờ, sạc nhanh 15 phút dùng cả đêm, thoải mái đeo xuyên suốt ngày và đêm.
Kết nối & an toàn tối ưu với gọi điện, nhắn tin, Apple Pay, Precision Finding, SOS Khẩn Cấp, Phát Hiện Ngã và Va Chạm.

Trọng lượng: 10.0000
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/ecf679f279715b27.png', 10990000, 0, 1, 940);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112608', 'Vàng Hồng - Dây hồng', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, NULL, 20, '/uploads/products/apple/ecf679f279715b27.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112610', 'Bạc - Dây tím', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, 10990000, 20, '/uploads/products/apple/47595b449c8365ec.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112611', 'Xám không gian - Dây đen', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, 10990000, 20, '/uploads/products/apple/0e52c653c198a9ab.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112612', 'Đen bóng - Dây đen', '42mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11490000, 10990000, 20, '/uploads/products/apple/e575874673416bc6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112625', 'Vàng Hồng - Dây hồng', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, NULL, 20, '/uploads/products/apple/b619d7bd537728a9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112626', 'Bạc - Dây tím', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, 10990000, 20, '/uploads/products/apple/5c1d03e354783f40.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112627', 'Xám không gian - Dây đen', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, NULL, 20, '/uploads/products/apple/50293d17f9c0bb72.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112628', 'Đen bóng - Dây đen', '42mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 11490000, 10990000, 20, '/uploads/products/apple/b7c8883eb68a2ea7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112644', 'Vàng Hồng - Dây hồng', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12349000, 11490000, 20, '/uploads/products/apple/1e3a8ff8e3cdd175.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112645', 'Bạc - Dây tím', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12349000, 11490000, 20, '/uploads/products/apple/e4f2ac5df1de9411.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112646', 'Xám không gian - Dây đen', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12349000, 11490000, 20, '/uploads/products/apple/9ae67df8aab150f6.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112648', 'Đen bóng - Dây đen', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 12349000, 11490000, 20, '/uploads/products/apple/db522d9e3f440709.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112653', 'Vàng Hồng - Dây hồng', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12349000, 11490000, 20, '/uploads/products/apple/d39e60db3ddf9c8e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112654', 'Bạc - Dây tím', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12349000, 11490000, 20, '/uploads/products/apple/5298a70e980e3b7e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112655', 'Xám không gian - Dây đen', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12349000, 11490000, 20, '/uploads/products/apple/9b61ecfd0f532261.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112656', 'Đen bóng - Dây đen', '46mm (GPS) Viền Nhôm Dây Cao Su Size M/L', 12349000, 11490000, 20, '/uploads/products/apple/215ceab082222e8f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112673', 'Titan Đen - Dây đen', '42mm (5G) Viền Titan Dây Cao Su Size S/M', 20990000, 18490000, 20, '/uploads/products/apple/10ae76bb81f768aa.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112674', 'Titan Tự Nhiên - Dây xám', '42mm (5G) Viền Titan Dây Cao Su Size S/M', 20990000, 18490000, 20, '/uploads/products/apple/a0c3e3f3bc1a2745.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112675', 'Titan Vàng - Dây hồng', '42mm (5G) Viền Titan Dây Cao Su Size S/M', 20990000, 18990000, 20, '/uploads/products/apple/07b00c6b41f54ee9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112670', 'Titan Tự Nhiên - Dây xám', '42mm (5G) Viền Titan Dây Cao Su Size M/L', 20990000, 18490000, 20, '/uploads/products/apple/179e5c4052896606.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112671', 'Titan Đen - Dây đen', '42mm (5G) Viền Titan Dây Cao Su Size M/L', 20990000, 18490000, 20, '/uploads/products/apple/fb3bba93727e6571.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112676', 'Titan Vàng - Dây hồng', '42mm (5G) Viền Titan Dây Cao Su Size M/L', 20990000, 18990000, 20, '/uploads/products/apple/5580f87ae94139c3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112695', 'Titan Đen - Dây đen', '46mm (5G) Viền Titan Dây Cao Su Size M/L', 22490000, 18990000, 20, '/uploads/products/apple/3dab21aa36b091c2.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112745', 'Titan Tự Nhiên - Dây xám', '46mm (5G) Viền Titan Dây Cao Su Size M/L', 22490000, 18990000, 20, '/uploads/products/apple/407488e25954ce17.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112767', 'Titan Vàng - Dây hồng', '46mm (5G) Viền Titan Dây Cao Su Size M/L', 22490000, 18990000, 20, '/uploads/products/apple/d5ca3b11830548aa.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112692', 'Titan Đen - Dây đen', '46mm (5G) Viền Titan Dây Cao Su Size S/M', 22490000, 18990000, 20, '/uploads/products/apple/f0908467410c8a74.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112693', 'Titan Tự Nhiên - Dây xám', '46mm (5G) Viền Titan Dây Cao Su Size S/M', 22490000, 18990000, 20, '/uploads/products/apple/957bd25c2a444cdd.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112766', 'Titan Vàng - Dây hồng', '46mm (5G) Viền Titan Dây Cao Su Size S/M', 22490000, 18990000, 20, '/uploads/products/apple/9360909b1c8e86f0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112701', 'Titan Đen - Dây đen', '46mm (5G) Viền Titan Dây Thép Size M/L', 23990000, 19990000, 20, '/uploads/products/apple/d8a8513bc61927d9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112702', 'Titan Vàng - Dây vàng', '46mm (5G) Viền Titan Dây Thép Size M/L', 23990000, 19990000, 20, '/uploads/products/apple/bb6561747aa82da9.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112746', 'Titan Tự Nhiên - Dây tự nhiên', '46mm (5G) Viền Titan Dây Thép Size M/L', 23990000, 19990000, 20, '/uploads/products/apple/5168c6a24fdf7608.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112698', 'Titan Đen - Dây đen', '46mm (5G) Viền Titan Dây Thép Size S/M', 23990000, 19990000, 20, '/uploads/products/apple/69b5694f9ba5bfe5.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112699', 'Titan Vàng - Dây vàng', '46mm (5G) Viền Titan Dây Thép Size S/M', 23990000, 19990000, 20, '/uploads/products/apple/f494d4b693ae0719.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112747', 'Titan Tự Nhiên - Dây tự nhiên', '46mm (5G) Viền Titan Dây Thép Size S/M', 23990000, 19990000, 20, '/uploads/products/apple/88cafbed2b14ea8c.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/9003349b02fe562d.png', 'Apple Watch Series 11', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4fd0b26373535904.png', 'Apple Watch Series 11', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ce99def34f326991.png', 'Apple Watch Series 11', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d21f5604119499c2.png', 'Apple Watch Series 11', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e0df376754c9d3a8.png', 'Apple Watch Series 11', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c661d87e41facc0c.png', 'Apple Watch Series 11', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b2688f01bfe9710a.png', 'Apple Watch Series 11', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/872281fc94bf24da.png', 'Apple Watch Series 11', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ecf679f279715b27.png', 'Apple Watch Series 11', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/47595b449c8365ec.png', 'Apple Watch Series 11', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0e52c653c198a9ab.png', 'Apple Watch Series 11', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e575874673416bc6.png', 'Apple Watch Series 11', 11);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dong-ho-thong-minh'), @brand, 'Apple Watch Ultra 3', 'apple-watch-ultra-3', 'CPS-apple-watch-ultra-3', 'Thiết kế titan siêu bền, kháng nước và bụi, kèm nút Action Button tùy chỉnh, đèn pin tích hợp và còi báo động nghe tới 180m. · Định vị GPS hai tần số cực chính xác, hỗ trợ luyện tập nâng cao, VO₂ max, Training Load và tích hợp Strava với Live Segments. · Mạng 5G tích hợp, cho phép gọi, nhắn tin, thanh toán Apple Pay và nghe nhạc trực tuyến ngay cả khi không mang iPhone.', 'Thiết kế titan siêu bền, kháng nước và bụi, kèm nút Action Button tùy chỉnh, đèn pin tích hợp và còi báo động nghe tới 180m.
Định vị GPS hai tần số cực chính xác, hỗ trợ luyện tập nâng cao, VO₂ max, Training Load và tích hợp Strava với Live Segments.
Mạng 5G tích hợp, cho phép gọi, nhắn tin, thanh toán Apple Pay và nghe nhạc trực tuyến ngay cả khi không mang iPhone.
Pin siêu dài tới 42 giờ, sạc nhanh 15 phút cho 12 giờ sử dụng, đồng hành cả hành trình phiêu lưu hay buổi tập ngoài trời.

Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/26f8561a0fa97050.png', 20490000, 0, 1, 810);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112704', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Cao Su Size S/M', 23990000, 20490000, 20, '/uploads/products/apple/26f8561a0fa97050.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112752', 'Titan Tự Nhiên - Dây xanh', '49mm (5G) Viền Titan Dây Cao Su Size S/M', 23990000, 20490000, 20, '/uploads/products/apple/217e74d7a4054bb7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112714', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Trail Size M/L', 23990000, 20490000, 20, '/uploads/products/apple/7678ed33c6dbd3b3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112759', 'Titan Tự Nhiên - Dây xanh', '49mm (5G) Viền Titan Dây Trail Size M/L', 23990000, 20490000, 20, '/uploads/products/apple/b959dd60c660887f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112706', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Alpine Size S', 23990000, 20490000, 20, '/uploads/products/apple/eaef405267d67a65.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112748', 'Titan Tự Nhiên - Dây xanh', '49mm (5G) Viền Titan Dây Alpine Size S', 23990000, 20490000, 20, '/uploads/products/apple/8fe8a72cc8a07bfd.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112710', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Alpine Size L', 23990000, 20490000, 20, '/uploads/products/apple/bee1430a9c0d6231.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112750', 'Titan Tự Nhiên - Dây xanh', '49mm (5G) Viền Titan Dây Alpine Size L', 23990000, 20490000, 20, '/uploads/products/apple/4d5fc6c9ebcb4310.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112712', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Trail Size S/M', 23990000, 20490000, 20, '/uploads/products/apple/ad56404721c3f25b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112751', 'Titan Tự Nhiên - Dây xanh', '49mm (5G) Viền Titan Dây Trail Size S/M', 23990000, 20490000, 20, '/uploads/products/apple/b4fdbe8a61e29a61.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112718', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Thép Size M', 26990000, 22490000, 20, '/uploads/products/apple/1311f87d418d8e9f.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112756', 'Titan Tự Nhiên - Dây tự nhiên', '49mm (5G) Viền Titan Dây Thép Size M', 26990000, 22490000, 20, '/uploads/products/apple/2f0e344a0db08d4a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112720', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Thép Size L', 26990000, 22490000, 20, '/uploads/products/apple/e1598e921eb98f04.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112760', 'Titan Tự Nhiên - Dây tự nhiên', '49mm (5G) Viền Titan Dây Thép Size L', 26990000, 22490000, 20, '/uploads/products/apple/4e2d2fbf15161cee.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112716', 'Titan Đen - Dây đen', '49mm (5G) Viền Titan Dây Thép Size S', 26990000, 22490000, 20, '/uploads/products/apple/f00d2ae8f06ba0a7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-112755', 'Titan Tự Nhiên - Dây tự nhiên', '49mm (5G) Viền Titan Dây Thép Size S', 26990000, 22490000, 20, '/uploads/products/apple/b831fe2e49df2085.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5147a667e5f5e104.png', 'Apple Watch Ultra 3', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/cbeb8e9a761117eb.png', 'Apple Watch Ultra 3', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/61b9b646a2eb6b79.png', 'Apple Watch Ultra 3', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/1967922306ee9aad.png', 'Apple Watch Ultra 3', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/5e7ab20ed14690fa.png', 'Apple Watch Ultra 3', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/783c1502fd5d7e05.png', 'Apple Watch Ultra 3', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d9f52141eaaf891f.png', 'Apple Watch Ultra 3', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/26f8561a0fa97050.png', 'Apple Watch Ultra 3', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/217e74d7a4054bb7.png', 'Apple Watch Ultra 3', 8);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dong-ho-thong-minh'), @brand, 'Apple Watch Series 10', 'apple-watch-series-10', 'CPS-apple-watch-series-10', 'Apple Watch Series 10 nổi bật với màn hình lớn hơn, tăng diện tích lên tới 30%, giúp bạn dễ dàng theo dõi thông tin. · Thiết kế mỏng nhẹ mang lại cảm giác dễ chịu khi đeo suốt cả ngày. · Với các tính năng sức khỏe tiên tiến, bạn sẽ nhận được những thông tin chuyên sâu về tình trạng cơ thể.', 'Apple Watch Series 10 nổi bật với màn hình lớn hơn, tăng diện tích lên tới 30%, giúp bạn dễ dàng theo dõi thông tin.
Thiết kế mỏng nhẹ mang lại cảm giác dễ chịu khi đeo suốt cả ngày.
Với các tính năng sức khỏe tiên tiến, bạn sẽ nhận được những thông tin chuyên sâu về tình trạng cơ thể.
Sạc nhanh giúp bạn chỉ mất khoảng 30 phút để nạp 80% pin, cực kỳ tiện lợi cho cuộc sống bận rộn.

Trọng lượng: 538.0000
Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/30e7182ad3575da8.png', 9590000, 0, 1, 780);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90210', 'Bạc', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11790000, 9990000, 20, '/uploads/products/apple/30e7182ad3575da8.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90211', 'Đen', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11790000, 9790000, 20, '/uploads/products/apple/cc5e21c58ae4b2dc.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90212', 'Hồng', '46mm (GPS) Viền Nhôm Dây Cao Su Size S/M', 11790000, 9590000, 20, '/uploads/products/apple/66b9d966a31178c3.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90278', 'Titan Tự Nhiên', '46mm 4G Viền Titan Dây Cao Su Size S/M', 21290000, 15490000, 20, '/uploads/products/apple/bdedc6a3f4d8449a.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90279', 'Titan Đen', '46mm 4G Viền Titan Dây Cao Su Size S/M', 21290000, 15490000, 20, '/uploads/products/apple/a8df1dd628c2f4ea.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90280', 'Titan Vàng', '46mm 4G Viền Titan Dây Cao Su Size S/M', 21290000, 16490000, 20, '/uploads/products/apple/5bb64b6040228da0.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90282', 'Titan Tự Nhiên', '46mm 4G Viền Titan Dây Cao Su Size M/L', 21290000, 15490000, 20, '/uploads/products/apple/a3065ad21921b7be.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90284', 'Titan Đen', '46mm 4G Viền Titan Dây Cao Su Size M/L', 21290000, 15490000, 20, '/uploads/products/apple/0fc3bb12d5624254.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90285', 'Titan Vàng', '46mm 4G Viền Titan Dây Cao Su Size M/L', 21290000, 16490000, 20, '/uploads/products/apple/fd20bfeb2465d1de.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90297', 'Titan Tự Nhiên', '46mm 4G Viền Titan Dây Thép Size S/M', 22590000, 15990000, 20, '/uploads/products/apple/a1922e5182315792.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90298', 'Titan Đen', '46mm 4G Viền Titan Dây Thép Size S/M', 22590000, 15990000, 20, '/uploads/products/apple/3f5ca8c42be0f9ed.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90299', 'Titan Vàng', '46mm 4G Viền Titan Dây Thép Size S/M', 22590000, 15990000, 20, '/uploads/products/apple/ac0a89aeed4d83a1.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90303', 'Titan Tự nhiên', '46mm 4G Viền Titan Dây Thép Size M/L', 22590000, 15990000, 20, '/uploads/products/apple/e91267c69307bf58.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90304', 'Titan Đen', '46mm 4G Viền Titan Dây Thép Size M/L', 22590000, 15990000, 20, '/uploads/products/apple/52b7e40e370b2d19.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90305', 'Titan Vàng', '46mm 4G Viền Titan Dây Thép Size M/L', 22590000, 15990000, 20, '/uploads/products/apple/1aac3fc78cf2e897.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/b5e01c4d96e9ccad.png', 'Apple Watch Series 10', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bc21ebe2a2f3938d.png', 'Apple Watch Series 10', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ef295581a7269387.jpg', 'Apple Watch Series 10', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/beda8f63d9bce87d.jpg', 'Apple Watch Series 10', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e4c275547e8c494a.jpg', 'Apple Watch Series 10', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0fb4f93b26a2998f.jpg', 'Apple Watch Series 10', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/c587bc4f33255949.jpg', 'Apple Watch Series 10', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/d5db34cd90004c73.jpg', 'Apple Watch Series 10', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/417d2b45aa76dd63.jpg', 'Apple Watch Series 10', 8);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/a1922e5182315792.png', 'Apple Watch Series 10', 9);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/3f5ca8c42be0f9ed.png', 'Apple Watch Series 10', 10);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/ac0a89aeed4d83a1.png', 'Apple Watch Series 10', 11);
INSERT INTO products (category_id, brand_id, name, slug, sku, short_desc, full_desc, thumbnail_url, base_price, is_featured, is_active, view_count) VALUES ((SELECT id FROM categories WHERE slug = 'dong-ho-thong-minh'), @brand, 'Apple Watch Ultra 2 2024', 'apple-watch-ultra-2-2024', 'CPS-apple-watch-ultra-2-2024', 'Apple Watch Ultra 2 là sự lựa chọn lý tưởng cho những người yêu thích chạy bộ, với GPS tần số kép mang lại độ chính xác ấn tượng. · Thiết bị có khả năng tự động nhận diện đường chạy và cung cấp các chỉ số dáng chạy tiên tiến, giúp bạn theo dõi hiệu quả tập luyện. · Với vỏ titan bền bỉ và kính sapphire, đồng hồ không chỉ nổi bật với thiết kế tinh tế mà còn có khả năng chống nước ở độ sâu 100 mét, lý tưởng cho các hoạt động ngoài trời.', 'Apple Watch Ultra 2 là sự lựa chọn lý tưởng cho những người yêu thích chạy bộ, với GPS tần số kép mang lại độ chính xác ấn tượng.
Thiết bị có khả năng tự động nhận diện đường chạy và cung cấp các chỉ số dáng chạy tiên tiến, giúp bạn theo dõi hiệu quả tập luyện.
Với vỏ titan bền bỉ và kính sapphire, đồng hồ không chỉ nổi bật với thiết kế tinh tế mà còn có khả năng chống nước ở độ sâu 100 mét, lý tưởng cho các hoạt động ngoài trời.
Thời lượng pin lên đến 36 giờ giúp bạn thoải mái trải nghiệm trong suốt những chuyến phiêu lưu dài ngày.

Bảo hành: 1 ĐỔI 1 trong 30 ngày nếu có lỗi phần cứng nhà sản xuất. Bảo hành 12 tháng tại trung tâm bảo hành chính hãng Apple: CareS.vn', '/uploads/products/apple/7c683f10c915e91b.png', 16490000, 0, 1, 620);
SET @p = LAST_INSERT_ID();
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90345', 'Titan Đen', '49mm 4G Viền Titan Đen Dây Alpine Size L', 22990000, 16490000, 20, '/uploads/products/apple/7c683f10c915e91b.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90347', 'Titan Đen', '49mm 4G Viền Titan Đen Dây Trail Size S/M', 22990000, 16490000, 20, '/uploads/products/apple/ea0b885edd4ddaa7.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90367', 'Titan Tự Nhiên', '49mm 4G Viền Titan Dây Trail Size S/M', 22990000, 16490000, 20, '/uploads/products/apple/7c4a3831c7ef9237.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90331', 'Titan Đen', '49mm 4G Viền Titan Đen Dây Cao Su', 22990000, 16490000, 20, '/uploads/products/apple/e778692e9b485381.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90340', 'Titan Đen', '49mm 4G Viền Titan Đen Dây Alpine Size S', 22990000, 16490000, 20, '/uploads/products/apple/cc5ba3e1e6c63786.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90369', 'Titan Tự Nhiên', '49mm 4G Viền Titan Dây Trail Size M/L', 22990000, 16490000, 20, '/uploads/products/apple/d9af71e3e2a2961e.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90351', 'Titan Đen', '49mm 4G Viền Titan Đen Dây Trail Size M/L', 22990000, 16490000, 20, '/uploads/products/apple/088f154ca533096d.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90342', 'Mặc định', '49mm 4G Viền Titan Đen Dây Alpine Size M', 22990000, NULL, 0, '/uploads/products/apple/79b6e33374164083.png', 1);
INSERT INTO product_variants (product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active) VALUES (@p, 'CPS-90354', 'Titan Đen', '49mm 4G Viền Titan Đen Dây Titan Size S', 25990000, 17990000, 20, '/uploads/products/apple/052430d674d16ba2.png', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/bb081f4a95f2af40.png', 'Apple Watch Ultra 2 2024', 0);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f8a6d9df1c402580.png', 'Apple Watch Ultra 2 2024', 1);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/fa19d891f79d18f3.jpg', 'Apple Watch Ultra 2 2024', 2);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/e19ce01258a8b6f5.jpg', 'Apple Watch Ultra 2 2024', 3);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/0895d2d7955c2350.jpg', 'Apple Watch Ultra 2 2024', 4);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/2ee44f844f03d85a.jpg', 'Apple Watch Ultra 2 2024', 5);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/55d8378a731be20c.jpg', 'Apple Watch Ultra 2 2024', 6);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/4f5097a16bc27008.jpg', 'Apple Watch Ultra 2 2024', 7);
INSERT INTO product_images (product_id, image_url, alt_text, sort_order) VALUES (@p, '/uploads/products/apple/f3268db81ff93fe7.jpg', 'Apple Watch Ultra 2 2024', 8);
COMMIT;
