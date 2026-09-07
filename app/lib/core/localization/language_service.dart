import 'package:flutter/material.dart';

enum AppLanguage { english, urdu, romanUrdu }

class LanguageService {
  LanguageService._internal();
  static final LanguageService instance = LanguageService._internal();

  final ValueNotifier<AppLanguage> currentLanguage =
      ValueNotifier<AppLanguage>(AppLanguage.english);

  AppLanguage get current => currentLanguage.value;

  void setLanguage(AppLanguage language) {
    if (currentLanguage.value != language) {
      currentLanguage.value = language;
    }
  }

  bool get isRtl => currentLanguage.value == AppLanguage.urdu;

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
