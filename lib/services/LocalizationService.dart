import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationServiceLanguage {
  final String key, title, icon;
  final String? date;
  final Locale locale;

  LocalizationServiceLanguage({
    required this.key,
    required this.title,
    required this.icon,
    this.date,
    this.locale = const Locale('en')
  });
}

class LocalizationService {
  static final locales = {
    'en': const Locale('en'),
    'ru': const Locale('ru')
  };

  static final LocalizationServiceLanguage defLocation = LocalizationServiceLanguage(
      key: 'english',
      title: 'English',
      icon: 'assets/icons/flags/united-kingdom.png',
      date: 'en_USA',
      locale: locales['en']!
  );

  static final List<LocalizationServiceLanguage> _locations = [
    defLocation,
    LocalizationServiceLanguage(key: 'deutsch', title: 'Deutsch', icon: 'assets/icons/flags/germany.png'),
    LocalizationServiceLanguage(key: 'french', title: 'Français', icon: 'assets/icons/flags/france.png'),
    LocalizationServiceLanguage(key: 'estonian', title: 'Estonian', icon: 'assets/icons/flags/estonia.png'),
    LocalizationServiceLanguage(key: 'russian', title: 'Русский', icon: 'assets/icons/flags/russia.png', date: 'ru', locale: locales['ru']!)
  ];

  static final LocalizationService _singleton = LocalizationService._internal();
  static String _currentDateLocale = defLocation.date!;

  factory LocalizationService() {
    return _singleton;
  }

  LocalizationService._internal();

  String _currentLangKey = 'none';
  LocalizationServiceLanguage _currentLanguage = defLocation;

  BuildContext? _mainContext;

  List<Locale> getSupportedLocales() {
    return locales.values.toList();
  }

  static getCurrentDateLocale() {
    return _currentDateLocale;
  }

  void setMainContext(BuildContext context) {
    _mainContext = context;

    if (isLangInit) {
      _mainContext!.setLocale(_currentLanguage.locale);
    }
  }

  LocalizationServiceLanguage getLanguage() {
    return _currentLanguage;
  }

  getLanguagesOptions() {
    var tabOptions = [];
    _locations.forEach((loc) {
      tabOptions.add({
        'key': loc.key,
        'title': loc.title,
        'icon': loc.icon
      });
    });
    return tabOptions;
  }

  String? tryFindLanguageKey() {
    var deviceLocale = _mainContext!.deviceLocale;
    String? retLangKey;
    for (var loc in _locations) {
      if (loc.locale.languageCode == 'en') {
        continue;
      }
      if (loc.locale.languageCode == deviceLocale.languageCode) {
        retLangKey = loc.key;
      }
    }
    return retLangKey;
  }

  bool isLangInit = false;
  void setLanguage(String lang) {
    if (_currentLangKey == lang) {
      return;
    }
    _currentLangKey = lang;

    _currentLanguage = _findLanguageByKey(lang);
    _currentDateLocale = (_currentLanguage.date ?? defLocation.date)!;
    isLangInit = true;

    if (_mainContext != null) {
      _mainContext!.setLocale(_currentLanguage.locale);
    }
  }

  LocalizationServiceLanguage _findLanguageByKey(String lang) {
    LocalizationServiceLanguage? findLang;
    _locations.forEach((loc) {
      if (loc.key == lang) {
        findLang = loc;
      }
    });

    if (findLang == null) {
      return defLocation;
    }

    return findLang!;
  }
}