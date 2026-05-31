import '../../../../core/utils/result.dart';
import '../entities/playback_snapshot.dart';
import '../repositories/quran_repository.dart';

/// Persists the current "continue listening" snapshot.
class SaveLastPlayed {
  const SaveLastPlayed(this._repository);

  final QuranRepository _repository;

  Future<Result<void>> call(PlaybackSnapshot snapshot) =>
      _repository.saveLastPlayed(snapshot);
}
