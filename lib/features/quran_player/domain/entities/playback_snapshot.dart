import 'package:equatable/equatable.dart';

/// Persisted "where the user left off" record — powers the "Continue listening"
/// card. Stores only what's needed to reconstruct playback.
class PlaybackSnapshot extends Equatable {
  const PlaybackSnapshot({
    required this.surahNumber,
    required this.editionId,
    required this.position,
  });

  final int surahNumber;
  final String editionId;

  /// Last known playback position.
  final Duration position;

  @override
  List<Object> get props => [surahNumber, editionId, position];
}
