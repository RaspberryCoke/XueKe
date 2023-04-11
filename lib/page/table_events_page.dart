import 'package:app_entrance/logic/login_logic.dart';
import 'package:app_entrance/logic/main_logic.dart';
import 'package:app_entrance/model/todo.dart';
import 'package:app_entrance/page/change_password_page.dart';
import 'package:app_entrance/page/constant.dart';
import 'package:app_entrance/page/event.dart';
import 'package:app_entrance/page/login.dart';
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
                fontSize: 16,
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
                height: 150,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Res.person_bg),
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
                          margin: EdgeInsets.only(left: 40, right: 20, top: 30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              LoginLogic.instance.currentUser?.avatar ?? Res.person,
                              height: 90,
                              width: 90,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 35),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  '昵称：${LoginLogic.instance.currentUser?.name ?? ''}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                 // '昵称：${LoginLogic.instance.currentUser?.name ?? ''}',
                                  /*style:
                                  TextStyle(fontSize: 14, color: Colors.white),*/
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 8),
                                child: Text(
                                  '${LoginLogic.instance.currentUser?.content ?? '千里之行，始于足下'}',
                                  style: TextStyle(fontSize: 13, color: Colors.black),

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
              //TextButton.icon(onPressed: onPressed, icon: icon, label: label),
              item('修改昵称', () async {
                var success = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return Changename();
                    }));
                if (success != null && success) {
                  setState(() {});
                }
              }),
              item('修改头像', () async {
                var success = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return ChangeAvatar();
                    }));
                if (success != null && success) {
                  setState(() {});
                }
              }),
              item('修改简介', () async {
                var success = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return ChangeContent();
                    }));
                if (success != null && success) {
                  setState(() {});
                }
              }),
              item('修改密码', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangePasswordPage();
                }));
              }),
              item('退出登录', () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                        (route) => route.settings.name == '/');
              }, textStyle: TextStyle(color: Colors.red, fontSize: 16)),


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


      body: Column(//待办画面
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


//修改头像
class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({Key? key}) : super(key: key);

  @override
  State<ChangeAvatar> createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  List<String> list = [
    Res.random_avator1,
    Res.random_avator2,
    Res.random_avator3,
  ];
  String? avatar = LoginLogic.instance.currentUser?.avatar;
  late int index = list.indexOf(avatar ?? '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '修改头像',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Color(0xFF5789c2),
          actions: [
            TextButton(
              onPressed: () {
                LoginLogic.instance.currentUser?.avatar = avatar;
                LoginLogic.instance.saveUser(LoginLogic.instance.currentUser!);
                Navigator.pop(context, true);
              },
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 0;
                    avatar = list[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(
                        color: avatar == Res.random_avator1
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    Res.random_avator1,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 1;
                    avatar = list[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(
                        color: avatar == Res.random_avator2
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    Res.random_avator2,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 2;
                    avatar = list[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(
                        color: avatar == Res.random_avator3
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    Res.random_avator3,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

//修改简介
class ChangeContent extends StatefulWidget {
  const ChangeContent({Key? key}) : super(key: key);

  @override
  State<ChangeContent> createState() => _ChangeContentState();
}

class _ChangeContentState extends State<ChangeContent> {
  String? content = LoginLogic.instance.currentUser?.content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '修改简介',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Color(0xFF5789c2),
          actions: [
            TextButton(
              onPressed: () {
                LoginLogic.instance.currentUser?.content = content;
                LoginLogic.instance.saveUser(LoginLogic.instance.currentUser!);
                Navigator.pop(context, true);
              },
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    hintText: '输入简介',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.black12),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    content = value;
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

//修改昵称
class Changename extends StatefulWidget {
  const Changename({Key? key}) : super(key: key);

  @override
  State<Changename> createState() => _ChangenameState();
}

class _ChangenameState extends State<Changename> {
  String? name = LoginLogic.instance.currentUser?.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '修改昵称',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Color(0xFF5789c2),
          actions: [
            TextButton(
              onPressed: () {
                LoginLogic.instance.currentUser?.name = name;
                LoginLogic.instance.saveUser(LoginLogic.instance.currentUser!);
                Navigator.pop(context, true);
              },
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    hintText: '输入昵称',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.black12),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
            ],
          ),
        ));
  }
}