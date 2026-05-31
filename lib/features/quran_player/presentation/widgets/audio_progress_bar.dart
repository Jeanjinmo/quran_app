import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// Progress bar + position/duration labels + seek slider.
///
/// When [duration] is null (header not parsed yet) the slider is disabled and
/// shows a 0-length track, so we never render a misleading position against an
/// unknown total. Once duration arrives the slider becomes interactive.
class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    required this.position,
    required this.duration,
    required this.onSeek,
    super.key,
  });

  final Duration position;
  final Duration? duration;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    final total = duration ?? Duration.zero;
    final maxMs = total.inMilliseconds.toDouble();
    // Clamp so a position slightly past a just-learned duration can't overflow.
    final value = position.inMilliseconds.clamp(0, maxMs.toInt()).toDouble();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: value,
            max: maxMs <= 0 ? 1 : maxMs,
            onChanged: duration == null
                ? null
                : (v) => onSeek(Duration(milliseconds: v.round())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDuration(position), style: textTheme.bodySmall),
              Text(
                duration == null ? '--:--' : formatDuration(total),
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
