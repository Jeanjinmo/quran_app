import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/settings/settings_cubit.dart';
import 'package:quran_app/core/settings/settings_local_data_source.dart';

class MockSettingsLocal extends Mock implements SettingsLocalDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(const Locale('en'));
  });

  late MockSettingsLocal local;

  setUp(() {
    local = MockSettingsLocal();
    when(() => local.readLocale()).thenReturn(null);
    when(() => local.readThemeMode()).thenReturn(ThemeMode.system);
    when(() => local.saveLocale(any())).thenAnswer((_) async {});
    when(() => local.saveThemeMode(any())).thenAnswer((_) async {});
  });

  blocTest<SettingsCubit, SettingsState>(
    'load() hydrates from storage',
    setUp: () {
      when(() => local.readLocale()).thenReturn(const Locale('id'));
      when(() => local.readThemeMode()).thenReturn(ThemeMode.dark);
    },
    build: () => SettingsCubit(local),
    act: (c) => c.load(),
    expect: () => [
      const SettingsState(locale: Locale('id'), themeMode: ThemeMode.dark),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'setThemeMode persists and emits',
    build: () => SettingsCubit(local),
    act: (c) => c.setThemeMode(ThemeMode.light),
    expect: () => [const SettingsState(themeMode: ThemeMode.light)],
    verify: (_) => verify(() => local.saveThemeMode(ThemeMode.light)).called(1),
  );

  blocTest<SettingsCubit, SettingsState>(
    'setLocale(null) clears to system',
    seed: () => const SettingsState(locale: Locale('en')),
    build: () => SettingsCubit(local),
    act: (c) => c.setLocale(null),
    expect: () => [const SettingsState()],
  );
}
