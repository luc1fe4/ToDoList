import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

enum CheckboxVisualState {
  unchecked,
  pressed,
  checked,
}

class TaskCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final CheckboxVisualState? forcedState;

  const TaskCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.forcedState,
  });

  @override
  Widget build(BuildContext context) {
    final state = forcedState ??
        (isChecked ? CheckboxVisualState.checked : CheckboxVisualState.unchecked);

    Color fillColor;
    Widget? iconWidget;

    switch (state) {
      case CheckboxVisualState.checked:
        fillColor = AppColors.sageAccent;
        iconWidget = Icon(
          Icons.check,
          size: 18,
          color: AppColors.outline,
        );
        break;
      case CheckboxVisualState.pressed:
        fillColor = AppColors.peachShadow;
        iconWidget = null;
        break;
      case CheckboxVisualState.unchecked:
        fillColor = AppColors.surface;
        iconWidget = null;
        break;
    }

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isChecked) : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: AppSpacing.minTouchTarget,
        height: AppSpacing.minTouchTarget,
        alignment: Alignment.center,
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppRadii.small),
            border: Border.all(
              color: AppColors.outline,
              width: AppBorders.cardWidth,
            ),
          ),
          child: iconWidget,
        ),
      ),
    );
  }
}
