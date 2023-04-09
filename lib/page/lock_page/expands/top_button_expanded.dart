import 'package:flutter/material.dart';
class TopButtonExpanded extends Expanded {
  TopButtonExpanded({
    Key? key,
    int flex = 6,
    required Widget child,
  }) : super(
    key: key,
    flex: flex,
    child: child,
  );
}