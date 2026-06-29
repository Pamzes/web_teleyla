//die Datei für kommunikation mit dem datenbank
//ermöglicht finden, erstellen und löschen von nutzer

import 'package:postgres/postgres.dart';
import '../../models/user.dart';

class UserRepository {
  final Connection connection;

  UserRepository(this.connection);

  // methode um nutzer mithilfe username zu finden
  Future<User?> findByUsername(String username) async {
    final result = await connection.execute(
      'SELECT * FROM users WHERE username = @username',
      parameters: {'username': username},
    );
    if (result.isEmpty) return null;
    //ergebnis wird als feld zurückgegeben
    return User.fromRow(result.first.toColumnMap());
  }

  Future<User?> findByEmail(String email) async {
    final result = await connection.execute(
      'SELECT * FROM users WHERE email = @email',
      parameters: {'email': email},
    );
    if (result.isEmpty) return null;
    //ergebnis wird als feld zurückgegeben
    return User.fromRow(result.first.toColumnMap());
  }

  // methode um nutzer mithilfe id zu finden
  Future<User?> findByID(int id) async {
    final result = await connection.execute(
      'SELECT FROM users WHERE user_id = @id',
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    //ergebnis wird als feld zurückgegeben
    return User.fromRow(result.first.toColumnMap());
  }

  // Neuen Nutzer erstellen durch sql befehl
  Future<User> create(
    int id,
    String username,
    String password,
    String email,
  ) async {
    final result = await connection.execute(
      'INSERT INTO users (user_id, username, password, email) VALUES (@id, @username, @password, @email) RETURNING *',
      parameters: {
        'id': id,
        'username': username,
        'password': password,
        'email': email,
      },
    );
    //ergebnis wird als feld zurückgegeben
    return User.fromRow(result.first.toColumnMap());
  }

  //dem nutzer status setzen
  Future<User?> setStatusByID(int status, int id) async {
    final result = await connection.execute(
      'UPDATE users SET user_status = @status WHERE user_id = @id RETURNING *',
      parameters: {'status': status, 'id': id},
    );
    return User.fromRow(result.first.toColumnMap());
  }

  // den nutzer loeschen
  Future<void> removeUserByID(int id) async {
    await connection.execute(
      'DELETE FROM users WHERE user_id = @id',
      parameters: {'id': id},
    );
  }
}
