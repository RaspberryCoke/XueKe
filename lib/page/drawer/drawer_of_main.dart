import 'package:flutter/material.dart';
import 'package:tomato_clock/logic/main_logic.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.memory(MainLogic.userInfo.picture).image,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.65), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 20, top: 60),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.memory(
                          MainLogic.userInfo.picture,
                          height: 97,
                          width: 97,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 60),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            MainLogic.userInfo.name,
                            overflow: TextOverflow.ellipsis, //溢出显示几个点
                            maxLines: 2,
                            style: TextStyle(
                                fontFamily: 'draw',
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        ListTile(
          selected: true,
          leading: Container(
            width: 37,
            child: Icon(
              Icons.face,
              size: 28,
              color: Colors.black,
            ),
          ),
          title: Text(
            "应用白名单",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          onTap: () {
              Navigator.pushNamed(context, '/white_app_page');
          },
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
        ),
        SizedBox(
          height: 5,
        ),
        ListTile(
          selected: true,
          leading: Container(
              width: 37,
//    color: Colors.yellow,
              child: Icon(
                Icons.create,
                size: 28,
                color: Colors.black,
              )),
          title: Text(
            "通知过滤",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/notification_page');

          },
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 5,
        ),
//         ListTile(
//           selected: true,
//           leading: Container(
//               width: 37,
// //    color: Colors.yellow,
//               child: Icon(
//                 Icons.settings,
//                 size: 28,
//                 color: Colors.black,
//               )),
//           title: Text(
//             "系统设置",
//             style: TextStyle(
//                 color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           onTap: () {
//             Navigator.pushNamed(context, '/setting_page');
// //setting();
//           },
//           trailing: Icon(Icons.keyboard_arrow_right_rounded),
//         ),

//for test

//         ListTile(
//           selected: true,
//           leading: Container(
//               width: 37,
// //    color: Colors.yellow,
//               child: Icon(
//                 Icons.settings,
//                 size: 28,
//                 color: Colors.black,
//               )),
//           title: Text(
//             "test",
//             style: TextStyle(
//                 color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           onTap: () {
//             Navigator.pushNamed(context, '/test_page');
// //setting();
//           },
//           trailing: Icon(Icons.keyboard_arrow_right_rounded),
//         ),

        SizedBox(
          height: 30,
        ),
      ],
    ));
  }
}
