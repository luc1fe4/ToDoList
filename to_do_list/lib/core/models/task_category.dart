import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum TaskCategory {
  study('Study'),
  work('Work'),
  personal('Personal'),
  health('Health'),
  none('None');

  final String label;

  const TaskCategory(this.label);

  Color get badgeColor {
    switch (this) {
      case TaskCategory.study:
        return AppColors.cream;
      case TaskCategory.work:
        return AppColors.mint;
      case TaskCategory.personal:
        return AppColors.peachShadow;
      case TaskCategory.health:
        return AppColors.sageAccent;
      case TaskCategory.none:
        return AppColors.surface;
    }
  }

  static TaskCategory fromString(String? val) {
    if (val == null) return TaskCategory.none;
    switch (val.toLowerCase().trim()) {
      case 'study':
        return TaskCategory.study;
      case 'work':
        return TaskCategory.work;
      case 'personal':
        return TaskCategory.personal;
      case 'health':
        return TaskCategory.health;
      default:
        return TaskCategory.none;
    }
  }
}
