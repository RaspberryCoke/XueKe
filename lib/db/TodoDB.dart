import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 用于存储白名单的数据库
///
/// 数据库名：todo.db
/// 表名：todo
/// 列名：
/// id INTEGER PRIMARY KEY AUTOINCREMENT
/// title TEXT
/// time  INTEGER
/// content TEXT
///
/// 数据库的逻辑控制：
/// 1.在main.dart中进行初始化。
/// 获取所有的Todo。
///
///
/// 2.所有的数据保存在main_logic的数据结构中
///  static List<Todo> refreshNotifier=[];
///  定义Todo数据结构：
class Todo {
  int id;
  String title;
  int time;
  String content;

  Todo(this.id, this.title, this.time, this.content);
}


class TodoDB{
  static String DATABASE_NAME='todo.db';
  static String TABLE_NAME='todo';
  static String COLUMN_ID_NAME='id';
  static String COLUMN_TITLE_NAME='title';
  static String COLUMN_TIME_NAME='time';
  static String COLUMN_CONTENT_NAME='content';
  static final TodoDB _instance = TodoDB._internal();
  Database? _database;
  factory TodoDB() {
    return _instance;
  }
  TodoDB._internal();
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), DATABASE_NAME),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE ${TABLE_NAME} '
                '(${COLUMN_ID_NAME} INTEGER PRIMARY KEY AUTOINCREMENT,'
                '${COLUMN_TITLE_NAME} TEXT,'
                '${COLUMN_TIME_NAME} INTEGER,'
                '${COLUMN_CONTENT_NAME} TEXT'
                '); ',
          );
        },
        version: 1,
      );
    } catch (e) {
      debugPrint(e.toString());
      _database = null;
    }
    return _database!;
  }

  Future<int> getTopID()async{
    final Database db = await database;
    try{
      List<Map<String,dynamic>> maps=await db.query(TABLE_NAME,orderBy: '${COLUMN_ID_NAME} DESC',limit: 1);
      if(maps.length==0){
        return 0;
      }
      return maps[0][COLUMN_ID_NAME];
    } catch(e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<int> insert(String title,int time,String content) async {
    final Database db = await database;
    int res=await db.insert(
      TABLE_NAME,
      {
        COLUMN_TITLE_NAME: title,
        COLUMN_TIME_NAME:time,
        COLUMN_CONTENT_NAME:content,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<int> deleteTitleName(String title) async{
    final Database db = await database;
    try{
      return db.delete(TABLE_NAME,where: '${COLUMN_TITLE_NAME} = ?',whereArgs: [title]);
    } catch(e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<List<Map<String,dynamic>>> query() async{
    final Database db = await database;
    try{
      List<Map<String,dynamic>> maps=await db.query(TABLE_NAME);
      return maps;
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> close() async{
    final Database db = await database;
    try{
      await db.close();
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTable() async{
    final Database db = await database;
    try{
      await db.execute('DROP TABLE ${TABLE_NAME}');
    } catch(e) {
      debugPrint(e.toString());
    }
  }
}