import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Light and dark [ThemeData] built from [AppColors].
/// Uses explicit [ColorScheme]s (not `fromSeed`) to match the specific
/// violet palette exactly. Poppins is applied globally via `google_fonts`.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(
    brightness: Brightness.light,
    scheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.primaryMedium,
      onSecondary: AppColors.textOnPrimary,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceLight,
      outline: AppColors.divider,
    ),
    scaffoldBg: AppColors.backgroundLight,
    appBarTitle: AppColors.primary,
    appBarIcon: AppColors.primary,
    secondaryText: AppColors.textSecondary,
    tabActive: AppColors.primary,
    tabInactive: AppColors.navInactive,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    scheme: const ColorScheme.dark(
      primary: AppColors.primaryDarkMode,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.primaryMedium,
      onSecondary: AppColors.textOnPrimary,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceDark,
      outline: AppColors.divider,
    ),
    scaffoldBg: AppColors.backgroundDark,
    appBarTitle: AppColors.textPrimaryDark,
    appBarIcon: AppColors.textPrimaryDark,
    secondaryText: AppColors.textSecondaryDark,
    tabActive: AppColors.primaryDarkMode,
    tabInactive: AppColors.textSecondaryDark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffoldBg,
    required Color appBarTitle,
    required Color appBarIcon,
    required Color secondaryText,
    required Color tabActive,
    required Color tabInactive,
  }) {
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: appBarTitle,
        ),
        iconTheme: IconThemeData(color: appBarIcon),
      ),
      dividerTheme: DividerThemeData(
        // 35% opacity per the design; withValues is the Flutter 3.44 API.
        color: AppColors.divider.withValues(alpha: 0.35),
        thickness: 1,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: tabActive,
        unselectedLabelColor: tabInactive,
        indicatorColor: tabActive,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
    );
  }
}
