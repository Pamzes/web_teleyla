import 'dart:io';
import 'dart:convert';
import '../models/message.dart';

class ChatService {
  // Alle Clients sind
  final List<WebSocket> _clients = [];

  // Client hinzufügen
  void addClient(WebSocket ws) {
    _clients.add(ws);
    print('Client connected. ${_clients.length} clients connected');
  }

  // Client entfernen
  void removeClient(WebSocket ws) {
    _clients.remove(ws);
    print('Client disconnected. ${_clients.length} clients connected');
  }

  // Nachricht an alle "verschicken"
  void broadcast(Message message) {
    final jsonString = jsonEncode(message.toJson());
    for (final client in _clients) {
      client.add(jsonString);
    }
  }

  // Bearbeitung einer Nachricht vom CLient
  Future<void> handleMessage(WebSocket sender, String data) async {
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final message = Message.fromJson(json);
      broadcast(message);
      print('Message from ${message.sender}: ${message.content}');
    } catch (e) {
      print('Error: $e');
    }
  }
}
