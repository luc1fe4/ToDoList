import 'package:flutter/material.dart';
import '../../../core/models/task_category.dart';
import '../../../core/models/task_model.dart';
import '../../../core/state/task_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/circular_icon_button.dart';
import '../../../core/widgets/sticker_button.dart';
import '../../../core/widgets/sticker_container.dart';
import '../../schedule/screens/date_selection_screen.dart';
import '../../schedule/screens/time_selection_screen.dart';

enum FormMode {
  create,
  edit,
}

class TaskFormScreen extends StatefulWidget {
  final FormMode mode;
  final TaskModel? initialTask;
  final bool isReadyState; // For Screen 18 preview
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final VoidCallback? onDateTap;
  final VoidCallback? onTimeTap;
  final ValueChanged<TaskModel>? onSubmit;

  const TaskFormScreen({
    super.key,
    this.mode = FormMode.create,
    this.initialTask,
    this.isReadyState = false,
    this.onBack,
    this.onCancel,
    this.onDateTap,
    this.onTimeTap,
    this.onSubmit,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late TextEditingController _titleController;
  late TaskCategory _selectedCategory;
  DateTime? _selectedDate;
  String? _selectedDateLabel;
  String? _selectedTime;
  bool _reminderEnabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.edit && widget.initialTask != null) {
      final t = widget.initialTask!;
      final now = DateTime.now();
      _titleController = TextEditingController(text: t.title);
      _selectedCategory = t.category;
      _selectedDate = t.dueDate ?? DateTime(now.year, now.month, now.day);
      _selectedDateLabel = t.dueDateLabel ?? formatDateLabel(_selectedDate!);
      _selectedTime = t.dueTime ?? '7:00 PM';
      _reminderEnabled = t.reminderEnabled;
    } else if (widget.isReadyState) {
      final now = DateTime.now();
      _titleController = TextEditingController(text: 'Review Dart notes');
      _selectedCategory = TaskCategory.study;
      _selectedDate = DateTime(now.year, now.month, now.day);
      _selectedDateLabel = formatDateLabel(_selectedDate!);
      _selectedTime = '6:00 PM';
      _reminderEnabled = true;
    } else {
      _titleController = TextEditingController();
      _selectedCategory = TaskCategory.none;
      _selectedDate = null;
      _selectedDateLabel = null;
      _selectedTime = null;
      _reminderEnabled = false;
    }

    _titleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _titleController.text.trim().isNotEmpty;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (ctx) => DateSelectionScreen(
          initialDate: _selectedDate ?? DateTime(now.year, now.month, now.day),
          taskTitlePreview: _titleController.text.trim().isNotEmpty
              ? _titleController.text.trim()
              : 'New Task',
          onBack: () => Navigator.of(ctx).pop(),
          onConfirm: (date) => Navigator.of(ctx).pop(date),
          onClear: () => Navigator.of(ctx).pop(null),
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _selectedDate = result;
      _selectedDateLabel = result != null ? formatDateLabel(result) : null;
    });
  }

  Future<void> _pickTime() async {
    int hour = 6;
    int minute = 0;
    bool isPm = true;

    if (_selectedTime != null) {
      final parsed = parseTimeOfDay(_selectedTime!);
      if (parsed != null) {
        hour = parsed.hour;
        minute = parsed.minute;
        isPm = parsed.isPm;
      }
    } else {
      final now = TimeOfDay.now();
      hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
      minute = now.minute;
      isPm = now.period == DayPeriod.pm;
    }

    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (ctx) => TimeSelectionScreen(
          initialHour: hour,
          initialMinute: minute,
          initialIsPm: isPm,
          taskTitlePreview: _titleController.text.trim().isNotEmpty
              ? _titleController.text.trim()
              : 'New Task',
          onBack: () => Navigator.of(ctx).pop(),
          onConfirm: (h, m, pm) {
            final minStr = m.toString().padLeft(2, '0');
            final period = pm ? 'PM' : 'AM';
            Navigator.of(ctx).pop('$h:$minStr $period');
          },
          onClear: () => Navigator.of(ctx).pop(null),
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      if (result is String) {
        _selectedTime = result;
        _reminderEnabled = true;
        if (_selectedDate == null) {
          final now = DateTime.now();
          _selectedDate = DateTime(now.year, now.month, now.day);
          _selectedDateLabel = formatDateLabel(_selectedDate!);
        }
      } else {
        _selectedTime = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.mode == FormMode.edit;
    final screenTitle = isEdit ? 'Edit Task' : 'New Task';
    final submitButtonLabel = isEdit ? 'Save Changes' : 'Create Task';

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
              // Header: Back button + Title
              Row(
                children: [
                  CircularIconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: AppColors.outline,
                    ),
                    onTap: widget.onBack ?? widget.onCancel,
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(child: Text(screenTitle, style: AppTypography.h1)),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),

              // Subhead
              Text("What's on your mind?", style: AppTypography.h2),
              const SizedBox(height: AppSpacing.s4),
              Text(
                'One small thing is a good start.',
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSpacing.s24),

              // Title input card
              StickerContainer(
                backgroundColor: AppColors.surface,
                shadowColor: AppColors.peachShadow,
                shadowOffset: const Offset(4.0, 4.0),
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITLE · REQUIRED',
                      style: AppTypography.uppercaseLabel.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    TextField(
                      controller: _titleController,
                      style: AppTypography.h3.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'e.g. Review Dart notes',
                        hintStyle: AppTypography.h3.copyWith(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s16),

              // Date Selector Row
              _buildSelectorRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: _selectedDateLabel ?? 'Add date · optional',
                isValueSelected: _selectedDateLabel != null,
                onTap: widget.onDateTap ?? _pickDate,
              ),
              const SizedBox(height: AppSpacing.s12),

              // Time Selector Row
              _buildSelectorRow(
                icon: Icons.access_time_outlined,
                label: 'Time',
                value: _selectedTime ?? 'Add time · optional',
                isValueSelected: _selectedTime != null,
                onTap: widget.onTimeTap ?? _pickTime,
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Date and time are optional. A date-only task has no timed reminder.',
                style: AppTypography.caption,
              ),
              const SizedBox(height: AppSpacing.s24),

              // Category Selector Row
              Text(
                'CATEGORY · OPTIONAL',
                style: AppTypography.uppercaseLabel.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: TaskCategory.values.map((cat) {
                    final isSelected = cat == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.s8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s16,
                            vertical: AppSpacing.s10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (cat == TaskCategory.none
                                    ? AppColors.peachShadow
                                    : cat.badgeColor)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadii.control),
                            border: Border.all(
                              color: AppColors.outline,
                              width: AppBorders.cardWidth,
                            ),
                          ),
                          child: Text(
                            cat.label,
                            style: AppTypography.body.copyWith(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Reminder Toggle Card
              StickerContainer(
                backgroundColor: AppColors.callout,
                borderWidth: AppBorders.cardWidth,
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 24,
                      color: AppColors.outline,
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedTime != null
                                ? '10 minutes before'
                                : 'No timed reminder',
                            style: AppTypography.h3.copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedTime != null
                                ? 'Notification at ${formatReminderTimeBefore(_selectedTime!)}'
                                : 'Add a date and time to enable.',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _reminderEnabled && _selectedTime != null,
                      activeThumbColor: AppColors.surface,
                      activeTrackColor: AppColors.sageAccent,
                      inactiveThumbColor: AppColors.surface,
                      inactiveTrackColor: AppColors.inactive,
                      trackOutlineColor: WidgetStateProperty.all(AppColors.outline),
                      onChanged: _selectedTime != null
                          ? (val) => setState(() => _reminderEnabled = val)
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // Action Buttons
              StickerButton(
                label: submitButtonLabel,
                variant: StickerButtonVariant.primary,
                onPressed: _canSubmit
                    ? () {
                        final formattedDueDateLabel =
                            formatDueDateLabel(_selectedDate, _selectedTime);
                        final formattedReminderLabel = _selectedTime != null
                            ? formatReminderTimeBefore(_selectedTime!)
                            : null;

                        final task = TaskModel(
                          id: widget.initialTask?.id ??
                              'task-${DateTime.now().millisecondsSinceEpoch}',
                          title: _titleController.text.trim(),
                          category: _selectedCategory,
                          dueDate: _selectedDate,
                          dueTime: _selectedTime,
                          dueDateLabel: _selectedDate != null || _selectedTime != null
                              ? formattedDueDateLabel
                              : 'No due date',
                          reminderEnabled: _reminderEnabled && _selectedTime != null,
                          reminderLabel: formattedReminderLabel,
                          createdAt: widget.initialTask?.createdAt ?? DateTime.now(),
                          shadowType: _selectedCategory == TaskCategory.health
                              ? ShadowType.sage
                              : ShadowType.peach,
                        );

                        if (widget.mode == FormMode.edit) {
                          TaskStore.instance.updateTask(task);
                        } else {
                          TaskStore.instance.createTask(task);
                        }

                        if (widget.onSubmit != null) {
                          widget.onSubmit!(task);
                        } else {
                          Navigator.of(context).maybePop(task);
                        }
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.s12),
              StickerButton(
                label: 'Cancel',
                variant: StickerButtonVariant.secondary,
                onPressed: widget.onCancel ?? widget.onBack,
              ),
              const SizedBox(height: AppSpacing.s24),

              // Footer Note
              Center(
                child: Text(
                  isEdit ? '' : 'Only a title is needed to create a task.',
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

  Widget _buildSelectorRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isValueSelected,
    bool isDisabled = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.inactive : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.control),
          border: Border.all(
            color: AppColors.outline,
            width: AppBorders.cardWidth,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.outline),
            const SizedBox(width: AppSpacing.s12),
            Text(
              label,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body.copyWith(
                    color: isValueSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isValueSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}
