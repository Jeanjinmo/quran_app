import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/event_transformers.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../../domain/entities/surah.dart';
import '../../../domain/usecases/get_surah_list.dart';
import '../../../domain/usecases/search_surahs.dart';

part 'surah_list_event.dart';
part 'surah_list_state.dart';

/// Loads the surah list on startup and filters it in memory on search.
class SurahListBloc extends Bloc<SurahListEvent, SurahListState> {
  SurahListBloc(this._getSurahList, this._searchSurahs)
    : super(const SurahListInitial()) {
    on<SurahListRequested>(_onRequested);
    // Debounce search so filtering runs after the user pauses typing, not on
    // every keystroke. Harmless for our in-memory filter, but the right pattern
    // and future-proof if search ever hits the network.
    on<SurahSearchChanged>(
      _onSearchChanged,
      transformer: debounce<SurahSearchChanged>(
        const Duration(milliseconds: 300),
      ),
    );
  }

  final GetSurahList _getSurahList;
  final SearchSurahs _searchSurahs;

  Future<void> _onRequested(
    SurahListRequested event,
    Emitter<SurahListState> emit,
  ) async {
    emit(const SurahListLoading());
    final result = await _getSurahList();
    switch (result) {
      case Ok(:final value):
        emit(SurahListLoaded(all: value, filtered: value));
      case Err(:final failure):
        emit(SurahListError(failure));
    }
  }

  void _onSearchChanged(
    SurahSearchChanged event,
    Emitter<SurahListState> emit,
  ) {
    // Only meaningful once loaded; ignore while in another phase.
    final current = state;
    if (current is! SurahListLoaded) return;
    emit(
      current.copyWith(
        query: event.query,
        filtered: _searchSurahs(current.all, event.query),
      ),
    );
  }
}
