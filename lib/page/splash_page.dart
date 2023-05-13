import 'package:flutter/material.dart';
import 'package:tomato_clock/debug.dart';
import 'dart:async';
import 'package:tomato_clock/logic/main_logic.dart';

class SplashPage extends StatefulWidget {
   const SplashPage({Key? key}) : super(key: key);
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _opacity=0;

  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity=1;
      });
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if(MainLogic.userInfo.uid==''){
        Navigator.pushReplacementNamed(context, '/QQLoginPageState');
      }else{
        infoprint("have login");
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
     return Container(
       child:  Column(
           children:<Widget> [
             SizedBox(height: 200),
             Container(
               height:140,
               width: 300,
             child: Container(
               child: Text("学刻",
                 textAlign: TextAlign.center,
                 style: TextStyle(
                  fontSize: 80,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "liu",
                ),
               )
             ),
           ),
             SizedBox(height: 130),
           Container(
             child:
             AnimatedOpacity(
                opacity: _opacity.toDouble(),
               duration: Duration(milliseconds: 1500),
                child:Image.asset("assets/newImages/school.png",fit:BoxFit.cover),
              ),
             height:200,
             width: 200,
             ),
           ]
         ),
     );
  }
}
