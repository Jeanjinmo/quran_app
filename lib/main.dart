import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/audio/audio_player_service.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/router/app_router.dart';
import 'core/settings/settings_cubit.dart';
import 'core/settings/settings_local_data_source.dart';
import 'core/theme/app_theme.dart';
import 'features/quran_player/data/datasources/player_local_data_source.dart';
import 'features/quran_player/data/datasources/quran_remote_data_source.dart';
import 'features/quran_player/data/repositories/quran_repository_impl.dart';
import 'features/quran_player/domain/usecases/get_audio_editions.dart';
import 'features/quran_player/domain/usecases/get_surah_audio_url.dart';
import 'features/quran_player/domain/usecases/get_surah_list.dart';
import 'features/quran_player/domain/usecases/save_last_played.dart';
import 'features/quran_player/domain/usecases/search_editions.dart';
import 'features/quran_player/domain/usecases/search_surahs.dart';
import 'features/quran_player/presentation/bloc/edition/edition_bloc.dart';
import 'features/quran_player/presentation/bloc/player/player_bloc.dart';
import 'features/quran_player/presentation/bloc/surah_list/surah_list_bloc.dart';
import 'l10n/app_localizations.dart';

/// Wires up all dependencies by hand and starts the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // just potrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();
  runApp(QuranApp(prefs: prefs));
}

class QuranApp extends StatelessWidget {
  const QuranApp({required this.prefs, super.key});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    // --- Data layer ---
    final dio = DioClient().dio;
    final remote = QuranRemoteDataSourceImpl(dio);
    final playerLocal = PlayerLocalDataSourceImpl(prefs);
    final repository = QuranRepositoryImpl(
      remote,
      playerLocal,
      NetworkInfoImpl(),
    );
    final audio = JustAudioPlayerService();
    final settingsLocal = SettingsLocalDataSource(prefs);

    // Blocs are provided app-wide. PlayerBloc lives at the root so audio (and
    // the mini-player) persist while navigating between Home and Player.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit(settingsLocal)..load()),
        BlocProvider(
          create: (_) =>
              SurahListBloc(GetSurahList(repository), const SearchSurahs())
                ..add(const SurahListRequested()),
        ),
        BlocProvider(
          create: (_) =>
              EditionBloc(GetAudioEditions(repository), const SearchEditions())
                ..add(const EditionsRequested()),
        ),
        BlocProvider(
          create: (_) => PlayerBloc(
            audio,
            const GetSurahAudioUrl(),
            SaveLastPlayed(repository),
          ),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Quran Player',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            locale: settings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
