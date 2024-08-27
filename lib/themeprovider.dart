// lib/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/themes/theme_data.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? MyAppThemes.darkThemeMode : MyAppThemes.lightTheme;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _saveTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }
}
