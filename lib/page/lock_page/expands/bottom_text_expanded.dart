import 'package:flutter/material.dart';
class BottomTextExpanded extends Expanded {
  BottomTextExpanded({
    Key? key,
    int flex = 12,
    required child,
  }) : super(
    key: key,
    flex: flex,
    child: child,
  );
}