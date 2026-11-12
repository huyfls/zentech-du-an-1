<?php
/**
 * ZenTech ProductModel
 * Kế thừa BaseModel - Xử lý truy vấn sản phẩm, biến thể, lọc giá, thông số EAV
 */
class ProductModel extends BaseModel
{
    /**
     * Lấy danh sách sản phẩm nổi bật (Trang chủ)
     * Kèm khoảng giá MIN(price)/sale_price và tên thương hiệu
     */
    public function getFeatured(int $limit = 8): array
    {
        $sql = "
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.thumbnail_url AS thumbnail,
                p.short_desc,
                p.is_featured,
                b.name AS brand_name,
                b.slug AS brand_slug,
                c.name AS category_name,
                c.slug AS category_slug,
                MIN(COALESCE(pv.sale_price, pv.price)) AS min_price,
                MAX(COALESCE(pv.sale_price, pv.price)) AS max_price,
                MIN(pv.price) AS original_price,
                MAX(
                    CASE 
                        WHEN pv.sale_price IS NOT NULL AND pv.sale_price < pv.price
                        THEN ROUND((1 - pv.sale_price / pv.price) * 100)
                        ELSE 0
                    END
                ) AS max_discount_pct,
                ROUND(COALESCE(AVG(r.rating), 5.0), 1) AS avg_rating,
                COUNT(DISTINCT r.id) AS review_count
            FROM products p
            INNER JOIN brands b ON b.id = p.brand_id
            INNER JOIN categories c ON c.id = p.category_id
            LEFT JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
            LEFT JOIN reviews r ON r.product_id = p.id AND r.is_approved = 1
            WHERE p.is_active = 1 AND p.is_featured = 1
            GROUP BY p.id, p.name, p.slug, p.thumbnail_url, p.short_desc, p.is_featured, b.name, b.slug, c.name, c.slug
            ORDER BY p.id DESC
            LIMIT :limit
        ";

        $stmt = $this->pdo->prepare($sql);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * Lấy danh sách sản phẩm mới nhất
     */
    public function getNewArrivals(int $limit = 8): array
    {
        $sql = "
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.thumbnail_url AS thumbnail,
                p.short_desc,
                p.is_featured,
                b.name AS brand_name,
                b.slug AS brand_slug,
                c.name AS category_name,
                c.slug AS category_slug,
                MIN(COALESCE(pv.sale_price, pv.price)) AS min_price,
                MAX(COALESCE(pv.sale_price, pv.price)) AS max_price,
                MIN(pv.price) AS original_price,
                MAX(
                    CASE 
                        WHEN pv.sale_price IS NOT NULL AND pv.sale_price < pv.price
                        THEN ROUND((1 - pv.sale_price / pv.price) * 100)
                        ELSE 0
                    END
                ) AS max_discount_pct,
                ROUND(COALESCE(AVG(r.rating), 5.0), 1) AS avg_rating,
                COUNT(DISTINCT r.id) AS review_count
            FROM products p
            INNER JOIN brands b ON b.id = p.brand_id
            INNER JOIN categories c ON c.id = p.category_id
            LEFT JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
            LEFT JOIN reviews r ON r.product_id = p.id AND r.is_approved = 1
            WHERE p.is_active = 1
            GROUP BY p.id, p.name, p.slug, p.thumbnail_url, p.short_desc, p.is_featured, b.name, b.slug, c.name, c.slug
            ORDER BY p.created_at DESC, p.id DESC
            LIMIT :limit
        ";

        $stmt = $this->pdo->prepare($sql);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /** Tạo danh sách placeholder `:prefix0, :prefix1...` cho IN (...) và nạp giá trị vào $params. */
    private function inList(array $values, string $prefix, array &$params): string
    {
        $names = [];
        foreach (array_values($values) as $i => $v) {
            $names[] = ":{$prefix}{$i}";
            $params[":{$prefix}{$i}"] = (string) $v;
        }
        return implode(', ', $names);
    }

    /**
     * Lọc sản phẩm theo nhiều tiêu chí (Bộ lọc CellphoneS style)
     */
    public function getFiltered(array $filters, int $page = 1, int $perPage = 12): array
    {
        $params = [];
        $where = ['p.is_active = 1'];

        // Lọc category (hỗ trợ cả ID và slug)
        if (!empty($filters['category_id']) && $filters['category_id'] > 0) {
            $where[] = 'p.category_id = :cat_id';
            $params[':cat_id'] = (int)$filters['category_id'];
        } elseif (!empty($filters['category_slug'])) {
            $in = $this->inList((array) $filters['category_slug'], 'cat_slug', $params);
            // slug cha (vd chuot-gaming) khớp cả sản phẩm của danh mục con
            $in2 = $this->inList((array) $filters['category_slug'], 'cat_par', $params);
            $where[] = "(c.slug IN ({$in}) OR c.parent_id IN (SELECT id FROM categories WHERE slug IN ({$in2})))";
        }

        // Lọc brand (hỗ trợ cả ID và slug)
        if (!empty($filters['brand_id']) && $filters['brand_id'] > 0) {
            $where[] = 'p.brand_id = :brand_id';
            $params[':brand_id'] = (int)$filters['brand_id'];
        } elseif (!empty($filters['brand_slug'])) {
            $in = $this->inList((array) $filters['brand_slug'], 'brand_slug', $params);
            $where[] = "b.slug IN ({$in})";
        }

        // Lọc từ khóa tìm kiếm (name, sku, short_desc, brand)
        if (!empty($filters['keyword'])) {
            $where[] = '(p.name LIKE :kw OR p.sku LIKE :kw OR p.short_desc LIKE :kw OR b.name LIKE :kw)';
            $params[':kw'] = '%' . $filters['keyword'] . '%';
        }

        // Lọc giá tối thiểu
        if (!empty($filters['price_min']) && $filters['price_min'] > 0) {
            $where[] = 'COALESCE(pv.sale_price, pv.price) >= :price_min';
            $params[':price_min'] = $filters['price_min'];
        }

        // Lọc giá tối đa
        if (!empty($filters['price_max']) && $filters['price_max'] > 0) {
            $where[] = 'COALESCE(pv.sale_price, pv.price) <= :price_max';
            $params[':price_max'] = $filters['price_max'];
        }

        // Sắp xếp
        $sortOrder = 'p.created_at DESC';
        if (!empty($filters['sort'])) {
            switch ($filters['sort']) {
                case 'price_asc':
                    $sortOrder = 'min_price ASC';
                    break;
                case 'price_desc':
                    $sortOrder = 'min_price DESC';
                    break;
                case 'name_asc':
                    $sortOrder = 'p.name ASC';
                    break;
                case 'featured':
                    $sortOrder = 'p.is_featured DESC, p.id DESC';
                    break;
                default:
                    $sortOrder = 'p.created_at DESC';
            }
        }

        $whereClause = implode(' AND ', $where);

        $baseSql = "
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.thumbnail_url AS thumbnail,
                p.short_desc,
                p.is_featured,
                b.name AS brand_name,
                b.slug AS brand_slug,
                c.name AS category_name,
                c.slug AS category_slug,
                MIN(COALESCE(pv.sale_price, pv.price)) AS min_price,
                MAX(COALESCE(pv.sale_price, pv.price)) AS max_price,
                MIN(pv.price) AS original_price,
                MAX(
                    CASE 
                        WHEN pv.sale_price IS NOT NULL AND pv.sale_price < pv.price
                        THEN ROUND((1 - pv.sale_price / pv.price) * 100)
                        ELSE 0
                    END
                ) AS max_discount_pct,
                ROUND(COALESCE(AVG(r.rating), 5.0), 1) AS avg_rating,
                COUNT(DISTINCT r.id) AS review_count
            FROM products p
            INNER JOIN brands b ON b.id = p.brand_id
            INNER JOIN categories c ON c.id = p.category_id
            LEFT JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
            LEFT JOIN reviews r ON r.product_id = p.id AND r.is_approved = 1
            WHERE {$whereClause}
            GROUP BY p.id, p.name, p.slug, p.thumbnail_url, p.short_desc, p.is_featured, b.name, b.slug, c.name, c.slug
            ORDER BY {$sortOrder}
        ";

        return $this->paginate($baseSql, $params, $page, $perPage);
    }

    /**
     * Tìm kiếm sản phẩm theo từ khóa
     */
    public function searchProducts(string $keyword, int $limit = 10): array
    {
        $sql = "
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.thumbnail_url AS thumbnail,
                b.name AS brand_name,
                c.name AS category_name,
                MIN(COALESCE(pv.sale_price, pv.price)) AS min_price,
                MIN(pv.price) AS original_price
            FROM products p
            INNER JOIN brands b ON b.id = p.brand_id
            INNER JOIN categories c ON c.id = p.category_id
            LEFT JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
            WHERE p.is_active = 1 AND (p.name LIKE :kw OR b.name LIKE :kw OR c.name LIKE :kw)
            GROUP BY p.id, p.name, p.slug, p.thumbnail_url, b.name, c.name
            ORDER BY p.id DESC
            LIMIT :limit
        ";

        $stmt = $this->pdo->prepare($sql);
        $stmt->bindValue(':kw', '%' . $keyword . '%');
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * Lấy chi tiết sản phẩm theo Slug
     */
    public function getBySlug(string $slug): ?array
    {
        $sql = "
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.sku,
                p.category_id,
                p.brand_id,
                p.short_desc,
                p.full_desc,
                p.thumbnail_url AS thumbnail,
                p.is_featured,
                p.is_active,
                p.view_count,
                p.sold_count,
                b.name AS brand,
                b.name AS brand_name,
                b.slug AS brand_slug,
                b.logo_url AS brand_logo,
                c.name AS category,
                c.name AS category_name,
                c.slug AS category_slug,
                ROUND(COALESCE(AVG(r.rating), 5.0), 1) AS avg_rating,
                COUNT(DISTINCT r.id) AS review_count
            FROM products p
            INNER JOIN brands b ON b.id = p.brand_id
            INNER JOIN categories c ON c.id = p.category_id
            LEFT JOIN reviews r ON r.product_id = p.id AND r.is_approved = 1
            WHERE p.slug = :slug AND p.is_active = 1
            GROUP BY p.id, p.name, p.slug, p.sku, p.category_id, p.brand_id, p.short_desc, p.full_desc, 
                     p.thumbnail_url, p.is_featured, p.is_active, p.view_count, p.sold_count, b.name, b.slug, b.logo_url, c.name, c.slug
            LIMIT 1
        ";

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([':slug' => $slug]);
        $product = $stmt->fetch();

        if ($product) {
            // Tăng lượt xem
            $this->pdo->prepare("UPDATE products SET view_count = view_count + 1 WHERE id = ?")->execute([$product['id']]);
        }

        return $product ?: null;
    }

    /**
     * Lấy chi tiết sản phẩm theo ID
     */
    public function getById(int $id): ?array
    {
        $sql = "SELECT p.*, b.name AS brand_name, c.name AS category_name 
                FROM products p
                INNER JOIN brands b ON b.id = p.brand_id
                INNER JOIN categories c ON c.id = p.category_id
                WHERE p.id = ? LIMIT 1";
        return $this->rawQueryOne($sql, [$id]);
    }

    /**
     * Lấy toàn bộ biến thể của 1 sản phẩm
     */
    public function getVariants(int $productId): array
    {
        // Thử lấy kèm thông tin màu sắc và kết nối từ variant_attribute_values
        $sql = "
            SELECT 
                pv.id,
                pv.product_id,
                pv.sku,
                COALESCE(pv.color, 
                    (SELECT vov.value 
                     FROM variant_attribute_values vav 
                     JOIN variant_option_values vov ON vov.id = vav.option_value_id
                     JOIN variant_options vo ON vo.id = vov.option_id
                     WHERE vav.variant_id = pv.id AND vo.name LIKE '%Màu%' LIMIT 1), 
                    'Tiêu chuẩn'
                ) AS color,
                COALESCE(pv.version_spec,
                    (SELECT vov.value 
                     FROM variant_attribute_values vav 
                     JOIN variant_option_values vov ON vov.id = vav.option_value_id
                     JOIN variant_options vo ON vo.id = vov.option_id
                     WHERE vav.variant_id = pv.id AND (vo.name LIKE '%Kết nối%' OR vo.name LIKE '%Switch%') LIMIT 1), 
                    'Mặc định'
                ) AS version_spec,
                pv.price,
                pv.sale_price,
                COALESCE(pv.sale_price, pv.price) AS effective_price,
                pv.stock_qty,
                pv.image_url,
                pv.is_active
            FROM product_variants pv
            WHERE pv.product_id = ? AND pv.is_active = 1
            ORDER BY pv.price ASC, pv.id ASC
        ";

        try {
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute([$productId]);
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            // Fallback nếu column color/version_spec chưa tồn tại trong product_variants
            $fallbackSql = "
                SELECT 
                    pv.id,
                    pv.product_id,
                    pv.sku,
                    'Tiêu chuẩn' AS color,
                    'Mặc định' AS version_spec,
                    pv.price,
                    pv.sale_price,
                    COALESCE(pv.sale_price, pv.price) AS effective_price,
                    pv.stock_qty,
                    pv.image_url,
                    pv.is_active
                FROM product_variants pv
                WHERE pv.product_id = ? AND pv.is_active = 1
                ORDER BY pv.price ASC
            ";
            return $this->rawQuery($fallbackSql, [$productId]);
        }
    }

    /**
     * Lấy 1 biến thể theo ID
     */
    public function getVariantById(int $variantId): ?array
    {
        $sql = "
            SELECT 
                pv.*,
                p.name AS product_name,
                p.thumbnail_url AS product_thumbnail,
                COALESCE(pv.sale_price, pv.price) AS effective_price
            FROM product_variants pv
            INNER JOIN products p ON p.id = pv.product_id
            WHERE pv.id = ? AND pv.is_active = 1
            LIMIT 1
        ";
        return $this->rawQueryOne($sql, [$variantId]);
    }

    /**
     * Lấy danh sách sản phẩm liên quan
     */
    public function getRelated(int $categoryId, int $excludeProductId, int $limit = 6): array
    {
        $sql = "
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.thumbnail_url AS thumbnail,
                p.is_featured,
                b.name AS brand_name,
                MIN(COALESCE(pv.sale_price, pv.price)) AS min_price,
                MIN(pv.price) AS original_price,
                ROUND(COALESCE(AVG(r.rating), 5.0), 1) AS avg_rating
            FROM products p
            INNER JOIN brands b ON b.id = p.brand_id
            LEFT JOIN product_variants pv ON pv.product_id = p.id AND pv.is_active = 1
            LEFT JOIN reviews r ON r.product_id = p.id AND r.is_approved = 1
            WHERE p.is_active = 1 AND p.category_id = :cat_id AND p.id != :ex_id
            GROUP BY p.id, p.name, p.slug, p.thumbnail_url, p.is_featured, b.name
            ORDER BY p.id DESC
            LIMIT :limit
        ";

        $stmt = $this->pdo->prepare($sql);
        $stmt->bindValue(':cat_id', $categoryId, PDO::PARAM_INT);
        $stmt->bindValue(':ex_id', $excludeProductId, PDO::PARAM_INT);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * Lấy thông số kỹ thuật (EAV) dạng nhóm
     */
    public function getSpecs(int $productId): array
    {
        $sql = "
            SELECT 
                COALESCE(ag.name, 'Thông số kỹ thuật') AS group_name,
                a.name AS label,
                CASE 
                    WHEN a.unit IS NOT NULL AND a.unit != '' 
                    THEN CONCAT(pa.value, ' ', a.unit) 
                    ELSE pa.value 
                END AS value
            FROM product_attributes pa
            INNER JOIN attributes a ON a.id = pa.attribute_id
            LEFT JOIN attribute_groups ag ON ag.id = a.group_id
            WHERE pa.product_id = ?
            ORDER BY COALESCE(ag.sort_order, 99) ASC, a.sort_order ASC
        ";

        $rows = $this->rawQuery($sql, [$productId]);
        $specs = [];
        foreach ($rows as $row) {
            $group = $row['group_name'];
            $specs[$group][] = [
                'label' => $row['label'],
                'value' => $row['value']
            ];
        }
        return $specs;
    }

    /**
     * Lấy thư viện ảnh của sản phẩm
     */
    public function getImages(int $productId): array
    {
        $sql = "SELECT image_url FROM product_images WHERE product_id = ? ORDER BY sort_order ASC";
        $rows = $this->rawQuery($sql, [$productId]);
        return array_column($rows, 'image_url');
    }

    /**
     * Lấy danh sách đánh giá của sản phẩm kèm thông tin người dùng
     */
    public function getReviews(int $productId): array
    {
        $sql = "
            SELECT 
                r.*,
                COALESCE(u.full_name, 'Khách hàng ZenTech') AS user_name,
                DATE_FORMAT(r.created_at, '%d/%m/%Y') AS review_date
            FROM reviews r
            LEFT JOIN users u ON u.id = r.user_id
            WHERE r.product_id = ? AND r.is_approved = 1
            ORDER BY r.id DESC
        ";
        return $this->rawQuery($sql, [$productId]);
    }

    /**
     * Lấy danh sách sản phẩm cho trang quản trị (Admin)
     */
    public function getAllAdmin(int $page = 1, int $perPage = 10, string $search = ''): array
    {
        $params = [];
        $where = ['1=1'];

        if (!empty($search)) {
            $where[] = '(p.name LIKE :kw OR p.sku LIKE :kw OR b.name LIKE :kw)';
            $params[':kw'] = '%' . $search . '%';
        }

        $whereClause = implode(' AND ', $where);

        $sql = "
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.sku,
                p.thumbnail_url,
                p.is_featured,
                p.is_active,
                p.created_at,
                b.name AS brand_name,
                c.name AS category_name,
                COUNT(pv.id) AS variant_count,
                MIN(COALESCE(pv.sale_price, pv.price)) AS min_price,
                MAX(COALESCE(pv.sale_price, pv.price)) AS max_price,
                COALESCE(SUM(pv.stock_qty), 0) AS total_stock
            FROM products p
            INNER JOIN brands b ON b.id = p.brand_id
            INNER JOIN categories c ON c.id = p.category_id
            LEFT JOIN product_variants pv ON pv.product_id = p.id
            WHERE {$whereClause}
            GROUP BY p.id, p.name, p.slug, p.sku, p.thumbnail_url, p.is_featured, p.is_active, p.created_at, b.name, c.name
            ORDER BY p.id DESC
        ";

        return $this->paginate($sql, $params, $page, $perPage);
    }
}
