// import 'package:postgres/postgres.dart';
// import 'package:uuid/uuid.dart';
// import '../../models/user.dart';

// class ChatsRepository {
//   final Connection connection;
//   ChatsRepository(this.connection);

//   Future<void> createChat(String title, User user) async {
//     try {
//       await connection.execute(
//         'INSERT INTO chats (id, chat_name, created_by, status) VALUES (@chatID, @title, @creator, @status)',
//         parameters: {
//           'chatID': const Uuid().v4(),
//           'title': title,
//           'creator': user.id,
//           'status': 1,
//         },
//       );
//     } catch (e) {
//       print('Error. Insert failed $e');
//     }
//   }

//   // Future<void> joinChat() async {
//   //   try{
//   //     await connection.execute('INSERT INTO chats ()')
//   //   }
//   // }

//   Future<List<String>> showChats() async {
//     try {

//       final result = await connection.execute(
//         'SELECT DISTINCT chat_name FROM chats',
//       );
//       return result.toList()
//           } catch (e) {
//       print('Error: $e');
//     }
//   }
// }
