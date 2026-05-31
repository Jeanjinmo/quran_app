// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Quran Player';

  @override
  String get greeting => 'Assalamualaikum';

  @override
  String get tabSurah => 'Surah';

  @override
  String get tabJuz => 'Juz';

  @override
  String juzLabel(int number) {
    return 'Juz $number';
  }

  @override
  String surahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count surah',
    );
    return '$_temp0';
  }

  @override
  String get searchSurahHint => 'Cari surah…';

  @override
  String get searchArtistHint => 'Cari qari…';

  @override
  String get continueListening => 'Lanjutkan mendengarkan';

  @override
  String get randomPlay => 'Putar acak';

  @override
  String get randomPlaySubtitle => 'Putar surah secara acak';

  @override
  String get reciterLabel => 'Qari';

  @override
  String get chooseReciter => 'Pilih qari';

  @override
  String get nowPlaying => 'Sedang diputar';

  @override
  String get play => 'Putar';

  @override
  String get pause => 'Jeda';

  @override
  String get resume => 'Lanjut';

  @override
  String versesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayat',
    );
    return '$_temp0';
  }

  @override
  String get revelationMeccan => 'Makkiyah';

  @override
  String get revelationMedinan => 'Madaniyah';

  @override
  String get retry => 'Coba lagi';

  @override
  String get errorNetwork =>
      'Tidak ada koneksi internet. Periksa jaringan lalu coba lagi.';

  @override
  String get errorServer =>
      'Terjadi kesalahan saat memuat data. Silakan coba lagi.';

  @override
  String get errorAudio => 'Tidak dapat memutar bacaan ini. Coba qari lain.';

  @override
  String get emptySearch => 'Tidak ada hasil ditemukan.';

  @override
  String get settings => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get languageEnglish => 'Inggris';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get languageSystem => 'Ikuti sistem';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Ikuti sistem';
}
