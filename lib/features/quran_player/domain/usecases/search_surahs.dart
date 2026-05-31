import '../entities/surah.dart';

/// Filters a loaded surah list in memory by a free-text query.
/// Matches case-insensitively on transliterated name, English meaning,
/// Arabic name, and surah number.
class SearchSurahs {
  const SearchSurahs();

  List<Surah> call(List<Surah> surahs, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return surahs;
    return surahs.where((s) {
      return s.englishName.toLowerCase().contains(q) ||
          s.englishNameTranslation.toLowerCase().contains(q) ||
          s.name.toLowerCase().contains(q) ||
          s.number.toString() == q;
    }).toList();
  }
}
