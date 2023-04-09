import 'package:flutter/material.dart';
class TopTextExpanded extends Expanded {
  TopTextExpanded({
    Key? key,
    int flex = 7,
    required Text child,
  }) : super(
    key: key,
    flex: flex,
    child: child,
  );
}