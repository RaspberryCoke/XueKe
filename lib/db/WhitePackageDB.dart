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
/// 把数据全部保存在MainLogic中的四个数据结构中。
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
///2.用户更改白名单的运行逻辑
/// 用户点开白名单页面，白名单页面使用whiteAppsMap进行初始化，构造所用的Item。
/// 一旦用户更改了某一项的状态，如果是从true变为false，那么就从数据库中删除这一项。
/// 如果是从false变为true，那么就向数据库中插入这一项。
///
/// 在数据库中进行修改之后，再把全局数据进行修改。把对应的两个数据结构
///  whiteAppsMap，和whitePackagesMap中的对应项设置为true或者false。
///
/// 最后，调用SuperviseController.packageChange()函数发送包改变信号，
/// 让Java中的代码查询数据库，进行同步的改变。
///
/// 3.值得注意的是，对于“学刻”和“com.hebut.tomato_clock”这两项，
/// 他们并不保存在数据库中。再进行初始化的时候，对于flutter中的程序而言，
/// 是在main.dart的initWhiteApp函数中，在加载完其他数据之后在对他们进行单独处理。
/// 同理，再Java程序中，也是在初始化的时候，对他们进行单独处理。
/// 具体来说是在每次query时，返回查询结果之前添加packageName即可。

class WhitePackageDB{
  static String DATABASE_NAME='white_package.db';
  static String TABLE_NAME='packages';
  static String COLUMN_APP_NAME='AppName';
  static String COLUMN_PACKAGE_NAME='PackageName';
  static final WhitePackageDB _instance = WhitePackageDB._internal();
  Database? _database;
  factory WhitePackageDB() {
    return _instance;
  }
  WhitePackageDB._internal();
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), DATABASE_NAME),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE ${TABLE_NAME} (${COLUMN_APP_NAME} TEXT,${COLUMN_PACKAGE_NAME} TEXT); ',
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

}