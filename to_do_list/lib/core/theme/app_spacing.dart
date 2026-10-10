import 'package:flutter/material.dart';

/// Centralized spacing system matching "Spacing / 4 · 8 · 12 · 16 · 24 · 32 · 48".
class AppSpacing {
  AppSpacing._();

  static const double s4 = 4.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s48 = 48.0;

  // Semantic layout constants from design spec
  static const double pageInset = 24.0;
  static const double minTouchTarget = 44.0;
  static const double buttonHeight = 52.0;
  static const double cardGap = 12.0;
  static const double navBottomMargin = 16.0;
  static const double navHeight = 64.0;

  // Standard EdgeInsets helpers
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: pageInset);
  static const EdgeInsets cardPadding = EdgeInsets.all(s16);
}
