
//initialisierung von felder und knöpfe
const messagesList = document.getElementById('messages');
const sendBtn = document.getElementById('send-btn');
const input = document.getElementById('chat-input-bar');


//einbauen von logging für debugging
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
ws.onerror = (error) => logStatus('WebSocket error: ' + error.message);

//nachrichteingang und speicherung in das feld
ws.onmessage = (event) => {
logStatus('recieved: ' + event.data);
            try {
                const msg = JSON.parse(event.data);
                const li = document.createElement('li');
                // verschiedene sender
                const sender = msg.senderId || msg.sender || 'Unknown';
                const text = msg.content || '';
                li.textContent = sender + ': ' + text;
                messagesList.appendChild(li);
                messagesList.scrollTop = messagesList.scrollHeight;
            } catch (e) {
                logStatus('Error: ' + e);
            }
        

}

//nachricht aus dem textfeld "input" verschicken
function sendMessage() {
    const text = chat-input-bar.value.trim();
    logStatus('sendMessage called, text=' + text);
    if (!text) {
        logStatus('Empty message');
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
    logStatus('sending JSON: ' + JSON.stringify(message));
    try {
        ws.send(JSON.stringify(message));
        logStatus('ws.send successfully complened');
    } catch(e) {
        logStatus('Error ws.send: ' + e);
    }
    input.value = '';
}

//erwartet interaktion mit dem knopf
send-btn.addEventListener('click', sendMessage);