import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomato_clock/logic/GlobalData.dart';

import '../../db/WhitePackageDB.dart';
import '../supervise_controller.dart';

class StartWhiteAppPage extends StatefulWidget {
  const StartWhiteAppPage({Key? key}) : super(key: key);

  @override
  StartWhiteAppState createState() {
    return StartWhiteAppState();
  }
}

class StartWhiteAppState extends State<StartWhiteAppPage> {
  List<ListTile> lists = [];

  @override
  initState() {
    debugPrint(" StartWhiteAppPage initState");
    super.initState();
    GlobalData.whiteAppsMap.forEach((key, value) {
      if (value == true&&key!="学刻") {
        lists.add(ListTile(
          title: Text(key),
          trailing: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                DeviceApps.openApp(GlobalData.appNameToPackageName[key]!);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text("打开")),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("白名单"),
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
      body: ListView(children: lists),
    );
  }

  @override
  void dispose() {
    debugPrint(" StartWhiteAppPage dispose");
    super.dispose();
  }
}
