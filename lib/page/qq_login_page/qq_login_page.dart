import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tencent_kit/tencent_kit.dart';
import 'package:tomato_clock/qq_api/model/tencent_api_resp.dart';
import 'package:tomato_clock/qq_api/model/tencent_unionid_resp.dart';
import 'package:tomato_clock/qq_api/tencent_api.dart';
const String _kTencentAppID = '102050200';
//const String _kUniversalLink = 'your tencent universal link'; // 可选项目

class QQLoginPage extends StatefulWidget {
  const QQLoginPage({Key? key}) : super(key: key);

  @override
  State<QQLoginPage> createState() => QQLoginPageState();
}

class QQLoginPageState extends State<QQLoginPage> {
  int _opacity=0;
  late final StreamSubscription<TencentResp> _respSubs;

  TencentLoginResp? _loginResp;
  void initState() {
    super.initState();
    _respSubs = TencentKitPlatform.instance.respStream().listen(_listenLogin);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity=1;
      });
    });
  }

  @override
  void dispose() {
    _respSubs.cancel();
    super.dispose();
  }

  void _listenLogin(TencentResp resp) {
    if (resp is TencentLoginResp) {
      _loginResp = resp;
      final String content = 'login openid: ${resp.openid} \n accessToken：${resp.accessToken}';
      _showTips('登录', content);
    } else if (resp is TencentShareMsgResp) {
      final String content = 'share: ${resp.ret} - ${resp.msg}';
      _showTips('分享', content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
          children:<Widget> [
            SizedBox(height: 250),
            // Container(
            //   height:140,
            //   width: 300,
            //   child: Container(
            //       child: Text("学刻",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 80,
            //           color: Colors.black,
            //           fontWeight: FontWeight.bold,
            //           fontFamily: "liu",
            //         ),
            //       )
            //   ),
            // ),
            //SizedBox(height: 60),
            Container(
              child:
              AnimatedOpacity(
                opacity: _opacity.toDouble(),
                duration: Duration(milliseconds: 1500),
                child:Image.asset("assets/newImages/qq_symbol.png",fit:BoxFit.cover),
              ),

              height:200,
              width: 180,
            ),


            SizedBox(height: 130),
            Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10),

                ),
              constraints: BoxConstraints(
                minWidth: 200,
                maxWidth: 200,
                maxHeight: 50,
                minHeight: 50,
              ),
              child:
              AnimatedOpacity(
                opacity: _opacity.toDouble(),
                duration: Duration(milliseconds: 500),
                child:Center(
                  child:TextButton(

                    onPressed: ()async {
                      print("aaaaaaaaaaaaaaaaaaaaaaaaaaa");
                      //1
                      await TencentKitPlatform.instance
                          .setIsPermissionGranted(granted: true);
                      //2
                      await TencentKitPlatform.instance.registerApp(
                        appId: _kTencentAppID,); // universalLink: _kUniversalLink);

                      //3.检查环境安装情况
                      //不知道TIM的作用
                      bool qq_is_installed = await TencentKitPlatform.instance
                          .isQQInstalled();
                      bool TIM_is_installed = true; //await TencentKitPlatform.instance.isTIMInstalled();
                      String content = '';
                      print('qq_is_installed: $qq_is_installed');
                      print('TIM_is_installed: $TIM_is_installed');
                      if (qq_is_installed == false ||
                          TIM_is_installed == false) {
                        if (!qq_is_installed && !TIM_is_installed)
                          content = 'QQ和TIM都未安装';
                        else if (!qq_is_installed)
                          content = 'QQ未安装';
                        else if (!TIM_is_installed)
                          content = 'TIM未安装';
                        _showTips('环境检查', content);
                        return;
                      }
                      //4
                      TencentKitPlatform.instance.login(
                        scope: <String>[TencentScope.kGetSimpleUserInfo],);
                      //5
                      print('login _loginResp: ${_loginResp?.isSuccessful}');
                      if ((_loginResp?.isSuccessful ?? false) &&
                          !(_loginResp!.isExpired ?? true)) {

                        final TencentUserInfoResp userInfo = await TencentApi.getUserInfo(
                            appId: _kTencentAppID, openid: _loginResp!.openid!,
                            accessToken: _loginResp!.accessToken!,);

                        if (userInfo.isSuccessful) {
                          _showTips('用户信息',
                              '用户昵称：${userInfo.nickname} '
                                  '用户性别：${userInfo.gender} '
                                  '用户城市和省份：${userInfo.city} - ${userInfo.province} '
                                  'QQ头像的url：${userInfo.figureurlQq} '
                                  '返回信息：${userInfo.msg}:'
                                  '返回码：${userInfo.ret}  '
                          );
                        } else {
                          _showTips(
                              '用户信息', '${userInfo.ret} - ${userInfo.msg}');
                        }
                      }

                      },
                    child: Text("QQ登录",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        backgroundColor: Colors.lightBlue ,
                        //fontWeight: FontWeight.bold,
                        //fontFamily: "liu",
                    ),
                  ),)
                ),
              ),

              height:200,
              width: 200,
            ),
          ]
      ),
    );
  }
  void _showTips(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}



