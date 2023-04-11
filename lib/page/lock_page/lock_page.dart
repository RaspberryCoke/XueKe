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
import 'package:tomato_clock/page/back_to_app.dart';


class LockPage extends StatelessWidget {
  LockPage({
    Key? key,
  }) : super(key: key);
  CountDownController controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(child:

      Container(

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
              TopTextExpanded(child: Text('TopTextExpanded')),
              MiddleBlankExpanded(),
              MiddleTimerExpanded(
                  child: CircularCountDownTimer(
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
              BottomButtonExpanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed:(){
                            //
                            BackToApp.is_set_to_keep_screen_on=true;
                          },
                          icon: Icon(Icons.start),
                        )
                        ,
                        IconButton(
                            onPressed: () async {
                              bool? res = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Text("Select an option"),
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text("close"),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                            BackToApp.is_set_to_keep_screen_on=false;
                                          },
                                          child: Text("cancel"),
                                        ),
                                      ],
                                    );
                                  });
                              if (res == true) {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                      ],
                    ),
                  ))
            ],
          ))

          , onWillPop: () async {
            bool? res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text("Select an option"),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, true);
                          BackToApp.is_set_to_keep_screen_on=false;
                        },
                        child: Text("close"),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text("cancel"),
                      ),
                    ],
                  );
                });
            return false;
          });
  }


}


