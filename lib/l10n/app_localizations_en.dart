// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
      other: '$count surahs',
      one: '1 surah',
    );
    return '$_temp0';
  }

  @override
  String get searchSurahHint => 'Search surah…';

  @override
  String get searchArtistHint => 'Search reciter…';

  @override
  String get continueListening => 'Continue listening';

  @override
  String get randomPlay => 'Random play';

  @override
  String get randomPlaySubtitle => 'Play a surah at random';

  @override
  String get reciterLabel => 'Reciter';

  @override
  String get chooseReciter => 'Choose reciter';

  @override
  String get nowPlaying => 'Now playing';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String versesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verses',
      one: '1 verse',
    );
    return '$_temp0';
  }

  @override
  String get revelationMeccan => 'Meccan';

  @override
  String get revelationMedinan => 'Medinan';

  @override
  String get retry => 'Retry';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorServer =>
      'Something went wrong while loading data. Please try again.';

  @override
  String get errorAudio =>
      'Could not play this recitation. Try another reciter.';

  @override
  String get emptySearch => 'No results found.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get languageSystem => 'System default';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System default';
}
