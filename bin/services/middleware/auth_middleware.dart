import 'package:shelf/shelf.dart';
import '../../auth/jwt_service.dart';
Middleware authMiddleware(JwtService jwtService) {
  //Middleware, die JWT Token aus dem Authorization Header extrahiert, verifiziert und die UserId in den Request Context einfügt
  return (Handler innerHandler) {
    //prüft, ob Authorization Header vorhanden ist und mit "Bearer " beginnt, wenn nicht, gibt 403 zurück
    return (Request request) async {
      final authHeader = request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden('Missing token');
      }
      //extrahiert Token aus Header, verifiziert es und fügt UserId in Request Context ein, wenn gültig, ansonsten gibt 403 zurück
      try {
        final token = authHeader.substring(7);
        final payload = jwtService.verify(token);
        final updatedRequest = request.change(context: {
          'userId': payload.payload['sub']
        });
        return innerHandler(updatedRequest);
      } catch (_) {
        return Response.forbidden('Invalid token');
      }
    };
  };
}
 