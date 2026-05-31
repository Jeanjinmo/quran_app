part of 'surah_list_bloc.dart';

sealed class SurahListEvent extends Equatable {
  const SurahListEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the full surah list (and the last-played snapshot) once on startup.
final class SurahListRequested extends SurahListEvent {
  const SurahListRequested();
}

/// Fires on every change to the search field — filters by title.
final class SurahSearchChanged extends SurahListEvent {
  const SurahSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
