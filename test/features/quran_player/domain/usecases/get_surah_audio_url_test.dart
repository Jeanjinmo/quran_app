import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran_player/domain/usecases/get_surah_audio_url.dart';

void main() {
  const usecase = GetSurahAudioUrl();

  test('builds the full-surah CDN url at 128 kbps', () {
    final url = usecase(surahNumber: 1, editionId: 'ar.alafasy');
    expect(
      url,
      'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3',
    );
  });

  test('uses the given surah number and edition', () {
    final url = usecase(surahNumber: 114, editionId: 'ar.abdullahbasfar');
    expect(url, endsWith('/128/ar.abdullahbasfar/114.mp3'));
  });
}
