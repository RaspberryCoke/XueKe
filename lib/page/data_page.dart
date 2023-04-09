import 'package:flutter/material.dart';
class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Widget build(BuildContext context){
    return const Center(
      child: Text("数据页面"),
    );
  }
}