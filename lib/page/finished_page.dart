import 'package:flutter/material.dart';
import 'package:tomato_clock/page/constant.dart';


class FinishedPage extends StatefulWidget {
  const FinishedPage({Key? key}) : super(key: key);

  @override
  State<FinishedPage> createState() => _FinishedPageState();
}

class _FinishedPageState extends State<FinishedPage> {

  void back() {
    Navigator.pushReplacementNamed(context, Constant.homePage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: back),
        title: Text('已完成待办'),
      ),
      body: Center(
        child: Text('这是已完成待办界面'),
      ),
    );
  }
}