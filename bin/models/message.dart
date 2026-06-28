import 'package:json_annotation/json_annotation.dart';

//import 'user.dart';
//vielleicht brauchen wir das später

part 'message.g.dart';

@JsonSerializable(createJsonSchema: true)
class Message {
  final int chatID;
  final int messageID;
  final int sender;
  final int recipient;
  final int? status;
  final String content;
  final DateTime timestamp;

  Message({
    required this.chatID,
    required this.messageID,
    required this.sender,
    required this.recipient,
    required this.content,
    required this.timestamp,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _messageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static const jsonSchema = _$MessageJsonSchema;

  factory Message.fromRow(Map<String, dynamic> row) {
    return Message(
      chatID: row['chat_id'] as int,
      messageID: row['message_id'] as int,
      sender: row['sender_id'] as int,
      recipient: row['recipient_id'] as int,
      content: row['message_content'] as String,
      timestamp: (row['datetime'] as DateTime).toLocal(),
      status: row['status'] as int,
    );
  }
}
