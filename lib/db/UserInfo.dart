import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:tomato_clock/debug.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 用于存储白名单的数据库
///
/// 数据库名：user_info.db
/// 表名：user_info
/// 列名：
/// uid TEXT
/// name TEXT
/// gender BOOLEAN--->男：0，女：1.
/// picture  BLOB
///
/// 数据库的逻辑控制：
/// 1.在main.dart中进行初始化。
/// 直接进行query，如果有结果，那就是已经登陆了，如果没有结果，那就是没有登陆。
/// query结束之后，保存到全局的数据结构之中。
/// 2.所有的数据保存在main_logic的数据结构中
///  static UserInfo user_info=UserInfo();
///  定义UserInfo数据结构：
class UserInfo {
  String uid;
  String name;
  int gender;//男为0，女为1.
  Uint8List picture;

  UserInfo(this.uid,this.name,this.gender,this.picture);
}


class UserInfoDB{
  static String DATABASE_NAME='user_info.db';
  static String TABLE_NAME='user_info';
  static String COLUMN_UID_NAME='uid';
  static String COLUMN_NAME_NAME='name';
  static String COLUMN_GENDER_NAME='gender';
  static String COLUMN_PICTURE_NAME='picture';
  static final UserInfoDB _instance = UserInfoDB._internal();
  Database? _database;
  factory UserInfoDB() {
    return _instance;
  }
  UserInfoDB._internal();
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
                '(${COLUMN_UID_NAME} TEXT,'
                '${COLUMN_NAME_NAME} TEXT,'
                '${COLUMN_GENDER_NAME} INTEGER,'
                '${COLUMN_PICTURE_NAME} BLOB'
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

  Future<int> insert(String uid,String name, int gender,Uint8List picture) async {
    final Database db = await database;
    int res=await db.insert(
      TABLE_NAME,
      {
        COLUMN_UID_NAME: uid,
        COLUMN_NAME_NAME:name,
        COLUMN_GENDER_NAME:gender,
        COLUMN_PICTURE_NAME:picture,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    db.close();
    if(res==0)errprint("insert error");
    return res;
  }

  Future<int> deleteUID(String uid) async{
    final Database db = await database;
    try{
      return db.delete(TABLE_NAME,where: '${COLUMN_UID_NAME} = ?',whereArgs: [uid]);
    } catch(e) {
      errprint(e.toString());
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


// 下载图像并将其作为二进制流显示
Future<Uint8List> downloadImageAsUint8List(String url) async {
  // 从网络上下载图像
  final response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}


//没有用到
// 从SQLite数据库中读取BLOB并将其作为图像显示
Future<Image> displayImageFromDatabase() async {
  // 从SQLite数据库中读取BLOB
  final db = await openDatabase('user_info.db');
  final result = await db.query('user_info');
  final bytes = result.first['picture'] as Uint8List;
  // 将BLOB作为图像显示
  // 这里使用了Image.memory()构造函数来显示从内存中读取的图像
  // 如果您要显示从磁盘文件读取的图像，请使用Image.file()构造函数
  return Image.memory(bytes);
}