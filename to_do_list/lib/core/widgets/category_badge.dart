import 'package:flutter/material.dart';
import '../models/task_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

class CategoryBadge extends StatelessWidget {
  final TaskCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryBadge({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (category == TaskCategory.none && onTap == null) {
      return const SizedBox.shrink();
    }

    // In selection rows: selected state may highlight, otherwise default category color
    final bgColor = isSelected ? (category == TaskCategory.none ? AppColors.peachShadow : category.badgeColor) : (onTap != null ? AppColors.surface : category.badgeColor);

    Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(
          color: AppColors.outline,
          width: AppBorders.controlWidth,
        ),
      ),
      child: Text(
        category.label,
        style: AppTypography.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: badge,
      );
    }

    return badge;
  }
}
