// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _messageFromJson(Map<String, dynamic> json) => Message(
  chatID: json['chatID'] as int,
  messageID: json['messageID'] as int,
  sender: json['sender'] as int,
  recipient: json['recipient'] as int,
  status: json['status'] as int,
  content: json['content'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'chatID': instance.chatID,
  'messageID': instance.messageID,
  'sender': instance.sender,
  'recipient': instance.recipient,
  'status': instance.status,
  'content': instance.content,
  'timestamp': instance.timestamp.toIso8601String(),
};

const _$MessageJsonSchema = {
  r'chatID': r'int',
  r'messageID': r'int',
  r'sender': r'User',
  r'recipient': r'User',
  r'status': r'int',
  r'content': r'String',
  r'timestamp': r'DateTime',
};
