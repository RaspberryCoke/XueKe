import 'package:flutter/material.dart';
class TopBlankExpanded extends Expanded {
  TopBlankExpanded({
    Key? key,
    int flex = 10,
    //required Widget child,
  }) : super(
    key: key,
    flex: flex,
    //child: child,
    child: Text(''),
  );
}