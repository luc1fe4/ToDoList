import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/mock/mock_tasks.dart';
import '../../../core/models/task_model.dart';
import '../../../core/state/task_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/category_badge.dart';
import '../../../core/widgets/circular_icon_button.dart';
import '../../../core/widgets/sticker_button.dart';
import '../../../core/widgets/sticker_container.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel? task;
  final bool isEditedPreview; // For Screen 25 preview
  final VoidCallback? onBack;
  final VoidCallback? onComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskDetailScreen({
    super.key,
    this.task,
    this.isEditedPreview = false,
    this.onBack,
    this.onComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final activeTask = (task != null ? TaskStore.instance.getTask(task!.id) : null) ??
        task ??
        MockTasks.taskFinishFlutter;

    final dueTimeStr = activeTask.dueTime;
    final reminderTimeStr = dueTimeStr != null
        ? formatReminderTimeBefore(dueTimeStr, minutesBefore: 10)
        : null;

    final isTomorrowTask = isEditedPreview || (activeTask.dueDateLabel?.contains('Tomorrow') == true);
    final isTodayTask = activeTask.dueDateLabel?.contains('Today') == true;

    final String dateLine1;
    if (loc.isVietnamese) {
      if (isTomorrowTask) {
        dateLine1 = 'Ngày mai, Thứ Sáu 9 tháng 10';
      } else if (isTodayTask) {
        dateLine1 = 'Hôm nay, Thứ Năm 8 tháng 10';
      } else {
        dateLine1 = loc.translateDueDateLabel(activeTask.dueDateLabel);
      }
    } else {
      if (isTomorrowTask) {
        dateLine1 = 'Tomorrow, Friday October 9';
      } else if (isTodayTask) {
        dateLine1 = 'Today, Thursday October 8';
      } else {
        dateLine1 = activeTask.dueDateLabel ?? 'Today, Thursday October 8';
      }
    }

    final dateLine2 = isEditedPreview
        ? '7:00 PM · 2026'
        : (activeTask.dueTime != null
            ? '${activeTask.dueTime} · 2026'
            : '${loc.allDay} · 2026');

    final reminderLine1 = activeTask.reminderEnabled
        ? loc.tenMinutesBefore
        : loc.noReminder;

    final String reminderLine2;
    if (isEditedPreview) {
      reminderLine2 = loc.isVietnamese
          ? 'Thứ Sáu, 9 thg 10 · 6:50 PM'
          : 'Friday, Oct 9 · 6:50 PM';
    } else if (activeTask.reminderEnabled && reminderTimeStr != null) {
      if (isTomorrowTask) {
        reminderLine2 = '${loc.tomorrow} · $reminderTimeStr';
      } else {
        reminderLine2 = '${loc.today} · $reminderTimeStr';
      }
    } else {
      reminderLine2 = loc.noTimedReminder;
    }

    final createdDateStr = loc.isVietnamese ? '7 tháng 10, 2026' : 'October 7, 2026';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageInset,
            vertical: AppSpacing.s16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Back + Title
              Row(
                children: [
                  CircularIconButton(
                    icon: Icon(Icons.arrow_back, size: 22, color: AppColors.outline),
                    onTap: onBack,
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(child: Text(loc.taskDetailsTitle, style: AppTypography.h1)),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),

              // Detail Card
              StickerContainer(
                backgroundColor: AppColors.surface,
                shadowColor: AppColors.peachShadow,
                shadowOffset: const Offset(4.0, 4.0),
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    CategoryBadge(category: activeTask.category),
                    const SizedBox(height: AppSpacing.s16),

                    // Title
                    Text(
                      activeTask.title,
                      style: AppTypography.h1.copyWith(
                        fontSize: 28,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),

                    // Date & Time Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 22,
                          color: AppColors.outline,
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateLine1,
                                style: AppTypography.h3.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dateLine2,
                                style: AppTypography.metadata,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Reminder Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 22,
                          color: AppColors.outline,
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminderLine1,
                                style: AppTypography.h3.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reminderLine2,
                                style: AppTypography.metadata,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s24),

                    // Created Metadata
                    Text(
                      loc.createdOn(createdDateStr),
                      style: AppTypography.metadata.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Action Buttons
              StickerButton(
                label: loc.completeTaskButton,
                variant: StickerButtonVariant.primary,
                onPressed: onComplete,
              ),
              const SizedBox(height: AppSpacing.s12),
              StickerButton(
                label: loc.editTaskButton,
                variant: StickerButtonVariant.secondary,
                onPressed: onEdit,
              ),
              const SizedBox(height: AppSpacing.s24),

              // Delete Task text button
              Center(
                child: GestureDetector(
                  onTap: onDelete,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                    child: Text(
                      loc.deleteTaskButton,
                      style: AppTypography.h3.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Footer quote
              Center(
                child: Text(
                  loc.taskDetailQuote,
                  style: AppTypography.caption,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
