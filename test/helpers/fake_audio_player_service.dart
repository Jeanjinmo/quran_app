import 'dart:async';

import 'package:quran_app/core/audio/audio_player_service.dart';

/// A controllable fake of [AudioPlayerService] for bloc tests.
///
/// Exposes the three streams via [StreamController]s so a test can push exact
/// position/duration/playback values and assert how PlayerBloc reacts — no real
/// audio, no platform channels.
class FakeAudioPlayerService implements AudioPlayerService {
  final positionController = StreamController<Duration>.broadcast();
  final durationController = StreamController<Duration?>.broadcast();
  final playbackController = StreamController<PlaybackUpdate>.broadcast();

  Duration? nextDuration;
  bool throwOnPlay = false;
  final List<String> playedUrls = [];
  Duration? seekedTo;
  bool paused = false;
  bool resumed = false;
  bool disposed = false;

  @override
  Stream<Duration> get positionStream => positionController.stream;

  @override
  Stream<Duration?> get durationStream => durationController.stream;

  @override
  Stream<PlaybackUpdate> get playbackStream => playbackController.stream;

  @override
  Future<Duration?> playUrl(String url) async {
    if (throwOnPlay) throw Exception('boom');
    playedUrls.add(url);
    return nextDuration;
  }

  @override
  Future<void> pause() async => paused = true;

  @override
  Future<void> resume() async => resumed = true;

  @override
  Future<void> seek(Duration position) async => seekedTo = position;

  @override
  Future<void> dispose() async {
    disposed = true;
    await positionController.close();
    await durationController.close();
    await playbackController.close();
  }
}
