import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran_player/domain/usecases/search_editions.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  const usecase = SearchEditions();

  test('returns all when query is empty', () {
    expect(usecase(tEditions, ''), tEditions);
  });

  test('matches by latin name (case-insensitive)', () {
    expect(usecase(tEditions, 'basfar'), [tEdition2]);
    expect(usecase(tEditions, 'MISHARY'), [tEdition1]);
  });

  test('returns empty when nothing matches', () {
    expect(usecase(tEditions, 'zzz'), isEmpty);
  });
}
