import 'package:flutter/material.dart';

class Backgroundmodel extends ChangeNotifier {
  String _currentTheme = "default";

  // Theme colors
  Color _scaffoldBgColor = const Color(0xFFC3A7E4); // Light Pink
  Color _appBarColor = const Color(0xFFC3A7E4);
  Color _drawerHeaderColor = const Color(0xFFC3A7E4);
  Color _buttonColor = const Color(0xFFC3A7E4);
  Color _accentColor = const Color(0xFFC3A7E4);
  Color _textColor = const Color.fromARGB(255, 219, 111, 210);
  Color _secondBtn = const Color.fromARGB(246, 211, 72, 169);
  Color _buyBtn = const Color.fromARGB(255, 246, 72, 179);
  Color _cartBtn = const Color.fromARGB(255, 231, 95, 202);
  Color _ratingColor = const Color.fromARGB(64, 197, 46, 211);

  void applyPurpleTheme() {
    _currentTheme = "purple";
    _scaffoldBgColor = const Color(0xFF4464AC);
    _appBarColor = const Color(0xFF4464AC);
    _drawerHeaderColor = const Color(0xFF4464AC);
    _buttonColor = const Color(0xFF6A5ACD);
    _accentColor = const Color(0xFF673AB7);
    _textColor = const Color(0xFF311B92);
    _secondBtn = const Color(0xFF3F51B5);
    _buyBtn = const Color(0xFF7E57C2);
    _cartBtn = const Color(0xFF9575CD);
    _ratingColor = const Color(0xFFB39DDB);
    notifyListeners();
  }

  void reset() {
    _currentTheme = "default";
    _scaffoldBgColor = const Color(0xFFC3A7E4); // Light Pink
    _appBarColor = const Color(0xFFC3A7E4);
    _drawerHeaderColor = const Color(0xFFC3A7E4);
    _buttonColor = const Color(0xFFC3A7E4);
    _accentColor = const Color(0xFFC3A7E4);
    _textColor = const Color(0xFFB71C1C);
    _secondBtn = const Color.fromARGB(255, 191, 88, 223);
    _buyBtn = const Color.fromARGB(255, 191, 88, 223);
    _cartBtn = const Color.fromRGBO(255, 191, 88, 223);
    _ratingColor = const Color.fromRGBO(2255, 191, 88, 223);
    notifyListeners();
  }

  Color get background => _scaffoldBgColor;
  Color get appBar => _appBarColor;
  Color get drawerHeader => _drawerHeaderColor;
  Color get button => _buttonColor;
  Color get accent => _accentColor;
  Color get textColor => _textColor;
  Color get secondBtn => _secondBtn;
  Color get buyBtn => _buyBtn;
  Color get cartBtn => _cartBtn;
  Color get ratingColor => _ratingColor;

  String get theme => _currentTheme;
}
