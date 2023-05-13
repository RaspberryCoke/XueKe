// import 'package:flutter/material.dart';
// import 'package:tomato_clock/logic/login_logic.dart';
// //import 'package:pomodoro_clock/page/constant.dart';
// import 'package:tomato_clock/res.dart';
//
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String account = '';
//   String password = '';
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _login() {
//     if (account.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('请输入账号'),
//       ));
//       return;
//     }
//     if (password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('请输入密码'),
//       ));
//       return;
//     }
//     bool success = LoginLogic.instance.checkAccount(account, password);
//     if (!success) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('账号或密码错误'),
//       ));
//       return;
//     }
//    // Navigator.pushReplacementNamed(context, Constant.homePage);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               Res.image_login_bg,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 100),
//               Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(25),
//                       child: Image.asset(
//                         Res.logo2,
//                         width: 50,
//                         height: 50,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       '时刻 助你每时每刻保持专注',
//                       style: TextStyle(fontSize: 10, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 padding: EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                       child: Row(
//                         children: [
//                           const Text(
//                             '账号:',
//                             style:
//                             TextStyle(fontSize: 16, color: Colors.black54),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               decoration: const InputDecoration(
//                                 isDense: true,
//                                 isCollapsed: true,
//                                 hintText: '输入账号',
//                                 hintStyle: TextStyle(
//                                     fontSize: 16, color: Colors.black12),
//                                 border: InputBorder.none,
//                               ),
//                               onChanged: (value) {
//                                 account = value;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(height: 1),
//                     Container(
//                       padding: EdgeInsets.only(bottom: 14, top: 14),
//                       child: Row(
//                         children: [
//                           const Text(
//                             '密码:',
//                             style:
//                             TextStyle(fontSize: 16, color: Colors.black54),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               obscureText: true,
//                               keyboardType: TextInputType.visiblePassword,
//                               decoration: const InputDecoration(
//                                 isDense: true,
//                                 isCollapsed: true,
//                                 hintText: '请输入密码',
//                                 hintStyle: TextStyle(
//                                     fontSize: 16, color: Colors.black12),
//                                 border: InputBorder.none,
//                               ),
//                               onChanged: (value) {
//                                 password = value;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
//                 child: ElevatedButton(
//                   onPressed: _login,
//                   style: ElevatedButton.styleFrom(
//                     primary: Color(0xFF2b354d),
//                   ),
//                   child: const Text('登录'),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 16, top: 20),
//                 child: GestureDetector(
//                   onTap: () {
//                    // Navigator.pushNamed(context, Constant.register);
//                   },
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       '注册账号',
//                       style: TextStyle(color: Colors.white, fontSize: 16,fontStyle:FontStyle.italic ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
