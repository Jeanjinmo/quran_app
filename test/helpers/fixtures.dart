import 'package:quran_app/features/quran_player/domain/entities/edition.dart';
import 'package:quran_app/features/quran_player/domain/entities/surah.dart';

/// Shared test data so individual tests stay focused on behavior, not setup.
const tSurah1 = Surah(
  number: 1,
  name: 'سُورَةُ ٱلْفَاتِحَةِ',
  englishName: 'Al-Faatiha',
  englishNameTranslation: 'The Opening',
  numberOfAyahs: 7,
  revelationType: 'Meccan',
);

const tSurah2 = Surah(
  number: 2,
  name: 'سُورَةُ ٱلْبَقَرَةِ',
  englishName: 'Al-Baqara',
  englishNameTranslation: 'The Cow',
  numberOfAyahs: 286,
  revelationType: 'Medinan',
);

const tSurahs = [tSurah1, tSurah2];

const tEdition1 = Edition(
  id: 'ar.alafasy',
  name: 'Mishary Rashid Alafasy',
  arabicName: 'مشاري راشد العفاسي',
);

const tEdition2 = Edition(
  id: 'ar.abdullahbasfar',
  name: 'Abdullah Basfar',
  arabicName: 'عبد الله بصفر',
);

const tEditions = [tEdition1, tEdition2];
