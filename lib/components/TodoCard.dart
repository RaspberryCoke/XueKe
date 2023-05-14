import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tomato_clock/logic/main_logic.dart';

import '../db/TodoDB.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final String content;
  final int time;

  const TodoCard({
    Key? key,
    required this.title,
    required this.content,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async{
          //开始计时
          MainLogic.title=title;
          MainLogic.content=content;
          MainLogic.minutes=time;
          MainLogic.todoid=await TodoDB().queryIdByTitle(MainLogic.title);
          Navigator.pushNamed(context, '/lock_page');
        },
        onLongPress: () async{
          //询问删除
          bool res=await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('确认删除？'),
                content: Text('您确定要删除吗？'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // 点击取消按钮，关闭对话框
                      Navigator.of(context).pop(false);
                    },
                    child: Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      // 点击确认按钮，关闭对话框并返回true
                      Navigator.of(context).pop(true);
                    },
                    child: Text('确认'),
                  ),
                ],
              );
            },
          );
          //处理结果
          if(!res) {
            return;
          }else{
            //准备删除
            //1.删除内存中的
            int len=MainLogic.todoList.length;
            for(int i=0;i<len;i++) {
              if (MainLogic.todoList[i].title==(title)) {
                MainLogic.todoList.removeAt(i);
                break;
              }
            }
            MainLogic.refreshNotifier.value=MainLogic.todoList;
            //2.删除数据库的
            TodoDB().deleteTitleName(title);
            return;
          }

        },
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
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/todoCardBackground/${Random().nextInt(25) + 1}.jpg',
                ),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(
                        left: 10, right: 16, top: 20, bottom: 16),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'wanghongziti'),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 5),
                  child: Text(
                    time.toString() + "分钟",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'wanghongziti'),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: Text(
                    content,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
