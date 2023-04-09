import 'package:flutter/material.dart';
class BottomButtonExpanded extends Expanded {
  BottomButtonExpanded({
    Key? key,
    int flex = 16,
    required Widget child,
  }) : super(
    key: key,
    flex: flex,
    child: child,
  );
}