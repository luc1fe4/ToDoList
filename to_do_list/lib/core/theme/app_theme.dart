import 'package:flutter/material.dart';
import '../state/settings_store.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Centralized application theme configured with design tokens.
class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final isDark = SettingsStore.instance.appearance == 'Dark Ink';

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: AppTypography.fontFamily,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.textPrimary,
        onPrimary: AppColors.surface,
        secondary: AppColors.peachAccent,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.brick,
        onError: AppColors.surface,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display,
        headlineLarge: AppTypography.h1,
        headlineMedium: AppTypography.h2,
        titleMedium: AppTypography.h3,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.metadata,
        bodySmall: AppTypography.caption,
        labelSmall: AppTypography.uppercaseLabel,
      ),
      dividerColor: AppColors.outline,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }

  static ThemeData get lightTheme => theme;
}
