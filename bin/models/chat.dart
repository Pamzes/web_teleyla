// import 'package:uuid/uuid.dart';
// class Chat {
//   final String id;
//   final String title;
//   final String creater;
//   final int? status;
  

//   Chat({
//     required this.id,
//     required this.title,
//     required this.creater,
    
//     required this.status,
//   });

//   factory Chat.fromJson(
//     Map<String, dynamic> json,
//     String sender,
//     String id,
//     String name,
//   ) => _chatFromJson(json, sender, id, name);

//   Map<String, dynamic> toJson() => _$ChatToJson(this);

//   static const jsonSchema = _$ChatJsonSchema;

//   factory Chat.fromRow(Map<String, dynamic> row) {
//     return Chat(
//       id: row['chat_id'] as String,
//       title: row['chat_name'] as String,
//       creater: row['created_by'] as String,
//       status: row['status'] as int,
//     );
//   }

//   Future<String> generateId() async {
//     final id = Uuid().v6();
//     return id;
//   }
// }