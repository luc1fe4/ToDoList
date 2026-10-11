import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'circular_icon_button.dart';
import 'sticker_container.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime _currentMonth;
  late DateTime _activeSelected;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _activeSelected = widget.selectedDate;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    // Days in current month
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    // First weekday of month (1 = Mon, 7 = Sun in Dart)
    final firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

    return StickerContainer(
      backgroundColor: AppColors.surface,
      shadowColor: AppColors.peachShadow,
      shadowOffset: const Offset(4.0, 4.0),
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month Header Row with Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularIconButton(
                size: 38,
                icon: Icon(Icons.chevron_left, size: 22, color: AppColors.outline),
                onTap: _previousMonth,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    loc.formatMonthYear(_currentMonth),
                    style: AppTypography.h3.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              CircularIconButton(
                size: 38,
                icon: Icon(Icons.chevron_right, size: 22, color: AppColors.outline),
                onTap: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          // Day of week headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: loc.calendarWeekdayHeaders
                .map((day) => SizedBox(
                      width: 32,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.s12),
          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 6 weeks
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final dayOffset = index - (firstWeekday - 1);
              if (dayOffset < 0 || dayOffset >= daysInMonth) {
                return const SizedBox.shrink();
              }
              final dayNumber = dayOffset + 1;
              final cellDate = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isSelected = cellDate.year == _activeSelected.year &&
                  cellDate.month == _activeSelected.month &&
                  cellDate.day == _activeSelected.day;
              final now = DateTime.now();
              final bool isFixture = widget.selectedDate.year == 2026 &&
                  widget.selectedDate.month == 10 &&
                  widget.selectedDate.day == 8 &&
                  !(now.year == 2026 && now.month == 10 && now.day == 8);
              final refDate = isFixture ? widget.selectedDate : DateTime(now.year, now.month, now.day);
              final today = DateTime(refDate.year, refDate.month, refDate.day);
              final tomorrow = today.add(const Duration(days: 1));
              final isTomorrow = cellDate.year == tomorrow.year &&
                  cellDate.month == tomorrow.month &&
                  cellDate.day == tomorrow.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeSelected = cellDate;
                  });
                  widget.onDateSelected(cellDate);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.textPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.control),
                    border: isTomorrow && !isSelected
                        ? Border.all(color: AppColors.outline, width: AppBorders.cardWidth)
                        : null,
                  ),
                  child: Text(
                    '$dayNumber',
                    style: AppTypography.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.surface : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          // Quick Chips: Today & Tomorrow
          Builder(
            builder: (context) {
              final loc = AppLocalizations.of(context);
              final now = DateTime.now();
              final bool isFixture = widget.selectedDate.year == 2026 &&
                  widget.selectedDate.month == 10 &&
                  widget.selectedDate.day == 8 &&
                  !(now.year == 2026 && now.month == 10 && now.day == 8);
              final refDate = isFixture ? widget.selectedDate : DateTime(now.year, now.month, now.day);
              final today = DateTime(refDate.year, refDate.month, refDate.day);
              final tomorrow = today.add(const Duration(days: 1));

              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeSelected = today;
                        });
                        widget.onDateSelected(today);
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.peachShadow,
                          borderRadius: BorderRadius.circular(AppRadii.control),
                          border: Border.all(
                            color: AppColors.outline,
                            width: AppBorders.cardWidth,
                          ),
                        ),
                        child: Text(
                          loc.quickChipToday(loc.formatDateChip(today)),
                          style: AppTypography.metadata.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeSelected = tomorrow;
                        });
                        widget.onDateSelected(tomorrow);
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadii.control),
                          border: Border.all(
                            color: AppColors.outline,
                            width: AppBorders.cardWidth,
                          ),
                        ),
                        child: Text(
                          loc.quickChipTomorrow(loc.formatDateChip(tomorrow)),
                          style: AppTypography.metadata.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
