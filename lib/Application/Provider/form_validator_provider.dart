import 'package:flutter/material.dart';

class RegisterValidator extends ChangeNotifier {
  String? _username;
  String? _email;
  String? _nickname;
  String? _password;
  String? _confirmPassword;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setUsername(String username) {
    _username = username;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setNickname(String nickname) {
    _nickname = nickname;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
  }

  bool validateForm() {
    // Validate form fields
    if (_username == null || _username!.isEmpty) {
      _errorMessage = 'Username is required';
      notifyListeners();
      return false;
    }
    if (_email == null || _email!.isEmpty) {
      _errorMessage = 'Email is required';
      notifyListeners();
      return false;
    }
    if (_nickname == null || _nickname!.isEmpty) {
      _errorMessage = 'Nickname is required';
      notifyListeners();
      return false;
    }
    if (_password == null || _password!.isEmpty) {
      _errorMessage = 'Password is required';
      notifyListeners();
      return false;
    }

    if (_confirmPassword == null || _confirmPassword!.isEmpty) {
      _errorMessage = 'Confirm Password is required';
      notifyListeners();
      return false;
    }

    if (_confirmPassword != _password) {
      _errorMessage = 'Password is not match';
      notifyListeners();
      return false;
    }
    // Reset error message if validation passes
    _errorMessage = null;
    notifyListeners();
    return true;
  }
}
class LoginValidator extends ChangeNotifier {
  String? _username;
  String? _password;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setUsername(String username) {
    _username = username;
  }

  void setPassword(String password) {
    _password = password;
  }

  bool validateForm() {
    // Validate form fields
    if (_username == null || _username!.isEmpty) {
      _errorMessage = 'Username is required';
      notifyListeners();
      return false;
    }
    if (_password == null || _password!.isEmpty) {
      _errorMessage = 'Password is required';
      notifyListeners();
      return false;
    }
    // Reset error message if validation passes
    _errorMessage = null;
    notifyListeners();
    return true;
  }
}