import 'package:mysql1/mysql1.dart';

class Mysql{

  Mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: ' ',
      db: 'test'
    );
    return await MySqlConnection.connect(settings);
  }
}

