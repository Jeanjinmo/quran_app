part of 'player_bloc.dart';

sealed class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

/// Start playing a surah with a reciter (loads the URL, then plays).
///
/// [startAt] lets "Continue listening" resume from a saved position; defaults to
/// the beginning for a fresh play. [playlist] is the ordered set of surahs the
/// player can move through (next/prev/auto-advance) — pass the full 114 so the
/// player behaves like an album; an empty list disables next/prev.
final class PlaySurahRequested extends PlayerEvent {
  const PlaySurahRequested({
    required this.surah,
    required this.edition,
    this.startAt = Duration.zero,
    this.playlist = const [],
  });

  final Surah surah;
  final Edition edition;
  final Duration startAt;
  final List<Surah> playlist;

  @override
  List<Object?> get props => [surah, edition, startAt, playlist];
}

final class PlayerPauseRequested extends PlayerEvent {
  const PlayerPauseRequested();
}

final class PlayerResumeRequested extends PlayerEvent {
  const PlayerResumeRequested();
}

/// Seek to [position] (driven by the slider).
final class PlayerSeekRequested extends PlayerEvent {
  const PlayerSeekRequested(this.position);

  final Duration position;

  @override
  List<Object?> get props => [position];
}

/// Skip to the next surah in the playlist (no-op at the end).
final class PlayerNextRequested extends PlayerEvent {
  const PlayerNextRequested();
}

/// Skip to the previous surah in the playlist (no-op at the start).
final class PlayerPreviousRequested extends PlayerEvent {
  const PlayerPreviousRequested();
}

// ── Private events bridged from the audio service's streams ──────────────────
// Routed through events so all emits stay on the bloc's event loop,
// avoiding any emit-after-close risk from stream callbacks.

final class _PositionChanged extends PlayerEvent {
  const _PositionChanged(this.position);

  final Duration position;

  @override
  List<Object?> get props => [position];
}

final class _DurationChanged extends PlayerEvent {
  const _DurationChanged(this.duration);

  final Duration? duration;

  @override
  List<Object?> get props => [duration];
}

final class _PlaybackChanged extends PlayerEvent {
  const _PlaybackChanged(this.update);

  final PlaybackUpdate update;

  @override
  List<Object?> get props => [update.status, update.playing];
}
