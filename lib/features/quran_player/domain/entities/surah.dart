import 'package:equatable/equatable.dart';

/// A surah ("song") — pure domain entity, no JSON or Flutter imports.
class Surah extends Equatable {
  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  /// 1-based surah number (1–114). Also used to build the audio URL.
  final int number;

  /// Arabic name, e.g. "سُورَةُ ٱلْفَاتِحَةِ".
  final String name;

  /// Transliterated name, e.g. "Al-Faatiha".
  final String englishName;

  /// English meaning, e.g. "The Opening".
  final String englishNameTranslation;

  /// Number of verses (ayahs) in the surah.
  final int numberOfAyahs;

  /// "Meccan" or "Medinan".
  final String revelationType;

  @override
  List<Object> get props => [
    number,
    name,
    englishName,
    englishNameTranslation,
    numberOfAyahs,
    revelationType,
  ];
}
