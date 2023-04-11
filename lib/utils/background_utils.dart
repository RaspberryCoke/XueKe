import 'dart:math';

import 'package:app_entrance/res.dart';

class BackgroundUtils {
  /// 随机背景图
  static String randomBackground() {
    List<String> bgs = [
      Res.default_background_1,
      Res.default_background_2,
      Res.default_background_3,
      Res.default_background_4,
      Res.default_background_5,
      Res.default_background_6,
    ];
    return bgs[Random().nextInt(bgs.length)];
  }
}
