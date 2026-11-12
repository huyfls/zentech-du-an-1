<?php
/**
 * ZenTech CategoryModel
 * Quản lý danh mục sản phẩm (cây đa cấp cha - con)
 */
class CategoryModel extends BaseModel
{
    /**
     * Danh mục đang hoạt động và có sản phẩm (kể cả của danh mục con)
     */
    public function getAll(): array
    {
        $sql = "
            SELECT c.*, parent.name AS parent_name,
                   (SELECT COUNT(*) FROM categories k WHERE k.parent_id = c.id) AS child_count
            FROM categories c
            LEFT JOIN categories parent ON parent.id = c.parent_id
            WHERE c.is_active = 1
              AND EXISTS (SELECT 1 FROM products p
                          LEFT JOIN categories pc ON pc.id = p.category_id
                          WHERE p.is_active = 1 AND (pc.id = c.id OR pc.parent_id = c.id))
            ORDER BY c.sort_order ASC, c.id ASC
        ";
        return $this->rawQuery($sql);
    }

    /**
     * Lấy danh mục kèm số lượng sản phẩm
     */
    public function getWithProductCount(): array
    {
        $sql = "
            SELECT 
                c.id,
                c.name,
                c.slug,
                c.image_url,
                COUNT(p.id) AS product_count
            FROM categories c
            LEFT JOIN products p ON p.category_id = c.id AND p.is_active = 1
            WHERE c.is_active = 1 AND c.parent_id IS NULL
            GROUP BY c.id, c.name, c.slug, c.image_url
            ORDER BY c.sort_order ASC
        ";
        return $this->rawQuery($sql);
    }

    /**
     * Lấy danh mục theo slug
     */
    public function getBySlug(string $slug): ?array
    {
        $sql = "SELECT * FROM categories WHERE slug = ? AND is_active = 1 LIMIT 1";
        return $this->rawQueryOne($sql, [$slug]);
    }

    /**
     * Lấy danh mục theo ID
     */
    public function getById(int $id): ?array
    {
        return $this->findById('categories', $id);
    }
}
