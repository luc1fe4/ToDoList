import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'sticker_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback? onButtonPressed;
  final Widget? customIllustration;

  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    this.onButtonPressed,
    this.customIllustration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Notebook Sticker Illustration
          customIllustration ?? const NotebookSticker(),
          const SizedBox(height: AppSpacing.s24),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.h2.copyWith(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          // CTA Button
          StickerButton(
            label: buttonLabel,
            onPressed: onButtonPressed,
            variant: StickerButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}

/// Sticker-style friendly notebook illustration matching Figma empty states
class NotebookSticker extends StatelessWidget {
  final double size;
  const NotebookSticker({super.key, this.size = 140.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.peachShadow,
        borderRadius: BorderRadius.circular(AppRadii.card * 1.5),
        border: Border.all(
          color: AppColors.outline,
          width: AppBorders.cardWidth,
        ),
      ),
      child: Container(
        width: size * 0.55,
        height: size * 0.72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.small),
          border: Border.all(
            color: AppColors.outline,
            width: AppBorders.cardWidth,
          ),
        ),
        child: Stack(
          children: [
            // Left spine line
            Positioned(
              left: 6,
              top: 0,
              bottom: 0,
              child: Container(
                width: 1.5,
                color: AppColors.outline,
              ),
            ),
            // Face: Eyes and Smile
            Align(
              alignment: const Alignment(0.2, 0.25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 3.5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 3.5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Smile arc
                  CustomPaint(
                    size: const Size(18, 8),
                    painter: _SmilePainter(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outline
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, 2)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
