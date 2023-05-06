import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../logic/GlobalData.dart';

class SuperviseController{
  static const WhetherSuperviseChannel = MethodChannel( "WhetherSupervise");
  static const PackageChangeChannel = MethodChannel( "PackageChange");
  static const BackToApp = MethodChannel( "BackToApp");
  static bool whetherSupervise=false;
  static Future<bool> startSupervise() async {
    try {
      final bool res = await WhetherSuperviseChannel.invokeMethod('startSupervise');
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
  static Future<bool> stopSupervise() async {
    try {
      final bool res = await WhetherSuperviseChannel.invokeMethod('stopSupervise');
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
  static Future<bool> packageChange() async {
    try {//直接发送信号。逻辑处理已经在white_app_page.dart中的turnTure和turnFalse中完成
      //也就是说，已经更新了全局数据，同时也进行了持久化。
      //这个时候，只需要在java代码中直接从数据库中获取数据即可。
      final bool res = await PackageChangeChannel.invokeMethod('packageChange');
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
  static Future<bool> backToApp() async{
    try {
      final bool res = await BackToApp.invokeMethod('backToApp');
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
}