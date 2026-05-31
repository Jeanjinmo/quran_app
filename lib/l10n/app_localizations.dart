import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Application title shown on the home app bar
  ///
  /// In en, this message translates to:
  /// **'Quran Player'**
  String get appTitle;

  /// Greeting label on the home screen
  ///
  /// In en, this message translates to:
  /// **'Assalamualaikum'**
  String get greeting;

  /// Home tab label for the surah list
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get tabSurah;

  /// Home tab label for the juz list
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get tabJuz;

  /// Title for a juz row, e.g. 'Juz 1'
  ///
  /// In en, this message translates to:
  /// **'Juz {number}'**
  String juzLabel(int number);

  /// Number of surahs within a juz
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 surah} other{{count} surahs}}'**
  String surahCount(int count);

  /// Placeholder for the surah search field (search by title)
  ///
  /// In en, this message translates to:
  /// **'Search surah…'**
  String get searchSurahHint;

  /// Placeholder for the reciter search field (search by artist)
  ///
  /// In en, this message translates to:
  /// **'Search reciter…'**
  String get searchArtistHint;

  /// Title of the last-played card on home
  ///
  /// In en, this message translates to:
  /// **'Continue listening'**
  String get continueListening;

  /// Title of the random-play card on home
  ///
  /// In en, this message translates to:
  /// **'Random play'**
  String get randomPlay;

  /// Subtitle of the random-play card on home
  ///
  /// In en, this message translates to:
  /// **'Play a surah at random'**
  String get randomPlaySubtitle;

  /// Label preceding the currently selected reciter
  ///
  /// In en, this message translates to:
  /// **'Reciter'**
  String get reciterLabel;

  /// Title of the reciter selection bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Choose reciter'**
  String get chooseReciter;

  /// Player screen header
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get nowPlaying;

  /// Play control label
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Pause control label
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Resume control label
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Number of verses (ayahs) in a surah
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 verse} other{{count} verses}}'**
  String versesCount(int count);

  /// Revelation type label for Meccan surahs
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get revelationMeccan;

  /// Revelation type label for Medinan surahs
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get revelationMedinan;

  /// Retry button on error states
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Message shown when there is no connectivity
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNetwork;

  /// Message shown on server/API errors
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading data. Please try again.'**
  String get errorServer;

  /// Message shown when audio playback fails
  ///
  /// In en, this message translates to:
  /// **'Could not play this recitation. Try another reciter.'**
  String get errorAudio;

  /// Shown when a search yields no matches
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get emptySearch;

  /// Settings menu title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Indonesian language option
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;

  /// Follow system language option
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Follow system theme option
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
