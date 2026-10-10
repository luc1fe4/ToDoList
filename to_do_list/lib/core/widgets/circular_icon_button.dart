import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_spacing.dart';

enum CircularButtonVariant {
  standard, // White surface, outline, no shadow (Profile, Back, More)
  accent,   // Peach surface, outline, peach shadow (Add '+')
}

class CircularIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final CircularButtonVariant variant;
  final double size;

  const CircularIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.variant = CircularButtonVariant.standard,
    this.size = AppSpacing.minTouchTarget, // 44.0
  });

  @override
  Widget build(BuildContext context) {
    final isAccent = variant == CircularButtonVariant.accent;
    final bgColor = isAccent ? AppColors.peachAccent : AppColors.surface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outline,
            width: AppBorders.cardWidth,
          ),
          boxShadow: isAccent
              ? [
                  BoxShadow(
                    color: AppColors.peachShadow,
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ]
              : null,
        ),
        child: icon,
      ),
    );
  }
}
