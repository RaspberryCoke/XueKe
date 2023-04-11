import 'package:app_entrance/logic/login_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_entrance/login/forgot_password_page.dart';
import 'package:app_entrance/login/registration_page.dart';
import 'package:app_entrance/login/header_widget.dart';
import 'package:app_entrance/login/theme_helper.dart';
import 'package:app_entrance/page/constant.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String account = '';
  String password = '';

  double _headerHeight = 280;
  Key _formKey = GlobalKey<FormState>();

  void _login() {
    if (account.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('请输入账号'),
      ));
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('请输入密码'),
      ));
      return;
    }
    bool success = LoginLogic.instance.checkAccount(account, password);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('账号或密码错误'),
      ));
      return;
    }
    Navigator.pushReplacementNamed(context, Constant.homePage);
  }

 void initState() {
    super.initState();
  }


    Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                //color: Colors.green,
                child: HeaderWidget(_headerHeight,true,Icons.login_rounded),
              ),
              Text(
                '学刻 你学习的好伙伴',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                    Text(
                    'Welcome to 学刻',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextField(
                                  onChanged: (value) {
                                   account = value;},
                                  decoration: ThemeHelper().textInputDecoration('账号', '请输入您的账号'),
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextField(
                                  obscureText: true,
                                  onChanged: (value){
                                    password = value;
                                  },
                                  decoration: ThemeHelper().textInputDecoration('密码', '请输入您的密码'),
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),


                              ),
                              SizedBox(height: 15.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10,0,10,20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                  },
                                  child: Text( "忘记密码?", style: TextStyle( color: Colors.grey, ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('登录'.toUpperCase(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ),
                                  onPressed: _login,

                                    //Navigator.pushReplacementNamed(context, Constant.homePage);
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));

                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(text: "还未注册账号? "),
                                          TextSpan(
                                            text: '创建账号',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                Navigator.pushReplacementNamed(context, Constant.register);
                                                //Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                              },
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                            ],
                          )
                      ),
                  ],
                ),
              )
              )
            ],
          ),
        ),
      );
    }
}