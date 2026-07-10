import 'dart:io';
import 'dart:convert';
import '../models/message_v2.dart';
import '../db/repository/messages_repository.dart';
import '../db/repository/users_repository.dart';

class ChatService {
  // Alle Clients sind
  final List<WebSocket> _clients = [];
  final List<String> messages = [];
  final Map<WebSocket, String> userIds = {};
  final Map<WebSocket, String> _currentRooms = {};

  final UserRepository _userRepo;
  final MessageRepository _messageRepo;

  ChatService(this._userRepo, this._messageRepo);

  String? getUserId(WebSocket ws) {
    return userIds[ws];
  }

  // Client hinzufügen
  void addClient(WebSocket ws, String userId) {
    _clients.add(ws);
    userIds[ws] = userId;
    print('User $userId connected. Total clients: ${_clients.length}');
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
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;

      // if (json.containsKey('action')) {
      //   await handleCommand(sender, json);
      //   return;
      // }

      final message = Message.fromJson(json);
      final user = await _userRepo.findByID(getUserId(sender));
      if (user == null) {
        return;
      }
      print('Message from ${user.name}: ${message.content}');
      _messageRepo.save(message);
      broadcast(message);
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> handleCommand(
  //   WebSocket sender,
  //   Map<String, dynamic> json,
  // ) async {
  //   final action = json['action'] as String;
  //   final data = json['data'] as Map<String, dynamic>? ?? {};

  //   switch (action) {
  //     case 'sign_up':
  //       await signUp(sender, data);
  //   }
  // }
  // Future<void> signUp(WebSocket sender, Map<String, dynamic> data) async {

  // }
}
