import 'dart:ui';
import 'package:tomato_clock/page/constant.dart';
import 'package:tomato_clock/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:/glassmorphism.dart';
import 'package:tomato_clock/utils/glass_widget.dart';
import 'package:tomato_clock/logic/login_logic.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => PersonPageState();
}

class PersonPageState extends State<PersonPage> {
  void back(){
    Navigator.pushReplacementNamed(context, Constant.homePage);
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // automaticallyImplyLeading : true,
        // actions: <Widget>[
        leading:
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed:
            back
        ),
        //  ],
        title: Text('个人中心'),

      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/bg2.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            SafeArea(
              child: Center(
                child: GlassWidget(
                  width: width * 0.9,
                  height: height,
                  borderRadius: 30,
                  blur: 20,
                  linearGradientBeginOpacity: 0.3,
                  linearGradientEndOpacity: 0.2,
                  borderGradientBeginOpacity: 0.5,
                  borderGradientEndOpacity: 0.02,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        buildUser(),
                       // buildInfo(),
                        SizedBox(
                          height: 30,
                        ),
                    //    buildProgress(),
                    //    buildMessage(),
                   //     buildWork(),
                    //    buildBottom(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
     }
  Widget buildUser() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      buildName(),
      buildPic(),
    ],
  );
  Widget buildName() => Container(
    padding: EdgeInsets.only(left: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 170,
            child:Text(
              '${LoginLogic.instance.currentUser?.name ?? ''}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: Color(0xFFeb3c63),
                fontSize: 35,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            )
        ),
      SizedBox(height: 20,),
      Container(
          width: 170,
          child:Text(
            '简介：${LoginLogic.instance.currentUser?.content ?? '千里之行，始于足下'}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Color(0xbb7ca21b),
              fontSize: 13,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          )
      )

      ],
    ),
  );
  Widget buildPic() => Padding(
    padding: const EdgeInsets.only(right: 15),
    child: Container(
      padding: EdgeInsets.all(5),
      height: 110,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffec2a4e).withOpacity(0.8),
              Color(0xFFfbb055).withOpacity(0.8)
            ]),
      ),
      child: Container(
        width: 90,
    //    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            LoginLogic.instance.currentUser?.avatar ?? Res.person,
            fit: BoxFit.cover,
      //      height: 90,
     //       width: 90,
          ),
        ),
      ),
    ),
  );

}