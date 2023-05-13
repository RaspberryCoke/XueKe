import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tomato_clock/db/TodoDB.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/debug.dart';

import '../../colors.dart';

class MyTodoPage extends StatefulWidget {
  const MyTodoPage({Key? key}) : super(key: key);

  @override
  MyTodoPageState createState() {
    return MyTodoPageState();
  }
}

class MyTodoPageState extends State<MyTodoPage> {
  String _todoName = "";
  String _todoDescription = "";
  int _minutes = 0;
  String _wrong_string = '';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "添加待办",
          style: TextStyle(color: Colors.black),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.clear,
              size: 33,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        constraints: BoxConstraints.expand(),
        child: ListView(
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(50, 50),
            ),
            Text(
              "      输入待办名称：",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'wanghongziti',
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox.fromSize(
                  size: Size(50, 10),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 250,
                    minWidth: 250,
                    maxHeight: 100,
                    minHeight: 100,
                  ),
                  child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "待办名称",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      maxLength: 8,
                      maxLines: 1,
                      onChanged: (text) {
                        _todoName = text;
                      },
                      onSubmitted: (text) {
                        _todoName = text;
                      }),
                )
              ],
            ),
            Text(
              "      输入待办描述：",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'wanghongziti',
              ),
            ),
            Row(children: <Widget>[
              SizedBox.fromSize(
                size: Size(50, 10),
              ),
              Container(
                  constraints: BoxConstraints(
                    maxWidth: 250,
                    minWidth: 250,
                    maxHeight: 100,
                    minHeight: 100,
                  ),
                  child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "待办描述",
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey)),
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      maxLength: 10,
                      maxLines: 1,
                      onChanged: (text) {
                        _todoDescription = text;
                      },
                      onSubmitted: (text) {
                        _todoDescription = text;
                      }))
            ]),
            Text(
              "      输入时长：",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'wanghongziti',
              ),
            ),
            Row(children: <Widget>[
              SizedBox.fromSize(
                size: Size(50, 10),
              ),
              Container(
                  constraints: BoxConstraints(
                    maxWidth: 250,
                    minWidth: 250,
                    maxHeight: 100,
                    minHeight: 100,
                  ),
                  child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "时长",
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey)),
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      maxLength: 3,
                      maxLines: 1,
                      onChanged: (text) {
                        infoprint(text);
                        _minutes = int.parse(text);
                      },
                      onSubmitted: (text) {
                        _minutes = int.parse(text);
                      }
                      // 其他属性
                      ))
            ]),
      Container(
        constraints: BoxConstraints(
          // maxWidth: 50,
          // minWidth: 50,
          maxHeight: 50,
          minHeight: 50,
        ),
        child:
            Row(children: <Widget>[
              SizedBox.fromSize(
                size: Size(100, 50),
              ),
              ElevatedButton(
                child: Text('提交'),
                onPressed: () async {
                  //先判断数据的合法性，是否重复
                  bool _is_repeated = false;

                  for (var value in MainLogic.todoList) {
                    if (value.title == _todoName) {
                      _is_repeated = true;
                      break;
                    }
                  }
                  if (_is_repeated == true) {
                    errprint("title is repeated!");
                    setState(() {
                      _wrong_string = "title is repeated!";
                    });
                    return;
                  }
                  if (_minutes == 0) {
                    errprint("time is zero!");
                    setState(() {
                      _wrong_string = "time is zero!";
                    });
                    return;
                  }

                  //向数据库中插入数据
                  int res = await TodoDB()
                      .insert(_todoName, _minutes, _todoDescription);
                  if (res <= 0) {
                    errprint("向数据库插入失败");
                    return;
                  }

                  //从数据库中检索出来最大的id，就是刚才插入的一项
                  int _id = await TodoDB().getTopID();

                  //更改全局数据
                  infoprint("add todo success!");
                  infoprint(
                      "id:$_id, title:$_todoName, minutes:$_minutes, description:$_todoDescription");
                  MainLogic.todoList
                      .add(Todo(_id, _todoName, _minutes, _todoDescription));
                  MainLogic.refreshNotifier.value = MainLogic.todoList;

                  //返回上一级页面
                  Navigator.pop(context);
                })],)
        ,),
            Text(_wrong_string),
          ],
        ),
      ),
    );
  }
}
