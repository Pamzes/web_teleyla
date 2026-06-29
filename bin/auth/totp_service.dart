//Max

import 'package:otp/otp.dart';

class TotpService {
  //generiert ein zufälliges Secret für TOTP
  String generateSecret() {
    return OTP.randomSecret();
  }

  //verifiziert das TOTP Passwort
  bool verify(String code, String secret) {
    //generiert das aktuelle TOTP Passwort basierend auf dem Secret und vergleicht es mit dem übergebenen Code
    final current = OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 30,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
    return current == code;
  }
}
