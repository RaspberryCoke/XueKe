import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tomato_clock/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../page/event.dart';

class MainLogic extends ChangeNotifier {
  static const String keyTodoList = 'todo_list';

  // 累计完成次数
  static const String keyTodoCount = 'todo_count';

  // 未来倒计时
  static const String keyFutureTodoList = 'future_todo_list';

  MainLogic._();

  static final MainLogic _instance = MainLogic._();

  static MainLogic get instance => _instance;

  late SharedPreferences sharedPreferences;

  late LinkedHashMap<DateTime, List<Todo>> map;

  /// completed events
  late LinkedHashMap<DateTime, List<Todo>> completedEvents;

  EventNotifier<List<Todo>> refreshNotifier = EventNotifier([]);

  List<Todo> futureTodoList = [];

  init(SharedPreferences sharedPreferences) {
    this.sharedPreferences = sharedPreferences;
    map = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    completedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    List<String>? json = sharedPreferences.getStringList(keyTodoList);
    if (json != null) {
      List<Todo> list = json.map((e) => Todo.fromJson(jsonDecode(e))).toList();
      convertListToMap(list);
    }
    //
    List<String>? completedEventsJson =
        sharedPreferences.getStringList(keyTodoCount);
    if (completedEventsJson != null) {
      List<Todo> list =
          completedEventsJson.map((e) => Todo.fromJson(jsonDecode(e))).toList();
      convertCompletedListToMap(list);
    }

    //
    List<String>? futureListJson =
        sharedPreferences.getStringList(keyFutureTodoList);
    if (futureListJson != null) {
      List<Todo> list =
          futureListJson.map((e) => Todo.fromJson(jsonDecode(e))).toList();
      futureTodoList = list;
    }
  }

  void convertCompletedListToMap(List<Todo> list) {
    for (Todo todo in list) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(todo.date!);
      //添加了小时和分钟
      DateTime finalDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day,dateTime.hour,dateTime.minute);
      List<Todo>? list = completedEvents[finalDate];
      if (list != null) {
        list.add(todo);
      } else {
        completedEvents[finalDate] = [todo];
      }
    }
  }

  void convertListToMap(List<Todo> list) {
    for (Todo todo in list) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(todo.date!);
      DateTime finalDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day);
      List<Todo>? list = map[finalDate];
      if (list != null) {
        list.add(todo);
      } else {
        map[finalDate] = [todo];
      }
    }
  }

  // 更新事件
  Future<bool> addTodo(Todo todo) async {
    List<Todo>? list = map[todo.getYmd()];
    if (list == null) {
      map[todo.getYmd()] = [todo];
    } else {
      list.insert(0, todo);
      map[todo.getYmd()] = list;
    }

    refreshNotifier.value = map[todo.getYmd()]!;
    return await saveData();
  }

  Future<bool> saveData() async {
    List<String> json = [];
    map.forEach((key, value) {
      json.addAll(value.map((element) {
        return jsonEncode(element);
      }).toList());
    });
    return await sharedPreferences.setStringList(keyTodoList, json);
  }

  Future<bool> saveCompleteData() async {
    List<String> json = [];
    completedEvents.forEach((key, value) {
      json.addAll(value.map((element) {
        return jsonEncode(element);
      }).toList());
    });
    return await sharedPreferences.setStringList(keyTodoCount, json);
  }

  Future<bool> saveFutureTodoData() async {
    List<String> json = futureTodoList.map((element) {
      return jsonEncode(element);
    }).toList();
    return await sharedPreferences.setStringList(keyFutureTodoList, json);
  }

  // 获取当前日期的事件
  List<Todo> getEventsForDay(DateTime dateTime) {
    DateTime finalDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return map[finalDate] ?? [];
  }

  Todo? getTodoById(int id) {
    for (List<Todo> list in map.values) {
      for (Todo todo in list) {
        if (todo.date == id) {
          return todo;
        }
      }
    }
    return null;
  }

  List<Todo> getAllTodos(DateTime dateTime) {
    return map[dateTime] ?? [];
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // 更新事件时间
  void addCompleteEvent(Todo todo) {
    convertCompletedListToMap([todo]);
    saveCompleteData();
  }

  void addFutureTodoEvent(Todo todo) {
    futureTodoList.add(todo);
    saveFutureTodoData();
  }

  void deleteFutureTodo(Todo todo) {
    futureTodoList.remove(todo);
    saveFutureTodoData();
  }

  /// 专注完成次数
  int completeCount() {
    int count = 0;
    completedEvents.forEach((key, value) {
      count += value.length;
    });
    return count;
  }

  /// 专注完成时间
  int completeTodoTime() {
    int count = 0;
    completedEvents.forEach((key, value) {
      for (Todo todo in value) {
        count += todo.duration ?? 0;
      }
    });
    return count == 0 ? 0 : (count / 60) ~/ completedEvents.keys.length;
  }

  /// 平均日时长
  int averageTodoTime() {
    int count = 0;
    completedEvents.forEach((key, value) {
      for (Todo todo in value) {
        count += todo.duration ?? 0;
      }
    });
    return count == 0 ? 0 : (count / 60) ~/ completedEvents.keys.length;
  }

  /// 当日完成次数
  int searchDayCount(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    int count = 0;
    DateTime finalDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    print(finalDate);
    print(completedEvents[finalDate]);
    completedEvents.containsKey(finalDate)
        ? count = completedEvents[finalDate]!.length
        : count = 0;
    return count;
  }

  //当日完成总时长
  int searchDaytotalMinute(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    int count = 0;
    DateTime finalDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    print(finalDate);
    print(completedEvents[finalDate]);
    List<Todo> list = [];
    if (completedEvents.containsKey(finalDate)) {
      list = completedEvents[finalDate]!;
      for (Todo todo in list) {
        count += todo.duration ?? 0;
      }
      count = (count ~/60) ;
      return count;
    } else {
      return 0;
    }
  }

  /// 当日完成平均时长
  int searchDayMinute(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    int count = 0;
    DateTime finalDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    print(finalDate);
    print(completedEvents[finalDate]);
    List<Todo> list = [];
    if (completedEvents.containsKey(finalDate)) {
      list = completedEvents[finalDate]!;
      for (Todo todo in list) {
        count += todo.duration ?? 0;
      }
      return count == 0 ? 0 : (count / 60) ~/ list.length;
    } else {
      return 0;
    }
  }

  //7天平均完成时长
  int searchsevenDaysMinute() {
    int count = 0;
    completedEvents.forEach((key, value) {
      for (Todo todo in value) {
        count += todo.duration ?? 0;
      }
    });
    return count == 0 ? 0 : (count / 60) ~/ 7;
  }

  //30天平均完成时长
  int searchthirtyDaysMinute() {
    int count = 0;
    completedEvents.forEach((key, value) {
      for (Todo todo in value) {
        count += todo.duration ?? 0;
      }
    });
    return count == 0 ? 0 : (count / 60) ~/ 30;
  }

  void deleteTodoById(int date) {
    for (List<Todo> list in map.values) {
      for (Todo todo in list) {
        if (todo.date == date) {
          list.remove(todo);
          break;
        }
      }
    }
    saveData();
  }
}
