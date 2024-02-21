import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_it/models/User.dart';

class User {
  static Future<void> setInfo(Member? member) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString("user", jsonEncode(member));
  }

  static Future setLogin(bool isLogin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("login", isLogin);
  }

  static Future<bool?> getLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("login");
  }

  static Future<Member> getInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var json = pref.getString("user");
    final jsonData = jsonDecode(json!);
    final Member users = Member.fromJson(jsonData);
    return users;
  }
}
