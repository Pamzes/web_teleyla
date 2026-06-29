//Max

import 'package:bcrypt/bcrypt.dart';

class PasswordService {
  //erstellt ein Hash aus Passwort und generiertem Salt
  String hash(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  //vergleicht Passwort mit Hash und gibt true zurück, wenn Passwort korrekt ist
  bool verify(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }
}
