import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:app_entrance/logic/login_logic.dart';
import 'package:app_entrance/model/user.dart';
import 'package:app_entrance/page/constant.dart';
import 'package:app_entrance/res.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String oldPassword = '';
  String password = '';
  String ensurePassword = '';

  void _register() {
    if (oldPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('请输入原密码'),
      ));
      return;
    }
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
    bool success = LoginLogic.instance.checkPassword(oldPassword, password);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('原密码错误'),
      ));
      return;
    }
    EasyLoading.showToast('密码修改成功');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修改密码'),
  //      backgroundColor: Color(0xFF5789c2),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        child: const Text(
                          '原密码:',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            isDense: true,
                   //         isCollapsed: true,
                            hintText: '输入原密码',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black12),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            oldPassword = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1),
                Container(
                  padding: EdgeInsets.only(bottom: 14, top: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        child: const Text(
                          '密码:',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            isDense: true,
                    //        isCollapsed: true,
                            hintText: '请输入密码',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black12),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1),
                Container(
                  padding: EdgeInsets.only(bottom: 14, top: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        child: const Text(
                          '确认密码:',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            isDense: true,
                  //          isCollapsed: true,
                            hintText: '请输入确认密码',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black12),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            ensurePassword = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                primary: Color(0xff41d9a3),
              ),
              child: const Text('确认'),
            ),
          ),
        ],
      ),
    );
  }
}
