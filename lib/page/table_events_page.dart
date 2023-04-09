import 'package:flutter/material.dart';
import 'package:app_entrance/res.dart';
import 'package:app_entrance/page/todo_page.dart';

class TableEventsPage extends StatefulWidget {
  const TableEventsPage({Key? key}) : super(key: key);

  @override
  State<TableEventsPage> createState() => _TableEventsPageState();
}

class _TableEventsPageState extends State<TableEventsPage> {

  double _xOffset = 0.0;
  double _yOffset = 0.0;

  List<String> cards = [
    Res.new_card_bg_1,
    Res.new_card_bg_2,
  ];

  void _showAddTodoDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Size size = MediaQuery.of(context).size;
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
                    accountName: Text("大包子",
                      style: TextStyle(fontSize: 16, color: Colors.black),),
                    accountEmail: Text("千里之行 始于足下",
                      style: TextStyle(fontSize: 13, color: Colors.black),),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://tse2-mm.cn.bing.net/th/id/OIP-C.j9by_1c7kEqMmgUf6klzwgHaFp?w=250&h=193&c=7&r=0&o=5&dpr=1.3&pid=1.7"
                      ),
                    ),
                    decoration: BoxDecoration(//背景
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://tse3-mm.cn.bing.net/th/id/OIP-C.Ih2_mBebzjZ8kEjgzXJjoAHaEo?w=297&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7"),
                            fit: BoxFit.cover)),

                    /*decoration: const BoxDecoration(
                        //color: Colors.yellow,
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://tse3-mm.cn.bing.net/th/id/OIP-C.Ih2_mBebzjZ8kEjgzXJjoAHaEo?w=297&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7"),
                            fit: BoxFit.cover)),
                    child: Column(
                      children: const [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                "https://tse2-mm.cn.bing.net/th/id/OIP-C.j9by_1c7kEqMmgUf6klzwgHaFp?w=250&h=193&c=7&r=0&o=5&dpr=1.3&pid=1.7"),
                          ),
                          title: Text(
                            "包子",
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                        )
                      ],
                    ),*/
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
          Divider(),
        ],
      )),


      floatingActionButton: Stack(
        children: [
          Positioned(
            right: _xOffset,
            bottom: _yOffset,
            child:FloatingActionButton.extended(
              icon: Icon(Icons.add),
              onPressed: () {

                _showAddTodoDialog();

              },
              label: Text(
                "创建待办",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              //ontouch: () {
                setState(() {
                  // _xOffset -= details.delta.dx;
                  //_yOffset -= details.delta.dy;
                  _xOffset = (_xOffset - details.delta.dx).clamp(0, 180);
                  _yOffset = (_yOffset - details.delta.dy).clamp(0, 577);
                });
             // };
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
