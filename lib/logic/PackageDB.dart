import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PackageDB{
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
        join(await getDatabasesPath(), 'package_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE packages (name TEXT) ',
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

  Future<int> insert(String name) async {
    final Database db = await database;
    int res=await db.insert(
      'packages',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<void> createTable(String tableName) async{
    final Database db = await database;
    try{
      await db.execute('CREATE TABLE $tableName (name TEXT) ');
    } catch(e) {
      debugPrint(e.toString());
    }
  }


  Future<int> delete(String name) async{
    final Database db = await database;
    try{
      return db.delete('packages',where: 'name = ?',whereArgs: [name]);
    } catch(e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<List<String>> query() async{
    final Database db = await database;
    try{
      List<Map<String,dynamic>> maps=await db.query("packages");
      List<String> res=[];
      for(int i=0;i<maps.length;i++)
      {
        res.add(maps[i]['name']);
      }
      return res;
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

  Future<void> deleteTable(String tableName) async{
    final Database db = await database;
    try{
      await db.execute('DROP TABLE $tableName');
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