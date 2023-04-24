import 'package:tomato_clock/logic/login_logic.dart';
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
import 'package:tomato_clock/logic/GlobalData.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class TableEventsPage extends StatefulWidget {
  const TableEventsPage({Key? key}) : super(key: key);

  @override
  State<TableEventsPage> createState() => _TableEventsPageState();
}

class _TableEventsPageState extends State<TableEventsPage> {
  late final ValueNotifier<List<Todo>> _selectedEvents;
  List<String> cards = [
    Res.card_bg_2,
    Res.card_bg_3,
    Res.card_bg_4,
    Res.card_bg_5,
    Res.card_bg_6,
  ];

  void setting() {
    Navigator.pushReplacementNamed(context, Constant.settingPage);
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
/*              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: UserAccountsDrawerHeader(
                          accountName: Text(LoginLogic.instance.currentUser?.name ?? '',
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
              ),*/

          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new ExactAssetImage('assets/person_bg.png'),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.65), BlendMode.dstATop),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 20, top: 60),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          LoginLogic.instance.currentUser?.avatar ?? Res.person,
                          height: 97,
                          width: 97,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 60),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '昵称：${LoginLogic.instance.currentUser?.name ?? ''}',
                              overflow: TextOverflow.ellipsis, //溢出显示几个点
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'draw',
                                  fontSize: 20,
                                  color: Colors.black),
                              // '昵称：${LoginLogic.instance.currentUser?.name ?? ''}',
                              /*style:
                                  TextStyle(fontSize: 14, color: Colors.white),*/
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 8),
                            child: Text(
                              '${LoginLogic.instance.currentUser?.content ?? '千里之行，始于足下'}',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              overflow: TextOverflow.ellipsis, //溢出显示几个点
                              maxLines: 1,
/*                                  '${LoginLogic.instance.currentUser?.content ?? '为了目标 每时每刻 砥砺前行'}',
                                  style:
                                  TextStyle(fontSize: 12, color: Colors.white),*/
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          /*Positioned(
            left: 10,
            child: TextButton.icon(
                icon:
                    Icon(Icons.settings, size: 30.0, color: Color(0xD903033F)),
                label: Text("个人中心",
                    style: TextStyle(fontSize: 20, color: Color(0xD903033F))),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 25)),
                ),
                onPressed: person),
          ),
          Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 0,
          ),
          SizedBox(
            height: 20,
          ),
          Positioned(
            left: 10,
            child: TextButton.icon(
                icon:
                    Icon(Icons.settings, size: 30.0, color: Color(0xD903033F)),
                label: Text(
                  "个人设置",
                  style: TextStyle(fontSize: 20, color: Color(0xD903033F)),
                ),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 25,
                  )),
                ),
                onPressed: setting),
          ),


          Divider(
                // color: Color(0xD0BBBB53),
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 0,
              ),*/
          ListTile(
            selected: true,
            leading: Container(
              width: 37,
              //    color: Colors.yellow,
              child: Icon(
                Icons.face,
                size: 28,
                color: Colors.black,
              ),
            ),
            title: Text(
              "个人中心",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              person();
            },
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            selected: true,
            leading: Container(
                width: 37,
                //    color: Colors.yellow,
                child: Icon(
                  Icons.create,
                  size: 28,
                  color: Colors.black,
                )),
            title: Text(
              "信息修改",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              setting();
            },
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            selected: true,
            leading: Container(
                width: 37,
                //    color: Colors.yellow,
                child: Icon(
                  Icons.event,
                  size: 28,
                  color: Colors.black,
                )),
            title: Text(
              "设定目标",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FuturePage(),
                  ),
                );
            },
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            selected: true,
            leading: Container(
                width: 37,
                //    color: Colors.yellow,
                child: Icon(
                  Icons.settings,
                  size: 28,
                  color: Colors.black,
                )),
            title: Text(
              "系统设置",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              //setting();
            },
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),


          SizedBox(
            height: 30,
          ),
          item('退出登录', () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
                (route) => route.settings.name == '/');
          }, textStyle: TextStyle(color: Colors.red, fontSize: 20)),
        ],
      )),
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
        //待办画面
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
                            image: AssetImage(cards[index % 6]),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {

                            /////////////////////
                            GlobalData.plan_name=todo.title!;
                            GlobalData.content=todo.content!;
                            GlobalData.minutes=todo.duration!~/60;
                            Navigator.pushNamed(context, '/lock_page');

                            // Navigator.pushNamed(
                            //   context,
                            //   Constant.todoDetailPage,
                            //   arguments: {
                            //     TodoDetailPage.keyId: todo.date,
                            //   },
                            // );
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
