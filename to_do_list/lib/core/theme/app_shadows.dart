import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Hard offset zero-blur shadows matching "Hard Shadow / X 4 · Y 4 · Blur 0 · Spread 0".
class AppShadows {
  AppShadows._();

  static const Offset defaultOffset = Offset(4.0, 4.0);

  // Peach backing shadow
  static BoxShadow get peach => BoxShadow(
    color: AppColors.peachShadow,
    offset: defaultOffset,
    blurRadius: 0.0,
    spreadRadius: 0.0,
  );

  // Sage backing shadow
  static BoxShadow get sage => BoxShadow(
    color: AppColors.sageShadow,
    offset: defaultOffset,
    blurRadius: 0.0,
    spreadRadius: 0.0,
  );

  // Outline drop shadow for active elements (if black drop shadow is needed)
  static BoxShadow get outline => BoxShadow(
    color: AppColors.outline,
    offset: defaultOffset,
    blurRadius: 0.0,
    spreadRadius: 0.0,
  );

  // Lists for BoxDecorations
  static List<BoxShadow> get peachShadowList => [peach];
  static List<BoxShadow> get sageShadowList => [sage];
}
