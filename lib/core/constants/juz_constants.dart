/// Static juz-to-surah mapping (30 entries, hardcoded — boundaries never change).
/// A surah can span multiple juz, so a number may appear in adjacent entries.
class Juz {
  const Juz({required this.number, required this.surahNumbers});

  /// 1-based juz number (1-30).
  final int number;

  /// Surah numbers appearing in this juz, in order.
  final List<int> surahNumbers;
}

class JuzConstants {
  const JuzConstants._();

  static const List<Juz> all = [
    Juz(number: 1, surahNumbers: [1, 2]),
    Juz(number: 2, surahNumbers: [2]),
    Juz(number: 3, surahNumbers: [2, 3]),
    Juz(number: 4, surahNumbers: [3, 4]),
    Juz(number: 5, surahNumbers: [4]),
    Juz(number: 6, surahNumbers: [4, 5]),
    Juz(number: 7, surahNumbers: [5, 6]),
    Juz(number: 8, surahNumbers: [6, 7]),
    Juz(number: 9, surahNumbers: [7, 8]),
    Juz(number: 10, surahNumbers: [8, 9]),
    Juz(number: 11, surahNumbers: [9, 10, 11]),
    Juz(number: 12, surahNumbers: [11, 12]),
    Juz(number: 13, surahNumbers: [12, 13, 14]),
    Juz(number: 14, surahNumbers: [15, 16]),
    Juz(number: 15, surahNumbers: [17, 18]),
    Juz(number: 16, surahNumbers: [18, 19, 20]),
    Juz(number: 17, surahNumbers: [21, 22]),
    Juz(number: 18, surahNumbers: [23, 24, 25]),
    Juz(number: 19, surahNumbers: [25, 26, 27]),
    Juz(number: 20, surahNumbers: [27, 28, 29]),
    Juz(number: 21, surahNumbers: [29, 30, 31, 32, 33]),
    Juz(number: 22, surahNumbers: [33, 34, 35, 36]),
    Juz(number: 23, surahNumbers: [36, 37, 38, 39]),
    Juz(number: 24, surahNumbers: [39, 40, 41]),
    Juz(number: 25, surahNumbers: [41, 42, 43, 44, 45]),
    Juz(number: 26, surahNumbers: [46, 47, 48, 49, 50, 51]),
    Juz(number: 27, surahNumbers: [51, 52, 53, 54, 55, 56, 57]),
    Juz(number: 28, surahNumbers: [58, 59, 60, 61, 62, 63, 64, 65, 66]),
    Juz(number: 29, surahNumbers: [67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77]),
    // Juz 30 ("Amma"): An-Naba (78) through An-Nas (114).
    Juz(
      number: 30,
      surahNumbers: [
        78,
        79,
        80,
        81,
        82,
        83,
        84,
        85,
        86,
        87,
        88,
        89,
        90,
        91,
        92,
        93,
        94,
        95,
        96,
        97,
        98,
        99,
        100,
        101,
        102,
        103,
        104,
        105,
        106,
        107,
        108,
        109,
        110,
        111,
        112,
        113,
        114,
      ],
    ),
  ];
}
