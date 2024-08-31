import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences _storage = SharedPreferences.getInstance() as SharedPreferences;

  // Custom dark theme
  final darkTheme = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12,
    
  );

  // Custom light theme
  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
  );

  UiProvider() {
    _loadTheme();
  }

  // Dark mode toggle action
  void changeTheme() {
    _isDark = !_isDark;
    _saveTheme(_isDark);
    notifyListeners();
  }

  // Load the theme from SharedPreferences
  void _loadTheme() async {
    _storage = await SharedPreferences.getInstance();
    _isDark = _storage.getBool('isDark') ?? false;
    notifyListeners();
  }

  // Save the theme preference
  void _saveTheme(bool isDark) async {
    await _storage.setBool('isDark', isDark);
  }

  init() {}
}
