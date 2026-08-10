import 'package:flutter/material.dart';

/// Supported app language with display name and text direction.
class SupportedLanguage {
  const SupportedLanguage({
    required this.code,
    required this.name,
    this.isRtl = false,
  });

  final String code;
  final String name;
  final bool isRtl;

  Locale get locale => Locale(code);
}

/// All languages available in the app language switcher.
abstract final class AppLanguages {
  static const supported = [
    SupportedLanguage(code: 'en', name: 'English'),
    SupportedLanguage(code: 'hi', name: 'हिंदी'),
    SupportedLanguage(code: 'mr', name: 'मराठी'),
    SupportedLanguage(code: 'gu', name: 'ગુજરાતી'),
    SupportedLanguage(code: 'pa', name: 'ਪੰਜਾਬੀ'),
    SupportedLanguage(code: 'ta', name: 'தமிழ்'),
    SupportedLanguage(code: 'kn', name: 'ಕನ್ನಡ'),
    SupportedLanguage(code: 'te', name: 'తెలుగు'),
    SupportedLanguage(code: 'ml', name: 'മലയാളം'),
    SupportedLanguage(code: 'or', name: 'ଓଡ଼ିଆ'),
    SupportedLanguage(code: 'bn', name: 'বাংলা'),
    SupportedLanguage(code: 'ur', name: 'اردو', isRtl: true),
  ];

  static SupportedLanguage? find(String code) {
    for (final lang in supported) {
      if (lang.code == code) return lang;
    }
    return null;
  }

  static bool isRtl(Locale locale) => find(locale.languageCode)?.isRtl ?? false;

  /// BCP-47 locale tag for Flutter TTS / speech engines.
  static String speechLocale(String code) {
    switch (code) {
      case 'hi':
        return 'hi-IN';
      case 'mr':
        return 'mr-IN';
      case 'gu':
        return 'gu-IN';
      case 'pa':
        return 'pa-IN';
      case 'ta':
        return 'ta-IN';
      case 'kn':
        return 'kn-IN';
      case 'te':
        return 'te-IN';
      case 'ml':
        return 'ml-IN';
      case 'or':
        return 'or-IN';
      case 'bn':
        return 'bn-IN';
      case 'ur':
        return 'ur-IN';
      default:
        return 'en-IN';
    }
  }
}
