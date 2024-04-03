import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  bool _isSearching = false;
  String _searchQuery = '';

  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
