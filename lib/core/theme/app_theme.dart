import 'package:flutter/material.dart';

/// Section 1.2 brand colors. Placeholder-level only — a real theming pass
/// is expected to replace/expand this once actual screens exist.
class AppColors {
  const AppColors._();

  static const navy = Color(0xFF1B2F5E);
  static const brandRed = Color(0xFFC0392B);
  static const appBg = Color(0xFFF2F2F0);
}

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.navy,
    secondary: AppColors.brandRed,
  ),
  scaffoldBackgroundColor: AppColors.appBg,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.navy,
    foregroundColor: Colors.white,
  ),
);
