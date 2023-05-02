import 'dart:math';

class WordUtils {
  /// 随机文字
  static String randomword() {
    List<String> wds = [
      ' 与其仰望\n他人，不如埋头奋斗',
      ' 与其仰望\n他人，不如埋头奋斗2',
      ' 与其仰望\n他人，不如埋头奋斗3',
      ' 与其仰望\n他人，不如埋头奋斗4',
      ' 与其仰望\n他人，不如埋头奋斗5',
      ' 与其仰望\n他人，不如埋头奋斗6',
    ];
    return wds[Random().nextInt(wds.length)];
  }
}
