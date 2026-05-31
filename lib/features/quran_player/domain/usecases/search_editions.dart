import '../entities/edition.dart';

/// Filters the reciter list by a free-text query.
/// Matches case-insensitively on both Latin and Arabic names.
class SearchEditions {
  const SearchEditions();

  List<Edition> call(List<Edition> editions, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return editions;
    return editions.where((e) {
      return e.name.toLowerCase().contains(q) || e.arabicName.contains(query);
    }).toList();
  }
}
