// import 'package:postgres/postgres.dart';

// class DatabaseService  {

 
//   final Connection connection 


 
// connection = await Connection.open(
//     Endpoint(
//       host: 'localhost',
//       port: 5432,
//       database: 'db_teleyla',
//       username: 'postgres',
//       password: '12345678',
//     ),
//   );
 
 
//  Future<void> insertUser(String name, String email) async {
//     try {
//       await connection.execute (
//         'INSERT INTO users (name, email) VALUES (@name, @email)',
//         parameters: {'name': name, 'email': email},
//       );
//       print('User added successfully.');
//     } catch (e) {
//       print('Error inserting user: $e');
//     }
//   }




// }
