import 'dart:async';

import 'package:just_audio/just_audio.dart';

/// Playback lifecycle states — mirrors just_audio's `ProcessingState` but
/// owned here so the BLoC and tests stay free of just_audio imports.
enum PlaybackStatus { idle, loading, buffering, ready, completed }

/// Thin interface over [AudioPlayer] so the BLoC and tests don't depend
/// on just_audio directly.
abstract interface class AudioPlayerService {
  /// Emits the current playback position as it advances.
  Stream<Duration> get positionStream;

  /// Emits the total track duration; `null` until it is known (e.g. while the
  /// header is still loading). The UI must treat `null` as "not ready yet".
  Stream<Duration?> get durationStream;

  /// Emits `(status, playing)` whenever either changes.
  Stream<PlaybackUpdate> get playbackStream;

  /// Loads [url] and starts playback. Returns the duration if already known.
  Future<Duration?> playUrl(String url);

  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration position);

  /// Releases native resources. Call from the owner's `close()`/`dispose()`.
  Future<void> dispose();
}

/// Value object emitted by [AudioPlayerService.playbackStream].
class PlaybackUpdate {
  const PlaybackUpdate({required this.status, required this.playing});

  final PlaybackStatus status;
  final bool playing;
}

/// just_audio-backed implementation.
class JustAudioPlayerService implements AudioPlayerService {
  JustAudioPlayerService([AudioPlayer? player])
    : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Stream<PlaybackUpdate> get playbackStream => _player.playerStateStream.map(
    (s) => PlaybackUpdate(
      status: _mapStatus(s.processingState),
      playing: s.playing,
    ),
  );

  @override
  Future<Duration?> playUrl(String url) async {
    final duration = await _player.setUrl(url);
    // Fire-and-forget: play() completes when playback *stops*, so we must not
    // await it here or this method would never return.
    unawaited(_player.play());
    return duration;
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> resume() => _player.play();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> dispose() => _player.dispose();

  PlaybackStatus _mapStatus(ProcessingState state) => switch (state) {
    ProcessingState.idle => PlaybackStatus.idle,
    ProcessingState.loading => PlaybackStatus.loading,
    ProcessingState.buffering => PlaybackStatus.buffering,
    ProcessingState.ready => PlaybackStatus.ready,
    ProcessingState.completed => PlaybackStatus.completed,
  };
}
