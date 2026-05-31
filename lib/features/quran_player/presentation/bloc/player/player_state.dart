part of 'player_bloc.dart';

sealed class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

/// Nothing loaded yet.
final class PlayerInitial extends PlayerState {
  const PlayerInitial();
}

/// A surah is loaded (or loading). One rich state carries everything the player
/// UI needs; it's updated via [copyWith] on every position tick so rebuilds are
/// cheap and the screen never loses the surah/edition context.
final class PlayerReady extends PlayerState {
  const PlayerReady({
    required this.surah,
    required this.edition,
    this.position = Duration.zero,
    this.duration,
    this.isPlaying = false,
    this.isBuffering = true,
    this.hasNext = false,
    this.hasPrevious = false,
  });

  final Surah surah;
  final Edition edition;
  final Duration position;

  /// Total track length; `null` until the audio header is parsed. The UI must
  /// disable the slider and show buffering while this is null.
  final Duration? duration;

  final bool isPlaying;
  final bool isBuffering;

  /// Whether the playlist has a surah after/before the current one — drives the
  /// enabled state of the next/previous controls.
  final bool hasNext;
  final bool hasPrevious;

  PlayerReady copyWith({
    Surah? surah,
    Edition? edition,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBuffering,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return PlayerReady(
      surah: surah ?? this.surah,
      edition: edition ?? this.edition,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }

  @override
  List<Object?> get props => [
    surah,
    edition,
    position,
    duration,
    isPlaying,
    isBuffering,
    hasNext,
    hasPrevious,
  ];
}

/// Playback failed (e.g. CDN 403 for an unavailable reciter). Keeps the surah/
/// edition so the UI can offer a retry or "pick another reciter".
final class PlayerFailure extends PlayerState {
  const PlayerFailure(this.failure, {this.surah, this.edition});

  final Failure failure;
  final Surah? surah;
  final Edition? edition;

  @override
  List<Object?> get props => [failure, surah, edition];
}
