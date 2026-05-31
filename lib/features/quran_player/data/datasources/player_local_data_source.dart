import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/playback_snapshot.dart';

/// Persists the last-played snapshot via `shared_preferences`.
/// Throws [CacheException] on read/write failures.
abstract interface class PlayerLocalDataSource {
  PlaybackSnapshot? readLastPlayed();
  Future<void> saveLastPlayed(PlaybackSnapshot snapshot);
}

class PlayerLocalDataSourceImpl implements PlayerLocalDataSource {
  const PlayerLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _surahKey = 'lastPlayed.surahNumber';
  static const _editionKey = 'lastPlayed.editionId';
  static const _positionKey = 'lastPlayed.positionMs';

  @override
  PlaybackSnapshot? readLastPlayed() {
    final surah = _prefs.getInt(_surahKey);
    final edition = _prefs.getString(_editionKey);
    // Both identifiers are required to reconstruct playback; if either is
    // missing there's nothing to continue.
    if (surah == null || edition == null) return null;
    return PlaybackSnapshot(
      surahNumber: surah,
      editionId: edition,
      position: Duration(milliseconds: _prefs.getInt(_positionKey) ?? 0),
    );
  }

  @override
  Future<void> saveLastPlayed(PlaybackSnapshot snapshot) async {
    try {
      await _prefs.setInt(_surahKey, snapshot.surahNumber);
      await _prefs.setString(_editionKey, snapshot.editionId);
      await _prefs.setInt(_positionKey, snapshot.position.inMilliseconds);
    } on Exception catch (e) {
      throw CacheException('Failed to save last played: $e');
    }
  }
}
