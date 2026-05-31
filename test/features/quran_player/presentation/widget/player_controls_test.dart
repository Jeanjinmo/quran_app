import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran_player/presentation/widgets/player_controls.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  // Controls with sensible defaults; override per test.
  Widget controls({
    bool isPlaying = false,
    bool isBuffering = false,
    bool hasNext = true,
    bool hasPrevious = true,
    VoidCallback? onPlayPause,
    VoidCallback? onNext,
    VoidCallback? onPrevious,
  }) {
    return PlayerControls(
      isPlaying: isPlaying,
      isBuffering: isBuffering,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      onPlayPause: onPlayPause ?? () {},
      onNext: onNext ?? () {},
      onPrevious: onPrevious ?? () {},
    );
  }

  testWidgets('shows a spinner while buffering (no play/pause icon)', (
    tester,
  ) async {
    await tester.pumpApp(controls(isBuffering: true));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
    expect(find.byIcon(Icons.pause_rounded), findsNothing);
  });

  testWidgets('shows play icon when paused and ready', (tester) async {
    await tester.pumpApp(controls());
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows pause icon when playing', (tester) async {
    await tester.pumpApp(controls(isPlaying: true));
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
  });

  testWidgets('tapping the play button fires onPlayPause', (tester) async {
    var tapped = 0;
    await tester.pumpApp(controls(onPlayPause: () => tapped++));
    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    expect(tapped, 1);
  });

  testWidgets('next/prev fire their callbacks when enabled', (tester) async {
    var next = 0;
    var prev = 0;
    await tester.pumpApp(
      controls(onNext: () => next++, onPrevious: () => prev++),
    );
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await tester.tap(find.byIcon(Icons.skip_previous_rounded));
    expect(next, 1);
    expect(prev, 1);
  });

  testWidgets('next is disabled at the last surah (hasNext=false)', (
    tester,
  ) async {
    await tester.pumpApp(controls(hasNext: false));
    final nextButton = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.skip_next_rounded),
        matching: find.byType(IconButton),
      ),
    );
    expect(nextButton.onPressed, isNull);
  });

  testWidgets('previous is disabled at the first surah (hasPrevious=false)', (
    tester,
  ) async {
    await tester.pumpApp(controls(hasPrevious: false));
    final prevButton = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.skip_previous_rounded),
        matching: find.byType(IconButton),
      ),
    );
    expect(prevButton.onPressed, isNull);
  });
}
