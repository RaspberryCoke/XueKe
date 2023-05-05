import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
    try {
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