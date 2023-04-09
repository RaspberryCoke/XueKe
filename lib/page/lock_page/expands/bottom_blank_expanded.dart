import 'package:flutter/material.dart';
class BottomBlankExpanded extends Expanded {
  BottomBlankExpanded({
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