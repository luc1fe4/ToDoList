import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/task_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'category_badge.dart';
import 'sticker_container.dart';
import 'task_checkbox.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleComplete;
  final VoidCallback? onMoreTap;
  final bool showMoreButton;
  final Color? customShadowColor;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onMoreTap,
    this.showMoreButton = true,
    this.customShadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDone = task.isCompleted;

    // Shadow color: If custom given, use it. Otherwise peach/sage when active, flat when done.
    final shadowColor = customShadowColor ??
        (isDone
            ? null
            : (task.shadowType == ShadowType.sage
                ? AppColors.sageShadow
                : AppColors.peachShadow));

    final cardBg = isDone ? AppColors.surface : AppColors.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
      child: StickerContainer(
        backgroundColor: cardBg,
        shadowColor: shadowColor,
        shadowOffset: const Offset(4.0, 4.0),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox
            TaskCheckbox(
              isChecked: isDone,
              onChanged: onToggleComplete,
            ),
            const SizedBox(width: AppSpacing.s12),
            // Middle Column: Title & Metadata Row
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.h3.copyWith(
                      color: isDone ? AppColors.textSecondary : AppColors.textPrimary,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s4,
                    children: [
                      if (task.completedLabel != null)
                        Text(
                          loc.translateCompletedLabel(task.completedLabel),
                          style: AppTypography.metadata.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                      else if (task.dueDateLabel != null || task.dueDate != null)
                        Text(
                          loc.formatTaskDueDateLabel(task),
                          style: AppTypography.metadata.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      CategoryBadge(category: task.category),
                    ],
                  ),
                ],
              ),
            ),
            if (showMoreButton) ...[
              const SizedBox(width: AppSpacing.s8),
              // Options '⋮'
              GestureDetector(
                onTap: onMoreTap ?? onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  child: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: AppColors.outline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
