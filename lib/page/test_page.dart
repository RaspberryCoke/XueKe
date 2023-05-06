import 'dart:developer';
import 'dart:ui';
import 'package:flutter_accessibility_service/accessibility_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:tomato_clock/logic/GlobalData.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);
  @override
  TestPageState createState()
  {
    return TestPageState();
  }
}

class TestPageState extends State<TestPage> {
  //lists=[];
  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
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
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Check Accessibility Permission'),
          onPressed: () async {
            final bool status = await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
            if (status) {
              print('Accessibility permission is granted.');
            } else {
              print('Accessibility permission is not granted.');
              final bool res = await FlutterAccessibilityService.requestAccessibilityPermission();
              FlutterAccessibilityService.accessStream.listen((event) {
                log("Current Event: $event");
              });
            }
              },
        ),
      ),
    );
  }
}