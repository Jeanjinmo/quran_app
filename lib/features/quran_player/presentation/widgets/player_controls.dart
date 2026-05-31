import 'package:flutter/material.dart';

/// Primary playback controls: previous · play/pause · next.
///
/// Play/pause/resume is a single toggle button (the standard music-player
/// pattern). Previous/next move between surahs and are disabled at the
/// boundaries (surah 1 has no previous, surah 114 has no next). The play/pause
/// button shows a small spinner while buffering — the one place the design
/// allows a CircularProgressIndicator.
class PlayerControls extends StatelessWidget {
  const PlayerControls({
    required this.isPlaying,
    required this.isBuffering,
    required this.hasNext,
    required this.hasPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final bool isPlaying;
  final bool isBuffering;
  final bool hasNext;
  final bool hasPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 36,
          color: scheme.onSurface,
          // A null onPressed disables + greys out the button at the boundary.
          onPressed: hasPrevious ? onPrevious : null,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
        const SizedBox(width: 16),
        _PlayPauseButton(
          isPlaying: isPlaying,
          isBuffering: isBuffering,
          onPlayPause: onPlayPause,
        ),
        const SizedBox(width: 16),
        IconButton(
          iconSize: 36,
          color: scheme.onSurface,
          onPressed: hasNext ? onNext : null,
          icon: const Icon(Icons.skip_next_rounded),
        ),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayPause,
  });

  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
      child: isBuffering
          ? const Padding(
              padding: EdgeInsets.all(22),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : IconButton(
              iconSize: 40,
              color: scheme.onPrimary,
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              onPressed: onPlayPause,
            ),
    );
  }
}
