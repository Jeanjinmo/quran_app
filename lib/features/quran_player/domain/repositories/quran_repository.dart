import '../../../../core/utils/result.dart';
import '../entities/edition.dart';
import '../entities/playback_snapshot.dart';
import '../entities/surah.dart';

/// Domain contract for fetching Quran data and persisting playback state.
/// All methods return [Result] — callers handle both success and failure.
abstract interface class QuranRepository {
  /// All 114 surahs (metadata only).
  Future<Result<List<Surah>>> getSurahList();

  /// The curated, playable reciter list ("artists").
  Future<Result<List<Edition>>> getAudioEditions();

  /// The last-played snapshot, or `null` when nothing has been played yet.
  Result<PlaybackSnapshot?> getLastPlayed();

  /// Persists the last-played snapshot.
  Future<Result<void>> saveLastPlayed(PlaybackSnapshot snapshot);
}
