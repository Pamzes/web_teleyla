//Peter
import 'dart:io';
import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../models/message_v2.dart';
import '../db/repository/messages_repository.dart';
import '../db/repository/users_repository.dart';
import '../db/repository/chats_repository.dart';

class ChatService {
  // Alle Clients sind
  final List<WebSocket> _clients = [];
  final List<String> messages = [];
  final Map<WebSocket, String> userIds = {};
  final Map<WebSocket, String> _currentRooms = {};

  final UserRepository _userRepo;
  final MessageRepository _messageRepo;
  final ChatsRepository _chatsRepo;

  ChatService(this._userRepo, this._messageRepo, this._chatsRepo);

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
      //  print('DEBUG: message Mapfrom created');
      if (json.containsKey('action')) {
        await handleCommand(sender, json);
        return;
      }
      //      final userId = (sender);
      //      print('DEBUG: userId from socket: $userId');
      final user = await _userRepo.findByID(getUserId(sender));
      if (user == null) {
        print("user not found");
        return;
      }
      final messageId = Uuid().v4();
      final senderName = user.name;
      final message = Message.fromJson(json, user.id, messageId, senderName);

      //    print('DEBUG: user found: ${user.name}');
      //  print('DEBUG: message instance from ${user.name} created');

      print('Message from ${user.name}: ${message.content}');
      _messageRepo.save(message);
      broadcast(message);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> handleCommand(
    WebSocket sender,
    Map<String, dynamic> json,
  ) async {
    final action = json['action'] as String;
    final data = json['data'] as Map<String, dynamic>? ?? {};

    switch (action) {
      case 'list':
        final list = await _chatsRepo.showChats();
        for (int i = 0; i < list.length; i++) {
          final jsonOut = list[i].toJson();
          sender.add(jsonOut);
        }

      case 'join':
        final userId = getUserId(sender);
        if (userId == null) {
          return;
        }
        _currentRooms[sender] = data['chatId'] as String;
        _chatsRepo.joinChat(userId, data['chatId']);

      case 'leave':
        final userId = getUserId(sender);
        if (userId == null) {
          return;
        }
        _currentRooms.remove(sender);
        _chatsRepo.removeMember(userId, data['chatId']);
    }
  }
}
