//erste version von authentification scriot für den client, ermöglicht anmeldedaten an den server verschicken
//geschrieben von Max, mithilfe von KI da JavaScript, verbessert vom Peter



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



function signUpUser() {
   
    const username = f_username.value.trim();
    const email = sufe.value.trim();
    const password = sufp.value.trim();

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

function signInUser() {
    
    const email = sife.value.trim();
    const password = sifp.value.trim();

    logStatus('Signing in: email = ' + email);

    if (!email || !password) {
        logStatus('Error: Missing fields');
        return;
    }

    const message = {
        action: 'sign_in',
        data: {
            email: email,
            password: password
        }
    };

    try {
        ws.send(JSON.stringify(message));
        logStatus('Sign in request sent');
    } catch (e) {
        logStatus('Send error: ' + e);
    }
}



//erwartet interaktion mit dem knopf
bsu.addEventListener('click', signUpUser);
bsi.addEventListener('click', signInUser);

