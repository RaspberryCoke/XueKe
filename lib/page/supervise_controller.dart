import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../logic/GlobalData.dart';

class SuperviseController{
  static bool isSupervised=false;

  static const WhetherSuperviseChannel = MethodChannel( "WhetherSupervise");
  static const PackageChangeChannel = MethodChannel( "PackageChange");
  static const ForegroundChangeChannel = MethodChannel( "ForegroundChange");
  static const NotificationChangeChannel = MethodChannel( "NotificationChange");
  static const GetPermissionChannel = MethodChannel( "GetPermission");

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
  static Future<bool> setToForeground() async {
    try {
      final bool res = await ForegroundChangeChannel.invokeMethod('setToForeground');
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
  static Future<bool> setToBackground() async {
    try {
      final bool res = await ForegroundChangeChannel.invokeMethod('setToBackground');
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
  static Future<bool> packageChange() async {
    try {//直接发送信号。逻辑处理已经在white_app_page.dart中的turnTure和turnFalse中完成
      //也就是说，已经更新了全局数据，同时也进行了持久化。
      //这个时候，只需要在java代码中直接从参数获取即可。
      List<String> allPackages=[];
      GlobalData.whitePackagesMap.forEach((key, value) {
        if(value==true)
          {
            allPackages.add(key);
          }
      });
      final bool res = await PackageChangeChannel.invokeMethod('packageChange',allPackages);
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
  static Future<bool>  notificationChange() async {
    try {

      final bool res = await NotificationChangeChannel.invokeMethod('notificationChange',GlobalData.packageFilterString);
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
  static Future<bool>  getPermission_notification() async {
    try {
      final bool res = await GetPermissionChannel.invokeMethod('notification');
      return Future.value(res);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
}