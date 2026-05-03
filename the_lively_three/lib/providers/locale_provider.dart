import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  Locale _locale = const Locale('en');  // Default locale (English)

  // Getter for locale
  Locale get locale => _locale;

  // Setter for locale
  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();  // Notify listeners about the change
      _saveLocaleToPreferences(newLocale);  // Save the new locale to shared preferences
    }
  }

  // Save locale to SharedPreferences
  void _saveLocaleToPreferences(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale.languageCode);  // Store the language code
  }

  // Load the locale from SharedPreferences
  Future<void> initializePersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    String storedLocale = prefs.getString('locale') ?? 'en';  // Default to 'en' if no locale is stored
    setLocale(Locale(storedLocale));  // Set the locale from persisted data
  }
}
