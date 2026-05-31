part of 'edition_bloc.dart';

sealed class EditionEvent extends Equatable {
  const EditionEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the curated reciter list once.
final class EditionsRequested extends EditionEvent {
  const EditionsRequested();
}

/// Fires on every change to the reciter search field — filters by artist.
final class EditionSearchChanged extends EditionEvent {
  const EditionSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// User picked a reciter; becomes the default used when playing any surah.
final class EditionSelected extends EditionEvent {
  const EditionSelected(this.edition);

  final Edition edition;

  @override
  List<Object?> get props => [edition];
}
