import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography tokens matching "Typography / Inter" design spec.
/// Rules: Line height 1.25 for headings; 1.4 for body passages. Dark due times, never pastel text.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  // Display · Extra Bold · 40
  static TextStyle get display => TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // H1 · Bold · 32
  static TextStyle get h1 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // H2 · Bold · 23
  static TextStyle get h2 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 23,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // Task / H3 · Semibold · 17
  static TextStyle get h3 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // Body · Regular · 15
  static TextStyle get body => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Metadata · Regular · 13
  static TextStyle get metadata => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  // Caption · Regular · 11-12
  static TextStyle get caption => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  // Uppercase Label · 9-10 · Tracking +1.2
  static TextStyle get uppercaseLabel => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.2,
    color: AppColors.textSecondary,
  );
}
