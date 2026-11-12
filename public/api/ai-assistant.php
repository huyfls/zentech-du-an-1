<?php
/**
 * ZenTech AI Assistant Backend Endpoint
 * Nhận POST { message, history } và trả về { reply }
 * Tích hợp Gemini API với chế độ Smart Fallback thông minh khi offline hoặc chưa cấu hình API key
 */
// Chỉ gọi từ chính website (cùng nguồn), nên không bật CORS cho trang khác.
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method Not Allowed']);
    exit;
}

// Đọc config
$configPath = dirname(__DIR__, 2) . '/config/app.php';
if (file_exists($configPath)) {
    require_once $configPath;
}

// Giới hạn mỗi phiên 15 tin trong 10 phút để không ai đốt hết hạn mức Gemini.
// shortcut: đếm theo phiên, người xóa cookie sẽ qua mặt được; khi đưa lên mạng nên đếm theo IP (Redis hoặc bảng DB).
session_start();
$now  = time();
$hits = array_values(array_filter($_SESSION['ai_hits'] ?? [], fn($t) => $now - $t < 600));
if (count($hits) >= 15) {
    http_response_code(429);
    echo json_encode(['reply' => 'Bạn nhắn hơi nhanh, vui lòng đợi vài phút rồi hỏi tiếp nhé.']);
    exit;
}
$_SESSION['ai_hits'] = array_merge($hits, [$now]);
session_write_close();

$data = json_decode(file_get_contents('php://input'), true);
$message = mb_substr(trim(is_array($data) && is_string($data['message'] ?? null) ? $data['message'] : ''), 0, 500);

if (empty($message)) {
    echo json_encode(['reply' => 'Chào bạn! Mình là ZenBot, trợ lý tư vấn gaming gear của ZenTech. Bạn cần tư vấn sản phẩm nào?']);
    exit;
}

$apiKey = defined('GEMINI_API_KEY') ? GEMINI_API_KEY : '';
$useAiApi = !empty($apiKey) && $apiKey !== 'YOUR_GEMINI_API_KEY_HERE';

// Nếu có API key thật, thử gọi Gemini API
if ($useAiApi) {
    try {
        $systemPrompt = "Bạn là ZenBot - chuyên gia tư vấn Gaming Gear & Phụ kiện máy tính thân thiện tại cửa hàng ZenTech (Việt Nam).
Cửa hàng cung cấp Chuột gaming, Bàn phím cơ, Tai nghe, Lót chuột và Màn hình từ các thương hiệu chính hãng: Logitech, Razer, DareU, HyperX, Corsair, Asus ROG, Akko.
Chính sách: Miễn phí vận chuyển cho đơn từ 500.000đ (dưới mức này phí 30.000đ); bảo hành chính hãng 12 tháng; đổi trả trong 7 ngày nếu sản phẩm có lỗi. Chỉ tư vấn theo thông tin này, không bịa địa chỉ cửa hàng hay số điện thoại.
Hãy tư vấn ngắn gọn, súc tích, nhiệt tình, có icon sinh động và hướng dẫn khách mua hàng tại ZenTech.";

        $url = GEMINI_API_URL;   // khóa gửi qua header, không đặt trong URL (tránh lọt vào log)
        $payload = [
            'contents' => [
                [
                    'parts' => [
                        ['text' => $systemPrompt . "\n\nKhách hàng hỏi: " . $message]
                    ]
                ]
            ],
            'generationConfig' => [
                'temperature' => 0.7,
                'maxOutputTokens' => 300,
            ]
        ];

        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'x-goog-api-key: ' . $apiKey]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode === 200 && $response) {
            $json = json_decode($response, true);
            $aiText = $json['candidates'][0]['content']['parts'][0]['text'] ?? '';
            if (!empty($aiText)) {
                echo json_encode(['reply' => $aiText, 'source' => 'gemini_api']);
                exit;
            }
        }
    } catch (\Throwable $e) {
        // Fallback tiếp tục bên dưới
    }
}

// ── SMART KNOWLEDGE FALLBACK ──────────────────────────────────────────
$msgLower = mb_strtolower($message, 'UTF-8');

if (str_contains($msgLower, 'chuột') || str_contains($msgLower, 'mouse')) {
    $reply = "🖱️ **Gợi ý Chuột Gaming bán chạy nhất tại ZenTech:**\n- **Logitech G Pro X Superlight 2** (1.750.000₫): Siêu nhẹ 60g, cảm biến HERO 2 32K DPI cực nhạy cho game thủ FPS/Esports.\n- **Razer DeathAdder V3 HyperSpeed** (1.490.000₫): Công thái học ôm tay, pin trâu 100 giờ.\n- **DareU EM901X RGB** (799.000₫): Ngon bổ rẻ có kèm dock sạc RGB tiện lợi.\n\n👉 Bạn muốn tìm chuột form đối xứng hay công thái học?";
} elseif (str_contains($msgLower, 'phím') || str_contains($msgLower, 'keyboard') || str_contains($msgLower, 'switch')) {
    $reply = "⌨️ **Gợi ý Bàn phím cơ tại ZenTech:**\n- **DareU EK87 Pro / EK75 RGB**: Gõ êm, switch Dream mượt mà, giá chỉ từ 890.000₫.\n- **Akko 3098B Plus Multi-modes**: Kết nối 3 chế độ (Bluetooth/Wireless 2.4G/Dây), keycap PBT bền bỉ.\n- **Logitech G PRO X TKL Wireless**: Chuẩn thi đấu chuyên nghiệp với công nghệ Lightspeed không độ trễ.\n\n👉 Bạn thích bàn phím kích thước nhỏ gọn TKL (87 phím) hay đầy đủ Fullsize?";
} elseif (str_contains($msgLower, 'tai nghe') || str_contains($msgLower, 'headset') || str_contains($msgLower, 'âm thanh')) {
    $reply = "🎧 **Gợi ý Tai nghe Gaming định vị chuẩn xác:**\n- **HyperX Cloud III Wireless**: Đệm mút êm ái, âm vòm DTS:X Spatial Audio định vị tiếng bước chân cực chuẩn, pin lên tới 120 giờ!\n- **Razer BlackShark V2 Pro**: Micro khử ồn chuẩn streamer, cách âm siêu tốt.\n\n👉 Bạn xem thông số chi tiết ở trang sản phẩm nhé!";
} elseif (str_contains($msgLower, 'bảo hành') || str_contains($msgLower, 'đổi trả') || str_contains($msgLower, 'hỏng')) {
    $reply = "**Bảo hành và đổi trả tại ZenTech:**\n- Bảo hành chính hãng **12 tháng**.\n- Đổi trả trong **7 ngày** nếu sản phẩm có lỗi.";
} elseif (str_contains($msgLower, 'ship') || str_contains($msgLower, 'vận chuyển') || str_contains($msgLower, 'giao hàng') || str_contains($msgLower, 'phí')) {
    $reply = "**Giao hàng tại ZenTech:**\n- Miễn phí vận chuyển cho đơn từ **500.000₫**.\n- Đơn dưới mức này tính phí **30.000₫**.\n- Thanh toán khi nhận hàng, chuyển khoản hoặc MoMo.";
} elseif (str_contains($msgLower, 'chào') || str_contains($msgLower, 'hi') || str_contains($msgLower, 'hello')) {
    $reply = "Dạ chào bạn! 👋 Mình là ZenBot - Trợ lý công nghệ của ZenTech. Bạn đang cần tìm phụ kiện hoặc linh kiện gear nào (Chuột, Bàn phím cơ, Tai nghe, Lót chuột) để mình tư vấn cấu hình phù hợp nhất nhé!";
} else {
    $reply = "Mình có thể tư vấn chuột, bàn phím cơ và tai nghe theo ngân sách và nhu cầu của bạn. Bạn thường chơi game gì và muốn chi khoảng bao nhiêu?";
}

echo json_encode([
    'reply' => $reply,
    'source' => 'smart_fallback'
]);
