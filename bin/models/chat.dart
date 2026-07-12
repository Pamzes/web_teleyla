import 'package:uuid/uuid.dart';

part 'chat.g.dart';

class Chat {
  final String id;
  final String title;
  final String creater;
  // final int? status;

  Chat({
    required this.id,
    required this.title,
    required this.creater,
    //   required this.status,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  /// Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  factory Chat.fromRow(Map<String, dynamic> row) {
    return Chat(
      id: row['chat_id'] as String,
      title: row['chat_name'] as String,
      creater: row['created_by'] as String,
      //   status: row['status'] as int,
    );
  }

  Future<String> generateId() async {
    final id = Uuid().v6();
    return id;
  }
}
