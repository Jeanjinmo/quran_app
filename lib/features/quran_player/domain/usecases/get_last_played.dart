import '../../../../core/utils/result.dart';
import '../entities/playback_snapshot.dart';
import '../repositories/quran_repository.dart';

/// Reads the persisted "continue listening" snapshot (or `null` if none).
class GetLastPlayed {
  const GetLastPlayed(this._repository);

  final QuranRepository _repository;

  Result<PlaybackSnapshot?> call() => _repository.getLastPlayed();
}
