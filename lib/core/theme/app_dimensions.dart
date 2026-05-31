/// Spacing, radii, and component sizes. Centralised so screens stay
/// visually consistent and easy to retune.
class AppDimensions {
  const AppDimensions._();

  // ── Spacing ─────────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24; // screen padding
  static const double spacingXl = 32;

  // ── Border radius ───────────────────────────────────────
  static const double radiusCard = 16;
  static const double radiusButton = 30; // pill CTA
  static const double radiusBadge = 50; // full circle
  static const double radiusTag = 8;

  // ── Component sizes ─────────────────────────────────────
  static const double listItemHeight = 62;
  static const double surahBadgeSize = 36;
  static const double ctaButtonHeight = 60;
  static const double miniPlayerHeight = 64;
  static const double albumArtSize = 220;
}
