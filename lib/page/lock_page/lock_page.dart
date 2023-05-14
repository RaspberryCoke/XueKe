import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:tomato_clock/db/HistoryDB.dart';
import 'package:tomato_clock/debug.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/page/lock_page/wordart.dart';
import '../../db/TodoDB.dart';
import '../../logic/main_logic.dart';
import 'package:tomato_clock/res.dart';
import 'package:tomato_clock/utils/background_utils.dart';
import 'package:tomato_clock/utils/word_utils.dart';
import 'expands/top_button_expanded.dart';
import 'expands/top_blank_expanded.dart';
import 'expands/middle_timer_expanded.dart';
import 'expands/top_text_expanded.dart';
import 'expands/bottom_text_expanded.dart';
import 'expands/bottom_button_expanded.dart';
import 'package:tomato_clock/page/supervise_controller.dart';


class LockPage extends StatefulWidget {

  const LockPage({Key? key}) : super(key: key);

  @override
  LockPageState createState() => LockPageState();
}

class LockPageState extends State<LockPage> {
  List<String> musicText = [
    '钢琴轻音乐',
    '雨声',
    '火焰声',
  ];

  List<String> wds = [
    ' 与其仰望\n他人，不如埋头奋斗',
    ' 燃烧点燃梦想\n   搏击展翅飞翔',
    ' 要改变命运\n  首先 要改变自我',
    ' 少问生活为什么\n  多问自己凭什么',
    ' 有志者\n  自有千计万计',
    ' 懒惰就像灰尘\n再硬的铁，碰上也会生锈',
  ];

  final AudioPlayer audioPlayer = AudioPlayer();

  late CountDownController controller;
  late CircularCountDownTimer _circular;
  late int _remain_time=MainLogic.minutes * 60;
  late bool _is_running;
  int _image_random = Random().nextInt(7)+1;//1-8
  int _string_random = Random().nextInt(6-1);//0-5
  int _selectedValue=3;
  bool _admit_music=true;
  String _music = '雨声';

  @override
  initState() {
    super.initState();
    debugPrint("LockPage initState");

    //设置循环播放
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        audioPlayer.play(AssetSource(MainLogic.musicToDir[_music]!));
      });
    });


    _is_running = true;
    controller = CountDownController();
    _circular = CircularCountDownTimer(
      isReverseAnimation: true,
      isReverse: true,
      width: 300,
      height: 300,
      duration: _remain_time,
      strokeWidth: 10,
      fillColor: Colors.green[300]!,
      ringColor: Colors.white.withOpacity(0.5),
      autoStart: true,
      controller: controller,
      textStyle: TextStyle(
          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
      onComplete: () {
        //设置运行状态
        _is_running = false;
        if (!mounted) return;
        //记录成功的结果
        //MainLogic.instance.addCompleteEvent(todo);
        //切换回主界面
        Navigator.pushReplacementNamed(context,  '/home_page');
        //发送通知
        SuperviseController.stopSupervise();
        SuperviseController.stopPeriodNotification();
        if(MainLogic.historyid<0){
          errprint("lock_page.dart: onComplete: ()  : MainLogic.historyid<0");
        }else{
          HistoryDB().updateHistoryIdToSucceed(MainLogic.historyid);
        }
      },
      onStart: ()async {
        _is_running = true;
        audioPlayer.play(AssetSource(MainLogic.musicToDir[_music]!));
        SuperviseController.startSupervise();
        SuperviseController.periodNotification(_remain_time);
        //先向history数据库中插入一条失败的条目，如果之后成功完成任务，再修改为成功的状态。
        int res=await HistoryDB().insert(MainLogic.todoid,MainLogic.title,MainLogic.minutes,
          DateTime.now(),MainLogic.content,0,'');
        if(res==0){
          errprint("lock_page.dart:int res=await HistoryDB().insert wrong!");
        }
        MainLogic.historyid=await HistoryDB().getTopID();
      },
    );
  }



  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    debugPrint("LockPage build, whetherSupervise = true");
    return WillPopScope(
        child: Container(
            //最外层被容器包裹，从而占满整个屏幕
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              //背景装饰
              image: DecorationImage(
                image: AssetImage("assets/lockImages/$_image_random.jpg"),
                fit: BoxFit.cover,
                alignment: Alignment.center,
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
                    //随机文字
                    child: word_art(text: wds[_string_random])),
                Spacer(flex: 5),
                MiddleTimerExpanded(child: _circular),
                Spacer(flex: 10),
                BottomTextExpanded(
                    child: Text(
                      MainLogic.title,
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
                            debugPrint("LockPage clock, resume");
                            controller.resume();
                            _is_running = true;
                            SuperviseController.isSupervised = true;
                            SuperviseController.startSupervise();
                            SuperviseController.periodNotification(_remain_time);
                            if(_admit_music==true)
                              audioPlayer.resume();
                          }
                          else {
                            debugPrint("LockPage clock, pause");
                            _is_running = false;
                            controller.pause();
                            SuperviseController.isSupervised = false;
                            SuperviseController.stopSupervise();
                            if(_admit_music==true)
                              audioPlayer.pause();
                          }},
                        icon: Icon(
                          Icons.pause_circle_outline,
                          color: Colors.white,
                          size: 35,
                          shadows: [
                            Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 2
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed:()async {
                            bool res=await showdialog();
                            if(res==true) Navigator.pop(context);
                            },
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
                        onPressed: () {
                          showMusicDialog();
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
                      IconButton(
                        onPressed:() async{
                          Navigator.pushNamed(context, '/start_white_app');
                        },
                        icon: const Icon(
                          Icons.app_blocking_rounded,
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
                            SuperviseController.isSupervised = false;
                            Navigator.pop(context, true);
                            SuperviseController.stopSupervise();
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

  void showMusicDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              height: 350,
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
                      height: 250,
                      decoration: BoxDecoration(
                        //color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child:ListView(
                        children: <Widget>[
                          RadioListTile(
                            title: Text('静音'),
                            value: 1,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                Navigator.pop(context);
                                _admit_music=false;
                                audioPlayer.stop();
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('钢琴轻音乐'),
                            value: 2,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                Navigator.pop(context);
                                _admit_music=true;
                                _music='钢琴轻音乐';
                                audioPlayer.play(AssetSource(MainLogic.musicToDir[_music]!));
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('雨声'),
                            value: 3,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                Navigator.pop(context);
                                _admit_music=true;
                                _music='雨声';
                                audioPlayer.play(AssetSource(MainLogic.musicToDir[_music]!));
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text('火焰声'),
                            value: 4,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                Navigator.pop(context);
                                _admit_music=true;
                                _music='火焰声';
                                audioPlayer.play(AssetSource(MainLogic.musicToDir[_music]!));
                              });
                            },
                          ),
                        ],
                      ) ,
                  )
                ],
              ),
            ),
          );
        });
  }



}
