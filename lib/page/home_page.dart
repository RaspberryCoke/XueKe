import 'package:tomato_clock/page/data_page/data_page.dart';
import 'package:flutter/material.dart';
import 'package:tomato_clock/page/history_page/history_page.dart';
import 'package:tomato_clock/page/setting_page/SettingPage.dart';
import 'package:tomato_clock/page/table_events_page.dart';

import '../colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TableEventsPage(),
    DataPage(),
    SettingPage(),
    HistoryPage(),
  ];
  Widget build(BuildContext context){
    return Scaffold(

      body: _pages[_currentIndex],
      extendBody: true, // very important as noted
      bottomNavigationBar: Container(
          //color: Colors.transparent,
          child: Padding(

              padding:
                  const EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  color:kShrinePink100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  //fixedColor: Colors.green,
                  iconSize: 35,
                  currentIndex: _currentIndex,
                  // 设置文字大小
                  selectedFontSize: 10,
                  selectedItemColor: kShrinePink400,
                  unselectedFontSize: 10,
                  // 显示选中的文字
                  showSelectedLabels: true,
                  // 显示不选中时的问题
                  showUnselectedLabels: true,
                  // 显示选中的文字
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) async {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.message_rounded),
                        label: "待办",
                        tooltip: ''),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.data_thresholding_outlined),
                      label: "数据",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "设置",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.table_rows_rounded),
                      label: "历史数据",
                    ),
                  ],
                ),
              ))),
    );
  }
}
