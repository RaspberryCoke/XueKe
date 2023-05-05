import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:tomato_clock/page/lock_page/wordart.dart';
import 'expands/top_button_expanded.dart';
import 'expands/top_blank_expanded.dart';
import 'expands/middle_timer_expanded.dart';
import 'expands/top_text_expanded.dart';
import 'expands/bottom_text_expanded.dart';
import 'expands/bottom_blank_expanded.dart';
import 'expands/bottom_button_expanded.dart';
import 'package:tomato_clock/page/supervise_controller.dart';
import 'package:tomato_clock/logic/GlobalData.dart';

class LockPage extends StatefulWidget {
  const LockPage({Key? key}) : super(key: key);

  @override
  LockPageState createState() => LockPageState();
}

class LockPageState extends State<LockPage> {
  @override
  initState() {
    super.initState();
    _remain_time = false;
    _is_running = false;
    controller = CountDownController();
    _circular = CircularCountDownTimer(
      isReverseAnimation: true,
      isReverse: true,
      width: 300,
      height: 300,
      duration: GlobalData.minutes * 60,
      strokeWidth: 10,
      fillColor: Colors.green[300]!,
      ringColor: Colors.white.withOpacity(0.5),
      autoStart: true,
      controller: controller,
      textStyle: TextStyle(
          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
      onComplete: () {
        _is_running = false;
      },
    );
  }

  late CountDownController controller;
  late CircularCountDownTimer _circular;
  late bool _remain_time;
  late bool _is_running;

  @override
  Widget build(BuildContext context) {
    SuperviseController.whetherSupervise = true;

    return WillPopScope(
        child: Container(
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
            //整个界面的灵活布局
            child: Flex(
              direction: Axis.vertical,
              children: [
                TopBlankExpanded(),
                TopButtonExpanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                      Icon(
                        Icons.ios_share_outlined,
                        color: Colors.white,
                        size: 30,
                        shadows: [
                          Shadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 2),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ])),
                TopButtonExpanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      SizedBox(
                        width: 50,
                      ),
                      Icon(
                        Icons.format_quote_rounded,
                        color: Colors.white,
                        size: 45,
                        shadows: [
                          Shadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 2),
                        ],
                      ),
                    ])),
                TopTextExpanded(
                    child: word_art(text: '              与其仰望\n他人，不如埋头奋斗')),
                Spacer(flex: 5),
                MiddleTimerExpanded(child: _circular),
                Spacer(flex: 10),
                BottomTextExpanded(
                    child: Text(
                  GlobalData.planName,
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black45,
                          offset: Offset(2, 2),
                          blurRadius: 2),
                    ],
                  ),
                )),
                Spacer(flex: 5),
                BottomButtonExpanded(
                    child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        //注意：这是一个判断句，如果是true，就显示这个按钮，如果是false，就显示另一个按钮
                        onPressed:() async {
                          if(_is_running == false)
                          {
                            controller.resume();
                            _is_running = true;
                          }
                          else {
                            _is_running = false;
                            controller.pause();
                          }
                        },
                        icon: Icon(
                          Icons.pause_circle_outline,
                          color: Colors.white,
                          size: 35,
                          shadows: [
                            Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 2),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed:showdialog,
                          icon: Icon(
                            Icons.stop_rounded,
                            color: Colors.white,
                            size: 35,
                            shadows: [
                              Shadow(
                                  color: Colors.black45,
                                  offset: Offset(2, 2),
                                  blurRadius: 2),
                            ],
                          )),
                      IconButton(
                        onPressed:() {
                         },
                        icon: const Icon(
                          Icons.music_note_rounded,
                          color: Colors.white,
                          size: 35,
                          shadows: [
                            Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            )),
        onWillPop:showdialog);
  }
  Future<bool> showdialog() async {
    bool? res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white),
              padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '请确定是否要退出倒计时',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 100,
                      decoration: BoxDecoration(
                        //color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                            SuperviseController.whetherSupervise = false;
                          },
                          child: Text(
                            "退出倒计时",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            "取消",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ]))
                ],
              ),
            ),
          );
        });
    if (res == true) {
      return true;
    } else
      return false;
  }
}
