import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/time_utils.dart';
import 'sticker_container.dart';

class TimeSelector extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final bool initialIsPm;
  final void Function(int hour, int minute, bool isPm)? onTimeChanged;

  const TimeSelector({
    super.key,
    this.initialHour = 6,
    this.initialMinute = 0,
    this.initialIsPm = true,
    this.onTimeChanged,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
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

  void _notify() {
    widget.onTimeChanged?.call(_hour, _minute, _isPm);
  }

  void _incrementHour() {
    setState(() {
      _hour = _hour >= 12 ? 1 : _hour + 1;
    });
    _notify();
  }

  void _decrementHour() {
    setState(() {
      _hour = _hour <= 1 ? 12 : _hour - 1;
    });
    _notify();
  }

  void _incrementMinute() {
    setState(() {
      _minute = (_minute + 1) % 60;
    });
    _notify();
  }

  void _decrementMinute() {
    setState(() {
      _minute = (_minute - 1 + 60) % 60;
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return StickerContainer(
      backgroundColor: AppColors.surface,
      shadowColor: AppColors.peachShadow,
      shadowOffset: const Offset(4.0, 4.0),
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DUE TIME · LOCAL TIME',
            style: AppTypography.uppercaseLabel.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hour Column
              _buildStepperColumn(
                label: 'HOUR',
                value: '$_hour',
                onUp: _incrementHour,
                onDown: _decrementHour,
              ),
              const SizedBox(width: AppSpacing.s16),
              // Minute Column
              _buildStepperColumn(
                label: 'MINUTE',
                value: _minute.toString().padLeft(2, '0'),
                onUp: _incrementMinute,
                onDown: _decrementMinute,
              ),
              const SizedBox(width: AppSpacing.s16),
              // AM / PM Column
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Column(
                  children: [
                    _buildAmPmButton('AM', !_isPm, () {
                      setState(() => _isPm = false);
                      _notify();
                    }),
                    const SizedBox(height: AppSpacing.s12),
                    _buildAmPmButton('PM', _isPm, () {
                      setState(() => _isPm = true);
                      _notify();
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          // Subtitle preview
          Center(
            child: Text(
              '${formatDateLabel(DateTime.now())} · $_hour:${_minute.toString().padLeft(2, '0')} ${_isPm ? 'PM' : 'AM'}',
              style: AppTypography.metadata.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperColumn({
    required String label,
    required String value,
    required VoidCallback onUp,
    required VoidCallback onDown,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.uppercaseLabel.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        _buildArrowButton(Icons.keyboard_arrow_up, onUp),
        const SizedBox(height: AppSpacing.s8),
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(AppRadii.control),
            border: Border.all(
              color: AppColors.outline,
              width: AppBorders.cardWidth,
            ),
          ),
          child: Text(
            value,
            style: AppTypography.h1.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        _buildArrowButton(Icons.keyboard_arrow_down, onDown),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.control),
          border: Border.all(
            color: AppColors.outline,
            width: AppBorders.cardWidth,
          ),
        ),
        child: Icon(icon, size: 24, color: AppColors.outline),
      ),
    );
  }

  Widget _buildAmPmButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 58,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.control),
          border: Border.all(
            color: AppColors.outline,
            width: AppBorders.cardWidth,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.h3.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.surface : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
