import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  // Default theme color (first color choice)
  Color _selectedColor = Color(0xFFC3A7E4);

  Color get selectedColor => _selectedColor;

  // Change color theme
  void changeThemeColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  // Default language (English)
  String _selectedLanguage = 'English';

  String get selectedLanguage => _selectedLanguage;

  // Change language
  void changeLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}
