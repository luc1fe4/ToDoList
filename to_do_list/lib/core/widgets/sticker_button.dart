import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum StickerButtonVariant {
  primary,
  secondary,
}

class StickerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final StickerButtonVariant variant;
  final double height;
  final double? width;
  final Color? customShadowColor;

  const StickerButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = StickerButtonVariant.primary,
    this.height = AppSpacing.buttonHeight,
    this.width = double.infinity,
    this.customShadowColor,
  });

  bool get isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color? shadowColor;

    if (variant == StickerButtonVariant.primary) {
      if (isEnabled) {
        backgroundColor = AppColors.textPrimary;
        textColor = AppColors.surface;
        shadowColor = customShadowColor ?? AppColors.sageShadow;
      } else {
        backgroundColor = AppColors.inactive;
        textColor = AppColors.textSecondary;
        shadowColor = null;
      }
    } else {
      // Secondary
      backgroundColor = AppColors.surface;
      textColor = AppColors.textPrimary;
      shadowColor = null;
    }

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(
            color: AppColors.outline,
            width: AppBorders.cardWidth,
          ),
          boxShadow: shadowColor != null
              ? [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.h3.copyWith(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
