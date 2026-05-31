import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/audio/audio_player_service.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/edition.dart';
import '../../../domain/entities/playback_snapshot.dart';
import '../../../domain/entities/surah.dart';
import '../../../domain/usecases/get_surah_audio_url.dart';
import '../../../domain/usecases/save_last_played.dart';

part 'player_event.dart';
part 'player_state.dart';

/// Manages playback: loading a URL, play/pause/seek, next/prev between surahs,
/// and auto-advance to the next surah when one finishes.
///
/// Stream → event bridge: the three audio streams are forwarded as private
/// events so every `emit` happens on the bloc's event loop. Subscriptions are
/// cancelled and the player disposed in [close] to avoid resource leaks.
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc(this._audio, this._getAudioUrl, this._saveLastPlayed)
    : super(const PlayerInitial()) {
    on<PlaySurahRequested>(_onPlaySurah);
    on<PlayerPauseRequested>(_onPause);
    on<PlayerResumeRequested>(_onResume);
    on<PlayerSeekRequested>(_onSeek);
    on<PlayerNextRequested>(_onNext);
    on<PlayerPreviousRequested>(_onPrevious);
    on<_PositionChanged>(_onPositionChanged);
    on<_DurationChanged>(_onDurationChanged);
    on<_PlaybackChanged>(_onPlaybackChanged);

    _positionSub = _audio.positionStream.listen(
      (p) => add(_PositionChanged(p)),
    );
    _durationSub = _audio.durationStream.listen(
      (d) => add(_DurationChanged(d)),
    );
    _playbackSub = _audio.playbackStream.listen(
      (u) => add(_PlaybackChanged(u)),
    );
  }

  final AudioPlayerService _audio;
  final GetSurahAudioUrl _getAudioUrl;
  final SaveLastPlayed _saveLastPlayed;

  late final StreamSubscription<Duration> _positionSub;
  late final StreamSubscription<Duration?> _durationSub;
  late final StreamSubscription<PlaybackUpdate> _playbackSub;

  /// Last position written to storage; used to throttle saves so we persist at
  /// most every few seconds instead of on every position tick.
  Duration _lastPersisted = Duration.zero;
  static const _persistInterval = Duration(seconds: 5);

  /// The ordered surahs the player can move through (next/prev/auto-advance),
  /// treated like an album queue. Kept across plays so navigation keeps working.
  List<Surah> _playlist = const [];

  int _indexOf(Surah surah) =>
      _playlist.indexWhere((s) => s.number == surah.number);

  bool _hasNext(Surah surah) {
    final i = _indexOf(surah);
    return i >= 0 && i < _playlist.length - 1;
  }

  bool _hasPrevious(Surah surah) => _indexOf(surah) > 0;

  Future<void> _onPlaySurah(
    PlaySurahRequested event,
    Emitter<PlayerState> emit,
  ) async {
    // Keep the most recent non-empty playlist so next/prev keep working even if
    // a later play event omits it.
    if (event.playlist.isNotEmpty) _playlist = event.playlist;
    emit(
      PlayerReady(
        surah: event.surah,
        edition: event.edition,
        position: event.startAt,
        isBuffering: true,
        hasNext: _hasNext(event.surah),
        hasPrevious: _hasPrevious(event.surah),
      ),
    );
    try {
      final url = _getAudioUrl(
        surahNumber: event.surah.number,
        editionId: event.edition.id,
      );
      final duration = await _audio.playUrl(url);
      // Resume from a saved position when continuing a previous track.
      if (event.startAt > Duration.zero) {
        await _audio.seek(event.startAt);
      }
      // Re-read state (stream events may have advanced it during the await) and
      // type-check instead of casting, so a late state change can't throw.
      final latest = state;
      if (duration != null && latest is PlayerReady) {
        emit(latest.copyWith(duration: duration));
      }
      _lastPersisted = event.startAt;
      _persist(event.startAt);
    } on Exception catch (e) {
      emit(
        PlayerFailure(
          AudioFailure(e.toString()),
          surah: event.surah,
          edition: event.edition,
        ),
      );
    }
  }

  Future<void> _onPause(
    PlayerPauseRequested event,
    Emitter<PlayerState> emit,
  ) async {
    // Persist the exact position when the user pauses, so "continue" is precise.
    final current = state;
    if (current is PlayerReady) _persist(current.position);
    await _audio.pause();
  }

  Future<void> _onResume(
    PlayerResumeRequested event,
    Emitter<PlayerState> emit,
  ) => _audio.resume();

  Future<void> _onSeek(PlayerSeekRequested event, Emitter<PlayerState> emit) =>
      _audio.seek(event.position);

  /// Skip forward. Re-dispatches a play request for the next surah (keeping the
  /// current reciter), so all the load/persist logic stays in one place.
  void _onNext(PlayerNextRequested event, Emitter<PlayerState> emit) {
    final current = state;
    if (current is! PlayerReady || !_hasNext(current.surah)) return;
    final next = _playlist[_indexOf(current.surah) + 1];
    add(PlaySurahRequested(surah: next, edition: current.edition));
  }

  void _onPrevious(PlayerPreviousRequested event, Emitter<PlayerState> emit) {
    final current = state;
    if (current is! PlayerReady || !_hasPrevious(current.surah)) return;
    final prev = _playlist[_indexOf(current.surah) - 1];
    add(PlaySurahRequested(surah: prev, edition: current.edition));
  }

  void _onPositionChanged(_PositionChanged event, Emitter<PlayerState> emit) {
    final current = state;
    if (current is! PlayerReady) return;
    emit(current.copyWith(position: event.position));
    // Throttled background save so progress survives an app kill mid-playback.
    if ((event.position - _lastPersisted).abs() >= _persistInterval) {
      _lastPersisted = event.position;
      _persist(event.position);
    }
  }

  void _onDurationChanged(_DurationChanged event, Emitter<PlayerState> emit) {
    final current = state;
    if (current is! PlayerReady) return;
    emit(current.copyWith(duration: event.duration));
  }

  void _onPlaybackChanged(_PlaybackChanged event, Emitter<PlayerState> emit) {
    final current = state;
    if (current is! PlayerReady) return;
    final u = event.update;
    emit(
      current.copyWith(
        isPlaying: u.playing,
        isBuffering:
            u.status == PlaybackStatus.loading ||
            u.status == PlaybackStatus.buffering,
      ),
    );
    // Auto-advance: when a surah finishes, roll on to the next like an album.
    // Stops naturally at the last surah (no next).
    if (u.status == PlaybackStatus.completed && _hasNext(current.surah)) {
      add(const PlayerNextRequested());
    }
  }

  /// Fire-and-forget persistence of the current track + position. A failure to
  /// save is non-fatal to playback, so the Result is intentionally ignored.
  void _persist(Duration position) {
    final current = state;
    if (current is! PlayerReady) return;
    unawaited(
      _saveLastPlayed(
        PlaybackSnapshot(
          surahNumber: current.surah.number,
          editionId: current.edition.id,
          position: position,
        ),
      ),
    );
  }

  /// Cancel every subscription and release the player before the bloc dies.
  /// Order matters: cancel first so no late event tries to `emit` after close.
  @override
  Future<void> close() async {
    await _positionSub.cancel();
    await _durationSub.cancel();
    await _playbackSub.cancel();
    await _audio.dispose();
    return super.close();
  }
}
