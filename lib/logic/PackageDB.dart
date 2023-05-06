import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 用于存储白名单的数据库
///
/// 数据库名：white_package.db
/// 表名：packages
/// 列名：AppName,PackageName
///
/// 数据库的逻辑控制：
/// 1.在main.dart中进行初始化。
/// 获取所有的应用实例。
/// 把数据全部保存在GlobalData中的四个数据结构中。
///
///  static Map<String,String> appNameToPackageName={};
///  static Map<String,String> PackageNameToappName={};
///
///  static Map<String,bool> whiteAppsMap={};
///  static Map<String,bool> whitePackagesMap={};
///
/// 其中appNameToPackageName和PackageNameToappName是一一对应的。
/// 另外两个数据结构分别保存appName对应的白名单状态和packageName对应的白名单状态。
/// 也就意味着在初始化时，同时初始化前两个数据结构和后两个数据结构。
///
/// 之后再读取数据库，调用查询函数，把数据库中的数据读取出来，然后更新后两个数据结构。
/// 把查到的数据设置为true。
///
/// 最后，调用SuperviseController.packageChange()函数发送包改变信号，
/// 这个信号可以让Java中的代码调用数据库查询操作，从而在Java中完成初始化工作。
///
/// 以上就是初始化工作。
///
///

class PackageDB{
  static String DATABASE_NAME='white_package.db';
  static String TABLE_NAME='packages';
  static String COLUMN_APP_NAME='AppName';
  static String COLUMN_PACKAGE_NAME='PackageName';
  static final PackageDB _instance = PackageDB._internal();
  Database? _database;
  factory PackageDB() {
    return _instance;
  }
  PackageDB._internal();
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), DATABASE_NAME),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE ${TABLE_NAME} (${COLUMN_APP_NAME} TEXT,${COLUMN_PACKAGE_NAME} TEXT) ',
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

  Future<int> insert(String appName,String packageName) async {
    final Database db = await database;
    int res=await db.insert(
      TABLE_NAME,
      {
        COLUMN_APP_NAME: appName,
        COLUMN_PACKAGE_NAME:packageName
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<int> deletePackageName(String name) async{
    final Database db = await database;
    try{
      return db.delete('packages',where: '${COLUMN_PACKAGE_NAME} = ?',whereArgs: [name]);
    } catch(e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<int> deleteAppName(String name) async{
    final Database db = await database;
    try{
      return db.delete('packages',where: '${COLUMN_APP_NAME} = ?',whereArgs: [name]);
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

  // Future<bool> isOpen() async{
  //   final Database db = await database;
  //   try{
  //     return db.isOpen;
  //   } catch(e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }
}