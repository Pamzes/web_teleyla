import 'package:uuid/uuid.dart';

import '../models/user.dart';
import '../db/repositories/users_repository.dart';
import 'jwt_service.dart';
import 'password_service.dart';

class AuthService {
  final UserRepository repo;
  final PasswordService passwordService;
  final JwtService jwtService;

  AuthService(this.repo, this.passwordService, this.jwtService);

  Future<String> register({
    required String email,
    required String username,
    required String password
  }) async {
    //prüft, ob User mit der Email bereits existiert, wenn ja, wirft Exception
    final existing = await repo.findByEmail(email);

    if (existing != null) {
      throw Exception('User already exists');
    }

    //erstellt neuen User mit generierter Id, Email, Username und gehashtem Passwort und speichert ihn im Repository
    final user = User(
      id: const Uuid().v4(), email: email, name: username, password: passwordService.hash(password));
    await repo.create(user);
    //generiert JWT Token für den neuen User und gibt ihn zurück
    return jwtService.generateToken(user.id);
  }

  Future<String> login({
    required String email,
    required String password
  }) async {

    //sucht User mit der Email im Repository
    final user = await repo.findByEmail(email);

    if (user == null) {
      throw Exception('Invalid credentials');
    }

    //vergleicht Passwort mit dem gespeicherten Hash, wenn falsch, wirft Exception
    final valid = passwordService.verify(password, user.passwordHash);

    if (!valid) {
      throw Exception('Invalid credentials');
    }

    //generiert JWT Token für den User und gibt ihn zurück
    return jwtService.generateToken(user.id);
  }
}
