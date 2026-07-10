import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'message_v2.g.dart';

@JsonSerializable(createJsonSchema: true)
class Message {
  final String chatID;
  final String messageID;
  final String senderID;
  final int? status;
  final String content;
  final DateTime timestamp;

  Message({
    required this.chatID,
    required this.messageID,
    required this.senderID,
    required this.content,
    required this.timestamp,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _messageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static const jsonSchema = _$MessageJsonSchema;

  factory Message.fromRow(Map<String, dynamic> row) {
    return Message(
      chatID: row['chat_id'] as String,
      messageID: row['message_id'] as String,
      senderID: row['sender_id'],
      content: row['message_content'] as String,
      timestamp: (row['datetime'] as DateTime).toLocal(),
      status: row['status'] as int,
    );
  }

  Future<String> generateId() async {
    final id = Uuid().v6();
    return id;
  }
}
