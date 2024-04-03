import 'package:flutter/material.dart';

class AddPostProvider extends ChangeNotifier {
  bool _isAddPostVisible = false;

  bool get isAddPostVisible => _isAddPostVisible;

  void toggleFormFieldVisibility() {
    _isAddPostVisible = !_isAddPostVisible;
    notifyListeners();
  }
}