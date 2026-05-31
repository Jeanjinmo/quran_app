import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/event_transformers.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../../domain/entities/edition.dart';
import '../../../domain/usecases/get_audio_editions.dart';
import '../../../domain/usecases/search_editions.dart';

part 'edition_event.dart';
part 'edition_state.dart';

/// Manages reciter selection: loads the list, handles search, and tracks
/// the currently selected reciter across surah changes.
class EditionBloc extends Bloc<EditionEvent, EditionState> {
  EditionBloc(this._getAudioEditions, this._searchEditions)
    : super(const EditionInitial()) {
    on<EditionsRequested>(_onRequested);
    on<EditionSearchChanged>(
      _onSearchChanged,
      transformer: debounce<EditionSearchChanged>(
        const Duration(milliseconds: 300),
      ),
    );
    on<EditionSelected>(_onSelected);
  }

  final GetAudioEditions _getAudioEditions;
  final SearchEditions _searchEditions;

  Future<void> _onRequested(
    EditionsRequested event,
    Emitter<EditionState> emit,
  ) async {
    emit(const EditionLoading());
    switch (await _getAudioEditions()) {
      case Ok(:final value):
        if (value.isEmpty) {
          emit(const EditionError(ServerFailure('No reciters available')));
          return;
        }
        // Default the selection to the first reciter so playback always has a
        // valid "artist" without forcing the user to choose first.
        emit(EditionLoaded(all: value, filtered: value, selected: value.first));
      case Err(:final failure):
        emit(EditionError(failure));
    }
  }

  void _onSearchChanged(
    EditionSearchChanged event,
    Emitter<EditionState> emit,
  ) {
    final current = state;
    if (current is! EditionLoaded) return;
    emit(
      current.copyWith(
        query: event.query,
        filtered: _searchEditions(current.all, event.query),
      ),
    );
  }

  void _onSelected(EditionSelected event, Emitter<EditionState> emit) {
    final current = state;
    if (current is! EditionLoaded) return;
    emit(current.copyWith(selected: event.edition));
  }
}
