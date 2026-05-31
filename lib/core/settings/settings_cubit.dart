import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_local_data_source.dart';

part 'settings_state.dart';

/// Manages app-wide language and theme preferences and persists changes.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._local) : super(const SettingsState());

  final SettingsLocalDataSource _local;

  /// Hydrate persisted preferences. Called once at startup.
  void load() {
    emit(
      SettingsState(
        locale: _local.readLocale(),
        themeMode: _local.readThemeMode(),
      ),
    );
  }

  Future<void> setLocale(Locale? locale) async {
    await _local.saveLocale(locale);
    emit(state.copyWith(locale: locale, clearLocale: locale == null));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _local.saveThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }
}
