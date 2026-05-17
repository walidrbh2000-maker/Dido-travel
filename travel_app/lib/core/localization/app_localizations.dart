import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocalizations {
  const AppLocalizations();

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('ar'),
    Locale('en'),
  ];

  static Locale localeResolution(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return const Locale('fr');
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return const Locale('fr');
  }

  static bool isRtl(Locale locale) => locale.languageCode == 'ar';
}

final l10nProvider = Provider<AppLocalizationsHelper>((ref) {
  return const AppLocalizationsHelper();
});

class AppLocalizationsHelper {
  const AppLocalizationsHelper();

  String appName() => 'Voyageur';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return const AppLocalizations();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
