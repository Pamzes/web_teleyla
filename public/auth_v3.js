//verbesserung für auth.js, websocket durch http anfragen an die endpoints ersetzt, noch nicht reibungslos
//Peter, mithilfe von KI da JavaScript

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

//verbindung von client zu server durch websockets
    const serverHost = window.location.hostname;
    const serverPort = window.location.port || '3000';
    const wsUrl = `ws://${serverHost}:${serverPort}/ws`;
    logStatus('Connecting to ' + wsUrl);

    const ws = new WebSocket(wsUrl);

//verbindung aktiv
ws.onopen = () => logStatus('WebSocket opened');

//verbindung geschlossen aufgrund...
ws.onclose = (event) => logStatus('WebSocket closed (code: ' + event.code + ')');

//fehlermeldung
ws.onerror = (error) => logStatus('WebSocket error');



async function signUpUser()  {
   
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

        const data = await response.json();
        if (!response.ok) {
            logStatus('Registration failed: ' + (data.message || data.error || response.status));
            return;
        }


        const token = data.access_token;
        logStatus('Registration successful! Token: ' + token);

     
        localStorage.setItem('jwt', token);

      
        window.location.href = '/chat.html'; 
    } catch (e) {
        logStatus('Network error: ' + e);
    }

    try {
        ws.send(JSON.stringify(message));
        logStatus('Sign up request sent');
    } catch (e) {
        logStatus('Send error: ' + e);
    }
}

async function signInUser() {
    
    const email = sife.value.trim();
    const password = sifp.value.trim();

    if (!email || !password) {
        logStatus('Error: Missing fields');
        return;
    }

    try {
        const response = await fetch('/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();
        if (!response.ok) {
            logStatus('Registration failed: ' + (data.message || data.error || response.status));
            return;
        }
                const token = data.access_token;
        logStatus('Registration successful! Token: ' + token);


        localStorage.setItem('jwt', token);

        window.location.href = '/chat.html'; 
    } catch (e) {
        logStatus('Network error: ' + e);
    }

    try {
        ws.send(JSON.stringify(message));
        logStatus('Sign up request sent');
    } catch (e) {
        logStatus('Send error: ' + e);
    }
}



//erwartet interaktion mit dem knopf
bsu.addEventListener('click', signUpUser);
bsi.addEventListener('click', signInUser);

