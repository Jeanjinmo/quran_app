part of 'edition_bloc.dart';

sealed class EditionState extends Equatable {
  const EditionState();

  @override
  List<Object?> get props => [];
}

final class EditionInitial extends EditionState {
  const EditionInitial();
}

final class EditionLoading extends EditionState {
  const EditionLoading();
}

final class EditionLoaded extends EditionState {
  const EditionLoaded({
    required this.all,
    required this.filtered,
    required this.selected,
    this.query = '',
  });

  /// Full reciter list (curated allowlist).
  final List<Edition> all;

  /// List after applying [query].
  final List<Edition> filtered;

  /// Currently selected reciter — never null once loaded (defaults to first).
  final Edition selected;

  final String query;

  EditionLoaded copyWith({
    List<Edition>? all,
    List<Edition>? filtered,
    Edition? selected,
    String? query,
  }) {
    return EditionLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      selected: selected ?? this.selected,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [all, filtered, selected, query];
}

final class EditionError extends EditionState {
  const EditionError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
