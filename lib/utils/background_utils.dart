import 'dart:math';

import 'package:tomato_clock/res.dart';

class BackgroundUtils {
  /// 随机背景图
  static String randomBackground() {
    List<String> bgs = [
      Res.default_background_new_8,
      Res.default_background_new_1,
      Res.default_background_new_2,
      Res.default_background_new_3,
      Res.default_background_new_4,
      Res.default_background_new_5,
      Res.default_background_new_6,
      Res.default_background_new_7,
    ];
    return bgs[Random().nextInt(bgs.length)];
  }
}
