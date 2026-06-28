class User {
  int id;
  String name;
  String password;
  String email;
  int status;

  List<User> friends = List.empty();

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.status,
  });

  factory User.fromRow(Map<String, dynamic> row) {
    return User(
      id: row['userID'] as int,
      name: row['username'] as String,
      password: row['password'] as String,
      email: (row['email']) as String,
      status: (row['currentUserStatus']) as int,
    );
  }
}
