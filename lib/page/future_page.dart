import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:app_entrance/logic/main_logic.dart';
import 'package:app_entrance/model/todo.dart';
import 'package:intl/intl.dart';
import 'package:app_entrance/page/todo_page.dart';
import 'package:app_entrance/res.dart';

/// 未来倒计时
class FuturePage extends StatefulWidget {
  const FuturePage({Key? key}) : super(key: key);

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  void _showAddTodoDialog() async {
    var result = await showGeneralDialog(
      barrierDismissible: false,
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Material(
          child: Center(child: AddFuturePage()),
          color: Colors.black26,
        );
      },
    );
    if (result == true) {
      setState(() {});
    }
  }

  void _showDeleteTodoDialog(Todo todo) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('是否删除该倒计时？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                MainLogic.instance.deleteFutureTodo(todo);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //  backgroundColor: Color(0xFF5789c2),
        elevation: 0,
        title: const Text('未来倒计时'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              _showAddTodoDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: MainLogic.instance.futureTodoList.length,
        itemBuilder: (context, index) {
          Todo todo = MainLogic.instance.futureTodoList[index];
          return GestureDetector(
            onLongPress: () {
              _showDeleteTodoDialog(todo);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(Res.bg_study_room_3),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          '${todo.title ?? ''}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '还剩',
                        style: TextStyle(
                            color: Colors.white, fontSize: 12, height: 2),
                      ),
                      Text(
                        '${todo.lessDay()}',
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                      Text(
                        '天',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${todo.content}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      Expanded(
                          child: Center(
                        child: Text(
                          '已过${todo.goDay()}/${todo.lessDay()}天',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(todo.date!))}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddFuturePage extends StatefulWidget {
  const AddFuturePage({Key? key}) : super(key: key);

  @override
  State<AddFuturePage> createState() => _AddFuturePageState();
}

class _AddFuturePageState extends State<AddFuturePage> {
  String _title = '';
  String _content = '';
  int _date = 0;

  void _showDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime(2026, 12, 31),
      locale: const Locale('zh'),
    ).then((value) {
      if (value != null) {
        setState(() {
          _date = value.millisecondsSinceEpoch;
        });
      }
    });
  }

  void _add() {
    if (_title.isEmpty) {
      EasyLoading.showError('请输入标题');
      return;
    }
    if (_content.isEmpty) {
      EasyLoading.showError('请输入描述');
      return;
    }
    if (_date == 0) {
      EasyLoading.showError('请选择目标时间');
      return;
    }
    var todo = Todo(
      title: _title,
      content: _content,
      date: _date,
      insertDate: DateTime.now().millisecondsSinceEpoch,
    );
    MainLogic.instance.addFutureTodoEvent(todo);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFe3e3e3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const Text('添加未来倒计时'),
                const Spacer(),
                GestureDetector(
                  onTap: _add,
                  child: Image.asset(
                    Res.ic_action_confirm,
                    width: 26,
                    height: 26,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    Res.ic_close,
                    width: 24,
                    height: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                const Text(
                  '标题:',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: '请输入标题',
                 //     isCollapsed: true,
                      isDense: true,
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black26),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _title = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                const Text(
                  '描述:',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: '请输入描述',
                //      isCollapsed: true,
                      isDense: true,
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black26),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _content = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFf7ede7),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: GestureDetector(
                  onTap: () {
                    _showDate(context);
                  },
                  child: Text(
                    _date == 0
                        ? '设定目标日期'
                        : '${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(_date))}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFd89a84),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}
