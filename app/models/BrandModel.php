<?php
/**
 * ZenTech BrandModel
 * Quản lý thương hiệu Gaming Gear (Logitech, Razer, Corsair, DareU, HyperX, Asus ROG, Akko, SteelSeries...)
 */
class BrandModel extends BaseModel
{
    /**
     * Lấy toàn bộ thương hiệu đang hoạt động
     */
    public function getAll(): array
    {
        $sql = "SELECT * FROM brands WHERE is_active = 1 ORDER BY name ASC";
        return $this->rawQuery($sql);
    }

    /**
     * Lấy danh sách thương hiệu kèm số lượng sản phẩm và dải giá
     */
    public function getAllWithProductCount(): array
    {
        $sql = "
            SELECT
                b.*,
                COUNT(p.id) AS product_count,
                MIN(v.min_price) AS min_price,
                MAX(v.max_price) AS max_price
            FROM brands b
            LEFT JOIN products p ON p.brand_id = b.id AND p.is_active = 1
            LEFT JOIN (
                SELECT product_id,
                       MIN(COALESCE(sale_price, price)) AS min_price,
                       MAX(COALESCE(sale_price, price)) AS max_price
                FROM product_variants WHERE is_active = 1 GROUP BY product_id
            ) v ON v.product_id = p.id
            WHERE b.is_active = 1
            GROUP BY b.id
            HAVING product_count > 0
            ORDER BY product_count DESC, b.name ASC
        ";
        return $this->rawQuery($sql);
    }

    /**
     * Lấy thương hiệu theo Slug
     */
    public function getBySlug(string $slug): ?array
    {
        $sql = "SELECT * FROM brands WHERE slug = ? AND is_active = 1 LIMIT 1";
        return $this->rawQueryOne($sql, [$slug]);
    }

    /**
     * Lấy thương hiệu theo ID
     */
    public function getById(int $id): ?array
    {
        return $this->findById('brands', $id);
    }
}
