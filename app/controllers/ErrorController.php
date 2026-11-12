<?php
/**
 * ErrorController — trang 403 / 404 có thể điều hướng tới.
 */
class ErrorController extends BaseController
{
    public function forbidden(): void
    {
        http_response_code(403);
        $errorCode = 403;
        $errorMessage = 'Bạn không có quyền xem nội dung này.';
        require VIEW_PATH . '/errors/error.php';
    }

    public function notFound(): void
    {
        http_response_code(404);
        $errorCode = 404;
        $errorMessage = 'Nội dung bạn tìm không tồn tại hoặc đã bị gỡ.';
        require VIEW_PATH . '/errors/error.php';
    }
}
