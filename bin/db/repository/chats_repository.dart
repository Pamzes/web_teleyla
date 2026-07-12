//Peter

//Datei zur interaktion mit tabellen von chats
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';
import '../../models/user.dart';
import '../../models/chat.dart';

class ChatsRepository {
  final Connection connection;
  ChatsRepository(this.connection);

  Future<void> createChat(String title, User user) async {
    try {
      final id = Uuid().v4();
      await connection.execute(
        'INSERT INTO chats (id, chat_name, created_by) VALUES (@chatID, @title, @creator)',
        parameters: {'chatID': id, 'title': title, 'creator': user.id},
      );
      await joinChat(user.id, id);
    } catch (e) {
      print('Error creating chat: $e');
      rethrow;
    }
  }

  Future<List<Chat>> showChats() async {
    final result = await connection.execute('SELECT * FROM chats');

    return result.map((row) => Chat.fromRow(row.toColumnMap())).toList();
  }

  Future<void> joinChat(String userId, String chatId) async {
    await connection.execute(
      'INSERT INTO chat_members (chat_id, member_id) VALUES (@chat, @user) ON CONFLICT DO NOTHING',
      parameters: {'chat': chatId, 'user': userId},
    );
  }

  Future<void> removeMember(String userId, String chatId) async {
    await connection.execute(
      'DELETE FROM chat_members WHERE chat_id = @chat AND member_id = @user',
      parameters: {'chat': chatId, 'user': userId},
    );
  }

  Future<List<User>> membersList(String chatId) async {
    final result = await connection.execute(
      'SELECT u.user_id, u.username, u.email FROM users u '
      'JOIN chat_members cm ON u.user_id = cm.member_id '
      'WHERE cm.chat_id = @chat',
      parameters: {'chat': chatId},
    );
    return result.map((row) => User.fromRow(row.toColumnMap())).toList();
  }
}
