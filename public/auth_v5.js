const bsu = document.getElementById("button_sign_up");
const bsi = document.getElementById("button_sign_in");
const sufp = document.getElementById("sign_up_field_password");
const sifp = document.getElementById("sign_in_field_password");
const sufe = document.getElementById("sign_up_field_email");
const sife = document.getElementById("sign_in_field_email");
const f_username = document.getElementById("field_username");

const statusEl = document.getElementById('wsStatus');
function logStatus(msg) {
    statusEl.textContent += msg + '\n';
    console.log(msg);
}

async function signUpUser() {
    const username = f_username.value.trim();
    const email = sufe.value.trim();
    const password = sufp.value.trim();

    logStatus('Registering...');
    if (!username || !email || !password) {
        logStatus('Error: Missing fields');
        return;
    }

    try {
        const response = await fetch('/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, email, password })
        });

        if (!response.ok) {
            const errorText = await response.text();
            logStatus('Registration failed: ' + errorText);
            return;
        }

        const data = await response.json();
        const token = data.access_token;
        logStatus('Registration successful! Token: ' + token);

        // Сохраняем токен для последующего использования в чате
        localStorage.setItem('jwt', token);

        // Переходим на страницу чата
        window.location.href = '/chat_v3.html';

    } catch (e) {
        logStatus('Network error: ' + e);
    }
}

async function signInUser() {
    const email = sife.value.trim();
    const password = sifp.value.trim();

    logStatus('Signing in...');
    if (!email || !password) {
        logStatus('Error: Missing fields');
        return;
    }

    try {
        const response = await fetch('/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        if (!response.ok) {
            const errorText = await response.text();
            logStatus('Login failed: ' + errorText);
            return;
        }

        const data = await response.json();
        const token = data.access_token;
        logStatus('Signed in! Token: ' + token);

        localStorage.setItem('jwt', token);
        window.location.href = '/chat_v3.html';

    } catch (e) {
        logStatus('Network error: ' + e);
    }
}

bsu.addEventListener('click', signUpUser);
bsi.addEventListener('click', signInUser);