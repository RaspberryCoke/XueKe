import 'dart:math';

import 'package:tomato_clock/db/TodoDB.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/model/todo.dart';
import 'package:tomato_clock/page/change_password_page.dart';
import 'package:tomato_clock/page/constant.dart';
import 'package:tomato_clock/page/event.dart';
import 'package:tomato_clock/page/future_page.dart';
import 'package:tomato_clock/page/person_page.dart';
import 'package:tomato_clock/page/login.dart';
import 'package:tomato_clock/page/mine_setting_page.dart';
import 'package:tomato_clock/page/todo_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:tomato_clock/res.dart';
import 'package:tomato_clock/page/todo_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tomato_clock/db/UserInfo.dart';

import '../colors.dart';
import '../components/MyCard.dart';
import 'drawer/drawer_of_main.dart';
import 'my_add_todo_page/my_add_todo_page.dart';


import 'package:tomato_clock/page/lock_page/lock_page.dart';
import 'package:tomato_clock/logic/GlobalData.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class TableEventsPage extends StatefulWidget {
  const TableEventsPage({Key? key}) : super(key: key);

  @override
  State<TableEventsPage> createState() => _TableEventsPageState();
}

class _TableEventsPageState extends State<TableEventsPage> {
  ValueNotifier<List<Todo>> _selectedEvents=ValueNotifier<List<Todo>>([]);


  void setting() {
    Navigator.pushReplacementNamed(context, Constant.changeInfoPage);
  }

  void person() {
    Navigator.pushReplacementNamed(context, Constant.personPage);
  }


  bool _isDragging = false;
  double _x = 0;
  double _y = 0;
  Widget item(String title, VoidCallback callback, {TextStyle? textStyle}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Text(
          title,
          style: textStyle ??
              TextStyle(
                color: Colors.black,
                fontSize: 35,
              ),
        ),
      ),
    );
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late EventNotifier<List<Todo>> _refresh;
  void _onRefresh() {
    //排除已被删除的情况。
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refresh = MainLogic.refreshNotifier;
    _refresh.addListener(_onRefresh);
    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(MainLogic.instance.getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _refresh.removeListener(_onRefresh);
    _selectedEvents.dispose();
    super.dispose();
  }

  void _showDeleteDialog(int date, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除代办'),
        content: Text('确认删除 $title ？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              MainLogic.todoList.removeWhere((element) => element.title == title);
              TodoDB().deleteTitleName(title);
              _onRefresh();
            },
            child: Text('确认'),
          ),
        ],
      ),
    );
  }



  void _showAddTodoDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Material(
            child: Center(child: MyTodoPage()),
            color: Colors.black26,
          ),
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kShrinePink50,
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.person,
              size: 33,
              //color: Colors.green,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        //头条
        //backgroundColor: Color(0x7E238020),
        elevation: 0,
        title: Text(
          '待办',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
      ),


      drawer: MyDrawer(),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: _x,
            bottom: _y,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _isDragging = true;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _x = (_x - details.delta.dx).clamp(0, 190);
                  _y = (_y - details.delta.dy).clamp(0, 580);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
              },
              child: FloatingActionButton.extended(
                onPressed: () {
                  _showAddTodoDialog();
                },
                label: Text(
                  "创建待办",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                icon: Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 12.0,
        // TODO: Build a grid of cards (102)
        children: generateAllCards(),
      ),
    );
  }

  List<MyCard> generateAllCards() {
    List<Todo>res= MainLogic.refreshNotifier.value;
    if(res.length==0){
      return [];
    }
    List<MyCard> allCards = [];
    for(var value in res){
      allCards.add(MyCard(title:value.title,content:value.content,time:value.time));
    }
    return allCards;
  }
}
