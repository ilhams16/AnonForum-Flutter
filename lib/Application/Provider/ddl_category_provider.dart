import 'package:anonforum/Domain/Entities/post_category.dart';
import 'package:flutter/material.dart';

class DropdownCategoryProvider extends ChangeNotifier {
  PostCategory? _selectedItem;

  PostCategory? get selectedItem => _selectedItem;

  void setSelectedItem(PostCategory item) {
    _selectedItem = item;
    notifyListeners();
  }
}