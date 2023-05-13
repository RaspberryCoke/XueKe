import 'dart:io';
import 'dart:ui';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  TestPageState createState() {
    return TestPageState();
  }
}

class TestPageState extends State<TestPage> {
  //lists=[];
  @override
  initState() {
    super.initState();
  }
  @override
  void dispose() {
    debugPrint('TestPage  dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // 图片和文本部分
            Container(
              height: 250,
              child: Stack(
                children: [
                  // 图片
                  Image.network(
                    'https://picsum.photos/200/300',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // 文本
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Drawer Header',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 列表部分
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Item 1'),
                  ),
                  ListTile(
                    title: Text('Item 2'),
                  ),
                  ListTile(
                    title: Text('Item 3'),
                  ),
                  // 在此添加更多的列表项
                ],
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text("test白名单"),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 33,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
              //Navigator.pop(context);
            },
          );
        }),
      ),
      body: Center(
        child: Column(children: <Widget>[
          ElevatedButton(
            child: Text(''),
            onPressed: ()  {
              DeviceApps.openApp("com.tencent.mm");
              sleep(Duration(seconds: 3));
              DeviceApps.openApp("com.hebut.tomato_clock");
            },
          ),
        ]),
      ),
    );
  }
}
