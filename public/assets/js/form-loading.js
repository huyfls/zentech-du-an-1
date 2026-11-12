/**
 * Trạng thái "đang gửi" cho mọi form POST: khóa nút gửi để tránh bấm đúp và cho người dùng biết đang xử lý.
 * Form bị chặn bởi trình duyệt (thiếu trường bắt buộc) hoặc bởi onsubmit (hộp xác nhận) sẽ không bị khóa.
 */
document.addEventListener('submit', e => {
    if (e.defaultPrevented) return;
    const form = e.target;
    if (!form.matches('form[method="POST" i], form[method="post"]')) return;
    const btn = e.submitter || form.querySelector('button[type="submit"]');
    if (!btn || btn.disabled) return;
    btn.dataset.label = btn.innerHTML;
    // Khóa sau khi trình duyệt đã gom dữ liệu form, để nút không mất giá trị gửi đi
    setTimeout(() => { btn.disabled = true; btn.setAttribute('aria-busy', 'true'); btn.textContent = 'Đang xử lý…'; }, 0);
});
// Quay lại bằng nút Back (bfcache): trả nút về trạng thái ban đầu
window.addEventListener('pageshow', e => {
    if (!e.persisted) return;
    document.querySelectorAll('button[data-label]').forEach(b => { b.disabled = false; b.removeAttribute('aria-busy'); b.innerHTML = b.dataset.label; });
});
