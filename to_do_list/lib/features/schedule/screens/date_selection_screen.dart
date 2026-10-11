import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/circular_icon_button.dart';
import '../../../core/widgets/date_selector.dart';
import '../../../core/widgets/sticker_button.dart';
import '../../../core/widgets/sticker_container.dart';

class DateSelectionScreen extends StatefulWidget {
  final DateTime initialDate;
  final String taskTitlePreview;
  final VoidCallback? onBack;
  final ValueChanged<DateTime>? onConfirm;
  final VoidCallback? onClear;

  const DateSelectionScreen({
    super.key,
    required this.initialDate,
    this.taskTitlePreview = 'Review Dart notes',
    this.onBack,
    this.onConfirm,
    this.onClear,
  });

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final dateButtonLabel = loc.useDateButton(_selectedDate);

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
                    icon: Icon(Icons.arrow_back, size: 22, color: AppColors.outline),
                    onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(child: Text(loc.chooseDate, style: AppTypography.h1)),
                ],
              ),
              const SizedBox(height: AppSpacing.s24),

              // Subhead
              Text(
                loc.kickerNewTaskSchedule,
                style: AppTypography.uppercaseLabel.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(loc.dateSubhead, style: AppTypography.h2),
              const SizedBox(height: AppSpacing.s4),
              Text(
                widget.taskTitlePreview,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Calendar Card Component
              DateSelector(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: AppSpacing.s16),

              // Callout Banner
              StickerContainer(
                backgroundColor: AppColors.callout,
                borderWidth: AppBorders.controlWidth,
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: AppColors.outline),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Text(
                        loc.dateSelectedHelper(formatDateLabel(_selectedDate)),
                        style: AppTypography.metadata,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Action Buttons
              StickerButton(
                label: dateButtonLabel,
                variant: StickerButtonVariant.primary,
                onPressed: () {
                  if (widget.onConfirm != null) {
                    widget.onConfirm!(_selectedDate);
                  } else {
                    Navigator.of(context).maybePop(_selectedDate);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              StickerButton(
                label: loc.clearDate,
                variant: StickerButtonVariant.secondary,
                onPressed: widget.onClear ??
                    widget.onBack ??
                    () => Navigator.of(context).maybePop(null),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
