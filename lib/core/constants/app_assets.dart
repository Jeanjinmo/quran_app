/// Typed constants for bundled image asset paths.
class AppAssets {
  const AppAssets._();

  static const String _base = 'assets/images';

  /// Open-Quran illustration (206x126) — album art + the Last-Read card art.
  static const String quran = '$_base/Quran.png';

  /// Small "Last Read" label icon (20x20).
  static const String lastReadIcon = '$_base/last_read_icon.png';

  /// Octagonal violet badge (36x36) behind a surah's number in the list.
  static const String numberBadge = '$_base/number.png';

  /// Full Last-Read card reference (326x131). Kept for visual reference; the
  /// card itself is rebuilt in code so its text is dynamic.
  static const String cardHome = '$_base/card_homepage.png';
}
