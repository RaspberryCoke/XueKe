import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'expands/top_button_expanded.dart';
import 'expands/middle_blank_expanded.dart';
import 'expands/top_blank_expanded.dart';
import 'expands/middle_timer_expanded.dart';
import 'expands/top_text_expanded.dart';
import 'expands/bottom_text_expanded.dart';
import 'expands/bottom_blank_expanded.dart';
import 'expands/bottom_button_expanded.dart';

class LockPage extends StatelessWidget {
  LockPage({Key? key,}) : super(key: key);
  CountDownController controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    return Container(

        //最外层被容器包裹，从而占满整个屏幕
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          //背景装饰
          image: DecorationImage(
            image: AssetImage('assets/newImages/colorful0001.png'),
            fit: BoxFit.cover,
          ),
        ),


        child: Flex(
          direction: Axis.vertical,


          children: [
            TopBlankExpanded(),
            TopButtonExpanded(child: Text('TopButtonExpanded')),
            TopTextExpanded(child:Text('TopTextExpanded')),
            MiddleBlankExpanded(),
            MiddleTimerExpanded(child: CircularCountDownTimer(
              isReverseAnimation: true,
              isReverse: true,
              width: 300,
              height: 300,
              duration: 60,
              strokeWidth: 25,
              fillColor: Colors.lightGreen,
              ringColor: Colors.white.withOpacity(0.5),
              autoStart: true,
              controller: controller,
              onComplete: () {
                controller.restart();
              },
            )),
            BottomTextExpanded(child: Text('')),
            BottomBlankExpanded(),
            BottomButtonExpanded(child:Container(
              width: double.infinity,
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)),

                ],
              ),
            )
            )
          ],
        ));
  }
  void _onAdd() {}
}
