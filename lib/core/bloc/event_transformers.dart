import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Debounce transformer for search — waits [duration] after the last event
/// before running the handler, so rapid keystrokes trigger one filter pass
/// instead of one per letter.
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}
