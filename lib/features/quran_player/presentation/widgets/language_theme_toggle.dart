import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../l10n/app_localizations.dart';

/// App-bar actions to switch language (EN/ID/system) and theme
/// (light/dark/system), both backed by [SettingsBloc] and persisted.
class LanguageThemeToggle extends StatelessWidget {
  const LanguageThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SettingsCubit>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<Locale?>(
          icon: const Icon(Icons.language),
          tooltip: l10n.language,
          onSelected: cubit.setLocale,
          itemBuilder: (context) => [
            PopupMenuItem(value: null, child: Text(l10n.languageSystem)),
            PopupMenuItem(
              value: const Locale('en'),
              child: Text(l10n.languageEnglish),
            ),
            PopupMenuItem(
              value: const Locale('id'),
              child: Text(l10n.languageIndonesian),
            ),
          ],
        ),
        PopupMenuButton<ThemeMode>(
          icon: const Icon(Icons.brightness_6_outlined),
          tooltip: l10n.theme,
          onSelected: cubit.setThemeMode,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Text(l10n.themeSystem),
            ),
            PopupMenuItem(value: ThemeMode.light, child: Text(l10n.themeLight)),
            PopupMenuItem(value: ThemeMode.dark, child: Text(l10n.themeDark)),
          ],
        ),
      ],
    );
  }
}
