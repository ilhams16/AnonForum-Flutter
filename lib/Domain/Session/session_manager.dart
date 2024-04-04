import 'dart:convert';

import 'package:anonforum/Domain/Entities/UserAuth/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _isUserInKey = 'isUser';

  static Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }
  static Future<void> setUser(UserLogin? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = value?.toJson();
    var jsonString = jsonEncode(json);
    await prefs.setString(_isUserInKey, jsonString);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  static Future<UserLogin> isUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = prefs.getString(_isUserInKey) ?? "No user";
    var user = UserLogin.fromJson(jsonDecode(json));
    return user;
  }
}