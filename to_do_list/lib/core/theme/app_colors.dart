import 'package:flutter/material.dart';
import '../state/settings_store.dart';

class _ThemePalette {
  final Color surface;
  final Color canvas;
  final Color textPrimary;
  final Color textSecondary;
  final Color outline;
  final Color peachAccent;
  final Color sageAccent;
  final Color peachShadow;
  final Color sageShadow;
  final Color inactive;
  final Color teal;
  final Color mint;
  final Color orange;
  final Color brick;
  final Color cream;
  final Color callout;

  const _ThemePalette({
    required this.surface,
    required this.canvas,
    required this.textPrimary,
    required this.textSecondary,
    required this.outline,
    required this.peachAccent,
    required this.sageAccent,
    required this.peachShadow,
    required this.sageShadow,
    required this.inactive,
    required this.teal,
    required this.mint,
    required this.orange,
    required this.brick,
    required this.cream,
    required this.callout,
  });
}

const _lightPalette = _ThemePalette(
  surface: Color(0xFFFFFFFF),
  canvas: Color(0xFFFAFAF8),
  textPrimary: Color(0xFF0E0E0E),
  textSecondary: Color(0xFF5A5A5A),
  outline: Color(0xFF111111),
  peachAccent: Color(0xFFF0B878),
  sageAccent: Color(0xFF8CC96E),
  peachShadow: Color(0xFFF5D9A8),
  sageShadow: Color(0xFFB9E0A0),
  inactive: Color(0xFFEEEEEC),
  teal: Color(0xFF5B8FA0),
  mint: Color(0xFFA9E6D8),
  orange: Color(0xFFE8843A),
  brick: Color(0xFFB5493B),
  cream: Color(0xFFFFF1CC),
  callout: Color(0xFFFFF4DD),
);

const _warmPaperPalette = _ThemePalette(
  surface: Color(0xFFFFFDF5),
  canvas: Color(0xFFF5EEDB),
  textPrimary: Color(0xFF2C2416),
  textSecondary: Color(0xFF756750),
  outline: Color(0xFF382E1E),
  peachAccent: Color(0xFFE8AB60),
  sageAccent: Color(0xFF7CB85C),
  peachShadow: Color(0xFFDFC08E),
  sageShadow: Color(0xFFC0DA93),
  inactive: Color(0xFFE8DEC7),
  teal: Color(0xFF4E7E8E),
  mint: Color(0xFF9DD4C4),
  orange: Color(0xFFD67329),
  brick: Color(0xFFA63E30),
  cream: Color(0xFFFDEBB8),
  callout: Color(0xFFFCEECC),
);

const _softMintPalette = _ThemePalette(
  surface: Color(0xFFFFFFFF),
  canvas: Color(0xFFEEF7F2),
  textPrimary: Color(0xFF143023),
  textSecondary: Color(0xFF4C6D5F),
  outline: Color(0xFF163828),
  peachAccent: Color(0xFFF0BA7E),
  sageAccent: Color(0xFF75C780),
  peachShadow: Color(0xFFEAD4B4),
  sageShadow: Color(0xFFA5E2BA),
  inactive: Color(0xFFDCECE3),
  teal: Color(0xFF488D8E),
  mint: Color(0xFFA2ECD8),
  orange: Color(0xFFE07E34),
  brick: Color(0xFFB5493B),
  cream: Color(0xFFE4F8EA),
  callout: Color(0xFFE2F4EC),
);

const _darkInkPalette = _ThemePalette(
  surface: Color(0xFF22242A),
  canvas: Color(0xFF16171B),
  textPrimary: Color(0xFFF2F4F8),
  textSecondary: Color(0xFFA0A6B2),
  outline: Color(0xFF4A4E5C),
  peachAccent: Color(0xFFF0B878),
  sageAccent: Color(0xFF8CC96E),
  peachShadow: Color(0xFF6E4E2C),
  sageShadow: Color(0xFF2F542A),
  inactive: Color(0xFF2D3038),
  teal: Color(0xFF76A8B9),
  mint: Color(0xFF5BAA9A),
  orange: Color(0xFFF0934E),
  brick: Color(0xFFD95A4A),
  cream: Color(0xFF333025),
  callout: Color(0xFF2B2E36),
);

/// Centralized semantic color tokens dynamically driven by active theme settings.
class AppColors {
  AppColors._();

  static _ThemePalette get _palette {
    switch (SettingsStore.instance.appearance) {
      case 'Warm Paper':
        return _warmPaperPalette;
      case 'Soft Mint':
        return _softMintPalette;
      case 'Dark Ink':
        return _darkInkPalette;
      case 'Light & bright':
      default:
        return _lightPalette;
    }
  }

  // Core Palettes
  static Color get surface => _palette.surface;
  static Color get canvas => _palette.canvas;
  static Color get textPrimary => _palette.textPrimary;
  static Color get textSecondary => _palette.textSecondary;
  static Color get outline => _palette.outline;

  // Accents
  static Color get peachAccent => _palette.peachAccent;
  static Color get sageAccent => _palette.sageAccent;

  // Hard Shadow Backings (Zero Blur)
  static Color get peachShadow => _palette.peachShadow;
  static Color get sageShadow => _palette.sageShadow;

  // States & Contextual
  static Color get inactive => _palette.inactive;
  static Color get teal => _palette.teal;
  static Color get mint => _palette.mint;
  static Color get orange => _palette.orange;
  static Color get brick => _palette.brick;
  static Color get cream => _palette.cream;
  static Color get callout => _palette.callout;
}
