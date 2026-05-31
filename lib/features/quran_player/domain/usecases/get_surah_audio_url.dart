import '../../../../core/constants/api_constants.dart';

/// Builds the CDN audio URL for a given surah and reciter (128 kbps, full-surah).
/// Pure and synchronous — no repository or I/O.
class GetSurahAudioUrl {
  const GetSurahAudioUrl();

  String call({required int surahNumber, required String editionId}) {
    return ApiConstants.fullSurahAudioUrl(
      cdnEditionId: editionId,
      surahNumber: surahNumber,
    );
  }
}
