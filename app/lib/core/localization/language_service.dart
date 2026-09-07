import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, urdu, romanUrdu }

class LanguageService {
  LanguageService._internal();
  static final LanguageService instance = LanguageService._internal();

  final ValueNotifier<AppLanguage> currentLanguage =
      ValueNotifier<AppLanguage>(AppLanguage.english);

  AppLanguage get current => currentLanguage.value;

  /// Call once from main() before runApp().
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('app_language');
    if (saved != null) {
      final lang = AppLanguage.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => AppLanguage.english,
      );
      currentLanguage.value = lang;
    }
  }

  void setLanguage(AppLanguage language) {
    if (currentLanguage.value != language) {
      currentLanguage.value = language;
      // Persist asynchronously — fire-and-forget
      SharedPreferences.getInstance()
          .then((p) => p.setString('app_language', language.name));
    }
  }

  bool get isRtl => currentLanguage.value == AppLanguage.urdu;
  bool get isUrdu => currentLanguage.value == AppLanguage.urdu;
  bool get isRomanUrdu => currentLanguage.value == AppLanguage.romanUrdu;

  Locale get locale {
    switch (currentLanguage.value) {
      case AppLanguage.urdu:
        return const Locale('ur', 'PK');
      case AppLanguage.romanUrdu:
        return const Locale('ur', 'Latn');
      case AppLanguage.english:
        return const Locale('en', 'US');
    }
  }

  String get displayName {
    switch (currentLanguage.value) {
      case AppLanguage.urdu:
        return 'اردو';
      case AppLanguage.romanUrdu:
        return 'Roman Urdu';
      case AppLanguage.english:
        return 'English';
    }
  }
}
