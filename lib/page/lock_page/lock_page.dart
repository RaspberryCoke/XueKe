import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/logic/play.dart';
import 'package:tomato_clock/model/todo.dart';
import 'package:tomato_clock/page/constant.dart';
import 'package:tomato_clock/page/lock_page/wordart.dart';
import 'package:tomato_clock/res.dart';
import 'package:tomato_clock/utils/background_utils.dart';
import 'package:tomato_clock/utils/word_utils.dart';
import 'expands/top_button_expanded.dart';
import 'expands/top_blank_expanded.dart';
import 'expands/middle_timer_expanded.dart';
import 'expands/top_text_expanded.dart';
import 'expands/bottom_text_expanded.dart';
import 'expands/bottom_blank_expanded.dart';
import 'expands/bottom_button_expanded.dart';
import 'package:tomato_clock/page/back_to_app.dart';
import 'package:tomato_clock/logic/GlobalData.dart';


enum MusicStatus { start, pause, init, resume, complete, close }

class LockPage extends StatefulWidget {

  static const String keyId = "key_id";
  const LockPage({Key? key, this.args}) : super(key: key);
  final Map<String, dynamic>? args;

  @override
  State<LockPage> createState() => _lock_page_state();
}

class _lock_page_state extends State<LockPage> {
  List<String> musics = [
    'yinyuehe.mp3',
    'fire.mp3',
    'yusheng.mp3',
    'guzheng.mp3',
    'xishui.mp3',
    'senlin.mp3',
  ];

  List<String> musicText = [
    '音乐盒',
    '火焰声',
    '下雨声',
    '古筝音',
    '溪水声',
    '森林声',
  ];

  List<String> musicBg = [
    Res.ic_bgm_box,
    Res.ic_bgm_fire,
    Res.ic_bgm_rain,
    Res.ic_bgm_guzheng,
    Res.ic_bgm_xishui,
    Res.ic_bgm_senlin,
  ];

  List<String> bgs = [
    Res.default_background_1,
    Res.default_background_2,
    Res.default_background_3,
    Res.default_background_4,
    Res.default_background_5,
    Res.default_background_6,
    Res.default_background_7,
  ];

  bool isDone = false;
  bool isStop = false;
  late Todo todo;/////////
  MusicStatus type = MusicStatus.init;
 // CountDownController controller = CountDownController();

  AudioPlayer player = AudioPlayer();

  Source _source = AssetSource(Play.t1);//初始音乐改为t1
  Source _timerSource = AssetSource(Play.instance.currentPlay());
  int musicIndex = 0;
   String backgroundPicture = BackgroundUtils.randomBackground();
   String word = WordUtils.randomword();

  void _initAudio() async {
    await player.setSource(_source);
    player.onPlayerComplete.listen((event) {
      if (type != MusicStatus.complete && type != MusicStatus.close) {
        player.play(_source);
      }
    });
  }


  @override
  initState() {
    super.initState();

    int? id = widget.args?[LockPage.keyId];
    if (id != null) {
      todo = MainLogic.instance.getTodoById(id)!;
    }
    _initAudio();
    Future.delayed(Duration.zero, () {
      controller.start();
      setSource(type);
      setState(() {
        type = MusicStatus.start;
      });
    });

    _remain_time = false;
    _is_running = false;
    controller = CountDownController();

/////////////////////////
    _circular = CircularCountDownTimer(
      isReverseAnimation: true,
      isReverse: true,
      width: 300,
      height: 300,
      duration: todo.duration!,///////
      initialDuration: 0,////////
      strokeWidth: 10,
      fillColor: Colors.green[300]!,
      ringColor: Colors.white.withOpacity(0.5),
      autoStart: true,
      controller: controller,
      textStyle: TextStyle(
          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
      onComplete: () {
        _is_running = false;
        isDone = true;
        if (!mounted) return;
        setState(() {
          type = MusicStatus.complete;
          setSource(type, res: _timerSource);
          MainLogic.instance.addCompleteEvent(todo);

          player.stop();

          Navigator.pushReplacementNamed(context, Constant.homePage) ;
        });
      },
    );
  }


  Future<void> setSource(MusicStatus type, {Source? res}) async {
    Source source = res ?? _source;
    if (type == MusicStatus.init) {
      await player.play(source);
    }
    if (type == MusicStatus.pause) {
      await player.resume();
    }
    if (type == MusicStatus.resume || type == MusicStatus.start) {
      await player.pause();
    }
    if (type == MusicStatus.complete) {//循环
      await player.setSource(source);
      await player.stop();
      await player.play(source);
    }
    if (type == MusicStatus.close) {
      await player.stop();
    }
  }

  int getCurrentDuration() {
    DateTime dateTime = DateFormat("ms").parse(controller.getTime());
    return dateTime.minute * 60 + dateTime.second;
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  void _showMusicCard() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            width: 170,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '默认背景音乐|音乐盒',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: musics.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              musicIndex = index;
                              Source _source = AssetSource(musics[index]);//获取音乐的索引
                              player.play(_source);
                              // Navigator.pop(context);

                              if (type == MusicStatus.init) {
                                type = MusicStatus.start;
                              }
                              setSource(MusicStatus.init);
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            foregroundDecoration: BoxDecoration(//选择该音乐
                              color: musicIndex != index
                                  ? Colors.white70
                                  : Colors.transparent,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(musicBg[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                musicText[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
    );
  }


  late CountDownController controller;
  late CircularCountDownTimer _circular;
  late bool _remain_time;
  late bool _is_running;

  @override
  Widget build(BuildContext context) {
    BackToApp.is_set_to_keep_screen_on = true;

    return WillPopScope(
        child: Container(
            //最外层被容器包裹，从而占满整个屏幕
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              //背景装饰
              image: DecorationImage(
                image: AssetImage(backgroundPicture),
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
                TopTextExpanded(//随机文字
                    child: word_art(text: word)),
                Spacer(flex: 5),
                MiddleTimerExpanded(child: _circular),
                Spacer(flex: 10),
                BottomTextExpanded(
                    child: Text(
                      todo.title ?? "",
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
                          controller.pause();
                          _is_running = false;
                          if (isDone && !isStop) {
                            isStop = true;
                            type = MusicStatus.close;
                            setSource(type);
                            return;
                          }
                          if (!mounted) return;
                          if (type == MusicStatus.init) {
                            controller.start();
                            setSource(type);
                            type = MusicStatus.start;
                          } else if (type == MusicStatus.start ||
                              type == MusicStatus.resume) {
                            controller.pause();
                            setSource(type);
                            type = MusicStatus.pause;
                          } else if (type == MusicStatus.pause) {
                            controller.resume();
                            setSource(type);
                            type = MusicStatus.resume;

                          } else if (type == MusicStatus.complete) {
                            type = MusicStatus.close;
                            setSource(type);
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          type == MusicStatus.start ||
                              type == MusicStatus.resume
                              ? Icons.pause_circle_outline:
                          type == MusicStatus.complete
                        ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline,
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
                          onPressed: () async {
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
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Column(children: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                    BackToApp.is_set_to_keep_screen_on = false;
                                                  },
                                                  child: Text(
                                                    "退出倒计时",
                                                    style: TextStyle(
                                                        color: Colors.black, fontSize: 18),
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
                                                    style: TextStyle(
                                                        color: Colors.black, fontSize: 18),
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
                              Navigator.pop(context);
                            } else return;

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

                        onPressed:() {/////音乐按钮
                          if (isDone) return;
                          _showMusicCard();
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
        onWillPop: () async {
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  BackToApp.is_set_to_keep_screen_on = false;
                                },
                                child: Text(
                                  "退出倒计时",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
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
        });
  }
}
