import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:app_entrance/logic/main_logic.dart';
import 'package:app_entrance/model/todo.dart';
import 'package:app_entrance/res.dart';
class TodoPage extends StatefulWidget {
  const TodoPage({Key? key, this.date}) : super(key: key);
  final int? date;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool get isEdit => widget.date != null;
  Todo? todo;
  String _title = '';
  String _content = '';
  int duration = 60;
  int _date = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
  }

  void _showDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime(2022, 12, 31),
      locale: const Locale('zh'),
    ).then((value) {
      if (value != null) {
        setState(() {
          _date = value.millisecondsSinceEpoch;
        });
      }
    });
  }

  Future<int> _showTimePicker(BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
        color: Colors.transparent,
        child: SliderView(duration: duration),
      ),
    );
  }

  String get _dateString {
    if (_date == 0) {
      return '请选择日期';
    }
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(_date));
  }

  void _updateTodo() async {
    if (_title.isEmpty) {
      return EasyLoading.showToast('请输入标题');
    }
    Todo todo = Todo(
      title: _title,
      content: _content,
      date: _date,
      duration: duration * 60,
    );
    await MainLogic.instance.addTodo(todo);
    Navigator.pop(context);
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
                const Text('添加待办'),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _updateTodo();
                  },
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
                      isCollapsed: true,
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
                  '时长:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      var value = await _showTimePicker(context);
                      if (value != duration) {
                        setState(() {
                          duration = value;
                        });
                      }
                    },
                    child: TextField(
                      controller: TextEditingController(
                          text: duration == 0 ? '请选择时长' : '$duration分钟'),
                      enabled: false,
                      style: TextStyle(
                        fontSize: 14,
                        color: duration == 0 ? Colors.black26 : Colors.black,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        isDense: true,
                        hintStyle:
                        TextStyle(fontSize: 14, color: Colors.black26),
                        border: InputBorder.none,
                        hintText: '请选择时长',
                      ),
                    ),
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
                  '日期:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showDate(context);
                    },
                    child: TextField(
                      controller: TextEditingController(
                          text: _date == 0 ? '请选择日期' : _dateString),
                      enabled: false,
                      style: TextStyle(
                        fontSize: 14,
                        color: _date == 0 ? Colors.black26 : Colors.black,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        isDense: true,
                        hintStyle:
                        TextStyle(fontSize: 14, color: Colors.black26),
                        border: InputBorder.none,
                        hintText: '请选择日期',
                      ),
                    ),
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
                  '备注:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _content),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: '请输入备注',
                      isCollapsed: true,
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
        ],
      ),
    );
  }
}

class SliderView extends StatefulWidget {
  const SliderView({Key? key, required this.duration}) : super(key: key);
  final int duration;

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  top: 5,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, value);
                    },
                    child: Image.asset(
                      Res.ic_close,
                      width: 18,
                      height: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                      child: Text(
                        '请拖动时长',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(height: 30),
            Slider(
              value: value.toDouble(),
              min: 1,
              max: 250,
              divisions: 250,
              label: '$value',
              onChanged: (double value) {
                setState(() {
                  this.value = value.toInt();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
