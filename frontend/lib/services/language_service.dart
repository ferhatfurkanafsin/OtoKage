import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  static const String _languageKey = 'selected_language';

  // Initialize and load saved language
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'en';
      _currentLocale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      // If initialization fails, keep default locale (en)
      _currentLocale = const Locale('en');
    }
  }

  // Change language and save preference
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode == _currentLocale.languageCode) return;

    _currentLocale = Locale(languageCode);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      // Silently fail if saving fails, but keep the locale changed in memory
    }
  }

  // Get display name for language
  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'ja':
        return '日本語';
      default:
        return 'English';
    }
  }

  // Get flag emoji for language
  String getLanguageFlag(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'tr':
        return '🇹🇷';
      case 'ja':
        return '🇯🇵';
      default:
        return '🇬🇧';
    }
  }
}
