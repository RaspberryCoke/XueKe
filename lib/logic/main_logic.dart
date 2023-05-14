import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tomato_clock/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../db/TodoDB.dart';
import '../db/UserInfo.dart';
import '../page/event.dart';

class MainLogic extends ChangeNotifier {



  //全局的已完成列表，在一开始就进行了初始化，从sqlite数据库中初始化。

  //全局的用户信息，在一开始就进行了初始化，从sqlite数据库中初始化。
  static UserInfo userInfo = UserInfo('','',0,Uint8List(0));

  static Map<String, String> musicToDir = {
    '钢琴轻音乐':'musics/piano.aac',
    '雨声':'musics/rain.aac',
    '火焰声':'musics/fire.aac',
  };


  static int todoid=-1;
  static int historyid=-1;
  static int minutes = 1;
  static String  title= '';
  static String  content= '';
  //包信息
  static Map<String,String> appNameToPackageName={};
  static Map<String,String> packageNameToAppName={};
  static Map<String,bool> whiteAppsMap={};
  static Map<String,bool> whitePackagesMap={};
  //以下代码和通知有关
  static Map<String,bool> packageWhetherFilter={};
  static Map<String,String> packageFilterString={};

  static const String keyrefreshNotifier = 'todo_list';
  // 累计完成次数
  static const String keyTodoCount = 'todo_count';
  // 未来倒计时
  static const String keyFuturerefreshNotifier = 'future_todo_list';



  MainLogic._();
  static final MainLogic _instance = MainLogic._();
  static MainLogic get instance => _instance;

  //全局的待办列表，在一开始就进行了初始化，从sqlite数据库中初始化。
  static List<Todo> todoList = [];
  static EventNotifier<List<Todo>> refreshNotifier = EventNotifier([]);
}
