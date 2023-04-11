import 'package:flutter/material.dart';
class MiddleBlankExpanded extends Expanded {
  MiddleBlankExpanded({
    Key? key,
    int flex = 15,
    //required Widget child,
  }) : super(
    key: key,
    flex: flex,
    //child: child,
    child: Text(''),
  );
}