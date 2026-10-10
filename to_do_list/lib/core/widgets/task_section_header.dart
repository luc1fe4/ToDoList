import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class TaskSectionHeader extends StatelessWidget {
  final String title;
  final int? count;
  final EdgeInsetsGeometry padding;

  const TaskSectionHeader({
    super.key,
    required this.title,
    this.count,
    this.padding = const EdgeInsets.only(
      top: AppSpacing.s16,
      bottom: AppSpacing.s8,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.uppercaseLabel.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (count != null)
            Text(
              '$count',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
