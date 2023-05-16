import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tomato_clock/logic/main_logic.dart';

import '../db/TodoDB.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String content;
  final int time;
  final DateTime starttime;
  final Color backgroundColor;
  final int succeed;

  const HistoryCard({
    Key? key,
    required this.title,
    required this.content,
    required this.time,
    required this.starttime,
    required this.backgroundColor,
    required this.succeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 15,left: 10, right: 10,bottom: 15),
    child: Card(
      borderOnForeground: false,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),

      child: Container(
        //constraints: BoxConstraints.expand(),
        constraints: BoxConstraints(
          minHeight: 170,
          maxHeight: 170,
          minWidth: 150,
          maxWidth: 150,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: backgroundColor,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(
                  left: 10, right: 16, top: 15, bottom: 5),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'wanghongziti'),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 5, bottom: 5),
                  child: Text(
                    starttime.toString().substring(0, 16),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'wanghongziti'),
                  ),
                ),
                Container(

                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 5, bottom: 5),
                  child: Text(
                    time.toString() + "分钟",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'wanghongziti'),
                  ),
                ),

                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child:
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(succeed==1?Icons.check:Icons.close,
                      color:succeed==1?Colors.green:Colors.red, size: 30)),

                )
              ],
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 5, bottom: 16),
              child: Text(
                content,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontFamily: 'wanghongziti'),
              ),
            ),
          ],
        ),
      ),
      //     ),
      //   ],
      // ),
    ));
  }
}
