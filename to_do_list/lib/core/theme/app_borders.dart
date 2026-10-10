import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized border definitions matching "Border / Card 1.5-2 · Small Control 1".
class AppBorders {
  AppBorders._();

  static const double cardWidth = 1.5;
  static const double controlWidth = 1.0;

  static BorderSide get cardBorderSide => BorderSide(
    color: AppColors.outline,
    width: cardWidth,
  );

  static BorderSide get controlBorderSide => BorderSide(
    color: AppColors.outline,
    width: controlWidth,
  );

  static Border get cardBorder => Border.all(
    color: AppColors.outline,
    width: cardWidth,
  );

  static Border get controlBorder => Border.all(
    color: AppColors.outline,
    width: controlWidth,
  );
}
