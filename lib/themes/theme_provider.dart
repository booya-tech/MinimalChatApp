import 'package:flutter/material.dart';
import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  // Define a public 'getter' for _themeData.
  // This allows other parts of the app to read the current theme
  // (e.g., 'Provider.of<ThemeProvider>(context).themeData')
  // but not directly modify the '_themeData' variable.
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // Call 'notifyListeners()'. This is the core method from 'ChangeNotifier'.
    // It tells all listening widgets (like those using 'Consumer' or
    // 'Provider.of') that the state has changed and they should rebuild.
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}