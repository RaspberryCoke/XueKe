import 'package:tomato_clock/logic/main_logic.dart';

class Play {
  static const String _playKey = 'play';

/*  static const String t1 = 't1.mp3';
  static const String t2 = 't2.mp3';
  static const String t3 = 't3.mp3';
  static const String t4 = 't4.mp3';
  static const String t5 = 't5.mp3';*/
  static const String t1 = 'music_box.mp3';
  static const String t2 = 'ticking_new.mp3';
  static const String t3 = 'class_ring_2.mp3';
  static const String t4 = 'wind_leaf.mp3';
  static const String t5 = 'kanoon.mp3';
  static const String t6 = 'bonfire_pure.mp3';
  static const String bgMusic = 'mp3_1.mp3';

  static const List<String> ts = [t1, t2, t3, t4, t5,t6];

  String? cPlay;

  String currentPlay() {
    if (cPlay == null) {
      cPlay = MainLogic.instance.sharedPreferences.getString(_playKey);
    }
    return cPlay ?? t1;
  }

  Play._();

  static final Play play = Play._();

  static Play get instance => play;

  void setCurrentPlay(String t) {
    cPlay = t;
    MainLogic.instance.sharedPreferences.setString(_playKey, t);
  }
}
