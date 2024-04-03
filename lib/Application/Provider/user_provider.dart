
import 'package:anonforum/Domain/Entities/user_login.dart';
import 'package:anonforum/Domain/Session/session_manager.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  int? userId = 0;
  String? token;

  UserDataProvider() {
    _getUserId();
  }

  Future<void> _getUserId() async {
    print('Fetching user ID...');
    UserLogin data = await SessionManager.isUser();
    if (data != null) {
      userId = data.userId;
      token = data.token;
      print('User ID fetched: $userId');
      notifyListeners();
    } else {
      print('User ID not found');
    }
  }

}
