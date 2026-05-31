/// Pure formatting helpers (no Flutter imports — keep them trivially testable).
library;

/// Formats a [Duration] as `m:ss` (or `h:mm:ss` for tracks over an hour).
String formatDuration(Duration d) {
  if (d.isNegative) return '0:00';
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  final seconds = d.inSeconds.remainder(60);
  final ss = seconds.toString().padLeft(2, '0');
  if (hours > 0) {
    final mm = minutes.toString().padLeft(2, '0');
    return '$hours:$mm:$ss';
  }
  return '$minutes:$ss';
}
