import 'package:flutter/material.dart';
class TopTextExpanded extends Expanded {
  TopTextExpanded({
    Key? key,
    int flex = 17,
    required  child,
  }) : super(
    key: key,
    flex: flex,
    child: child,
  );
}