import 'package:sqflite/sqflite.dart';
import 'package:tomato_clock/core/database/sql_manager.dart';

abstract class BaseTableProvider {
  String tableName();

  String creatTableString();

  //获取当前数据库对象
  Future<Database> getDataBase() async {
    bool isTableExist = await SqlManager.isTableExists(tableName());

    if (!isTableExist) {
      //表不存在则创建表
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(creatTableString());
      return db;
    } else {
      return await SqlManager.getCurrentDataBase();
    }
  }

//创建表
  Future<void> creatTable() async {
    bool isTableExist = await SqlManager.isTableExists(tableName());

    if (!isTableExist) {
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(creatTableString());
    }
  }
}
