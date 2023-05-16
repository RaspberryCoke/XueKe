import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomato_clock/colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  initState() {
    debugPrint("SettingPageState initState");
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("SettingPageState dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                constraints: const BoxConstraints(
                  minHeight: 45,
                  maxHeight: 45,
                  minWidth: 130,
                  maxWidth: 130,
                ),
                child: Center(
                    child: Text(
                      '设置',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    )))),
        //backgroundColor: Colors.white,
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
                "应用白名单",
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
                "通知白名单",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/notification_page');
              },
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
