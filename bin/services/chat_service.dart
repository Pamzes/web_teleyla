import 'dart:io';
import 'dart:convert';
import '../models/message.dart';
import '../db/repository/messages_repository.dart';

class ChatService {
  // Alle Clients sind
  final List<WebSocket> _clients = [];
  final List<String> messages = [];

  final MessageRepository _messageRepo;

  ChatService(this._messageRepo);

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

  // Nachricht kodieren und an alle "verschicken"
  void broadcast(Message message) {
    final jsonString = jsonEncode(message.toJson());
    //print('DEBUG: message $jsonString encoded');
    for (final client in _clients) {
      client.add(jsonString);
    }
    messages.add(message.content);
    //print('DEBUG: message $jsonString sent');
  }

  // Bearbeitung einer Nachricht vom CLient
  Future<void> handleMessage(WebSocket sender, String data) async {
    //print('DEBUG: handleMessage recieved: $data');
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final action = json['action'] as String?;

      final message = Message.fromJson(json);
      print('Message from ${message.sender}: ${message.content}');
      _messageRepo.save(message);
      broadcast(message);
    } catch (e) {
      print('Error: $e');
    }
  }
}
