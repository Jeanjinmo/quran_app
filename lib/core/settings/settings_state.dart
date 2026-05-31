part of 'settings_cubit.dart';

/// Immutable snapshot of current settings (locale + theme mode).
final class SettingsState extends Equatable {
  const SettingsState({this.locale, this.themeMode = ThemeMode.system});

  /// Selected locale, or `null` to follow the system language.
  final Locale? locale;

  /// Selected theme mode; defaults to following the system.
  final ThemeMode themeMode;

  SettingsState copyWith({
    Locale? locale,
    bool clearLocale = false,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      locale: clearLocale ? null : (locale ?? this.locale),
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [locale, themeMode];
}
