import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';

/// Base neo-brutalist container:
/// - 1.5px crisp border (#111111)
/// - Hard offset zero-blur shadow backing (Offset 4, 4)
/// - No soft blur, no gradients
class StickerContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color? shadowColor;
  final Offset shadowOffset;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const StickerContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = AppBorders.cardWidth,
    this.borderRadius = AppRadii.card,
    this.shadowColor,
    this.shadowOffset = const Offset(4.0, 4.0),
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.outline,
          width: borderWidth,
        ),
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                  color: shadowColor!,
                  offset: shadowOffset,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
