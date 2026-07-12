part of 'message_v2.dart';

Message _messageFromJson(
  Map<String, dynamic> json,
  String sender,
  String id,
  String name,
) => Message(
  chatID: json['chatID'] as String,
  messageID: id,
  senderID: sender,
  senderName: name,
  status: json['status'] as int,
  content: json['content'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'chatID': instance.chatID,
  'messageID': instance.messageID,
  'sender': instance.senderID,
  'name': instance.senderName,
  'status': instance.status,
  'content': instance.content,
  'timestamp': instance.timestamp.toIso8601String(),
};

const _$MessageJsonSchema = {
  r'chatID': r'int',
  r'messageID': r'int',
  r'sender': r'User',
  r'status': r'int',
  r'content': r'String',
  r'timestamp': r'DateTime',
};
