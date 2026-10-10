import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class CompletionSnackbar extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final IconData icon;

  const CompletionSnackbar({
    super.key,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.icon = Icons.check_circle_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pageInset),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: AppColors.callout,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(
          color: AppColors.outline,
          width: AppBorders.cardWidth,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.outline),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              message,
              style: AppTypography.metadata.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: AppSpacing.s8),
            GestureDetector(
              onTap: onActionPressed,
              behavior: HitTestBehavior.opaque,
              child: Text(
                actionLabel!,
                style: AppTypography.h3.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
