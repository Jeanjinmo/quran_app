import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/utils/formatters.dart';

void main() {
  group('formatDuration', () {
    test('formats sub-hour durations as m:ss', () {
      expect(formatDuration(const Duration(seconds: 5)), '0:05');
      expect(formatDuration(const Duration(minutes: 1, seconds: 12)), '1:12');
      expect(formatDuration(const Duration(minutes: 4, seconds: 20)), '4:20');
    });

    test('formats hour-plus durations as h:mm:ss', () {
      expect(
        formatDuration(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1:02:03',
      );
    });

    test('clamps negatives to 0:00', () {
      expect(formatDuration(const Duration(seconds: -5)), '0:00');
    });
  });
}
