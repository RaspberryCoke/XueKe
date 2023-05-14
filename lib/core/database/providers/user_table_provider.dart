import 'package:tomato_clock/core/database/providers/base_table_provider.dart';
class UserTableProvider extends BaseTableProvider{
  final String tablename = "user";

  //表列名
  final String userID = 'u_id';//ID
  final String userQQ = 'u_qq';//名称



  String tableName(){
    return tablename;
  }


  @override
  String creatTableString() {
    return '''CREATE TABLE $tablename(
     $userID INTEGER PRIMARY KEY AUTOINCREMENT,//自增长
     $userQQ INTERGER NOT NULL)''';
  }
}