import 'package:flutter/material.dart';
class MiddleTimerExpanded extends Expanded {
  MiddleTimerExpanded({
    Key? key,
    int flex = 35,
    required Widget child,
  }) : super(
    key: key,
    flex: flex,
    child: child,
  );
}