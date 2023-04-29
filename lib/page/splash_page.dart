import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:tomato_clock/page/constant.dart';
import 'package:tomato_clock/res.dart';
import 'package:tomato_clock/page/login.dart';
import 'dart:async';
import 'package:tomato_clock/page/constant.dart';

class SplashPage extends StatefulWidget {
   const SplashPage({Key? key}) : super(key: key);

   //final String title;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  void initState()
  {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacementNamed(context, Constant.login);
    });
  }

  //打开app的延时显示
  /*bool _isVisible = false;
  _SplashScreenState(){

    new Timer(const Duration(milliseconds: 2000), (){
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      });
    });

    new Timer(
        Duration(milliseconds: 10),(){
      setState(() {
        _isVisible = true; // Now it is showing fade effect and navigating to Login page
      });
    }
    );*/


  @override
  Widget build(BuildContext context) {
     return Container(

       decoration: new BoxDecoration(
         gradient: new LinearGradient(
           colors: [
             Color(0xFFE8E53E),
             Color(0xFF91E18C),
           ],
           //colors: [Theme.of(context).accentColor,Theme.of(context).primaryColor:Colors.Colors.white],
             begin: const FractionalOffset(0,0),
             end: const FractionalOffset(1, 0),
             stops: [0,1],
           tileMode: TileMode.clamp,
         )
       ),
       child: AnimatedOpacity(
         opacity: 1, duration: Duration(milliseconds: 1000),
         child: Center(
           child: Container(
           height:140,
           width: 140,
             child: Container(
               child: ClipOval(
                 child: Image.asset('assets/logo2.png'),
               ),
             ),
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: Colors.white,
               boxShadow:[
                 BoxShadow(
                   color: Colors.amber.withOpacity(0.3),
                   blurRadius: 2,
                   offset: Offset(5,3),
                   spreadRadius: 2
                 )
               ]
             ),

           )
         ),
       ),
     );
  }
}
