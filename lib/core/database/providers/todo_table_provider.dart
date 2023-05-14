import 'package:tomato_clock/core/database/providers/base_table_provider.dart';
class TodoTableProvider extends BaseTableProvider{
  final String tablename = "todo";

  //表列名
  final String ID = 'id';//ID
  final String title = 'title';//名称
  final String date = 'date';//日期
  final String duration = 'duration';//时长
  final String content = 'content';//备注
  final String insertDate ='insertDate';//加入的时间


  String tableName(){
  return tablename;
  }


  @override
  String creatTableString() {
    return '''CREATE TABLE $tablename(
     $ID INTEGER PRIMARY KEY AUTOINCREMENT,//自增长
     $title TEXT NOT NULL,
     $date INTEGER NOT NULL,
     $duration INTEGER NOT NULL,
     $insertDate INTEGER NOT NULL,
     $content TEXT
    )''';
  }
}