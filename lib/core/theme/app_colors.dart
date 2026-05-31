import 'package:flutter/material.dart';

/// Brand colour palette tokens. Semantic mapping to light/dark schemes
/// is in `app_theme.dart`.
class AppColors {
  const AppColors._();

  // ── Brand (violet family) ───────────────────────────────
  static const Color primary = Color(0xFF672CBC); // light brand / active
  static const Color primaryMedium = Color(0xFF863ED5); // gradient mid, badges
  static const Color primaryBright = Color(0xFF994EF8); // gradient highlight
  static const Color primaryDark = Color(0xFF3B1E77); // gradient start
  static const Color navyDeep = Color(0xFF240F4F); // primary text (light)
  static const Color primaryDarkMode = Color(0xFFA44AFF); // brand in dark

  // ── Text ────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF240F4F);
  static const Color textSecondary = Color(0xFF8789A3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFA19CC5);

  // ── Backgrounds & surfaces ──────────────────────────────
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5EFFB);
  static const Color backgroundDark = Color(0xFF040C23);
  static const Color surfaceDark = Color(0xFF1D2233);

  // ── Accent ──────────────────────────────────────────────
  static const Color accentPeach = Color(0xFFF9B091); // CTA button
  static const Color accentGold = Color(0xFFF5B304);

  // ── Navigation / dividers ───────────────────────────────
  static const Color navInactive = Color(0xFF8789A3);
  static const Color divider = Color(0xFFBBC4CE);

  /// Shared gradient for the "Continue listening" card and the player's
  /// album-art header (top-left → bottom-right).
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryMedium, primaryBright],
  );
}
