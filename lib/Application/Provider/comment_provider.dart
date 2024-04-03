import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  bool _isExpanded = false;
  bool _isComment = false;
  String _comment = '';

  bool get isExpanded => _isExpanded;
  bool get isComment => _isComment;
  String get comment => _comment;


  void toggleComment() {
    _isComment = !_isComment;
    notifyListeners();
  }

  void setComment(String comment) {
    _comment = comment;
    notifyListeners();
  }

  void toggleExpansion() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}