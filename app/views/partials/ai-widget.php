<!-- ================================================================
     AI TECH ASSISTANT WIDGET – ZenBot (Glassmorphism & Neon Glow)
     ================================================================ -->
<div id="zenbot-widget-container" class="fixed bottom-6 right-6 z-50 select-none">
    
    <!-- 1. POPUP CHAT WINDOW (Initially hidden) -->
    <div id="zenbot-chat-window" 
         class="hidden flex-col w-[380px] sm:w-[400px] h-[520px] max-h-[85vh] bg-zinc-900/95 backdrop-blur-2xl border border-accent-500/30 rounded-3xl  overflow-hidden mb-4 transition-all duration-300 animate-fade-in">
        
        <!-- Header -->
        <div class="px-5 py-4 bg-gradient-to-r from-zinc-900 via-zinc-800 to-zinc-900 border-b border-zinc-800 flex items-center justify-between shrink-0">
            <div class="flex items-center gap-3">
                <div class="relative">
                    <div class="w-10 h-10 rounded-2xl bg-accent-500 flex items-center justify-center text-on text-lg shadow-md ">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 8V4m-6 8h12a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2zm3 3h.01M15 15h.01"/></svg>
                    </div>
                    <span class="absolute -bottom-0.5 -right-0.5 w-3 h-3 rounded-full bg-green-400 border-2 border-zinc-900 animate-pulse"></span>
                </div>
                <div>
                    <div class="font-bold text-sm text-white flex items-center gap-1.5">
                        <span>ZenBot</span>
                        <span class="text-[10px] font-mono px-1.5 py-0.2 rounded bg-accent-500/20 text-accent-400 border border-accent-500/30">AI PRO</span>
                    </div>
                    <div class="text-[11px] text-zinc-400">Chuyên gia Gear & Setup</div>
                </div>
            </div>

            <!-- Close Button -->
            <button type="button" 
                    onclick="window.ZenBotWidget.toggle()"
                    class="w-8 h-8 rounded-full bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white flex items-center justify-center transition">
                ✕
            </button>
        </div>

        <!-- Messages Area (Scrollable) -->
        <div id="zenbot-messages" class="flex-1 overflow-y-auto p-4 space-y-3 text-xs">
            <!-- Bot Greeting -->
            <div class="flex items-start gap-2.5">
                <div class="w-7 h-7 rounded-lg bg-accent-500/20 text-accent-400 flex items-center justify-center shrink-0 text-sm">
                    
                </div>
                <div class="bg-zinc-800/90 text-zinc-200 border border-zinc-700/60 rounded-2xl rounded-tl-sm p-3.5 max-w-[85%] leading-relaxed">
                    Chào bạn! Tôi là <strong class="text-accent-400">ZenBot</strong>. Bạn cần tư vấn chuột sensor chuẩn thi đấu, bàn phím cơ switch êm hay setup góc máy theo ngân sách nào?
                </div>
            </div>
        </div>

        <!-- Quick Chips (Gợi ý câu hỏi) -->
        <div id="zenbot-quick-chips" class="px-4 py-2 bg-zinc-950/40 border-t border-zinc-800/80 flex items-center gap-1.5 overflow-x-auto text-[11px] shrink-0">
            <button type="button" onclick="window.ZenBotWidget.sendQuick('Tư vấn chuột gaming dưới 1 triệu')" 
                    class="whitespace-nowrap px-2.5 py-1 rounded-full bg-zinc-800 hover:bg-zinc-700 text-zinc-300 hover:text-accent-400 border border-zinc-700/60 transition">
                Chuột dưới 1Tr
            </button>
            <button type="button" onclick="window.ZenBotWidget.sendQuick('Switch bàn phím nào gõ êm nhất?')" 
                    class="whitespace-nowrap px-2.5 py-1 rounded-full bg-zinc-800 hover:bg-zinc-700 text-zinc-300 hover:text-accent-400 border border-zinc-700/60 transition">
                ⌨️ Switch êm nhất
            </button>
            <button type="button" onclick="window.ZenBotWidget.sendQuick('Tai nghe chơi game FPS nghe rõ tiếng chân')" 
                    class="whitespace-nowrap px-2.5 py-1 rounded-full bg-zinc-800 hover:bg-zinc-700 text-zinc-300 hover:text-accent-400 border border-zinc-700/60 transition">
                Tai nghe FPS
            </button>
        </div>

        <!-- Input Box -->
        <form id="zenbot-form" onsubmit="window.ZenBotWidget.handleSubmit(event)" class="p-3 bg-zinc-950/80 border-t border-zinc-800 flex items-center gap-2 shrink-0">
            <input type="text" 
                   id="zenbot-input"
                   placeholder="Hỏi ZenBot về chuột, phím, tai nghe..." 
                   autocomplete="off"
                   class="flex-1 bg-zinc-900 border border-zinc-700 focus:border-accent-400 rounded-xl px-3.5 py-2.5 text-xs text-white outline-none">
            
            <button type="submit" 
                    id="zenbot-send-btn"
                    class="w-9 h-9 rounded-xl bg-accent-500 hover:bg-accent-600 text-on flex items-center justify-center shrink-0 transition shadow-md ">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/>
                </svg>
            </button>
        </form>
    </div>

    <!-- 2. FLOATING TRIGGER BUTTON (Always visible) -->
    <button type="button" 
            id="zenbot-toggle-btn"
            onclick="window.ZenBotWidget.toggle()"
            aria-label="Mở ZenBot AI Assistant"
            class="group relative flex items-center gap-3 p-3.5 rounded-full bg-accent-500 hover:bg-accent-600 text-on  hover:scale-105 transition-all duration-300 hover:">
        <!-- Pulse Glow Ring -->
        <span class="absolute inset-0 rounded-full bg-accent-400 opacity-30 group-hover:animate-ping pointer-events-none"></span>
        
        <!-- Icon -->
        <svg class="w-6 h-6 shrink-0 group-hover:rotate-12 transition-transform duration-300" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 2a2 2 0 012 2c0 .74-.4 1.39-1 1.73V7h1a7 7 0 017 7h1a1 1 0 011 1v3a1 1 0 01-1 1h-1v1a2 2 0 01-2 2H5a2 2 0 01-2-2v-1H2a1 1 0 01-1-1v-3a1 1 0 011-1h1a7 7 0 017-7V5.73A2 2 0 019 4a2 2 0 012-2zM7.5 13a1.5 1.5 0 100 3 1.5 1.5 0 000-3zm9 0a1.5 1.5 0 100 3 1.5 1.5 0 000-3z"/>
        </svg>

        <!-- Badge text (desktop only) -->
        <span class="hidden md:inline font-bold text-xs pr-1">Tư vấn AI</span>
    </button>
</div>

<!-- ================================================================
     ZenBot Client Engine (Fetch API + Local Multi-turn Memory)
     ================================================================ -->
<script>
window.ZenBotWidget = (function() {
    let isOpen = false;
    let history = [];
    const chatWindow = document.getElementById('zenbot-chat-window');
    const messagesBox = document.getElementById('zenbot-messages');
    const inputEl = document.getElementById('zenbot-input');
    const sendBtn = document.getElementById('zenbot-send-btn');

    function toggle() {
        isOpen = !isOpen;
        if (isOpen) {
            chatWindow.classList.remove('hidden');
            chatWindow.classList.add('flex');
            inputEl.focus();
        } else {
            chatWindow.classList.add('hidden');
            chatWindow.classList.remove('flex');
        }
    }

    function appendMessage(role, text) {
        const div = document.createElement('div');
        if (role === 'user') {
            div.className = 'flex justify-end';
            div.innerHTML = `
                <div class="bg-accent-500 text-on rounded-2xl rounded-tr-sm p-3 max-w-[85%] leading-relaxed shadow-sm">
                    ${escapeHtml(text)}
                </div>
            `;
        } else {
            div.className = 'flex items-start gap-2.5';
            div.innerHTML = `
                <div class="w-7 h-7 rounded-lg bg-accent-500/20 text-accent-400 flex items-center justify-center shrink-0 text-sm">
                    ⚡
                </div>
                <div class="bg-zinc-800/90 text-zinc-200 border border-zinc-700/60 rounded-2xl rounded-tl-sm p-3.5 max-w-[85%] leading-relaxed whitespace-pre-wrap">
                    ${formatBotReply(text)}
                </div>
            `;
        }
        messagesBox.appendChild(div);
        messagesBox.scrollTop = messagesBox.scrollHeight;
    }

    function appendTyping() {
        const div = document.createElement('div');
        div.id = 'zenbot-typing';
        div.className = 'flex items-start gap-2.5';
        div.innerHTML = `
            <div class="w-7 h-7 rounded-lg bg-accent-500/20 text-accent-400 flex items-center justify-center shrink-0 text-sm">⚡</div>
            <div class="bg-zinc-800/90 border border-zinc-700/60 rounded-2xl p-3 flex items-center gap-1.5 text-zinc-400">
                <span class="w-1.5 h-1.5 rounded-full bg-accent-400 animate-bounce"></span>
                <span class="w-1.5 h-1.5 rounded-full bg-accent-400 animate-bounce" style="animation-delay: 0.15s"></span>
                <span class="w-1.5 h-1.5 rounded-full bg-accent-400 animate-bounce" style="animation-delay: 0.3s"></span>
            </div>
        `;
        messagesBox.appendChild(div);
        messagesBox.scrollTop = messagesBox.scrollHeight;
    }

    function removeTyping() {
        const el = document.getElementById('zenbot-typing');
        if (el) el.remove();
    }

    async function send(message) {
        if (!message || message.trim() === '') return;
        appendMessage('user', message);
        inputEl.value = '';

        history.push({ role: 'user', content: message });
        appendTyping();

        try {
            // Xác định endpoint API
            const apiUrl = window.location.origin.includes('localhost') 
                ? '/api/ai-assistant.php' 
                : '/api/ai-assistant.php';

            const res = await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: message, history: history })
            });

            removeTyping();

            if (!res.ok) {
                appendMessage('bot', 'ZenBot đang bận xử lý, bạn thử lại sau ít giây nhé! ');
                return;
            }

            const data = await res.json();
            const reply = data.reply || 'Cảm ơn câu hỏi của bạn!';
            appendMessage('bot', reply);
            history.push({ role: 'assistant', content: reply });

        } catch (err) {
            removeTyping();
            appendMessage('bot', 'Lỗi kết nối tới trợ lý AI. Vui lòng kiểm tra lại mạng hoặc thử lại sau! ');
        }
    }

    function handleSubmit(e) {
        e.preventDefault();
        send(inputEl.value);
    }

    function sendQuick(text) {
        send(text);
    }

    function escapeHtml(str) {
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    function formatBotReply(text) {
        // Hỗ trợ in đậm markdown **text**
        let out = escapeHtml(text);
        out = out.replace(/\*\*(.*?)\*\*/g, '<strong class="text-white font-bold">$1</strong>');
        return out;
    }

    return {
        toggle,
        sendQuick,
        handleSubmit,
    };
})();
</script>
