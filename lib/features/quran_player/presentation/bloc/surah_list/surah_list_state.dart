part of 'surah_list_bloc.dart';

/// States for the surah list. Sealed so the UI switch is exhaustive
/// across initial, loading, loaded, and error phases.
sealed class SurahListState extends Equatable {
  const SurahListState();

  @override
  List<Object?> get props => [];
}

final class SurahListInitial extends SurahListState {
  const SurahListInitial();
}

final class SurahListLoading extends SurahListState {
  const SurahListLoading();
}

final class SurahListLoaded extends SurahListState {
  const SurahListLoaded({
    required this.all,
    required this.filtered,
    this.query = '',
  });

  /// Full, unfiltered list — cached so search filters in memory.
  final List<Surah> all;

  /// The list after applying [query]; equals [all] when the query is empty.
  final List<Surah> filtered;

  final String query;

  SurahListLoaded copyWith({
    List<Surah>? all,
    List<Surah>? filtered,
    String? query,
  }) {
    return SurahListLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [all, filtered, query];
}

final class SurahListError extends SurahListState {
  const SurahListError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
