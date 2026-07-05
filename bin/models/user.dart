//Peter

class User {
  String? id;
  String name;
  String password;
  String email;
  int? status;
  String? totp;

  List<User> friends = List.empty();

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
  });

  factory User.fromRow(Map<String, dynamic> row) {
    return User(
      id: row['user_id'] as String,
      name: row['username'] as String,
      password: row['password'] as String,
      email: (row['email']) as String,
    );
  }
}
