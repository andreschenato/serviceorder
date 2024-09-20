import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';

abstract class DBConfig {
  Future<dynamic> createConnection();

  Future<dynamic> get connection;
}

class MySqlDBConfiguration implements DBConfig {
  MySQLConnection? _connection;

  @override
  Future<MySQLConnection> get connection async {
    _connection ??= await createConnection();
    _connection ??= throw Exception('[Error/DB] -> Falha ao criar conexão');
    return _connection!;
  }

  @override
  Future<MySQLConnection> createConnection() async {
    await dotenv.load(fileName: ".env");
    return await MySQLConnection.createConnection(
      host: dotenv.env['DB_HOST']!,
      port: int.parse(dotenv.env['DB_PORT']!),
      userName: dotenv.env['DB_USER']!,
      password: dotenv.env['DB_PASS']!,
      databaseName: dotenv.env['DB_SCHEMA']!,
    );
  }
}