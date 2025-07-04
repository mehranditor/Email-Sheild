import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selectedLanguage';
  SharedPreferences? _prefs;
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedLanguage = _prefs?.getString(_languageKey) ?? 'en';
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      _currentLocale = Locale(languageCode);
      if (_prefs != null) {
        await _prefs!.setString(_languageKey, languageCode);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting language: $e');
    }
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'zh':
        return 'Chinese';
      case 'tr':
        return 'Turkish';
      case 'fa':
        return 'Persian';
      case 'ar':
        return 'Arabic';
      case 'ja':
        return 'Japanese';
      case 'ko':
        return 'Korean';
      case 'ru':
        return 'Russian';
      case 'it':
        return 'Italian';
      case 'pt':
        return 'Portuguese';
      case 'nl':
        return 'Dutch';
      case 'hi':
        return 'Hindi';
      default:
        return 'English';
    }
  }

  String getLanguageCode(String name) {
    switch (name) {
      case 'English':
        return 'en';
      case 'Spanish':
        return 'es';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
      case 'Chinese':
        return 'zh';
      case 'Turkish':
        return 'tr';
      case 'Persian':
        return 'fa';
      case 'Arabic':
        return 'ar';
      case 'Japanese':
        return 'ja';
      case 'Korean':
        return 'ko';
      case 'Russian':
        return 'ru';
      case 'Italian':
        return 'it';
      case 'Portuguese':
        return 'pt';
      case 'Dutch':
        return 'nl';
      case 'Hindi':
        return 'hi';
      default:
        return 'en';
    }
  }
}
