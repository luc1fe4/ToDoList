import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/circular_icon_button.dart';
import '../../../core/widgets/sticker_button.dart';
import '../../../core/widgets/sticker_container.dart';
import '../../../core/widgets/time_selector.dart';

class TimeSelectionScreen extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final bool initialIsPm;
  final String taskTitlePreview;
  final VoidCallback? onBack;
  final void Function(int hour, int minute, bool isPm)? onConfirm;
  final VoidCallback? onClear;

  const TimeSelectionScreen({
    super.key,
    this.initialHour = 6,
    this.initialMinute = 0,
    this.initialIsPm = true,
    this.taskTitlePreview = 'Review Dart notes',
    this.onBack,
    this.onConfirm,
    this.onClear,
  });

  @override
  State<TimeSelectionScreen> createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  late int _hour;
  late int _minute;
  late bool _isPm;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
    _isPm = widget.initialIsPm;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final minuteStr = _minute.toString().padLeft(2, '0');
    final periodStr = _isPm ? 'PM' : 'AM';
    final timeStr = '$_hour:$minuteStr $periodStr';

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
                  Expanded(child: Text(loc.chooseTime, style: AppTypography.h1)),
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
              Text(loc.timeSubhead, style: AppTypography.h2),
              const SizedBox(height: AppSpacing.s4),
              Text(
                widget.taskTitlePreview,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Time Stepper Component
              TimeSelector(
                initialHour: _hour,
                initialMinute: _minute,
                initialIsPm: _isPm,
                onTimeChanged: (h, m, pm) {
                  setState(() {
                    _hour = h;
                    _minute = m;
                    _isPm = pm;
                  });
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
                        loc.timeReminderHelper(
                          calculateReminderFromComponents(_hour, _minute, _isPm),
                        ),
                        style: AppTypography.metadata,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Action Buttons
              StickerButton(
                label: loc.useTime(timeStr),
                variant: StickerButtonVariant.primary,
                onPressed: () {
                  if (widget.onConfirm != null) {
                    widget.onConfirm!(_hour, _minute, _isPm);
                  } else {
                    Navigator.of(context).maybePop(timeStr);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              StickerButton(
                label: loc.clearTime,
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
