//die Datei für kommunikation mit dem datenbank
//ermöglicht finden, speichern und löschen von nachrichten im datenbank
//Peter, code selber geschrieben

import 'package:postgres/postgres.dart';
import '../../models/message.dart';

class MessageRepository {
  final Connection connection;

  MessageRepository(this.connection);

  // neue nachricht speichern
  Future<void> save(Message message) async {
    try {
      await connection.execute(
        Sql.named(
          'INSERT INTO messages (chat_id, message_id, sender_id, recipient_id, message_content, datetime) VALUES (@chatID, @messageID, @senderID, @recipientID, @content, @datetime)',
        ),
        parameters: {
          'chatID': message.chatID,
          'messageID': message.messageID,
          'senderID': message.sender,
          'recipientID': message.recipient,
          'content': message.content,
          'datetime': message.timestamp.toIso8601String(),
        },
      );
      print('DEBUG: message saved successfully');
    } catch (e) {
      print('ERROR saving message: $e');
    }
  }

  //nachricht finden
  Future<Message> findByID(String id) async {
    final result = await connection.execute(
      'SELECT * FROM messages WHERE message_id = @id',
      parameters: {id: id},
    );
    return Message.fromRow(result.first.toColumnMap());
  }

  //methode um Nachricht zu löschen
  Future<void> deleteMessageByID(String id) async {
    await connection.execute(
      'DELETE FROM messages WHERE message_id = @id',
      parameters: {'id': id},
    );
  }

  //methode um geschichte des chats aufzurufen
  Future<List<Message>> getHistory(String chatID) async {
    int limit = 50;
    <String, dynamic>{'limit': limit};

    final result = await connection.execute(
      'SELECT * FROM messages WHERE chat_id = @chatID',
      parameters: {chatID: chatID},
    );
    //Gibt Nachrichtenliste zurück
    return result
        .map((row) => Message.fromRow(row.toColumnMap()))
        .toList()
        .reversed //chronologische reihenfolge
        .toList();
  }
}
