import 'dart:math';

class WordUtils {
  /// 随机文字
  static String randomword() {
    List<String> wds = [
      ' 与其仰望\n他人，不如埋头奋斗',
      ' 燃烧点燃梦想\n   搏击展翅飞翔',
      ' 要改变命运\n  首先 要改变自我',
      ' 少问生活为什么\n  多问自己凭什么',
      ' 有志者\n  自有千计万计',
      ' 懒惰就像灰尘\n再硬的铁，碰上也会生锈',
    ];
    return wds[Random().nextInt(wds.length)];
  }
}
