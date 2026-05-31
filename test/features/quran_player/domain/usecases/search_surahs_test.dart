import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran_player/domain/usecases/search_surahs.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  const usecase = SearchSurahs();

  test('returns all when query is empty', () {
    expect(usecase(tSurahs, ''), tSurahs);
    expect(usecase(tSurahs, '   '), tSurahs);
  });

  test('matches by english name (case-insensitive)', () {
    expect(usecase(tSurahs, 'baqara'), [tSurah2]);
    expect(usecase(tSurahs, 'AL-FAATIHA'), [tSurah1]);
  });

  test('matches by english translation', () {
    expect(usecase(tSurahs, 'opening'), [tSurah1]);
  });

  test('matches by surah number', () {
    expect(usecase(tSurahs, '2'), [tSurah2]);
  });

  test('returns empty when nothing matches', () {
    expect(usecase(tSurahs, 'zzz'), isEmpty);
  });
}
