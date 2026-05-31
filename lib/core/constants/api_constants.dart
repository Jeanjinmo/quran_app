/// Non-UI constants: API endpoints, audio CDN, and the curated reciter
/// allowlist. User-facing strings live in `lib/l10n/*.arb`, not here.
library;

/// Al-Quran Cloud REST API + the Islamic Network audio CDN.
class ApiConstants {
  const ApiConstants._();

  /// Base URL for the metadata API (surah list, editions).
  static const String baseUrl = 'https://api.alquran.cloud/v1/';

  /// `GET /surah` — list of all 114 surahs.
  static const String surahList = 'surah';

  /// `GET /edition?format=audio` — audio editions (kept for reference; the qari
  /// list shown in-app comes from [QariConstants.allowlist], see that doc).
  static const String audioEditions = 'edition?format=audio';

  /// CDN host that serves **full-surah** mp3 files (one file per whole surah).
  ///
  /// Path: `audio-surah/{bitrate}/{cdnEditionId}/{surahNumber}.mp3`.
  /// Verified facts (HTTP): full-surah audio exists only at **128 kbps** and
  /// only for a subset of Arabic reciters, so [audioBitrate] is fixed.
  static const String audioCdnBase =
      'https://cdn.islamic.network/quran/audio-surah';

  /// The only bitrate for which full-surah files exist on the CDN.
  static const int audioBitrate = 128;

  /// Builds the playable full-surah URL for a reciter + surah.
  static String fullSurahAudioUrl({
    required String cdnEditionId,
    required int surahNumber,
  }) => '$audioCdnBase/$audioBitrate/$cdnEditionId/$surahNumber.mp3';
}

/// A single reciter ("artist") offered in-app.
///
/// [cdnId] is the **CDN namespace** identifier (used to build audio URLs) —
/// note this is *not* the same as the `/edition` API identifier; the two
/// namespaces differ and cannot be mapped 1:1 (e.g. the API's
/// `ar.saoodshuraym` returns 403, while the CDN uses `ar.saudalshuraim`).
class Qari {
  const Qari({
    required this.cdnId,
    required this.name,
    required this.arabicName,
  });

  /// CDN edition id, e.g. `ar.alafasy`. Drives the audio URL.
  final String cdnId;

  /// Display name in Latin script, e.g. "Mishary Alafasy".
  final String name;

  /// Display name in Arabic script.
  final String arabicName;
}

/// Reciters verified to have complete full-surah audio (surahs 1–114, 128 kbps).
/// The live `/edition` API ids don't match CDN folder names, so this list is
/// maintained separately. Names are sourced from the ID3 tags of the mp3 files.
class QariConstants {
  const QariConstants._();

  static const List<Qari> allowlist = [
    Qari(
      cdnId: 'ar.alafasy',
      name: 'Mishary Rashid Alafasy',
      arabicName: 'مشاري راشد العفاسي',
    ),
    Qari(
      cdnId: 'ar.abdulbasitmurattal',
      name: 'AbdulBaset AbdulSamad (Murattal)',
      arabicName: 'عبد الباسط عبد الصمد - مرتل',
    ),
    Qari(
      cdnId: 'ar.abdulbasitmujawwad',
      name: 'AbdulBaset AbdulSamad (Mujawwad)',
      arabicName: 'عبد الباسط عبد الصمد - مجوّد',
    ),
    Qari(
      cdnId: 'ar.saudalshuraim',
      name: "Sa'ud Al-Shuraim",
      arabicName: 'سعود الشريم',
    ),
    Qari(
      cdnId: 'ar.mahershakhashiro',
      name: 'Maher Shakhashero',
      arabicName: 'ماهر شخاشيرو',
    ),
    Qari(
      cdnId: 'ar.muhammadayyub',
      name: 'Mohammad Ayyub',
      arabicName: 'محمد أيوب',
    ),
    Qari(
      cdnId: 'ar.nasseralqatami',
      name: 'Nasser Alqatami',
      arabicName: 'ناصر القطامي',
    ),
    Qari(
      cdnId: 'ar.yasseraldossari',
      name: 'Yasser Al-Dosari',
      arabicName: 'ياسر الدوسري',
    ),
    Qari(
      cdnId: 'ar.abdullahawadaljuhani',
      name: 'Abdullah Awad Al-Juhany',
      arabicName: 'عبد الله عواد الجهني',
    ),
    Qari(
      cdnId: 'ar.aliabdurrahmanalhuthaify',
      name: 'Ali Abdur-Rahman Al-Huthaify',
      arabicName: 'علي عبد الرحمن الحذيفي',
    ),
    Qari(
      cdnId: 'ar.abdullahbasfar',
      name: 'Abdullah Basfar',
      arabicName: 'عبد الله بصفر',
    ),
  ];

  /// The reciter selected by default on first launch.
  static const Qari defaultQari = Qari(
    cdnId: 'ar.alafasy',
    name: 'Mishary Rashid Alafasy',
    arabicName: 'مشاري راشد العفاسي',
  );
}
