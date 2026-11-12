<?php
/**
 * ZenTech AdminProductController
 * Quản lý danh mục sản phẩm, biến thể đa màu sắc/phiên bản, tồn kho
 */
class AdminProductController extends BaseController
{
    private ProductModel  $productModel;
    private CategoryModel $categoryModel;
    private BrandModel    $brandModel;

    public function __construct()
    {
        parent::__construct();
        $this->requireAdmin();
        $this->productModel  = new ProductModel($this->pdo);
        $this->categoryModel = new CategoryModel($this->pdo);
        $this->brandModel    = new BrandModel($this->pdo);
    }

    /**
     * Danh sách sản phẩm (Admin Table)
     */
    public function index(): void
    {
        $page    = max(1, (int) $this->getGet('page', 1));
        $search  = trim($this->getGet('q', ''));
        $perPage = 10;

        $result   = $this->productModel->getAllAdmin($page, $perPage, $search);
        $products = $result['items'];
        $total    = $result['total'];
        $pages    = $result['total_pages'];

        $this->render('admin/products/index', compact('products', 'page', 'pages', 'total', 'search'), 'admin');
    }

    /**
     * Form thêm mới sản phẩm
     */
    public function create(): void
    {
        $categories = $this->categoryModel->getAll();
        $brands     = $this->brandModel->getAll();
        $product    = null;
        $variants   = [];

        $this->render('admin/products/form', compact('categories', 'brands', 'product', 'variants'), 'admin');
    }

    /**
     * POST - Lưu sản phẩm mới + các dòng biến thể
     */
    public function store(): void
    {
        $name        = trim($this->getPost('name', ''));
        $categoryId  = (int) $this->getPost('category_id', 0);
        $brandId     = (int) $this->getPost('brand_id', 0);
        $sku         = trim($this->getPost('sku', ''));
        $shortDesc   = trim($this->getPost('short_desc', ''));
        $fullDesc    = $_POST['full_desc'] ?? '';
        $thumbnail   = trim($this->getPost('thumbnail_url', ''));
        $isFeatured  = isset($_POST['is_featured']) ? 1 : 0;
        $variantsRaw = $_POST['variants'] ?? [];

        if (empty($name) || $categoryId <= 0 || $brandId <= 0) {
            $this->setFlash('error', 'Vui lòng điền đầy đủ tên sản phẩm, danh mục và thương hiệu.');
            $this->redirect('/admin/products/create');
            return;
        }

        if ($errs = $this->variantErrors(is_array($variantsRaw) ? $variantsRaw : [])) {
            $this->setFlash('error', implode(' ', $errs));
            $this->redirect('/admin/products/create');
            return;
        }

        // Tạo slug từ tên
        $slug = $this->createSlug($name);
        // Đảm bảo slug là duy nhất
        $check = $this->pdo->prepare("SELECT id FROM products WHERE slug = ?");
        $check->execute([$slug]);
        if ($check->fetch()) {
            $slug .= '-' . time();
        }

        $this->pdo->beginTransaction();
        try {
            // 1. Chèn bảng products
            $sqlProd = "
                INSERT INTO products (
                    category_id, brand_id, name, slug, sku, 
                    short_desc, full_desc, thumbnail_url, is_featured, is_active, created_at
                ) VALUES (
                    :cat, :brand, :name, :slug, :sku, 
                    :short, :full, :thumb, :feat, 1, NOW()
                )
            ";
            $stmt = $this->pdo->prepare($sqlProd);
            $stmt->execute([
                ':cat'   => $categoryId,
                ':brand' => $brandId,
                ':name'  => $name,
                ':slug'  => $slug,
                ':sku'   => $sku ?: 'ZT-' . strtoupper(substr(uniqid(), -6)),
                ':short' => $shortDesc,
                ':full'  => $fullDesc,
                ':thumb' => $thumbnail ?: 'https://placehold.co/600x600/1e293b/22d3ee?text=' . urlencode($name),
                ':feat'  => $isFeatured,
            ]);

            $productId = (int) $this->pdo->lastInsertId();

            // 2. Chèn danh sách biến thể (product_variants)
            $sqlVar = "
                INSERT INTO product_variants (
                    product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active
                ) VALUES (
                    :pid, :sku, :color, :spec, :price, :sale, :stock, :img, 1
                )
            ";
            $stmtVar = $this->pdo->prepare($sqlVar);

            if (!empty($variantsRaw) && is_array($variantsRaw)) {
                foreach ($variantsRaw as $index => $v) {
                    if (empty($v['price'])) continue;

                    $vSku = !empty($v['sku']) ? trim($v['sku']) : ($sku . '-' . ($index + 1));
                    $stmtVar->execute([
                        ':pid'   => $productId,
                        ':sku'   => $vSku,
                        ':color' => trim($v['color'] ?? 'Tiêu chuẩn'),
                        ':spec'  => trim($v['version_spec'] ?? 'Mặc định'),
                        ':price' => (float) $v['price'],
                        ':sale'  => !empty($v['sale_price']) ? (float)$v['sale_price'] : null,
                        ':stock' => (int) ($v['stock_qty'] ?? 0),
                        ':img'   => !empty($v['image_url']) ? trim($v['image_url']) : $thumbnail,
                    ]);
                }
            } else {
                // Tạo 1 biến thể mặc định nếu không nhập
                $stmtVar->execute([
                    ':pid'   => $productId,
                    ':sku'   => $sku . '-DEF',
                    ':color' => 'Tiêu chuẩn',
                    ':spec'  => 'Mặc định',
                    ':price' => 500000,
                    ':sale'  => null,
                    ':stock' => 10,
                    ':img'   => $thumbnail,
                ]);
            }

            $this->pdo->commit();
            $this->setFlash('success', 'Thêm mới sản phẩm thành công!');
            $this->redirect('/admin/products');

        } catch (Throwable $e) {
            $this->pdo->rollBack();
            error_log('[ZenTech][Product Create Error] ' . $e->getMessage());
            $this->setFlash('error', 'Có lỗi xảy ra khi lưu sản phẩm, vui lòng thử lại.');
            $this->redirect('/admin/products/create');
        }
    }

    /**
     * Form chỉnh sửa sản phẩm
     */
    public function edit(int $id): void
    {
        $product = $this->productModel->getById($id);
        if (!$product) {
            $this->redirect('/admin/products');
            return;
        }

        $categories = $this->categoryModel->getAll();
        $brands     = $this->brandModel->getAll();
        $variants   = $this->productModel->getVariants($id);

        $this->render('admin/products/form', compact('categories', 'brands', 'product', 'variants'), 'admin');
    }

    /**
     * POST - Cập nhật sản phẩm & biến thể
     */
    public function update(int $id): void
    {
        $name        = trim($this->getPost('name', ''));
        $categoryId  = (int) $this->getPost('category_id', 0);
        $brandId     = (int) $this->getPost('brand_id', 0);
        $sku         = trim($this->getPost('sku', ''));
        $shortDesc   = trim($this->getPost('short_desc', ''));
        $fullDesc    = $_POST['full_desc'] ?? '';
        $thumbnail   = trim($this->getPost('thumbnail_url', ''));
        $isFeatured  = isset($_POST['is_featured']) ? 1 : 0;
        $variantsRaw = $_POST['variants'] ?? [];

        if ($errs = $this->variantErrors(is_array($variantsRaw) ? $variantsRaw : [])) {
            $this->setFlash('error', implode(' ', $errs));
            $this->redirect('/admin/products/edit/' . $id);
            return;
        }

        if ($name === '' || $categoryId <= 0 || $brandId <= 0) {
            $this->setFlash('error', 'Vui lòng điền đầy đủ tên sản phẩm, danh mục và thương hiệu.');
            $this->redirect('/admin/products/edit/' . $id);
            return;
        }

        $this->pdo->beginTransaction();
        try {
            // Cập nhật sản phẩm
            $sql = "
                UPDATE products SET 
                    name = :name, category_id = :cat, brand_id = :brand, 
                    sku = :sku, short_desc = :short, full_desc = :full, 
                    thumbnail_url = :thumb, is_featured = :feat, updated_at = NOW()
                WHERE id = :id
            ";
            $this->pdo->prepare($sql)->execute([
                ':name'  => $name,
                ':cat'   => $categoryId,
                ':brand' => $brandId,
                ':sku'   => $sku,
                ':short' => $shortDesc,
                ':full'  => $fullDesc,
                ':thumb' => $thumbnail,
                ':feat'  => $isFeatured,
                ':id'    => $id,
            ]);

            // Cập nhật/Thêm biến thể
            if (!empty($variantsRaw) && is_array($variantsRaw)) {
                foreach ($variantsRaw as $v) {
                    if (empty($v['price'])) continue;

                    if (!empty($v['id'])) {
                        // Update existing variant
                        $upSql = "
                            UPDATE product_variants SET 
                                color = :color, version_spec = :spec, price = :price, 
                                sale_price = :sale, stock_qty = :stock, image_url = :img
                            WHERE id = :vid AND product_id = :pid
                        ";
                        $this->pdo->prepare($upSql)->execute([
                            ':color' => trim($v['color'] ?? ''),
                            ':spec'  => trim($v['version_spec'] ?? ''),
                            ':price' => (float)$v['price'],
                            ':sale'  => !empty($v['sale_price']) ? (float)$v['sale_price'] : null,
                            ':stock' => (int)$v['stock_qty'],
                            ':img'   => trim($v['image_url'] ?? ''),
                            ':vid'   => (int)$v['id'],
                            ':pid'   => $id,
                        ]);
                    } else {
                        // Insert new variant
                        $inSql = "
                            INSERT INTO product_variants (
                                product_id, sku, color, version_spec, price, sale_price, stock_qty, image_url, is_active
                            ) VALUES (
                                :pid, :sku, :color, :spec, :price, :sale, :stock, :img, 1
                            )
                        ";
                        $vSku = !empty($v['sku']) ? trim($v['sku']) : ($sku . '-' . uniqid());
                        $this->pdo->prepare($inSql)->execute([
                            ':pid'   => $id,
                            ':sku'   => $vSku,
                            ':color' => trim($v['color'] ?? 'Tiêu chuẩn'),
                            ':spec'  => trim($v['version_spec'] ?? 'Mặc định'),
                            ':price' => (float)$v['price'],
                            ':sale'  => !empty($v['sale_price']) ? (float)$v['sale_price'] : null,
                            ':stock' => (int)($v['stock_qty'] ?? 0),
                            ':img'   => !empty($v['image_url']) ? trim($v['image_url']) : $thumbnail,
                        ]);
                    }
                }
            }

            $this->pdo->commit();
            $this->setFlash('success', 'Cập nhật sản phẩm thành công!');
            $this->redirect('/admin/products');

        } catch (Throwable $e) {
            $this->pdo->rollBack();
            error_log('[ZenTech][Product Update Error] ' . $e->getMessage());
            $this->setFlash('error', 'Có lỗi xảy ra khi cập nhật, vui lòng thử lại.');
            $this->redirect('/admin/products/edit/' . $id);
        }
    }

    /**
     * POST - Xóa mềm sản phẩm (set is_active = 0)
     */
    public function delete(int $id): void
    {
        $stmt = $this->pdo->prepare("UPDATE products SET is_active = 0 WHERE id = ?");
        $stmt->execute([$id]);

        $this->setFlash('success', 'Đã chuyển sản phẩm vào thùng rác.');
        $this->redirect('/admin/products');
    }

    /** Kiểm tra các dòng biến thể; trả về danh sách lỗi (rỗng nếu hợp lệ). */
    private function variantErrors(array $variants): array
    {
        $errors = [];
        foreach ($variants as $i => $v) {
            if (empty($v['price']) && empty($v['id'])) continue;   // dòng trống bị bỏ qua như cũ
            $n = (int) $i + 1;
            $price = (float) ($v['price'] ?? 0);
            $sale  = isset($v['sale_price']) && $v['sale_price'] !== '' ? (float) $v['sale_price'] : null;
            if ($price <= 0) $errors[] = "Biến thể {$n}: giá bán phải lớn hơn 0.";
            if ($sale !== null && ($sale <= 0 || $sale >= $price)) $errors[] = "Biến thể {$n}: giá khuyến mãi phải lớn hơn 0 và nhỏ hơn giá gốc.";
            if ((int) ($v['stock_qty'] ?? 0) < 0) $errors[] = "Biến thể {$n}: tồn kho không được âm.";
        }
        return $errors;
    }

    private function createSlug(string $string): string
    {
        $search = [
            'à', 'á', 'ạ', 'ả', 'ã', 'â', 'ầ', 'ấ', 'ậ', 'ẩ', 'ẫ', 'ă', 'ằ', 'ắ', 'ặ', 'ẳ', 'ẵ',
            'è', 'é', 'ẹ', 'ẻ', 'ẽ', 'ê', 'ề', 'ế', 'ệ', 'ể', 'ễ',
            'ì', 'í', 'ị', 'ỉ', 'ĩ',
            'ò', 'ó', 'ọ', 'ỏ', 'õ', 'ô', 'ồ', 'ố', 'ộ', 'ổ', 'ỗ', 'ơ', 'ờ', 'ớ', 'ợ', 'ở', 'ỡ',
            'ù', 'ú', 'ụ', 'ủ', 'ũ', 'ư', 'ừ', 'ứ', 'ự', 'ử', 'ữ',
            'ỳ', 'ý', 'ỵ', 'ỷ', 'ỹ',
            'đ',
        ];
        $replace = [
            'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a',
            'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e',
            'i', 'i', 'i', 'i', 'i',
            'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o',
            'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u',
            'y', 'y', 'y', 'y', 'y',
            'd',
        ];
        $slug = str_replace($search, $replace, mb_strtolower($string, 'UTF-8'));
        $slug = preg_replace('/[^a-z0-9\s-]/', '', $slug);
        $slug = preg_replace('/[\s-]+/', '-', $slug);
        return trim($slug, '-');
    }
}
