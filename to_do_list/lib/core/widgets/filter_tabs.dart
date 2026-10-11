import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum TaskFilterTab {
  all('All'),
  today('Today'),
  upcoming('Upcoming');

  final String title;
  const TaskFilterTab(this.title);
}

class FilterTabs extends StatelessWidget {
  final TaskFilterTab selectedTab;
  final ValueChanged<TaskFilterTab> onTabSelected;

  const FilterTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Row(
      children: TaskFilterTab.values.map((tab) {
        final isSelected = tab == selectedTab;
        final title = loc.filterTabTitle(tab);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: tab != TaskFilterTab.values.last ? AppSpacing.s8 : 0,
            ),
            child: GestureDetector(
              onTap: () => onTabSelected(tab),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textPrimary : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  border: Border.all(
                    color: AppColors.outline,
                    width: AppBorders.cardWidth,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: AppTypography.h3.copyWith(
                      color: isSelected ? AppColors.surface : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
