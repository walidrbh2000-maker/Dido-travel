import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _localeKey = 'app_locale';
  static const _themeKey = 'app_theme_mode';

  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  String get locale => _prefs.getString(_localeKey) ?? 'fr';

  Future<void> setLocale(String localeCode) =>
      _prefs.setString(_localeKey, localeCode);

  bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;

  Future<void> setDarkMode(bool value) =>
      _prefs.setBool(_themeKey, value);

  Future<void> clear() => _prefs.clear();
}
