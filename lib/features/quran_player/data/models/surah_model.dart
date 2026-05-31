import '../../../../core/error/exceptions.dart';
import '../../domain/entities/surah.dart';

/// Data-layer model for a surah from `GET /surah`. [toEntity] converts it
/// to the domain [Surah] so the rest of the app never touches raw JSON.
class SurahModel {
  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      revelationType: json['revelationType'] as String,
    );
  }

  /// Builds a list of models from the API's `data` array, validating the shape.
  static List<SurahModel> listFromData(Object? data) {
    if (data is! List) {
      throw const ServerException('Expected a list of surahs');
    }
    return data
        .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Surah toEntity() => Surah(
    number: number,
    name: name,
    englishName: englishName,
    englishNameTranslation: englishNameTranslation,
    numberOfAyahs: numberOfAyahs,
    revelationType: revelationType,
  );
}
