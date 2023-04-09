import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'expands/top_button_expanded.dart';
import 'expands/top_blank_expanded.dart';
import 'expands/middle_timer_expanded.dart';
import 'expands/top_text_expanded.dart';
import 'expands/bottom_text_expanded.dart';
import 'expands/bottom_blank_expanded.dart';
import 'expands/bottom_button_expanded.dart';

//expands/top_button_expanded.dart.dart
class LockPage extends StatelessWidget {
  LockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

        //最外层被容器包裹，从而占满整个屏幕
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //背景装饰
          image: DecorationImage(
            image: AssetImage('assets/a.jpg'),
            fit: BoxFit.cover,
          ),
        ),


        child: Flex(
          //Flex在垂直方向上的两个子widget按1：1来占据水平空间
          direction: Axis.vertical,


          children: [
            TopButtonExpanded(child: Text('TopButtonExpanded')),
            TopTextExpanded(child:Text('TopTextExpanded')),
            TopBlankExpanded(),
            MiddleTimerExpanded(child: Text('MiddleTimerExpanded')),
            BottomTextExpanded(child: Text('BottomTextExpanded')),
            BottomBlankExpanded(),
            BottomButtonExpanded(child:Text('BottomButtonExpanded')),
          ],
        ));
  }

  void _onAdd() {}
}
