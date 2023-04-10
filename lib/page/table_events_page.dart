import 'package:app_entrance/logic/login_logic.dart';
import 'package:app_entrance/logic/main_logic.dart';
import 'package:app_entrance/model/todo.dart';
import 'package:app_entrance/page/constant.dart';
import 'package:app_entrance/page/event.dart';
import 'package:app_entrance/page/todo_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:app_entrance/res.dart';
import 'package:app_entrance/page/todo_page.dart';
import 'package:table_calendar/table_calendar.dart';

class TableEventsPage extends StatefulWidget {
  const TableEventsPage({Key? key}) : super(key: key);

  @override
  State<TableEventsPage> createState() => _TableEventsPageState();
}

class _TableEventsPageState extends State<TableEventsPage> {
  late final ValueNotifier<List<Todo>> _selectedEvents;
  List<String> cards = [
    Res.new_card_bg_1,
    Res.new_card_bg_2,
    Res.new_card_bg_3,
    Res.new_card_bg_4,
  ];


  bool _isDragging = false;
  double _x = 0;
  double _y = 0;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late EventNotifier<List<Todo>> _refresh;
  void _onRefresh() {
    if (!mounted) return;
    List<Todo> list = [];
    list.addAll(MainLogic.instance.getEventsForDay(_selectedDay!));
    Future.delayed(Duration.zero, () {
      _selectedEvents.value = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh = MainLogic.instance.refreshNotifier;
    _refresh.addListener(_onRefresh);
    _selectedDay = _focusedDay;
    _selectedEvents =
        ValueNotifier(MainLogic.instance.getEventsForDay(_selectedDay!));
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
              MainLogic.instance.deleteTodoById(date);
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
            child: Center(child: TodoPage()),
            color: Colors.black26,
          ),
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.person,
              size: 33,
              //color: Colors.green,
            ),
            onPressed: (){
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


      drawer: Drawer(
        //backgroundColor: Colors.white,
          child: Column(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      tileMode: TileMode.mirror,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFf689ad3), Color(0xD9B5B5FF)],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: UserAccountsDrawerHeader(
                          accountName: Text(LoginLogic.instance.currentUser?.account ?? '',
                            style: TextStyle(fontSize: 16, color: Colors.black),),
                          accountEmail: Text('${LoginLogic.instance.currentUser?.content ?? '千里之行，始于足下'}',
                            style: TextStyle(fontSize: 13, color: Colors.black),),
                          currentAccountPicture: CircleAvatar(
                              backgroundImage: new ExactAssetImage('assets/person.png')
                          ),
                          decoration: BoxDecoration(//背景
                            image: DecorationImage(
                              image: new ExactAssetImage('assets/person_bg.png'),
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                              fit: BoxFit.cover,
                            ),
                          )
                      ))
                ],
              ),
              const ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.people),
                ),
                title: Text("个人中心"),
              ),
              Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 0,
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.settings),
                ),
                title: Text("系统设置"),
              ),
              Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 0,
              ),
            ],
          )
      ),



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


      body: Column(
        children: [
          const SizedBox(height: 20),

          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Todo>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    Todo todo = value[index];
                    return GestureDetector(
                      onLongPress: () {
                        _showDeleteDialog(todo.date!, todo.title!);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(cards[index % 4]),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Constant.todoDetailPage,
                              arguments: {
                                TodoDetailPage.keyId: todo.date,
                              },
                            );
                          },
                          title: Text(
                            '${todo.title}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          subtitle: Text(
                            '${todo.toMs()}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            '${todo.doneToString()}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
