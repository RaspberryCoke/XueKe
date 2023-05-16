import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 用于存储白名单的数据库
///
/// 数据库名：history.db
/// 表名：history
/// 列名：
/// historyid INTEGER PRIMARY KEY AUTOINCREMENT
/// todoid INTEGER
/// title TEXT
/// starttime  DATETIME
/// time INTEGER
/// content TEXT
/// success INTEGER
/// tag TEXT
///
/// 数据库的逻辑控制：
/// 1.在main.dart中进行初始化。
/// 获取所有的Todo。
///
///
/// 2.所有的数据保存在main_logic的数据结构中
///  static List<Todo> refreshNotifier=[];
///  定义Todo数据结构：
class History {
  int historyid;
  int todoid;
  String title;
  int time;
  String content;
  DateTime starttime;
  int success;
  String tag;
  History(this.historyid,this.todoid, this.title, this.time, this.content,this.starttime,this.success,this.tag);

  static History fromMap(Map<String, dynamic> the_data) {
    return History(
      the_data['historyid'],
      the_data['todoid'],
      the_data['title'],
      the_data['time'],
      the_data['content'],
      DateTime.parse(the_data['starttime']),
      the_data['success'],
      the_data['tag'],
    );
  }
}


class HistoryDB{
  static String DATABASE_NAME='history.db';
  static String TABLE_NAME='history';
  static String COLUMN_HISTORY_ID_NAME='historyid';
  static String COLUMN_TODO_ID_NAME='todoid';
  static String COLUMN_TITLE_NAME='title';
  static String COLUMN_TIME_NAME='time';
  static String COLUMN_START_TIME_NAME='starttime';
  static String COLUMN_CONTENT_NAME='content';
  static String COLUMN_SUCCESS_NAME='success';
  static String COLUMN_TAG_NAME='tag';
  static final HistoryDB _instance = HistoryDB._internal();



  Database? _database;
  factory HistoryDB() {
    return _instance;
  }
  HistoryDB._internal();
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), DATABASE_NAME),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE ${TABLE_NAME} ('
                '${COLUMN_HISTORY_ID_NAME} INTEGER PRIMARY KEY AUTOINCREMENT,'
                '${COLUMN_TODO_ID_NAME} INTEGER,'
                '${COLUMN_TITLE_NAME} TEXT,'
                '${COLUMN_TIME_NAME} INTEGER,'
                '${COLUMN_START_TIME_NAME} DATETIME,'
                '${COLUMN_CONTENT_NAME} TEXT,'
                '${COLUMN_SUCCESS_NAME} INTEGER,'
                '${COLUMN_TAG_NAME} TEXT'
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
      List<Map<String,dynamic>> maps=await db.query(TABLE_NAME,orderBy: '${COLUMN_HISTORY_ID_NAME} DESC',limit: 1);
      if(maps.length==0){
        return 0;
      }
      return maps[0][COLUMN_HISTORY_ID_NAME];
    } catch(e) {
      debugPrint(e.toString());
      return 0;
    }
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


  Future<int> deleteHistoryID(int id) async{
    final Database db = await database;
    try{
      return db.delete(TABLE_NAME,where: '${COLUMN_HISTORY_ID_NAME} = ?',whereArgs: [id]);
    } catch(e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<int> updateHistoryIdToSucceed(int historyid) async{
    final Database db = await database;
    try{
      return db.update(TABLE_NAME,{'success':1},where: '${COLUMN_HISTORY_ID_NAME} = ?',whereArgs: [historyid]);
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

  Future<List<Map<String,dynamic>>> load_data(int _size,int _offset) async{
    final Database db = await database;
    try{
      List<Map<String,dynamic>> maps=await db.query(TABLE_NAME,orderBy: '${COLUMN_HISTORY_ID_NAME} DESC',limit: _size,offset: _offset);
      return maps;
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<int> insert(int todoid,String title,int time,DateTime starttime,
      String content,int success,String tag) async {
    final Database db = await database;
    int res=await db.insert(
      TABLE_NAME,
      {
        COLUMN_TODO_ID_NAME:todoid,
        COLUMN_START_TIME_NAME:starttime.toString(),
        COLUMN_TITLE_NAME: title,
        COLUMN_TIME_NAME:time,
        COLUMN_CONTENT_NAME:content,
        COLUMN_SUCCESS_NAME:success,
        COLUMN_TAG_NAME:tag,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
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


  Future<DateTime> findOldestDateTime()async{
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_NAME, orderBy: '${COLUMN_HISTORY_ID_NAME} ASC', limit: 1);

    final date = DateTime.parse(maps[0][COLUMN_START_TIME_NAME]);
    return date;
  }


  Future<int> makeData() async{
    final Database db = await database;

    int _res=await db.delete(TABLE_NAME,where: '1= ?',whereArgs: [1]);
    if(_res==0)
      {
        await db.delete(TABLE_NAME);
      }

    int all=0;
    for(int i=1;i<=15;i++) {
      all+=await db.insert(
        TABLE_NAME,
        {
          COLUMN_TODO_ID_NAME: 3,
          COLUMN_START_TIME_NAME: DateTime(2023, 5, i, 13, 25, 23, 123, 123).toString(),
          COLUMN_TITLE_NAME: 'title',
          COLUMN_TIME_NAME: Random().nextInt(99) + 1,
          COLUMN_CONTENT_NAME: '',
          COLUMN_SUCCESS_NAME: 1,
          COLUMN_TAG_NAME: '',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    all+=await db.insert(
      TABLE_NAME,
      {
        COLUMN_TODO_ID_NAME: 3,
        COLUMN_START_TIME_NAME: DateTime(2023, 4, 29, 13, 25, 23, 123, 123).toString(),
        COLUMN_TITLE_NAME: 'title',
        COLUMN_TIME_NAME: Random().nextInt(99) + 1,
        COLUMN_CONTENT_NAME: '',
        COLUMN_SUCCESS_NAME: 1,
        COLUMN_TAG_NAME: '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    all+=await db.insert(
      TABLE_NAME,
      {
        COLUMN_TODO_ID_NAME: 3,
        COLUMN_START_TIME_NAME: DateTime(2023, 4, 30, 13, 25, 23, 123, 123).toString(),
        COLUMN_TITLE_NAME: 'title',
        COLUMN_TIME_NAME: Random().nextInt(99) + 1,
        COLUMN_CONTENT_NAME: '',
        COLUMN_SUCCESS_NAME: 1,
        COLUMN_TAG_NAME: '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return all;
  }



  Future<int> queryDataByDate(DateTime date) async {
    final Database db = await database;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));
    final queryResult = await db.query(
      TABLE_NAME,
      where: '${COLUMN_START_TIME_NAME} BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    int t=0;
    for(var i=0;i<queryResult.length;i++)
      {
        t+=queryResult[i][COLUMN_TIME_NAME] as int;
      }
    return t;
  }


}