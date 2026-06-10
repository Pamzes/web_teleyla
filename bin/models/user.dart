class User {
  int id;
  String name;
  String password;
  String email;

  List<User> friends = List.empty();

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
  });
}
