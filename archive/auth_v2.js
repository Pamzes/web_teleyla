const sendBtn = document.getElementById('sendBtn');
const usernameInput = document.getElementById('text');    // переименовал, чтобы не конфликтовать
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');

// Логирование
const statusEl = document.getElementById('wsStatus');
function logStatus(msg) {
    statusEl.textContent += msg + '\n';
    console.log(msg);
}

// Проверка, что элементы найдены
if (!sendBtn || !usernameInput || !emailInput || !passwordInput) {
    logStatus('ОШИБКА: не все элементы найдены!');
    throw new Error('Missing DOM elements');
}

// WebSocket-подключение
const serverHost = window.location.hostname;
const serverPort = window.location.port || '3000';
const wsUrl = `ws://${serverHost}:${serverPort}/ws`;
logStatus('Connecting to ' + wsUrl);

const ws = new WebSocket(wsUrl);

ws.onopen = () => logStatus('WebSocket opened');
ws.onclose = (event) => logStatus('WebSocket closed (code: ' + event.code + ')');
ws.onerror = () => logStatus('WebSocket error');
ws.onmessage = (event) => logStatus('Received: ' + event.data);

// Функция регистрации
function signUpUser() {
    // Используем разные имена, чтобы избежать конфликта с глобальными ссылками
    const username = usernameInput.value.trim();
    const email = emailInput.value.trim();
    const password = passwordInput.value.trim();

    logStatus('Signing up: username=' + username + ', email=' + email);

    if (!username || !email || !password) {
        logStatus('Error: Missing fields');
        return;
    }

    const message = {
        action: 'sign_up',
        data: {
            username: username,
            email: email,
            password: password
        }
    };

    try {
        ws.send(JSON.stringify(message));
        logStatus('Sign up request sent');
    } catch (e) {
        logStatus('Send error: ' + e);
    }
}

// Назначаем обработчик без скобок!
sendBtn.addEventListener('click', signUpUser);

logStatus('Registration script ready');