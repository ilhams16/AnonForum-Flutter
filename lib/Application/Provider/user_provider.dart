
import 'package:anonforum/Domain/Entities/UserAuth/user_login.dart';
import 'package:anonforum/Domain/Session/session_manager.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  int? userId = 0;
  String? token;

  UserDataProvider() {
    _getUserId();
  }

  Future<void> _getUserId() async {
    UserLogin data = await SessionManager.isUser();
    if (data != null) {
      userId = data.userId;
      token = data.token;
      notifyListeners();
    } else {
    }
  }

}
