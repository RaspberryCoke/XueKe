import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
