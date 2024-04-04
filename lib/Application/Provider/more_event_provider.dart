import 'package:flutter/material.dart';

class MoreEventProvider extends ChangeNotifier{
  bool _isPopUp = false;
  bool _isDelete= false;
  bool _isEdit = false;

  bool get isPopUp => _isPopUp;
  bool get isDelete => _isDelete;
  bool get isEdit => _isEdit;

  void toggleMoreEvent() {
    _isPopUp = !_isPopUp;
    notifyListeners();
  }
  void toggleDeleteModal() {
    _isDelete = !_isDelete;
    notifyListeners();
  }
  void toggleEditModal() {
    _isEdit = !_isEdit;
    notifyListeners();
  }
}