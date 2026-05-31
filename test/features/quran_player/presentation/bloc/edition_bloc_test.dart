import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/utils/result.dart';
import 'package:quran_app/features/quran_player/domain/repositories/quran_repository.dart';
import 'package:quran_app/features/quran_player/domain/usecases/get_audio_editions.dart';
import 'package:quran_app/features/quran_player/domain/usecases/search_editions.dart';
import 'package:quran_app/features/quran_player/presentation/bloc/edition/edition_bloc.dart';

import '../../../../helpers/fixtures.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

void main() {
  late MockQuranRepository repo;

  setUp(() {
    repo = MockQuranRepository();
    when(
      () => repo.getAudioEditions(),
    ).thenAnswer((_) async => const Ok(tEditions));
  });

  EditionBloc build() =>
      EditionBloc(GetAudioEditions(repo), const SearchEditions());

  blocTest<EditionBloc, EditionState>(
    'emits [Loading, Loaded] with first edition selected by default',
    build: build,
    act: (b) => b.add(const EditionsRequested()),
    expect: () => [
      const EditionLoading(),
      const EditionLoaded(
        all: tEditions,
        filtered: tEditions,
        selected: tEdition1,
      ),
    ],
  );

  blocTest<EditionBloc, EditionState>(
    'EditionSelected updates the selection',
    build: build,
    act: (b) async {
      b.add(const EditionsRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      b.add(const EditionSelected(tEdition2));
    },
    skip: 2,
    expect: () => [
      isA<EditionLoaded>().having((s) => s.selected, 'selected', tEdition2),
    ],
  );

  blocTest<EditionBloc, EditionState>(
    'search filters reciters (debounced)',
    build: build,
    act: (b) async {
      b.add(const EditionsRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      b.add(const EditionSearchChanged('basfar'));
    },
    wait: const Duration(milliseconds: 400),
    skip: 2,
    expect: () => [
      isA<EditionLoaded>().having((s) => s.filtered, 'filtered', [tEdition2]),
    ],
  );
}
