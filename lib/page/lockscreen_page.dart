import 'package:flutter/material.dart';

class LockPage extends StatefulWidget{
  const LockPage ({super.key});

  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage>{
  Widget build(BuildContext context){
    return const Center(
      child: Text("锁屏页面"),
    );
  }
}