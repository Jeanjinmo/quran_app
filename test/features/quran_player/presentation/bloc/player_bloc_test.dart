import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/audio/audio_player_service.dart';
import 'package:quran_app/core/utils/result.dart';
import 'package:quran_app/features/quran_player/domain/entities/playback_snapshot.dart';
import 'package:quran_app/features/quran_player/domain/repositories/quran_repository.dart';
import 'package:quran_app/features/quran_player/domain/usecases/get_surah_audio_url.dart';
import 'package:quran_app/features/quran_player/domain/usecases/save_last_played.dart';
import 'package:quran_app/features/quran_player/presentation/bloc/player/player_bloc.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fixtures.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

void main() {
  late FakeAudioPlayerService audio;
  late MockQuranRepository repo;

  setUpAll(() {
    registerFallbackValue(
      const PlaybackSnapshot(
        surahNumber: 1,
        editionId: 'ar.alafasy',
        position: Duration.zero,
      ),
    );
  });

  setUp(() {
    audio = FakeAudioPlayerService();
    repo = MockQuranRepository();
    when(
      () => repo.saveLastPlayed(any()),
    ).thenAnswer((_) async => const Ok(null));
  });

  PlayerBloc build() =>
      PlayerBloc(audio, const GetSurahAudioUrl(), SaveLastPlayed(repo));

  blocTest<PlayerBloc, PlayerState>(
    'PlaySurahRequested loads the url and emits PlayerReady with duration',
    setUp: () => audio.nextDuration = const Duration(minutes: 4),
    build: build,
    act: (b) =>
        b.add(const PlaySurahRequested(surah: tSurah1, edition: tEdition1)),
    expect: () => [
      isA<PlayerReady>().having((s) => s.isBuffering, 'isBuffering', true),
      isA<PlayerReady>().having(
        (s) => s.duration,
        'duration',
        const Duration(minutes: 4),
      ),
    ],
    verify: (_) {
      expect(audio.playedUrls.single, contains('/ar.alafasy/1.mp3'));
    },
  );

  blocTest<PlayerBloc, PlayerState>(
    'position stream updates PlayerReady.position',
    build: build,
    act: (b) async {
      b.add(const PlaySurahRequested(surah: tSurah1, edition: tEdition1));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      audio.positionController.add(const Duration(seconds: 12));
    },
    skip: 1,
    expect: () => [
      isA<PlayerReady>().having(
        (s) => s.position,
        'position',
        const Duration(seconds: 12),
      ),
    ],
  );

  blocTest<PlayerBloc, PlayerState>(
    'emits PlayerFailure when playback throws',
    setUp: () => audio.throwOnPlay = true,
    build: build,
    act: (b) =>
        b.add(const PlaySurahRequested(surah: tSurah1, edition: tEdition1)),
    expect: () => [isA<PlayerReady>(), isA<PlayerFailure>()],
  );

  blocTest<PlayerBloc, PlayerState>(
    'pause forwards to the audio service',
    build: build,
    act: (b) async {
      b.add(const PlaySurahRequested(surah: tSurah1, edition: tEdition1));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      b.add(const PlayerPauseRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
    },
    verify: (_) => expect(audio.paused, isTrue),
  );

  test('close cancels subscriptions and disposes the player', () async {
    final bloc = build();
    await bloc.close();
    expect(audio.disposed, isTrue);
  });

  group('playlist navigation', () {
    blocTest<PlayerBloc, PlayerState>(
      'sets hasPrevious=false / hasNext=true at the first surah',
      build: build,
      act: (b) => b.add(
        const PlaySurahRequested(
          surah: tSurah1,
          edition: tEdition1,
          playlist: tSurahs,
        ),
      ),
      expect: () => [
        isA<PlayerReady>()
            .having((s) => s.hasPrevious, 'hasPrevious', false)
            .having((s) => s.hasNext, 'hasNext', true),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'next advances to the following surah in the playlist',
      build: build,
      act: (b) async {
        b.add(
          const PlaySurahRequested(
            surah: tSurah1,
            edition: tEdition1,
            playlist: tSurahs,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));
        b.add(const PlayerNextRequested());
        await Future<void>.delayed(const Duration(milliseconds: 100));
      },
      verify: (_) => expect(audio.playedUrls.last, contains('/2.mp3')),
    );

    blocTest<PlayerBloc, PlayerState>(
      'next is a no-op at the last surah',
      build: build,
      act: (b) async {
        b.add(
          const PlaySurahRequested(
            surah: tSurah2,
            edition: tEdition1,
            playlist: tSurahs,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));
        b.add(const PlayerNextRequested());
        await Future<void>.delayed(const Duration(milliseconds: 100));
      },
      verify: (_) => expect(audio.playedUrls.length, 1),
    );

    blocTest<PlayerBloc, PlayerState>(
      'auto-advances to the next surah when playback completes',
      build: build,
      act: (b) async {
        b.add(
          const PlaySurahRequested(
            surah: tSurah1,
            edition: tEdition1,
            playlist: tSurahs,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));
        audio.playbackController.add(
          const PlaybackUpdate(
            status: PlaybackStatus.completed,
            playing: false,
          ),
        );
        // Auto-advance is a chain of events (completed → next → play), so allow
        // a few event-loop turns for it to settle.
        await Future<void>.delayed(const Duration(milliseconds: 300));
      },
      verify: (_) => expect(audio.playedUrls.last, contains('/2.mp3')),
    );
  });
}
