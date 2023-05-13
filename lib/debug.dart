import 'package:flutter/cupertino.dart';

void errprint(String err) {
  debugPrint('\x1B[31m$err\x1B[0m');
}

void warnprint(String warn) {
  debugPrint('\x1B[35m$warn\x1B[0m');
}

void infoprint(String info) {
  debugPrint('\x1B[32m$info\x1B[0m');
}