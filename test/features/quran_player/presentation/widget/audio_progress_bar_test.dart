import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran_player/presentation/widgets/audio_progress_bar.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('disables the slider and shows --:-- when duration is null', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: AudioProgressBar(
          position: const Duration(seconds: 5),
          duration: null,
          onSeek: (_) {},
        ),
      ),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.onChanged, isNull); // disabled
    expect(find.text('--:--'), findsOneWidget);
    expect(find.text('0:05'), findsOneWidget);
  });

  testWidgets('enables the slider and shows total when duration is known', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: AudioProgressBar(
          position: const Duration(minutes: 1, seconds: 12),
          duration: const Duration(minutes: 4, seconds: 20),
          onSeek: (_) {},
        ),
      ),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.onChanged, isNotNull); // enabled
    expect(find.text('1:12'), findsOneWidget);
    expect(find.text('4:20'), findsOneWidget);
  });
}
