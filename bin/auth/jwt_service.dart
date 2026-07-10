//Max
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtService {
  static const secret = 'SUPER_SECRET_KEY_CHANGE_ME'; //Platzhalter

  //generiert JWT Token mit UserId als Payload
  String generateToken(String userId) {
    final jwt = JWT({'sub': userId, 'type': 'access_token'});
    //signiert Token mit SecretKey und gibt es zurück, mit Ablaufzeit von 1 Stunde
    return jwt.sign(SecretKey(secret), expiresIn: const Duration(hours: 1));
  }

  //verifiziert JWT Token und gibt ihn zurück, wenn gültig
  JWT verify(String token) {
    return JWT.verify(token, SecretKey(secret));
  }

  String extractUserId(String token) {
    final jwt = JWT.verify(token, SecretKey(secret));
    return jwt.payload['sub'] as String;
  }
}
