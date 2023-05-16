import 'package:tomato_clock/db/TodoDB.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/page/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../colors.dart';
import '../components/TodoCard.dart';
import 'drawer/drawer_of_main.dart';
import 'my_add_todo_page/my_add_todo_page.dart';

class TableEventsPage extends StatefulWidget {
  const TableEventsPage({Key? key}) : super(key: key);

  @override
  State<TableEventsPage> createState() => _TableEventsPageState();
}

class _TableEventsPageState extends State<TableEventsPage> {
  ValueNotifier<List<Todo>> _selectedEvents = ValueNotifier<List<Todo>>([]);

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
        backgroundColor: Colors.transparent,
        leading: Builder(builder: (BuildContext context) {
          return
            Padding(
              padding: EdgeInsets.only(top: 5,left: 5, right: 5,bottom: 5),
          child:
          Container(
            height:30,
            width: 30,
            decoration: BoxDecoration(
              color: kShrinePink300, // 设置容器的背景颜色为白色
              shape: BoxShape.circle, // 将容器形状设置为圆形
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: ClipOval(
            child: GestureDetector(
              child:Image.memory(
                MainLogic.userInfo.picture,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ) ,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            )

          )));
        }),
        //头条
        //backgroundColor: Color(0x7E238020),
        elevation: 0,
        title: Padding(
            padding: EdgeInsets.only(top: 5,left: 10, right: 10,bottom: 5),
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: kShrinePink300,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints(
                  minHeight: 45,
                  maxHeight: 45,
                  minWidth: 130,
                  maxWidth: 130,
                ),
                child: Center(
                    child: Text(
                  '待办任务',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                )))),
        actions: [
          Padding(
              padding: EdgeInsets.only(top: 5,left: 10, right: 10,bottom: 5),
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: kShrinePink300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    minHeight: 45,
                    maxHeight: 45,
                    minWidth: 110,
                    maxWidth: 110,
                  ),
                  child: Center(
                      child: TextButton(
                          onPressed: () {
                            _showAddTodoDialog();
                          },
                          child: Text(
                            '添加代办',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )))))
        ],
      ),
      drawer: MyDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 12.0,
        // TODO: Build a grid of cards (102)
        children: generateAllCards(),
      ),
    );
  }

  List<TodoCard> generateAllCards() {
    List<Todo> res = MainLogic.refreshNotifier.value;
    if (res.length == 0) {
      return [];
    }
    List<TodoCard> allCards = [];
    for (var value in res) {
      allCards.add(TodoCard(
          title: value.title, content: value.content, time: value.time));
    }
    return allCards;
  }
}
