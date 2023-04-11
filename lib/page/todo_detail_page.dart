import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_entrance/logic/main_logic.dart';
import 'package:app_entrance/logic/play.dart';
import 'package:app_entrance/res.dart';
import 'package:app_entrance/utils/background_utils.dart';

import '../model/todo.dart';

enum MusicStatus { start, pause, init, resume, complete, close }

class TodoDetailPage extends StatefulWidget {
  static const String keyId = "key_id";

  const TodoDetailPage({Key? key, this.args}) : super(key: key);
  final Map<String, dynamic>? args;

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  List<String> musics = [
    'music_box.mp3',
    'ticking_new.mp3',
    'class_ring_2.mp3',
    'wind_leaf.mp3',
    'kanoon.mp3',
    'bonfire_pure.mp3',
  ];

  List<String> musicText = [
    '音乐盒',
    '时钟滴答-Free',
    '雨声-普通版-Free',
    '雨声-无损-Free',
    '静心沉思-高清',
    '笔触书香-无损',
  ];

  List<String> musicBg = [
    Res.ic_bgm_box,
    Res.ic_bgm_clock,
    Res.ic_bgm_rain,
    Res.ic_bgm_rain2,
    Res.ic_bgm_think,
    Res.ic_bgm_bookflip,
  ];

  List<String> bgs = [
    Res.default_background_new_1,
    Res.default_background_new_2,
    Res.default_background_new_3,
    Res.default_background_new_4,
    Res.default_background_new_5,
    Res.default_background_new_6,
    Res.default_background_new_7,
  ];
  bool isDone = false;
  bool isStop = false;
  late Todo todo;
  MusicStatus type = MusicStatus.init;
  CountDownController controller = CountDownController();
  AudioPlayer player = AudioPlayer();
  Source _source = AssetSource(Play.bgMusic);
  Source _timerSource = AssetSource(Play.instance.currentPlay());
  int musicIndex = 0;
  late String backgroundPicture = BackgroundUtils.randomBackground();

  void _initAudio() async {
    await player.setSource(_source);
    player.onPlayerComplete.listen((event) {
      if (type != MusicStatus.complete && type != MusicStatus.close) {
        player.play(_source);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    int? id = widget.args?[TodoDetailPage.keyId];
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
    if (type == MusicStatus.complete) {
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
                      '默认背景音乐|白噪音',
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

  void _showOutDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('退出待办'),
              content: Text('是否退出当前任务？'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('取消')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('确定')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!isDone) {
          _showOutDialog();
        }
        return Future.value(isDone);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (!isDone) {
                _showOutDialog();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(''),
        ),
        body: Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundPicture),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.only(top: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  isDone
                      ? Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white10,
                              width: 2,
                            ),
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              '已完成',
                              style: TextStyle(
                                  fontSize: 33.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          child: CircularCountDownTimer(
                              // Countdown duration in Seconds.
                              duration: todo.duration!,

                              // Countdown initial elapsed Duration in Seconds.
                              initialDuration: 0,

                              // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                              controller: controller,

                              // Width of the Countdown Widget.
                              width: 300,

                              // Height of the Countdown Widget.
                              height: 300,

                              // Ring Color for Countdown Widget.
                              ringColor: type == MusicStatus.init
                                  ? Colors.white
                                  : Colors.white10,

                              // Ring Gradient for Countdown Widget.
                              ringGradient: null,

                              // Filling Color for Countdown Widget.
                              fillColor: Colors.white,

                              // Filling Gradient for Countdown Widget.
                              fillGradient: null,

                              // Background Color for Countdown Widget.
                              backgroundColor: Colors.transparent,

                              // Background Gradient for Countdown Widget.
                              backgroundGradient: null,

                              // Border Thickness of the Countdown Ring.
                              strokeWidth: 2,

                              // Begin and end contours with a flat edge and no extension.
                              strokeCap: StrokeCap.round,

                              // Text Style for Countdown Text.
                              textStyle: TextStyle(
                                  fontSize: 33.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),

                              // Format for the Countdown Text.
                              textFormat: CountdownTextFormat.MM_SS,

                              // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                              isReverse: true,

                              // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                              isReverseAnimation: true,

                              // Handles visibility of the Countdown Text.
                              isTimerTextShown: true,

                              // Handles the timer start.
                              autoStart: false,

                              // This Callback will execute when the Countdown Starts.
                              onStart: () {

                              },
                              // This Callback will execute when the Countdown Ends.
                              onComplete: () {
                                isDone = true;
                                if (!mounted) return;
                                setState(() {
                                  type = MusicStatus.complete;
                                  setSource(type, res: _timerSource);
                                  MainLogic.instance.addCompleteEvent(todo);
                                });
                              }),
                        ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    todo.title ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isDone) return;
                        _showMusicCard();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Image.asset(
                              Res.ic_music,
                              width: 32,
                              height: 32,
                            ),
                          ),
                          Container(
                            child:
                                Image.asset(Res.ic_action_keyboard_arrow_down),
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 70),
                    GestureDetector(
                      onTap: () {
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
                      child: Icon(
                          type == MusicStatus.start ||
                                  type == MusicStatus.resume
                              ? Icons.pause_circle_filled_outlined
                              : type == MusicStatus.complete
                                  ? Icons.stop_circle_outlined
                                  : Icons.play_circle_outline,
                          size: 30,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
