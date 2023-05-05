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
import 'package:flutter/cupertino.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        //backgroundColor: Colors.white,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 33,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            // ListTileMoreCustomizable(
            //   title: Text("白名单"),
            //   onTap: (details) {////////////////////
            //     Navigator.pushNamed(context, '/white_app_page');
            //   },
            // ),
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
                "白名单",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/white_app_page');

              },
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
