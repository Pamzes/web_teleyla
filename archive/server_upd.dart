// import 'dart:io';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;
// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf_static/shelf_static.dart';
// import '../bin/services/chat_service.dart';
// import 'package:postgres/postgres.dart';
// import '../bin/db/repository/users_repository.dart';
// import '../bin/db/repository/messages_repository.dart';
// import '../bin/auth/auth_service.dart';
// import '../bin/auth/jwt_service.dart';
// import '../bin/auth/password_service.dart';
// import '../bin/services/middleware/auth_middleware.dart';
// import 'dart:convert';

// //die meisten funktionen kommen aus oben importierten packages, was serverprogramm sehr vereinfacht
// //code wurde mithilfe von anleitungen aus packages und KI geschrieben
// //server starten
// void main() async {
//   final settings = ConnectionSettings(sslMode: SslMode.disable);

//   final connection = await Connection.open(
//     Endpoint(
//       host: 'localhost',
//       port: 5432,
//       database: 'db_teleyla',
//       username: 'postgres',
//       password: '12345678',
//     ),
//     settings: settings,
//   );

//   try {
//     // Open the connection
//     await connection.execute('SELECT * FROM users');
//     print('Connected to PostgreSQL successfully!');
//   } catch (e) {
//     print('Failed to connect to PostgreSQL: $e');
//   }

//   final userRepo = UserRepository(connection);
//   final messageRepo = MessageRepository(connection);

//   final chatService = ChatService(userRepo, messageRepo);
//   final authService = AuthService(userRepo, PasswordService(), JwtService());
//   final jwtService = JwtService();

//   // Bearbeitet static, also html
//   final staticHandler = createStaticHandler(
//     'public',
//     defaultDocument: 'index.html',
//   );

//   // Router, der Serverzustand auf die Nachfrage widergibt
//   final router = Router()
//     ..get('/api/health', (Request request) {
//       return Response.ok('Server started on Port 3000');
//     });

//   // Router, der die Authentifizierung behandelt, also Registrierung und Login
//   router.post('/register', (Request request) async {
//     final body = jsonDecode(await request.readAsString());
//     final token = await authService.register(
//       email: body['email'],
//       username: body['username'],
//       password: body['password'],
//     );

//     return Response.ok(
//       jsonEncode({'access_token': token}),
//       headers: {'Content-Type': 'application/json'},
//     );
//   });

//   router.post('/login', (Request request) async {
//     final body = jsonDecode(await request.readAsString());

//     final token = await authService.login(
//       email: body['email'],
//       password: body['password'],
//     );

//     return Response.ok(
//       jsonEncode({'access_token': token}),
//       headers: {'Content-Type': 'application/json'},
//     );
//   });

//   final protectedRouter = Router();

//   //geschützte Route, die nur mit gültigem JWT Token aufgerufen werden kann, gibt UserId zurück
//   protectedRouter.get('/profile', (Request request) {
//     return Response.ok(
//       jsonEncode({'userId': request.context['userId']}),
//       headers: {'Content-Type': 'application/json'},
//     );
//   });

//   //geschützte Route, die nur mit gültigem JWT Token aufgerufen werden kann, gibt alle Nachrichten zurück
//   router.mount(
//     '/api/',
//     const Pipeline()
//         .addMiddleware(logRequests())
//         .addMiddleware(authMiddleware(jwtService))
//         .addHandler(protectedRouter.call),
//   );

//   // Funktion, die Nachfragen in richtige Reihenfolge bearbeitet:
//   // erstens bekommt staticHandler  den Request, danach Router
//   final cascade = Cascade().add(staticHandler).add(router.call);
//   final handler = const Pipeline()
//       .addMiddleware(logRequests())
//       .addHandler(cascade.handler);

//   // Start vom Server, der httpanfragen bearbeitet
//   final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
//   print('Server started on http://localhost:3000');

//   await for (final httpRequest in server) {
//     // Wenn eine Anfrage mit Namen /ws kommt, wird die Verbindung bis Websocket upgradet
//     if (httpRequest.uri.path == '/ws') {
//       // Vergleicht header bei dem Request mit dem "websocket"
//       if (httpRequest.headers.value('upgrade') == 'websocket') {
//         try {
//           final webSocket = await WebSocketTransformer.upgrade(httpRequest);
//           //print('DEBUG: WebSocket upgrade successful');
//           //einfügen von neuem Client in die Liste mit aktiven Clients in chat_service
//           chatService.addClient(webSocket);
//           //nachrichten von neuem CLient werden erwartet
//           webSocket.listen(
//             (data) {
//               if (data is String) {
//                 //print("DEBUG: message recieved");
//                 chatService.handleMessage(webSocket, data);
//               }
//             },
//             //entfernung vom Client aus Liste, wenn er nicht mehr verbunden ist
//             onDone: () => chatService.removeClient(webSocket),
//             onError: (error) {
//               print('WebSocket error: $error');
//               chatService.removeClient(webSocket);
//             },
//           );
//           //fehler wenn upgrade nicht geklappt hat, status 500 bedeutet serverfehler
//         } catch (e) {
//           print('Websocket update error $e');
//           httpRequest.response.statusCode = 500;
//           await httpRequest.response.close();
//         }
//       } else {
//         //fehler, wenn client nicht auf websocket umgeschaltet hat status 400 bedeutet clientfehler
//         httpRequest.response.statusCode = 400;
//         httpRequest.response.writeln('WebSocket upgrade required');
//         await httpRequest.response.close();
//       }
//     } else {
//       // wenn request nicht /ws war, wird der von dieser methode bearbeitet
//       await shelf_io.handleRequest(httpRequest, handler);
//     }
//   }
// }
