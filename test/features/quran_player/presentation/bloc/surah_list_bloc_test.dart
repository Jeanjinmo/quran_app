import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failures.dart';
import 'package:quran_app/core/utils/result.dart';
import 'package:quran_app/features/quran_player/domain/repositories/quran_repository.dart';
import 'package:quran_app/features/quran_player/domain/usecases/get_surah_list.dart';
import 'package:quran_app/features/quran_player/domain/usecases/search_surahs.dart';
import 'package:quran_app/features/quran_player/presentation/bloc/surah_list/surah_list_bloc.dart';

import '../../../../helpers/fixtures.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

void main() {
  late MockQuranRepository repo;

  setUp(() => repo = MockQuranRepository());

  SurahListBloc build() =>
      SurahListBloc(GetSurahList(repo), const SearchSurahs());

  blocTest<SurahListBloc, SurahListState>(
    'emits [Loading, Loaded] on successful load',
    setUp: () => when(
      () => repo.getSurahList(),
    ).thenAnswer((_) async => const Ok(tSurahs)),
    build: build,
    act: (b) => b.add(const SurahListRequested()),
    expect: () => [
      const SurahListLoading(),
      const SurahListLoaded(all: tSurahs, filtered: tSurahs),
    ],
  );

  blocTest<SurahListBloc, SurahListState>(
    'emits [Loading, Error] on failure',
    setUp: () => when(
      () => repo.getSurahList(),
    ).thenAnswer((_) async => const Err(NetworkFailure())),
    build: build,
    act: (b) => b.add(const SurahListRequested()),
    expect: () => [
      const SurahListLoading(),
      const SurahListError(NetworkFailure()),
    ],
  );

  blocTest<SurahListBloc, SurahListState>(
    'search filters the loaded list (debounced)',
    seed: () => const SurahListLoaded(all: tSurahs, filtered: tSurahs),
    build: build,
    act: (b) => b.add(const SurahSearchChanged('baqara')),
    wait: const Duration(milliseconds: 400),
    expect: () => [
      const SurahListLoaded(all: tSurahs, filtered: [tSurah2], query: 'baqara'),
    ],
  );
}
