import 'package:app_entrance/logic/login_logic.dart';
import 'package:app_entrance/model/user.dart';
import 'package:app_entrance/page/constant.dart';
import 'package:app_entrance/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_entrance/login/theme_helper.dart';
import 'package:app_entrance/login/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';


class RegistrationPage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{
  String name = '';
  String account = '';
  String password = '';
  String ensurePassword = '';
  String email='';
  String phonenum='';

  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  void _back(){
    Navigator.pushReplacementNamed(context, Constant.login);
  }
  void _register() {

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('请输入密码'),
      ));
      return;
    }

    if (ensurePassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('请再次输入密码'),
      ));
      return;
    }

    if (password != ensurePassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('两次输入的密码不一致'),
      ));
      return;
    }

    if (email.isEmpty && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('请输入正确的邮箱地址'),
      ));
      return ;
    }

    User user = User(name:name,account: account, password: password);
    bool success = LoginLogic.instance.register(user);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('账号已存在'),
      ));
      return;
    }
    Navigator.pushReplacementNamed(context, Constant.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 160,
              child:
                HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
          //  SizedBox(height: 110),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 50),
/*                        Positioned(
                          left: 18.0,
                          child:
                          BackButton(
                            color: Colors.black,
                            onPressed: _back,
                          ),
                        ),*/
                        SizedBox(height: 80),
                        Container(
                          child: TextFormField(
                            validator: (val) {
                              if((val!.isEmpty)){
                                return "请输入昵称";
                              }
                              return null;
                            },
                               onChanged: (value) {
                                name = value;},
                            decoration: ThemeHelper().textInputDecoration('昵称', '请输入您的昵称'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: TextFormField(
                            validator: (val) {
                              if((val!.isEmpty)){
                                return "请输入昵称";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              account = value;
                            },
                            decoration: ThemeHelper().textInputDecoration('账号', '请输入您的账号'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            validator: (val) {
                              if((val!.isEmpty)){
                                return "请输入登入密码";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "密码", "请输入您的登入密码"),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            validator: (val) {
                              if((val!.isEmpty)){
                                return "请再次输入密码";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              ensurePassword = value;
                            },
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "密码", "请确认您的登入密码"),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: ThemeHelper().textInputDecoration("邮箱", "请输入您的邮箱"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "请输入正确的邮箱";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            onChanged: (value) {
                              phonenum = value;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                                "手机号码",
                                "请输入您的手机号码"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)){
                                return "请输入正确的手机号码";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),

                        SizedBox(height: 10.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    Text("我接受所有条款和协议.", style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Theme.of(context).errorColor,fontSize: 17,),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return '您需要接受所有条款与协议';
                            } else {
                              return null;
                            }
                          },
                        ),

                        SizedBox(height: 10.0),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "注册".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            //onPressed:_register
    onPressed: () {
    if (_formKey.currentState!.validate()) {
      if (password != ensurePassword) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('两次输入的密码不一致'),
        ));
        return;
      }

      if (email.isEmpty && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('请输入正确的邮箱地址'),
        ));
        return ;
      }

      User user = User(name:name,account: account, password: password);
      bool success = LoginLogic.instance.register(user);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('账号已存在'),
        ));
        return;
      }
      Navigator.pushReplacementNamed(context, Constant.login);
      //_register;
    }}





                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin: EdgeInsets.fromLTRB(10,20,10,20),
                          //child: Text('Don\'t have an account? Create'),
                          child: Text.rich(
                              TextSpan(
                                  children: [
                                    TextSpan(text: "已存在账号? "),
                                    TextSpan(
                                      text: '返回登录',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.pushReplacementNamed(context, Constant.login);
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                    ),
                                  ]
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}