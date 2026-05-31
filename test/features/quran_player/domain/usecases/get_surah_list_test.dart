import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failures.dart';
import 'package:quran_app/core/utils/result.dart';
import 'package:quran_app/features/quran_player/domain/entities/surah.dart';
import 'package:quran_app/features/quran_player/domain/repositories/quran_repository.dart';
import 'package:quran_app/features/quran_player/domain/usecases/get_surah_list.dart';

import '../../../../helpers/fixtures.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

void main() {
  late MockQuranRepository repo;
  late GetSurahList usecase;

  setUp(() {
    repo = MockQuranRepository();
    usecase = GetSurahList(repo);
  });

  test('forwards the repository Ok result', () async {
    when(() => repo.getSurahList()).thenAnswer((_) async => const Ok(tSurahs));

    final result = await usecase();

    expect(result, isA<Ok<List<Surah>>>());
    expect((result as Ok<List<Surah>>).value, tSurahs);
    verify(() => repo.getSurahList()).called(1);
  });

  test('forwards the repository Err result', () async {
    when(
      () => repo.getSurahList(),
    ).thenAnswer((_) async => const Err(NetworkFailure()));

    final result = await usecase();

    expect(result, isA<Err<List<Surah>>>());
    expect((result as Err<List<Surah>>).failure, isA<NetworkFailure>());
  });
}
