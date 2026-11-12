# ⚙️ ZenTech — SQL & PHP PDO Reference
## Các câu lệnh SQL tối ưu cho Backend MVC

> **Stack:** PHP 8.x · PDO · MySQL 8.0+ · Mô hình MVC  
> Mỗi luồng gồm: **SQL thuần** (kiểm tra trên phpMyAdmin) + **PHP PDO** (dán vào Model)

---

## LUỒNG 1 — Danh sách sản phẩm trang chủ

> Lấy sản phẩm kèm: ảnh đại diện · tên thương hiệu · khoảng giá (min/max từ biến thể) · điểm đánh giá trung bình.

### 1.1 SQL thuần

```sql
SELECT
    p.id,
    p.name,
    p.slug,
    p.thumbnail_url,
    p.is_featured,
    p.sold_count,
    b.name                              AS brand_name,
    b.slug                              AS brand_slug,
    -- Giá: lấy từ biến thể đang hoạt động
    MIN(COALESCE(pv.sale_price, pv.price)) AS price_min,
    MAX(COALESCE(pv.sale_price, pv.price)) AS price_max,
    MIN(pv.price)                          AS original_price_min,
    -- Phần trăm giảm giá lớn nhất
    MAX(
        CASE
            WHEN pv.sale_price IS NOT NULL
            THEN ROUND((1 - pv.sale_price / pv.price) * 100)
            ELSE 0
        END
    )                                   AS max_discount_pct,
    -- Đánh giá
    ROUND(AVG(r.rating), 1)             AS avg_rating,
    COUNT(DISTINCT r.id)                AS review_count,
    -- Tồn kho (tổng tất cả biến thể)
    SUM(pv.stock_qty)                   AS total_stock
FROM products p
INNER JOIN brands         b  ON b.id  = p.brand_id
INNER JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
LEFT  JOIN reviews        r  ON r.product_id = p.id AND r.is_approved = 1
WHERE
    p.is_active = 1
GROUP BY
    p.id, p.name, p.slug, p.thumbnail_url,
    p.is_featured, p.sold_count,
    b.name, b.slug
-- Chỉ lấy sản phẩm còn hàng
HAVING total_stock > 0
ORDER BY p.is_featured DESC, p.created_at DESC
LIMIT 20 OFFSET 0;
```

### 1.2 PHP PDO — `ProductModel.php`

```php
<?php
// app/Models/ProductModel.php

class ProductModel
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    /**
     * Lấy danh sách sản phẩm cho trang chủ / danh mục.
     *
     * @param int $limit   Số sản phẩm mỗi trang
     * @param int $offset  Vị trí bắt đầu (phân trang)
     * @param bool $featuredOnly  Chỉ lấy sản phẩm nổi bật
     * @return array
     */
    public function getProductList(
        int  $limit       = 20,
        int  $offset      = 0,
        bool $featuredOnly = false
    ): array {
        $featuredClause = $featuredOnly ? 'AND p.is_featured = 1' : '';

        $sql = "
            SELECT
                p.id,
                p.name,
                p.slug,
                p.thumbnail_url,
                p.is_featured,
                p.sold_count,
                b.name                                       AS brand_name,
                b.slug                                       AS brand_slug,
                MIN(COALESCE(pv.sale_price, pv.price))       AS price_min,
                MAX(COALESCE(pv.sale_price, pv.price))       AS price_max,
                MIN(pv.price)                                AS original_price_min,
                MAX(
                    CASE WHEN pv.sale_price IS NOT NULL
                         THEN ROUND((1 - pv.sale_price / pv.price) * 100)
                         ELSE 0 END
                )                                            AS max_discount_pct,
                ROUND(AVG(r.rating), 1)                      AS avg_rating,
                COUNT(DISTINCT r.id)                         AS review_count,
                SUM(pv.stock_qty)                            AS total_stock
            FROM products p
            INNER JOIN brands           b  ON b.id = p.brand_id
            INNER JOIN product_variants pv ON pv.product_id = p.id
                                          AND pv.is_active  = 1
            LEFT  JOIN reviews          r  ON r.product_id  = p.id
                                          AND r.is_approved = 1
            WHERE p.is_active = 1
            {$featuredClause}
            GROUP BY
                p.id, p.name, p.slug, p.thumbnail_url,
                p.is_featured, p.sold_count,
                b.name, b.slug
            HAVING total_stock > 0
            ORDER BY p.is_featured DESC, p.created_at DESC
            LIMIT :limit OFFSET :offset
        ";

        $stmt = $this->pdo->prepare($sql);
        $stmt->bindValue(':limit',  $limit,  PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
```

---

## LUỒNG 2 — Bộ lọc sản phẩm nâng cao (Filter)

> Lọc theo: khoảng giá · thương hiệu · chuẩn kết nối · danh mục · sắp xếp.  
> Dùng **dynamic query building** trong PHP để tránh SQL Injection và đảm bảo linh hoạt.

### 2.1 SQL mẫu (đầy đủ filter)

```sql
-- Ví dụ: lọc chuột không dây Logitech + Razer, giá 500K-2Tr, sắp xếp giá tăng dần
SELECT
    p.id,
    p.name,
    p.slug,
    p.thumbnail_url,
    b.name                                   AS brand_name,
    MIN(COALESCE(pv.sale_price, pv.price))   AS price_min,
    MAX(COALESCE(pv.sale_price, pv.price))   AS price_max,
    ROUND(AVG(r.rating), 1)                  AS avg_rating,
    COUNT(DISTINCT r.id)                     AS review_count,
    SUM(pv.stock_qty)                        AS total_stock
FROM products p
INNER JOIN brands           b   ON b.id = p.brand_id
INNER JOIN product_variants pv  ON pv.product_id = p.id AND pv.is_active = 1
-- JOIN để lọc theo chuẩn kết nối (Wireless / Có dây)
INNER JOIN variant_attribute_values vav ON vav.variant_id = pv.id
INNER JOIN variant_option_values    vov ON vov.id = vav.option_value_id
INNER JOIN variant_options          vo  ON vo.id  = vov.option_id
                                       AND vo.name = 'Kết nối'
LEFT JOIN reviews r ON r.product_id = p.id AND r.is_approved = 1
WHERE
    p.is_active     = 1
    -- Lọc danh mục (bao gồm cả danh mục con bằng cách dùng path hoặc IN)
    AND p.category_id IN (6, 7, 8)              -- Chuột Gaming + các con
    -- Lọc hãng (multi-select)
    AND p.brand_id IN (1, 2)                    -- Logitech, Razer
    -- Lọc khoảng giá (dựa trên giá hiệu dụng = sale_price hoặc price)
    AND COALESCE(pv.sale_price, pv.price) BETWEEN 500000 AND 2000000
    -- Lọc chuẩn kết nối
    AND vov.value LIKE '%Wireless%'             -- 'Wireless 2.4G', 'USB + Wireless'
GROUP BY p.id, p.name, p.slug, p.thumbnail_url, b.name
HAVING total_stock > 0
-- Sắp xếp: price_asc | price_desc | newest | best_seller | top_rated
ORDER BY price_min ASC
LIMIT 12 OFFSET 0;
```

### 2.2 PHP PDO — Dynamic Query Builder

```php
<?php
// app/Models/ProductModel.php (tiếp theo)

/**
 * Lọc sản phẩm theo nhiều tiêu chí động (giống CellphoneS).
 *
 * @param array $filters {
 *   int[]   brand_ids      Mảng brand_id cần lọc
 *   int[]   category_ids   Mảng category_id (đã flatten cả cấp con)
 *   int     price_min      Giá tối thiểu (VNĐ)
 *   int     price_max      Giá tối đa (VNĐ)
 *   string  connection     'wireless' | 'wired' | null
 *   string  sort_by        'price_asc'|'price_desc'|'newest'|'best_seller'|'top_rated'
 *   int     limit
 *   int     page
 * }
 * @return array { items: array, total: int }
 */
public function filterProducts(array $filters): array
{
    // ── Giá trị mặc định ──────────────────────────────────────────
    $brandIds    = $filters['brand_ids']    ?? [];
    $catIds      = $filters['category_ids'] ?? [];
    $priceMin    = $filters['price_min']    ?? 0;
    $priceMax    = $filters['price_max']    ?? PHP_INT_MAX;
    $connection  = $filters['connection']   ?? null;   // 'wireless' | 'wired'
    $sortBy      = $filters['sort_by']      ?? 'newest';
    $limit       = max(1, (int)($filters['limit'] ?? 12));
    $page        = max(1, (int)($filters['page']  ?? 1));
    $offset      = ($page - 1) * $limit;

    $params      = [];   // PDO bind params
    $joins       = '';
    $conditions  = ['p.is_active = 1'];

    // ── Lọc theo Danh mục ─────────────────────────────────────────
    if (!empty($catIds)) {
        $catPlaceholders = implode(',', array_fill(0, count($catIds), '?'));
        $conditions[]    = "p.category_id IN ($catPlaceholders)";
        array_push($params, ...$catIds);
    }

    // ── Lọc theo Thương hiệu ──────────────────────────────────────
    if (!empty($brandIds)) {
        $brandPlaceholders = implode(',', array_fill(0, count($brandIds), '?'));
        $conditions[]      = "p.brand_id IN ($brandPlaceholders)";
        array_push($params, ...$brandIds);
    }

    // ── Lọc theo Khoảng giá ───────────────────────────────────────
    $conditions[] = 'COALESCE(pv.sale_price, pv.price) >= ?';
    $params[]     = $priceMin;
    $conditions[] = 'COALESCE(pv.sale_price, pv.price) <= ?';
    $params[]     = $priceMax;

    // ── Lọc theo Chuẩn kết nối ───────────────────────────────────
    if ($connection !== null) {
        $joins .= "
            INNER JOIN variant_attribute_values _vav
                    ON _vav.variant_id = pv.id
            INNER JOIN variant_option_values    _vov
                    ON _vov.id = _vav.option_value_id
            INNER JOIN variant_options          _vo
                    ON _vo.id  = _vov.option_id
                   AND _vo.name = 'Kết nối'
        ";
        if ($connection === 'wireless') {
            $conditions[] = "_vov.value LIKE '%Wireless%'";
        } elseif ($connection === 'wired') {
            $conditions[] = "_vov.value NOT LIKE '%Wireless%'";
        }
    }

    // ── Sắp xếp ───────────────────────────────────────────────────
    $orderMap = [
        'price_asc'   => 'price_min ASC',
        'price_desc'  => 'price_min DESC',
        'newest'      => 'p.created_at DESC',
        'best_seller' => 'p.sold_count DESC',
        'top_rated'   => 'avg_rating DESC, review_count DESC',
    ];
    $orderClause = $orderMap[$sortBy] ?? 'p.created_at DESC';

    $whereClause = implode(' AND ', $conditions);

    // ── Query chính ───────────────────────────────────────────────
    $sql = "
        SELECT
            p.id,
            p.name,
            p.slug,
            p.thumbnail_url,
            b.name                                   AS brand_name,
            b.slug                                   AS brand_slug,
            MIN(COALESCE(pv.sale_price, pv.price))   AS price_min,
            MAX(COALESCE(pv.sale_price, pv.price))   AS price_max,
            MIN(pv.price)                            AS original_price_min,
            MAX(CASE WHEN pv.sale_price IS NOT NULL
                     THEN ROUND((1 - pv.sale_price / pv.price) * 100)
                     ELSE 0 END)                     AS max_discount_pct,
            ROUND(AVG(r.rating), 1)                  AS avg_rating,
            COUNT(DISTINCT r.id)                     AS review_count,
            SUM(pv.stock_qty)                        AS total_stock
        FROM products p
        INNER JOIN brands           b  ON b.id  = p.brand_id
        INNER JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
        {$joins}
        LEFT  JOIN reviews          r  ON r.product_id  = p.id AND r.is_approved = 1
        WHERE {$whereClause}
        GROUP BY p.id, p.name, p.slug, p.thumbnail_url, b.name, b.slug
        HAVING total_stock > 0
        ORDER BY {$orderClause}
        LIMIT ? OFFSET ?
    ";

    // ── Query đếm tổng (phân trang) ───────────────────────────────
    $countSql = "
        SELECT COUNT(DISTINCT p.id) AS total
        FROM products p
        INNER JOIN brands           b  ON b.id  = p.brand_id
        INNER JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
        {$joins}
        LEFT  JOIN reviews          r  ON r.product_id  = p.id AND r.is_approved = 1
        WHERE {$whereClause}
        HAVING SUM(pv.stock_qty) > 0
    ";

    // ── Thực thi COUNT ────────────────────────────────────────────
    $countStmt = $this->pdo->prepare($countSql);
    $countStmt->execute($params);
    $total = (int)($countStmt->fetchColumn() ?: 0);

    // ── Thực thi SELECT chính ─────────────────────────────────────
    $params[] = $limit;
    $params[] = $offset;

    $stmt = $this->pdo->prepare($sql);
    $stmt->execute($params);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return [
        'items'       => $items,
        'total'       => $total,
        'page'        => $page,
        'limit'       => $limit,
        'total_pages' => (int)ceil($total / $limit),
    ];
}
```

### 2.3 Ví dụ gọi từ Controller

```php
<?php
// app/Controllers/ProductController.php

class ProductController
{
    private ProductModel $model;

    public function __construct(ProductModel $model)
    {
        $this->model = $model;
    }

    public function filter(): void
    {
        // Nhận params từ URL: ?brands[]=1&brands[]=2&price_min=500000&sort=price_asc
        $filters = [
            'brand_ids'    => array_map('intval', $_GET['brands']     ?? []),
            'category_ids' => array_map('intval', $_GET['categories'] ?? []),
            'price_min'    => (int)($_GET['price_min'] ?? 0),
            'price_max'    => (int)($_GET['price_max'] ?? PHP_INT_MAX),
            'connection'   => $_GET['connection'] ?? null,   // 'wireless' | 'wired'
            'sort_by'      => $_GET['sort']       ?? 'newest',
            'page'         => (int)($_GET['page'] ?? 1),
            'limit'        => 12,
        ];

        $result = $this->model->filterProducts($filters);

        header('Content-Type: application/json');
        echo json_encode($result);
    }
}
```

---

## LUỒNG 3 — Transaction: Trừ tồn kho & Tạo đơn hàng

> **Yêu cầu nguyên tử (ACID):** Nếu bất kỳ bước nào thất bại (hết hàng, lỗi DB...) → toàn bộ hoàn tác (ROLLBACK).

### 3.1 Sơ đồ luồng nghiệp vụ

```
Khách bấm "Đặt hàng"
        │
        ▼
  BEGIN TRANSACTION
        │
        ├─ [1] Kiểm tra tồn kho từng variant (SELECT ... FOR UPDATE)
        │        └─ Nếu stock_qty < qty_ordered → ROLLBACK + thông báo lỗi
        │
        ├─ [2] Tạo đơn hàng (INSERT INTO orders)
        │
        ├─ [3] Insert từng dòng sản phẩm (INSERT INTO order_items)
        │
        ├─ [4] Trừ tồn kho từng variant (UPDATE product_variants)
        │
        ├─ [5] Ghi log trạng thái đơn (INSERT INTO order_status_logs)
        │
        └─ [6] COMMIT — Thành công
```

### 3.2 SQL thuần (mô tả từng bước)

```sql
-- ══════════════════════════════════════════════════════════
-- BƯỚC 1: Khóa hàng để kiểm tra tồn kho
--   FOR UPDATE: khóa record, ngăn transaction song song thay đổi
-- ══════════════════════════════════════════════════════════
SELECT
    pv.id,
    pv.stock_qty,
    pv.price,
    pv.sale_price,
    p.name  AS product_name
FROM product_variants pv
INNER JOIN products p ON p.id = pv.product_id
WHERE pv.id IN (5, 8, 14)   -- danh sách variant_id trong giỏ hàng
FOR UPDATE;                  -- Row-level lock trong InnoDB

-- ══════════════════════════════════════════════════════════
-- BƯỚC 2: Tạo đơn hàng
-- ══════════════════════════════════════════════════════════
INSERT INTO orders (
    user_id, order_code,
    receiver_name, receiver_phone, shipping_address,
    payment_method, payment_status,
    subtotal, shipping_fee, discount_amount, total_amount,
    status
) VALUES (
    2,                    -- user_id
    'ZT20261104001',      -- order_code (sinh từ PHP)
    'Nguyễn Văn An', '0912345678',
    'Số 10, Nguyễn Trãi, Phường 2, Quận 5, TP.HCM',
    'cod', 'unpaid',
    2439000,   -- subtotal
    30000,     -- shipping_fee
    0,         -- discount_amount
    2469000,   -- total_amount
    'pending'
);

-- ══════════════════════════════════════════════════════════
-- BƯỚC 3: Chèn từng dòng sản phẩm trong đơn
-- ══════════════════════════════════════════════════════════
INSERT INTO order_items
    (order_id, variant_id, product_name, variant_info, unit_price, quantity, total_price)
VALUES
    (LAST_INSERT_ID(), 5,  'DareU EM901X Wireless', 'Đen | USB + Wireless', 799000, 1,  799000),
    (LAST_INSERT_ID(), 8,  'Razer DeathAdder V3',   'Đen | USB có dây',    1190000, 1, 1190000),
    (LAST_INSERT_ID(), 14, 'Corsair K70 Pro Mini',  'Đen | USB + Wireless', 450000, 1,  450000);

-- ══════════════════════════════════════════════════════════
-- BƯỚC 4: Trừ tồn kho (đảm bảo không bị âm)
-- ══════════════════════════════════════════════════════════
UPDATE product_variants
SET stock_qty = stock_qty - 1
WHERE id = 5  AND stock_qty >= 1;

UPDATE product_variants
SET stock_qty = stock_qty - 1
WHERE id = 8  AND stock_qty >= 1;

UPDATE product_variants
SET stock_qty = stock_qty - 1
WHERE id = 14 AND stock_qty >= 1;

-- ══════════════════════════════════════════════════════════
-- BƯỚC 5: Ghi log trạng thái
-- ══════════════════════════════════════════════════════════
INSERT INTO order_status_logs (order_id, old_status, new_status, note)
VALUES (LAST_INSERT_ID(), NULL, 'pending', 'Đơn hàng được tạo tự động');
```

### 3.3 PHP PDO — `OrderModel.php` (Transaction đầy đủ)

```php
<?php
// app/Models/OrderModel.php

class OrderModel
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    /**
     * Tạo đơn hàng + trừ tồn kho trong một transaction nguyên tử.
     *
     * @param int   $userId
     * @param array $address  ['receiver_name', 'receiver_phone', 'shipping_address']
     * @param array $items    [['variant_id'=>5, 'quantity'=>1], ...]
     * @param string $paymentMethod  'cod' | 'vnpay' | 'momo'
     * @param int   $discountAmount  Số tiền giảm từ voucher
     * @param int   $shippingFee
     * @return array ['success'=>bool, 'order_id'=>int|null, 'message'=>string]
     */
    public function placeOrder(
        int    $userId,
        array  $address,
        array  $items,
        string $paymentMethod  = 'cod',
        int    $discountAmount = 0,
        int    $shippingFee    = 30000
    ): array {
        // ── Khởi đầu transaction ──────────────────────────────────
        $this->pdo->beginTransaction();

        try {
            // ── Bước 1: Lấy & khóa hàng tồn kho ─────────────────
            $variantIds  = array_column($items, 'variant_id');
            $placeholders = implode(',', array_fill(0, count($variantIds), '?'));

            $lockSql = "
                SELECT
                    pv.id,
                    pv.stock_qty,
                    COALESCE(pv.sale_price, pv.price) AS effective_price,
                    p.name  AS product_name,
                    GROUP_CONCAT(
                        vov.value ORDER BY vo.name SEPARATOR ' | '
                    ) AS variant_info
                FROM product_variants pv
                INNER JOIN products p ON p.id = pv.product_id
                LEFT JOIN variant_attribute_values vav ON vav.variant_id = pv.id
                LEFT JOIN variant_option_values    vov ON vov.id = vav.option_value_id
                LEFT JOIN variant_options          vo  ON vo.id  = vov.option_id
                WHERE pv.id IN ({$placeholders})
                  AND pv.is_active = 1
                GROUP BY pv.id, pv.stock_qty, effective_price, p.name
                FOR UPDATE
            ";

            $lockStmt = $this->pdo->prepare($lockSql);
            $lockStmt->execute($variantIds);
            $stockData = $lockStmt->fetchAll(PDO::FETCH_ASSOC);

            // Index theo variant_id để tra cứu nhanh
            $stockMap = array_column($stockData, null, 'id');

            // ── Bước 1b: Kiểm tra đủ hàng ────────────────────────
            $subtotal = 0;
            $outOfStock = [];

            foreach ($items as $item) {
                $vid = $item['variant_id'];
                $qty = $item['quantity'];

                if (!isset($stockMap[$vid])) {
                    throw new \RuntimeException(
                        "Sản phẩm ID={$vid} không tồn tại hoặc đã ngừng bán."
                    );
                }

                if ($stockMap[$vid]['stock_qty'] < $qty) {
                    $outOfStock[] = $stockMap[$vid]['product_name']
                        . " (còn {$stockMap[$vid]['stock_qty']} sản phẩm)";
                }

                $subtotal += $stockMap[$vid]['effective_price'] * $qty;
            }

            if (!empty($outOfStock)) {
                throw new \RuntimeException(
                    'Sản phẩm hết hàng: ' . implode(', ', $outOfStock)
                );
            }

            $totalAmount = $subtotal + $shippingFee - $discountAmount;

            // ── Bước 2: Tạo đơn hàng ─────────────────────────────
            $orderCode = 'ZT' . date('Ymd') . str_pad(
                random_int(1, 9999), 4, '0', STR_PAD_LEFT
            );

            $orderSql = "
                INSERT INTO orders (
                    user_id, order_code,
                    receiver_name, receiver_phone, shipping_address,
                    payment_method, payment_status,
                    subtotal, shipping_fee, discount_amount, total_amount,
                    status
                ) VALUES (
                    :user_id, :order_code,
                    :receiver_name, :receiver_phone, :shipping_address,
                    :payment_method, 'unpaid',
                    :subtotal, :shipping_fee, :discount_amount, :total_amount,
                    'pending'
                )
            ";
            $orderStmt = $this->pdo->prepare($orderSql);
            $orderStmt->execute([
                ':user_id'          => $userId,
                ':order_code'       => $orderCode,
                ':receiver_name'    => $address['receiver_name'],
                ':receiver_phone'   => $address['receiver_phone'],
                ':shipping_address' => $address['shipping_address'],
                ':payment_method'   => $paymentMethod,
                ':subtotal'         => $subtotal,
                ':shipping_fee'     => $shippingFee,
                ':discount_amount'  => $discountAmount,
                ':total_amount'     => $totalAmount,
            ]);

            $orderId = (int)$this->pdo->lastInsertId();

            // ── Bước 3: Chèn order_items ──────────────────────────
            $itemSql = "
                INSERT INTO order_items
                    (order_id, variant_id, product_name, variant_info,
                     unit_price, quantity, total_price)
                VALUES
                    (:order_id, :variant_id, :product_name, :variant_info,
                     :unit_price, :quantity, :total_price)
            ";
            $itemStmt = $this->pdo->prepare($itemSql);

            foreach ($items as $item) {
                $vid  = $item['variant_id'];
                $qty  = $item['quantity'];
                $price = $stockMap[$vid]['effective_price'];

                $itemStmt->execute([
                    ':order_id'     => $orderId,
                    ':variant_id'   => $vid,
                    ':product_name' => $stockMap[$vid]['product_name'],
                    ':variant_info' => $stockMap[$vid]['variant_info'],
                    ':unit_price'   => $price,
                    ':quantity'     => $qty,
                    ':total_price'  => $price * $qty,
                ]);
            }

            // ── Bước 4: Trừ tồn kho ───────────────────────────────
            $deductSql = "
                UPDATE product_variants
                SET stock_qty = stock_qty - :qty
                WHERE id = :vid
                  AND stock_qty >= :qty
            ";
            $deductStmt = $this->pdo->prepare($deductSql);

            foreach ($items as $item) {
                $deductStmt->execute([
                    ':qty' => $item['quantity'],
                    ':vid' => $item['variant_id'],
                ]);
                // Nếu không có hàng nào bị ảnh hưởng → race condition!
                if ($deductStmt->rowCount() === 0) {
                    throw new \RuntimeException(
                        "Race condition: Sản phẩm ID={$item['variant_id']} đã hết hàng."
                    );
                }
            }

            // ── Bước 5: Ghi log trạng thái ───────────────────────
            $logSql = "
                INSERT INTO order_status_logs
                    (order_id, old_status, new_status, changed_by, note)
                VALUES
                    (:order_id, NULL, 'pending', :user_id, 'Đơn hàng được tạo thành công')
            ";
            $this->pdo->prepare($logSql)->execute([
                ':order_id' => $orderId,
                ':user_id'  => $userId,
            ]);

            // ── COMMIT ────────────────────────────────────────────
            $this->pdo->commit();

            return [
                'success'    => true,
                'order_id'   => $orderId,
                'order_code' => $orderCode,
                'message'    => 'Đặt hàng thành công!',
            ];

        } catch (\Throwable $e) {
            // ── ROLLBACK ─ Hoàn tác toàn bộ ──────────────────────
            $this->pdo->rollBack();

            // Ghi log lỗi (không expose ra ngoài)
            error_log('[ZenTech][Order] ' . $e->getMessage());

            return [
                'success'  => false,
                'order_id' => null,
                'message'  => $e->getMessage(),
            ];
        }
    }
}
```

---

## LUỒNG 4 — Chi tiết sản phẩm + Biến thể + Thông số kỹ thuật

> Trang chi tiết sản phẩm cần **3 query độc lập** (tối ưu hơn 1 mega-join):  
> Query 1 → Thông tin chính + rating  
> Query 2 → Danh sách biến thể + tùy chọn  
> Query 3 → Bảng thông số kỹ thuật (EAV)

### 4.1 Query 1 — Thông tin sản phẩm chính

```sql
SELECT
    p.id,
    p.name,
    p.slug,
    p.sku,
    p.short_desc,
    p.full_desc,
    p.thumbnail_url,
    p.view_count,
    p.sold_count,
    b.id                AS brand_id,
    b.name              AS brand_name,
    b.slug              AS brand_slug,
    b.logo_url          AS brand_logo,
    c.id                AS category_id,
    c.name              AS category_name,
    c.slug              AS category_slug,
    -- Thống kê đánh giá
    ROUND(AVG(r.rating), 1) AS avg_rating,
    COUNT(r.id)             AS review_count,
    SUM(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END) AS rating_5,
    SUM(CASE WHEN r.rating = 4 THEN 1 ELSE 0 END) AS rating_4,
    SUM(CASE WHEN r.rating = 3 THEN 1 ELSE 0 END) AS rating_3,
    SUM(CASE WHEN r.rating = 2 THEN 1 ELSE 0 END) AS rating_2,
    SUM(CASE WHEN r.rating = 1 THEN 1 ELSE 0 END) AS rating_1,
    -- Giá bán hiển thị
    MIN(COALESCE(pv.sale_price, pv.price)) AS display_price_min,
    MAX(COALESCE(pv.sale_price, pv.price)) AS display_price_max
FROM products p
INNER JOIN brands           b  ON b.id = p.brand_id
INNER JOIN categories       c  ON c.id = p.category_id
INNER JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
LEFT  JOIN reviews          r  ON r.product_id  = p.id AND r.is_approved = 1
WHERE p.id = :product_id
  AND p.is_active = 1
GROUP BY
    p.id, p.name, p.slug, p.sku, p.short_desc, p.full_desc,
    p.thumbnail_url, p.view_count, p.sold_count,
    b.id, b.name, b.slug, b.logo_url,
    c.id, c.name, c.slug;
```

### 4.2 Query 2 — Danh sách biến thể + tùy chọn

```sql
-- Trả về mỗi biến thể kèm chuỗi tùy chọn JSON
SELECT
    pv.id              AS variant_id,
    pv.sku,
    pv.price,
    pv.sale_price,
    COALESCE(pv.sale_price, pv.price) AS effective_price,
    pv.stock_qty,
    pv.image_url       AS variant_image,
    -- Tổng hợp tùy chọn thành JSON array: [{"option":"Màu sắc","value":"Đen","hex":"#1a1a1a"}]
    JSON_ARRAYAGG(
        JSON_OBJECT(
            'option', vo.name,
            'value',  vov.value,
            'hex',    vov.color_hex
        )
    )                  AS options_json
FROM product_variants       pv
INNER JOIN variant_attribute_values vav ON vav.variant_id      = pv.id
INNER JOIN variant_option_values    vov ON vov.id              = vav.option_value_id
INNER JOIN variant_options          vo  ON vo.id               = vov.option_id
WHERE pv.product_id = :product_id
  AND pv.is_active  = 1
GROUP BY
    pv.id, pv.sku, pv.price, pv.sale_price,
    effective_price, pv.stock_qty, pv.image_url
ORDER BY pv.price ASC;
```

### 4.3 Query 3 — Bảng thông số kỹ thuật (EAV)

```sql
-- Nhóm thuộc tính theo group, hiển thị theo bảng thông số kỹ thuật
SELECT
    ag.id              AS group_id,
    ag.name            AS group_name,
    ag.sort_order      AS group_order,
    a.id               AS attr_id,
    a.name             AS attr_name,
    a.unit,
    a.sort_order       AS attr_order,
    pa.value,
    -- Hiển thị kèm đơn vị: "25600 DPI"
    CASE
        WHEN a.unit IS NOT NULL
        THEN CONCAT(pa.value, ' ', a.unit)
        ELSE pa.value
    END                AS display_value
FROM product_attributes pa
INNER JOIN attributes       a   ON a.id  = pa.attribute_id
LEFT  JOIN attribute_groups ag  ON ag.id = a.group_id
WHERE pa.product_id = :product_id
ORDER BY ag.sort_order ASC, a.sort_order ASC;
```

### 4.4 PHP PDO — `ProductModel::getProductDetail()`

```php
<?php
// app/Models/ProductModel.php (tiếp theo)

/**
 * Lấy toàn bộ dữ liệu chi tiết một sản phẩm.
 * Trả về mảng gồm: thông tin chính, danh sách biến thể, thông số kỹ thuật.
 *
 * @param int $productId
 * @return array|null  null nếu không tìm thấy
 */
public function getProductDetail(int $productId): ?array
{
    // ── Query 1: Thông tin chính ──────────────────────────────────
    $infoSql = "
        SELECT
            p.id, p.name, p.slug, p.sku,
            p.short_desc, p.full_desc, p.thumbnail_url,
            p.view_count, p.sold_count,
            b.id AS brand_id, b.name AS brand_name,
            b.slug AS brand_slug, b.logo_url AS brand_logo,
            c.id AS category_id, c.name AS category_name,
            c.slug AS category_slug,
            ROUND(AVG(r.rating), 1)                             AS avg_rating,
            COUNT(r.id)                                         AS review_count,
            SUM(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END)      AS rating_5,
            SUM(CASE WHEN r.rating = 4 THEN 1 ELSE 0 END)      AS rating_4,
            SUM(CASE WHEN r.rating = 3 THEN 1 ELSE 0 END)      AS rating_3,
            SUM(CASE WHEN r.rating = 2 THEN 1 ELSE 0 END)      AS rating_2,
            SUM(CASE WHEN r.rating = 1 THEN 1 ELSE 0 END)      AS rating_1,
            MIN(COALESCE(pv.sale_price, pv.price))              AS display_price_min,
            MAX(COALESCE(pv.sale_price, pv.price))              AS display_price_max
        FROM products p
        INNER JOIN brands           b  ON b.id = p.brand_id
        INNER JOIN categories       c  ON c.id = p.category_id
        INNER JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
        LEFT  JOIN reviews          r  ON r.product_id  = p.id AND r.is_approved = 1
        WHERE p.id = :pid AND p.is_active = 1
        GROUP BY p.id, p.name, p.slug, p.sku,
                 p.short_desc, p.full_desc, p.thumbnail_url,
                 p.view_count, p.sold_count,
                 b.id, b.name, b.slug, b.logo_url,
                 c.id, c.name, c.slug
    ";
    $infoStmt = $this->pdo->prepare($infoSql);
    $infoStmt->execute([':pid' => $productId]);
    $product = $infoStmt->fetch(PDO::FETCH_ASSOC);

    if (!$product) return null;

    // ── Tăng view_count (fire-and-forget, không ảnh hưởng response) ──
    $this->pdo->prepare(
        "UPDATE products SET view_count = view_count + 1 WHERE id = ?"
    )->execute([$productId]);

    // ── Query 2: Biến thể ─────────────────────────────────────────
    $variantSql = "
        SELECT
            pv.id AS variant_id,
            pv.sku,
            pv.price,
            pv.sale_price,
            COALESCE(pv.sale_price, pv.price) AS effective_price,
            pv.stock_qty,
            pv.image_url AS variant_image,
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'option', vo.name,
                    'value',  vov.value,
                    'hex',    vov.color_hex
                )
            ) AS options_json
        FROM product_variants       pv
        INNER JOIN variant_attribute_values vav ON vav.variant_id    = pv.id
        INNER JOIN variant_option_values    vov ON vov.id            = vav.option_value_id
        INNER JOIN variant_options          vo  ON vo.id             = vov.option_id
        WHERE pv.product_id = :pid AND pv.is_active = 1
        GROUP BY pv.id, pv.sku, pv.price, pv.sale_price,
                 effective_price, pv.stock_qty, pv.image_url
        ORDER BY pv.price ASC
    ";
    $variantStmt = $this->pdo->prepare($variantSql);
    $variantStmt->execute([':pid' => $productId]);
    $variants = $variantStmt->fetchAll(PDO::FETCH_ASSOC);

    // Parse JSON options từ DB
    foreach ($variants as &$v) {
        $v['options'] = json_decode($v['options_json'], true) ?? [];
        unset($v['options_json']);
    }
    unset($v);

    // ── Query 3: Thông số kỹ thuật (EAV) ─────────────────────────
    $specSql = "
        SELECT
            ag.id        AS group_id,
            ag.name      AS group_name,
            ag.sort_order AS group_order,
            a.name       AS attr_name,
            a.unit,
            a.sort_order AS attr_order,
            CASE WHEN a.unit IS NOT NULL
                 THEN CONCAT(pa.value, ' ', a.unit)
                 ELSE pa.value
            END          AS display_value
        FROM product_attributes pa
        INNER JOIN attributes       a   ON a.id  = pa.attribute_id
        LEFT  JOIN attribute_groups ag  ON ag.id = a.group_id
        WHERE pa.product_id = :pid
        ORDER BY ag.sort_order ASC, a.sort_order ASC
    ";
    $specStmt = $this->pdo->prepare($specSql);
    $specStmt->execute([':pid' => $productId]);
    $rawSpecs = $specStmt->fetchAll(PDO::FETCH_ASSOC);

    // Nhóm specs theo group_name
    $specs = [];
    foreach ($rawSpecs as $row) {
        $group = $row['group_name'] ?? 'Thông số khác';
        $specs[$group][] = [
            'name'  => $row['attr_name'],
            'value' => $row['display_value'],
        ];
    }

    // ── Query 4: Ảnh gallery ──────────────────────────────────────
    $imageSql = "
        SELECT image_url, alt_text, sort_order
        FROM product_images
        WHERE product_id = :pid
        ORDER BY sort_order ASC
    ";
    $imageStmt = $this->pdo->prepare($imageSql);
    $imageStmt->execute([':pid' => $productId]);
    $images = $imageStmt->fetchAll(PDO::FETCH_ASSOC);

    // ── Ghép kết quả ─────────────────────────────────────────────
    return [
        'product'  => $product,
        'variants' => $variants,
        'specs'    => $specs,
        'images'   => $images,
    ];
}
```

### 4.5 Ví dụ response JSON từ `getProductDetail(1)`

```json
{
  "product": {
    "id": 1,
    "name": "Logitech G Pro X Superlight 2",
    "avg_rating": 4.8,
    "review_count": 42,
    "display_price_min": 1750000,
    "display_price_max": 1890000
  },
  "variants": [
    {
      "variant_id": 1,
      "sku": "LOG-GPXSL2-BLK",
      "price": 1890000,
      "sale_price": 1750000,
      "effective_price": 1750000,
      "stock_qty": 25,
      "options": [
        { "option": "Màu sắc", "value": "Đen",          "hex": "#1a1a1a" },
        { "option": "Kết nối", "value": "Wireless 2.4G", "hex": null }
      ]
    }
  ],
  "specs": {
    "Thông số cảm biến": [
      { "name": "DPI tối đa",    "value": "25600 DPI" },
      { "name": "Loại cảm biến", "value": "HERO 2 (Optical)" }
    ],
    "Kết nối & Pin": [
      { "name": "Thời lượng pin", "value": "95 giờ" }
    ]
  }
}
```

---

## Tổng kết — Index khuyến nghị

> Chạy các lệnh sau trên phpMyAdmin để tối ưu tốc độ query khi dữ liệu lớn.

```sql
-- Tối ưu Luồng 1 & 2: lọc sản phẩm
ALTER TABLE products
    ADD INDEX idx_prod_active_featured (is_active, is_featured),
    ADD INDEX idx_prod_active_cat      (is_active, category_id),
    ADD INDEX idx_prod_created         (created_at DESC),
    ADD INDEX idx_prod_sold            (sold_count DESC);

-- Tối ưu filter giá trong product_variants
ALTER TABLE product_variants
    ADD INDEX idx_var_price     (price),
    ADD INDEX idx_var_sale      (sale_price),
    ADD INDEX idx_var_stock_act (product_id, is_active, stock_qty);

-- Tối ưu EAV lookup
ALTER TABLE product_attributes
    ADD INDEX idx_pa_prod_attr (product_id, attribute_id);

-- Tối ưu review aggregation
ALTER TABLE reviews
    ADD INDEX idx_rv_prod_approved (product_id, is_approved, rating);
```

---

> [!IMPORTANT]
> **Luồng 3 (Transaction)** phải dùng `InnoDB` — đã được set trong schema. Không dùng `MyISAM`.

> [!TIP]
> **Luồng 2 (Filter)**: Khi số lượng filter tăng lên, có thể cân nhắc dùng **MySQL Fulltext Search** hoặc **Elasticsearch** cho production.

> [!WARNING]
> **Race condition tồn kho**: Lệnh `SELECT ... FOR UPDATE` chỉ hiệu quả khi tất cả transaction đều dùng cùng pattern này. Không đọc tồn kho bằng query thường trước khi UPDATE.
