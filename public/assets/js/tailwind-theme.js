/**
 * ZenTech — Tailwind theme (nạp sau tailwind CDN).
 * Hướng: phòng trưng bày sáng (tham chiếu Apple Store / Nothing).
 * Thang xám `zinc` được ĐẢO: 950 là nền trang (trắng), 50 là mực gần đen,
 * nên các class kiểu bg-zinc-900 / text-zinc-400 tự thành "bề mặt" / "chữ phụ" trên nền sáng.
 * `white` trỏ về mực, vì text-white trong view cũ nghĩa là "chữ chính".
 * `on` = chữ trắng trên nền màu (nút xanh, nhãn đỏ).
 */
tailwind.config = {
    theme: {
        extend: {
            fontFamily: {
                sans:    ['"Be Vietnam Pro"', 'system-ui', '-apple-system', 'sans-serif'],
                display: ['"Be Vietnam Pro"', 'system-ui', '-apple-system', 'sans-serif'],
                mono:    ['"Be Vietnam Pro"', 'system-ui', 'sans-serif'],
            },
            colors: {
                white: '#1d1d1f',
                on: '#ffffff',
                zinc: {
                    50: '#111113', 100: '#1d1d1f', 200: '#2c2c2e', 300: '#424245',
                    400: '#6e6e73', 500: '#737378', 600: '#b0b0b8', 700: '#d2d2d7',
                    750: '#dcdce1', 800: '#e8e8ed', 850: '#efeff2', 900: '#f5f5f7', 950: '#ffffff',
                },
                accent: {
                    50: '#eef4ff', 100: '#dce9ff', 200: '#b9d3ff', 300: '#3b82f6',
                    400: '#1a5fd0', 500: '#0f5de0', 600: '#0b4fc2', 700: '#0a3f9c',
                    800: '#0b327a', 900: '#0c2a63', 950: '#071a40',
                },
                ember: {
                    300: '#f5c451', 400: '#e8a100', 500: '#d18b00', 600: '#b07300',
                    700: '#8a5a00', 800: '#6b4600', 900: '#4f3400',
                },
                red:     { 400: '#d92d20', 500: '#c9261b', 600: '#b42318' },
                green:   { 400: '#097a3c', 500: '#0b8a45', 600: '#086a34' },
                emerald: { 400: '#097a3c', 500: '#0b8a45', 600: '#086a34' },
                amber:   { 400: '#b45309', 500: '#b45309' },
                yellow:  { 400: '#a16207' },
                rose:    { 400: '#d92d20', 500: '#c9261b' },
            },
            borderRadius: { xl: '0.75rem', '2xl': '1rem', '3xl': '1.5rem' },
            animation: { 'fade-in': 'fadeIn 0.25s ease-out', 'slide-down': 'slideDown 0.3s ease-out' },
            keyframes: {
                fadeIn:    { '0%': { opacity: 0 }, '100%': { opacity: 1 } },
                slideDown: { '0%': { transform: 'translateY(-8px)', opacity: 0 }, '100%': { transform: 'translateY(0)', opacity: 1 } },
            },
        },
    },
};
