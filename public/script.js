
const messagesList = document.getElementById('messages');
const sendBtn = document.getElementById('sendBtn');
const input = document.getElementById('input');



const statusEl = document.getElementById('wsStatus');
function logStatus(msg) {
    statusEl.textContent += msg + '\n';
    console.log(msg);
}

    const serverHost = window.location.hostname;
    const serverPort = window.location.port || '3000';
    const wsUrl = `ws://${serverHost}:${serverPort}/ws`;
    logStatus('Подключаюсь к ' + wsUrl);

    const ws = new WebSocket(wsUrl);


ws.onopen = () => logStatus('WebSocket открыт');
ws.onclose = (event) => logStatus('WebSocket закрыт (код: ' + event.code + ')');
ws.onerror = (error) => logStatus('WebSocket ошибка: ' + error.message);

ws.onmessage = (event) => {
logStatus('Получено: ' + event.data);
            try {
                const msg = JSON.parse(event.data);
                const li = document.createElement('li');
                // Используем senderId или sender (в зависимости от сервера)
                const sender = msg.senderId || msg.sender || 'Аноним';
                const text = msg.content || '';
                li.textContent = sender + ': ' + text;
                messagesList.appendChild(li);
                messagesList.scrollTop = messagesList.scrollHeight;
            } catch (e) {
                logStatus('Ошибка разбора: ' + e);
            }
        

}


function sendMessage() {
    const text = input.value.trim();
    logStatus('sendMessage вызвана, text=' + text);
    if (!text) {
        logStatus('Пустое сообщение, выход');
        return;
    }
    const message = {
    chatID: 12,     
    messageID: 1,   
    sender: 1,  
    recipient : 2,  
    status: 1,
    content: text,
    timestamp: new Date().toISOString()
    };
    logStatus('Отправляю JSON: ' + JSON.stringify(message));
    try {
        ws.send(JSON.stringify(message));
        logStatus('ws.send выполнен успешно');
    } catch(e) {
        logStatus('ОШИБКА ws.send: ' + e);
    }
    input.value = '';
}

sendBtn.addEventListener('click', sendMessage);