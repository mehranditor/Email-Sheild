import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  SharedPreferences? _prefs;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isDarkMode = _prefs?.getBool(_themeKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
      _isDarkMode = false;
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      if (_prefs != null) {
        await _prefs!.setBool(_themeKey, _isDarkMode);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling theme: $e');
    }
  }
}
