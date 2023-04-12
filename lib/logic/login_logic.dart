import 'dart:convert';

import 'package:flutter/foundation.dart';
import '/logic/main_logic.dart';
import '/model/user.dart';

class LoginLogic extends ChangeNotifier {
  static const String keyUser = 'key_user';

  LoginLogic._();

  static final LoginLogic _instance = LoginLogic._();

  static LoginLogic get instance => _instance;

  List<User> users = [];
  User? currentUser;

  init() {
    List<String>? json =
        MainLogic.instance.sharedPreferences.getStringList('key_user');
    if (json != null) {
      users = json.map((e) => User.fromJson(jsonDecode(e))).toList();
    }
    if (users.isNotEmpty) {
      currentUser = users.last;
    }
  }

  bool checkAccount(String account, String password) {
    if (users.isEmpty) {
      return false;
    }
    List<User> list =
        users.where((element) => account == element.account).toList();
    if (list.isEmpty) {
      return false;
    }
    if (list.first.password == password) {
      currentUser = list.first;
      return true;
    }
    return false;
  }

  bool checkPassword(String oldPassword, String password) {
    if (currentUser == null) {
      return false;
    }
    var result = currentUser!.password == oldPassword;
    if (result) {
      currentUser!.password = password;
      MainLogic.instance.sharedPreferences.setStringList(
          keyUser, users.map((e) => jsonEncode(e.toJson())).toList());
    }
    return result;
  }

  void saveUser(User user) {
    users
        .where((element) => element.account == user.account)
        .toList()
        .forEach((element) {
      element.name=user.name;//修改
      element.avatar = user.avatar;
      element.content = user.content;
      element.email = user.email;
      element.phonenum = user.phonenum;
    });
    MainLogic.instance.sharedPreferences.setStringList(
        keyUser, users.map((e) => jsonEncode(e.toJson())).toList());
    notifyListeners();
  }

  bool register(User user) {
    if (users.isEmpty) {
      users.add(user);
      MainLogic.instance.sharedPreferences.setStringList(
          keyUser, users.map((e) => jsonEncode(e.toJson())).toList());
      return true;
    }
    List<User> list =
        users.where((element) => user.account == element.account).toList();

    if (list.isNotEmpty) {
      return false;
    }
    users.add(user);
    MainLogic.instance.sharedPreferences.setStringList(
        keyUser, users.map((e) => jsonEncode(e.toJson())).toList());
    return true;
  }
}
