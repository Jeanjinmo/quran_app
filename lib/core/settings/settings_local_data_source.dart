import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kept separate from [SettingsCubit] so the cubit depends on a clean abstraction,
/// centralizing the serialization details.
class SettingsLocalDataSource {
  SettingsLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _localeKey = 'settings.localeCode';
  static const _themeKey = 'settings.themeMode';

  /// Reads the saved locale, or `null` to follow the system language.
  Locale? readLocale() {
    final code = _prefs.getString(_localeKey);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  /// Persists the locale. Passing `null` clears it (back to "follow system").
  Future<void> saveLocale(Locale? locale) async {
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.languageCode);
    }
  }

  /// Reads the saved [ThemeMode], defaulting to [ThemeMode.system].
  ThemeMode readThemeMode() {
    final name = _prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) =>
      _prefs.setString(_themeKey, mode.name);
}
