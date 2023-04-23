import 'package:tomato_clock/page/data_page.dart';
import 'package:flutter/material.dart';
import 'package:tomato_clock/page/table_events_page.dart';
import 'package:tomato_clock/page/lock_page/lock_page.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class HomePage extends StatefulWidget{
  const HomePage({super.key});

  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{
  int _currentIndex=0;

  final List<Widget> _pages=[
    TableEventsPage(),
    LockPage(),
    DataPage(),
  ];


/*  TabController tabController;

  List colors=[Colors.blue,Colors.pink,Colors.orange];

  int currentIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 3)..addListener((){
      setState(() {
        currentIndex=tabController.index;
      });
    });
  }*/
  Widget build(BuildContext context){
    return Scaffold(

      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        //fixedColor: Colors.green,
        iconSize: 35,
        currentIndex: _currentIndex,
        // 设置文字大小
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // 显示选中的文字
        showSelectedLabels: true,
        // 显示不选中时的问题
        showUnselectedLabels: true,
        // 显示选中的文字
        type: BottomNavigationBarType.fixed,

        onTap: (index){
          setState(() {
            if(index==1)
            {
              //全屏页面的跳转的实现

              Navigator.pushNamed(context, '/lock_page');
            }
            else
              _currentIndex=index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon:Icon(Icons.message_rounded), label: "待办",tooltip: ''),
          BottomNavigationBarItem(icon:Icon(Icons.lock), label: "锁屏",tooltip: ''),
          BottomNavigationBarItem(icon:Icon(Icons.data_thresholding_outlined), label: "数据",tooltip: ''),
          //BottomNavigationBarItem(icon:Icon(Icons.people), label: "用户"),
        ],
      ),
    );



  }
}