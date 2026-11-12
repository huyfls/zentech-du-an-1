<?php
/**
 * ZenTech — Router
 * Phân tích URI và điều hướng đến Controller/Action tương ứng.
 * Hỗ trợ GET và POST, kiểm tra quyền admin cho route /admin/*.
 */
class Router {

    // -------------------------------------------------------------------------
    // Danh sách route tĩnh: [method, pattern, controller, action]
    // -------------------------------------------------------------------------
    private array $routes = [
        // Trang chủ
        ['GET',  '/',                          'HomeController',          'index'],

        // Sản phẩm (hỗ trợ cả slug tiếng Việt và tiếng Anh)
        ['GET',  '/san-pham',                  'ProductController',       'index'],
        ['GET',  '/products',                  'ProductController',       'index'],
        ['GET',  '/san-pham/{slug}',           'ProductController',       'detail'],
        ['GET',  '/products/{slug}',           'ProductController',       'detail'],

        // Tìm kiếm nhanh (Spotlight) & số lượng giỏ hàng (badge)
        ['GET',  '/search',                    'HomeController',          'search'],
        ['GET',  '/cart/count',                'CartController',          'getCount'],
        ['POST', '/danh-gia',                  'ReviewController',        'add'],
        ['POST', '/wishlist/toggle',           'WishlistController',      'toggle'],

        // Giỏ hàng
        ['GET',  '/gio-hang',                  'CartController',          'index'],
        ['GET',  '/cart',                      'CartController',          'index'],
        ['POST', '/cart/add',                  'CartController',          'add'],
        ['POST', '/cart/update',               'CartController',          'update'],
        ['POST', '/cart/remove',               'CartController',          'remove'],

        // Thanh toán & Đặt hàng
        ['GET',  '/thanh-toan',                'OrderController',         'checkout'],
        ['GET',  '/checkout',                  'OrderController',         'checkout'],
        ['POST', '/order/place',               'OrderController',         'place'],
        ['POST', '/coupon/preview',            'OrderController',         'couponPreview'],

        // Đơn hàng cá nhân
        ['GET',  '/don-hang',                  'OrderController',         'history'],
        ['GET',  '/orders',                    'OrderController',         'history'],
        ['GET',  '/don-hang/{id}',             'OrderController',         'detail'],
        ['GET',  '/orders/{id}',               'OrderController',         'detail'],
        ['POST', '/orders/cancel/{id}',        'OrderController',         'cancel'],

        // Tài khoản cá nhân
        ['GET',  '/tai-khoan',                 'AccountController',       'index'],
        ['POST', '/tai-khoan/thong-tin',       'AccountController',       'updateProfile'],
        ['POST', '/tai-khoan/mat-khau',        'AccountController',       'changePassword'],
        ['POST', '/tai-khoan/dia-chi',         'AccountController',       'addAddress'],
        ['POST', '/tai-khoan/dia-chi/xoa/{id}','AccountController',       'deleteAddress'],

        // Điều hướng thương hiệu / về chúng tôi
        ['GET',  '/thuong-hieu',               'BrandController',         'index'],
        ['GET',  '/brands',                    'BrandController',         'index'],
        ['GET',  '/thuong-hieu/{slug}',        'BrandController',         'detail'],
        ['GET',  '/brands/{slug}',             'BrandController',         'detail'],
        ['GET',  '/ve-chung-toi',              'HomeController',          'about'],
        ['GET',  '/about',                     'HomeController',          'about'],

        // Xác thực (Đăng nhập / Đăng ký / Đăng xuất)
        ['GET',  '/auth/login',                'AuthController',          'loginPage'],
        ['GET',  '/login',                     'AuthController',          'loginPage'],
        ['GET',  '/dang-nhap',                 'AuthController',          'loginPage'],
        ['POST', '/auth/login',                'AuthController',          'login'],
        ['POST', '/login',                     'AuthController',          'login'],
        ['POST', '/dang-nhap',                 'AuthController',          'login'],

        ['GET',  '/auth/register',             'AuthController',          'registerPage'],
        ['GET',  '/register',                  'AuthController',          'registerPage'],
        ['GET',  '/dang-ky',                   'AuthController',          'registerPage'],
        ['POST', '/auth/register',             'AuthController',          'register'],
        ['POST', '/register',                  'AuthController',          'register'],
        ['POST', '/dang-ky',                   'AuthController',          'register'],

        ['GET',  '/quen-mat-khau',             'AuthController',          'forgotPage'],
        ['POST', '/quen-mat-khau',             'AuthController',          'forgot'],
        ['GET',  '/dat-lai-mat-khau/{token}',  'AuthController',          'resetPage'],
        ['POST', '/dat-lai-mat-khau/{token}',  'AuthController',          'reset'],

        // Đăng xuất bắt buộc POST + CSRF (tránh logout CSRF)
        ['POST', '/auth/logout',               'AuthController',          'logout'],
        ['POST', '/logout',                    'AuthController',          'logout'],
        ['POST', '/dang-xuat',                 'AuthController',          'logout'],

        // --- Admin (yêu cầu quyền admin) ---
        ['GET',  '/admin',                     'AdminDashboardController','index'],
        ['GET',  '/admin/products',            'AdminProductController',  'index'],
        ['GET',  '/admin/products/create',     'AdminProductController',  'create'],
        ['POST', '/admin/products/create',     'AdminProductController',  'store'],
        ['GET',  '/admin/products/edit/{id}',  'AdminProductController',  'edit'],
        ['POST', '/admin/products/edit/{id}',  'AdminProductController',  'update'],
        ['POST', '/admin/products/delete/{id}','AdminProductController',  'delete'],
        ['GET',  '/admin/orders',              'AdminOrderController',    'index'],
        ['GET',  '/admin/orders/detail/{id}',  'AdminOrderController',    'detail'],
        ['GET',  '/admin/coupons',             'AdminCouponController',   'index'],
        ['POST', '/admin/coupons/create',      'AdminCouponController',   'store'],
        ['POST', '/admin/coupons/toggle/{id}', 'AdminCouponController',   'toggle'],
        ['GET',  '/403',                       'ErrorController',         'forbidden'],
        ['GET',  '/404',                       'ErrorController',         'notFound'],
        ['POST', '/admin/orders/update/{id}',  'AdminOrderController',    'updateStatus'],
    ];

    // -------------------------------------------------------------------------
    // Lấy base path từ APP_URL để loại bỏ prefix khi so sánh URI
    // -------------------------------------------------------------------------
    private function getBasePath(): string {
        $appUrl   = defined('APP_URL') ? APP_URL : '';
        $parsed   = parse_url($appUrl, PHP_URL_PATH);
        return rtrim($parsed ?? '', '/');
    }

    // -------------------------------------------------------------------------
    // Chuẩn hoá URI: loại bỏ base path, query string và trailing slash
    // -------------------------------------------------------------------------
    private function normalizeUri(): string {
        $uri      = $_SERVER['REQUEST_URI'] ?? '/';
        $uri      = strtok($uri, '?');           // loại bỏ query string
        $uri      = rawurldecode($uri);
        $base     = $this->getBasePath();
        if ($base !== '' && str_starts_with($uri, $base)) {
            $uri = substr($uri, strlen($base));
        }
        $uri = '/' . trim($uri, '/');
        return $uri ?: '/';
    }

    // -------------------------------------------------------------------------
    // Khớp URI với pattern có tham số động {param}
    // Trả về mảng params nếu khớp, false nếu không
    // -------------------------------------------------------------------------
    private function matchPattern(string $pattern, string $uri): array|false {
        // Chuyển pattern thành regex
        $regex = preg_replace('/\{[a-zA-Z_]+\}/', '([^/]+)', $pattern);
        $regex = '#^' . $regex . '$#u';

        if (!preg_match($regex, $uri, $matches)) {
            return false;
        }

        // Lấy tên tham số từ pattern
        preg_match_all('/\{([a-zA-Z_]+)\}/', $pattern, $paramNames);
        array_shift($matches); // loại bỏ full match

        $params = [];
        foreach ($paramNames[1] as $i => $name) {
            $params[$name] = $matches[$i] ?? null;
        }
        return $params;
    }

    // -------------------------------------------------------------------------
    // Kiểm tra route có thuộc admin hay không
    // -------------------------------------------------------------------------
    private function isAdminRoute(string $pattern): bool {
        return str_starts_with($pattern, '/admin');
    }

    // -------------------------------------------------------------------------
    // Phân phối request đến controller/action phù hợp
    // -------------------------------------------------------------------------
    public function dispatch(): void {
        $method = strtoupper($_SERVER['REQUEST_METHOD'] ?? 'GET');
        $uri    = $this->normalizeUri();

        foreach ($this->routes as [$routeMethod, $pattern, $controllerClass, $action]) {
            // Kiểm tra phương thức HTTP
            if ($routeMethod !== $method) {
                continue;
            }

            // Khớp URI
            $params = $this->matchPattern($pattern, $uri);
            if ($params === false) {
                continue;
            }

            // --- Kiểm tra quyền admin ---
            if ($this->isAdminRoute($pattern)) {
                if (!isset($_SESSION['user_role']) || $_SESSION['user_role'] !== 'admin') {
                    $this->redirectTo('/auth/login');
                    return;
                }
            }

            // --- CSRF: mọi request ghi dữ liệu đều phải có token hợp lệ ---
            if ($method === 'POST' && !Csrf::verify()) {
                $this->renderError(419, 'Phiên làm việc đã hết hạn. Vui lòng tải lại trang và thử lại.');
                return;
            }

            // --- Tham số id phải là số nguyên dương ---
            if (isset($params['id'])) {
                if (!ctype_digit((string) $params['id'])) {
                    $this->render404("Trang '{$uri}' không tồn tại.");
                    return;
                }
                $params['id'] = (int) $params['id'];
            }

            // Khởi tạo controller và gọi action
            if (!class_exists($controllerClass)) {
                $this->render404("Controller '{$controllerClass}' không tồn tại.");
                return;
            }

            $controller = new $controllerClass();

            if (!method_exists($controller, $action)) {
                $this->render404("Action '{$action}' không tồn tại trong '{$controllerClass}'.");
                return;
            }

            // Truyền tham số động vào action
            call_user_func_array([$controller, $action], $params);
            return;
        }

        // Không khớp bất kỳ route nào
        $this->render404("Trang '{$uri}' không tồn tại.");
    }

    // -------------------------------------------------------------------------
    // Redirect nội bộ (dùng base path)
    // -------------------------------------------------------------------------
    private function redirectTo(string $path): void {
        $base = $this->getBasePath();
        header('Location: ' . $base . $path);
        exit;
    }

    // -------------------------------------------------------------------------
    // Hiển thị trang lỗi chung (419...)
    // -------------------------------------------------------------------------
    private function renderError(int $code, string $message): void {
        http_response_code($code);
        if (($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '') === 'XMLHttpRequest'
            || str_contains($_SERVER['HTTP_ACCEPT'] ?? '', 'application/json')) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(['success' => false, 'message' => $message], JSON_UNESCAPED_UNICODE);
            exit;
        }
        $errorCode = $code;
        $errorMessage = $message;
        require VIEW_PATH . '/errors/error.php';
        exit;
    }

    // -------------------------------------------------------------------------
    // Hiển thị trang 404
    // -------------------------------------------------------------------------
    private function render404(string $message = 'Không tìm thấy trang.'): void {
        http_response_code(404);
        $viewFile = defined('VIEW_PATH') ? VIEW_PATH . '/errors/404.php' : null;
        if ($viewFile && file_exists($viewFile)) {
            $errorMessage = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
            require $viewFile;
        } else {
            echo "<h1>404 — Không tìm thấy trang</h1><p>" 
                 . htmlspecialchars($message, ENT_QUOTES, 'UTF-8') . "</p>";
        }
        exit;
    }
}
