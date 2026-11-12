<?php
/**
 * ProductController.php
 * Xử lý danh sách sản phẩm, chi tiết sản phẩm và bộ lọc AJAX
 */
class ProductController extends BaseController
{
    private ProductModel  $productModel;
    private CategoryModel $categoryModel;
    private BrandModel    $brandModel;

    public function __construct()
    {
        parent::__construct();
        $this->productModel  = new ProductModel($this->pdo);
        $this->categoryModel = new CategoryModel($this->pdo);
        $this->brandModel    = new BrandModel($this->pdo);
    }

    /**
     * Danh sách sản phẩm có phân trang + bộ lọc category/brand/price
     */
    public function index(): void
    {
        // category/brand nhận một giá trị (?category=a) hoặc nhiều (?category[]=a&category[]=b)
        $slugs = fn(string $k): array => array_values(array_filter((array) ($_GET[$k] ?? []), fn($v) => is_string($v) && trim($v) !== ''));

        // Lấy tham số lọc từ GET (hỗ trợ cả slug, id và alias tham số)
        $filters = [
            'category_slug' => $slugs('category'),
            'category_id'   => (int)$this->getGet('category_id', 0),
            'brand_slug'    => $slugs('brand'),
            'brand_id'      => (int)$this->getGet('brand_id', 0),
            'price_min'     => (float)($this->getGet('price_min') ?: $this->getGet('min_price', 0)),
            'price_max'     => (float)($this->getGet('price_max') ?: $this->getGet('max_price', 0)),
            'keyword'       => trim($this->getGet('keyword') ?: $this->getGet('q', '')),
            'sort'          => $this->getGet('sort', 'newest'), // newest | price_asc | price_desc | name_asc
        ];

        $page    = max(1, (int) $this->getGet('page', 1));
        $perPage = 48;

        // Lấy sản phẩm theo bộ lọc (paginated)
        $result     = $this->productModel->getFiltered($filters, $page, $perPage);
        $products   = $result['items'];
        $totalItems = $result['total'];
        $totalPages = (int) ceil($totalItems / $perPage);

        // Dữ liệu cho sidebar bộ lọc
        $categories = $this->categoryModel->getAll();
        $brands     = $this->brandModel->getAll();

        $this->render('products/index', compact(
            'products', 'categories', 'brands', 'filters',
            'page', 'totalPages', 'totalItems'
        ));
    }

    /**
     * Chi tiết sản phẩm theo slug
     * Nhóm variants theo color và version_spec
     */
    public function detail(string $slug): void
    {
        // Lấy thông tin sản phẩm chính
        $product = $this->productModel->getBySlug($slug);

        if (!$product) {
            $this->redirect('/404');
            return;
        }

        // Lấy tất cả variants của sản phẩm
        $variants = $this->productModel->getVariants($product['id']);

        // Nhóm variants theo color để hiển thị bộ chọn màu sắc
        $variantsByColor = [];
        foreach ($variants as $v) {
            $color = $v['color'] ?? 'default';
            $variantsByColor[$color][] = $v;
        }

        // Nhóm variants theo version_spec để hiển thị cấu hình
        $variantsBySpec = [];
        foreach ($variants as $v) {
            $spec = $v['version_spec'] ?? 'standard';
            $variantsBySpec[$spec][] = $v;
        }

        // Encode variants thành JSON để JavaScript xử lý real-time price update
        $variantsJson = json_encode($variants, JSON_UNESCAPED_UNICODE);

        // Lấy thư viện ảnh chi tiết
        $images = $this->productModel->getImages($product['id']);
        if (empty($images) && !empty($product['thumbnail_url'])) {
            $images = [$product['thumbnail_url']];
        }

        // Thông số kỹ thuật (EAV) nhóm theo nhóm thuộc tính
        $specs = $this->productModel->getSpecs($product['id']);

        // Lấy danh sách đánh giá
        $reviews = $this->productModel->getReviews($product['id']);

        $reviewState = $this->isLoggedIn() ? $this->productModel->reviewEligibility((int) $_SESSION['user_id'], (int) $product['id'])[0] : 'guest';

        // Lấy sản phẩm liên quan (cùng category, trừ sản phẩm hiện tại)
        $relatedProducts = $this->productModel->getRelated(
            $product['category_id'],
            $product['id'],
            6
        );

        $this->render('products/detail', compact(
            'product', 'variants', 'variantsByColor',
            'variantsBySpec', 'variantsJson', 'relatedProducts',
            'images', 'reviews', 'specs', 'reviewState'
        ) + ['pageTitle' => $product['name'] . ' – ZenTech']);
    }
}
