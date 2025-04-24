import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int selectedThemeIndex = 0;
  String selectedLanguage = 'Filipino';

  final List<Color> themeColors = [
    Color(0xFFD99BA2),
    Color(0xFFC3A7E4),
    Color(0xFF4464AC),
  ];

  // Update theme based on index selected in the dropdown
  void updateTheme(int index) {
    selectedThemeIndex = index;
    notifyListeners();
  }

  // Update language based on user selection
  void updateLanguage(String language) {
    selectedLanguage = language;
    notifyListeners();
  }
}
