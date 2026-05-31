import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/settings/settings_cubit.dart';
import 'package:quran_app/core/error/failures.dart';
import 'package:quran_app/features/quran_player/presentation/bloc/edition/edition_bloc.dart';
import 'package:quran_app/features/quran_player/presentation/bloc/player/player_bloc.dart';
import 'package:quran_app/features/quran_player/presentation/bloc/surah_list/surah_list_bloc.dart';
import 'package:quran_app/features/quran_player/presentation/pages/home_page.dart';
import 'package:quran_app/features/quran_player/presentation/widgets/error_retry.dart';
import 'package:quran_app/features/quran_player/presentation/widgets/loading_shimmer_list.dart';
import 'package:quran_app/features/quran_player/presentation/widgets/surah_track_tile.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

class MockSurahListBloc extends MockBloc<SurahListEvent, SurahListState>
    implements SurahListBloc {}

class MockEditionBloc extends MockBloc<EditionEvent, EditionState>
    implements EditionBloc {}

class MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  late MockSurahListBloc surahListBloc;
  late MockEditionBloc editionBloc;
  late MockPlayerBloc playerBloc;
  late MockSettingsCubit settingsCubit;

  setUp(() {
    surahListBloc = MockSurahListBloc();
    editionBloc = MockEditionBloc();
    playerBloc = MockPlayerBloc();
    settingsCubit = MockSettingsCubit();

    when(() => editionBloc.state).thenReturn(
      const EditionLoaded(
        all: tEditions,
        filtered: tEditions,
        selected: tEdition1,
      ),
    );
    when(() => playerBloc.state).thenReturn(const PlayerInitial());
    when(() => settingsCubit.state).thenReturn(const SettingsState());
  });

  Widget subject() => MultiBlocProvider(
    providers: [
      BlocProvider<SurahListBloc>.value(value: surahListBloc),
      BlocProvider<EditionBloc>.value(value: editionBloc),
      BlocProvider<PlayerBloc>.value(value: playerBloc),
      BlocProvider<SettingsCubit>.value(value: settingsCubit),
    ],
    child: const HomePage(),
  );

  testWidgets('shows shimmer while loading', (tester) async {
    when(() => surahListBloc.state).thenReturn(const SurahListLoading());
    await tester.pumpApp(subject());
    expect(find.byType(LoadingShimmerList), findsOneWidget);
  });

  testWidgets('shows the surah list when loaded', (tester) async {
    when(
      () => surahListBloc.state,
    ).thenReturn(const SurahListLoaded(all: tSurahs, filtered: tSurahs));
    await tester.pumpApp(subject());
    expect(find.byType(SurahTrackTile), findsNWidgets(tSurahs.length));
    expect(find.text('Al-Faatiha'), findsOneWidget);
  });

  testWidgets('shows error + retry on failure', (tester) async {
    when(
      () => surahListBloc.state,
    ).thenReturn(const SurahListError(NetworkFailure()));
    await tester.pumpApp(subject());
    expect(find.byType(ErrorRetry), findsOneWidget);
  });
}
