import 'package:flutter/services.dart';

class BackToApp{
  static const the_channel = MethodChannel( "BackToApp");
  static bool is_set_to_keep_screen_on=false;
  static Future<bool> back_to_app() async {
    try {
      final bool res = await the_channel.invokeMethod('take_to_top');
      return Future.value(res);
    } on PlatformException catch (e) {
      print("back_to_app error: ${e.message}");
      return Future.value(false);
    }
  }
}