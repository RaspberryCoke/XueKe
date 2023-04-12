import 'package:app_entrance/page/constant.dart';
import 'package:app_entrance/page/login.dart';
import 'package:flutter/material.dart';
import 'package:app_entrance/logic/login_logic.dart';
import 'package:app_entrance/page/change_password_page.dart';
import 'package:app_entrance/res.dart';

/// 我的设置页面
class MineSettingPage extends StatefulWidget {
  const MineSettingPage({Key? key}) : super(key: key);

  @override
  State<MineSettingPage> createState() => _MineSettingPageState();
}

class _MineSettingPageState extends State<MineSettingPage> {
  void back(){
    Navigator.pushReplacementNamed(context, Constant.homePage);
  }
  Widget item(String title, VoidCallback callback, {TextStyle? textStyle}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Text(
          title,
          style: textStyle ??
              TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text('设置'),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
/*          Positioned(
            top: 50,
            child: BackButton(
              color: Colors.white,
            ),
          ),*/
          Container(
            width: double.infinity,
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
               // image: AssetImage(
                  image: new ExactAssetImage('assets/person_bg.png'),
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  fit: BoxFit.cover,
              //),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          LoginLogic.instance.currentUser?.avatar ?? Res.person,
                          height: 90,
                          width: 90,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '昵称：${LoginLogic.instance.currentUser?.name ?? ''}',
                              overflow: TextOverflow.ellipsis,//溢出显示几个点
                              maxLines: 2,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              // '昵称：${LoginLogic.instance.currentUser?.name ?? ''}',
                              /*style:
                                  TextStyle(fontSize: 14, color: Colors.white),*/
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 8),
                            child: Text(
                              '${LoginLogic.instance.currentUser?.content ?? '千里之行，始于足下'}',
                              style: TextStyle(fontSize: 13, color: Colors.black),
                              overflow: TextOverflow.ellipsis,//溢出显示几个点
                              maxLines: 1,
/*                                  '${LoginLogic.instance.currentUser?.content ?? '为了目标 每时每刻 砥砺前行'}',
                                  style:
                                  TextStyle(fontSize: 12, color: Colors.white),*/
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
          item('修改昵称', () async {
            var success = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return Changename();
                }));
            if (success != null && success) {
              setState(() {});
            }
          }),
          item('修改头像', () async {
            var success = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return ChangeAvatar();
                }));
            if (success != null && success) {
              setState(() {});
            }
          }),
          item('修改简介', () async {
            var success = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return ChangeContent();
                }));
            if (success != null && success) {
              setState(() {});
            }
          }),
          item('修改密码', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangePasswordPage();
            }));
          }),

        ],
      ),
    );
  }
}


//修改头像
class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({Key? key}) : super(key: key);

  @override
  State<ChangeAvatar> createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  List<String> list = [
    Res.person,
    Res.person2,
    Res.person3,
    Res.person4
  ];
  String? avatar = LoginLogic.instance.currentUser?.avatar;
  late int index = list.indexOf(avatar ?? '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '修改头像',
            style: TextStyle(fontSize: 16),
          ),
          //  backgroundColor: Color(0xFF5789c2),
          actions: [
            TextButton(
              onPressed: () {
                LoginLogic.instance.currentUser?.avatar = avatar;
                LoginLogic.instance.saveUser(LoginLogic.instance.currentUser!);
                Navigator.pop(context, true);
              },
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 0;
                    avatar = list[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(80),
                    border: Border.all(
                        color: avatar == Res.person
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    Res.person,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Spacer(),


              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 1;
                    avatar = list[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(80),
                    border: Border.all(
                        color: avatar == Res.person2
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    Res.person2,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Spacer(),


              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 2;
                    avatar = list[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        color: avatar == Res.person3
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    Res.person3,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],

          ),
        ));
  }
}




//修改简介
class ChangeContent extends StatefulWidget {
  const ChangeContent({Key? key}) : super(key: key);

  @override
  State<ChangeContent> createState() => _ChangeContentState();
}

class _ChangeContentState extends State<ChangeContent> {
  String? content = LoginLogic.instance.currentUser?.content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '修改简介',
            style: TextStyle(fontSize: 16),
          ),
          //      backgroundColor: Color(0xFF5789c2),
          actions: [
            TextButton(
              onPressed: () {
                LoginLogic.instance.currentUser?.content = content;
                LoginLogic.instance.saveUser(LoginLogic.instance.currentUser!);
                Navigator.pop(context, true);
              },
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    //    isCollapsed: true,
                    hintText: '输入简介',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.black12),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    content = value;
                  },
                ),
              ),
            ],
          ),
        ));
  }
}


//修改昵称
class Changename extends StatefulWidget {
  const Changename({Key? key}) : super(key: key);

  @override
  State<Changename> createState() => _ChangenameState();
}

class _ChangenameState extends State<Changename> {
  String? name = LoginLogic.instance.currentUser?.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '修改昵称',
            style: TextStyle(fontSize: 16),
          ),
          //      backgroundColor: Color(0xFF5789c2),
          actions: [
            TextButton(
              onPressed: () {
                LoginLogic.instance.currentUser?.name = name;
                LoginLogic.instance.saveUser(LoginLogic.instance.currentUser!);
                Navigator.pop(context, true);
              },
              child: Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    //          isCollapsed: true,
                    hintText: '输入昵称',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.black12),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
            ],
          ),
        ));
  }
}