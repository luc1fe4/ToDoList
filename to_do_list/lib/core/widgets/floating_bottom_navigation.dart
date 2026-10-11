import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum NavigationTab {
  tasks,
  completed,
  settings,
}

class FloatingBottomNavigation extends StatelessWidget {
  final NavigationTab currentTab;
  final ValueChanged<NavigationTab> onTabChanged;

  const FloatingBottomNavigation({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      height: AppSpacing.navHeight,
      margin: const EdgeInsets.only(
        left: AppSpacing.pageInset,
        right: AppSpacing.pageInset,
        bottom: AppSpacing.navBottomMargin,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(
          color: AppColors.outline,
          width: AppBorders.cardWidth,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNavItem(
              tab: NavigationTab.tasks,
              label: loc.navTasks,
              icon: Icons.layers_outlined,
              activeIcon: Icons.layers,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              tab: NavigationTab.completed,
              label: loc.navCompleted,
              icon: Icons.check,
              activeIcon: Icons.check,
            ),
          ),
          Expanded(
            child: _buildNavItem(
              tab: NavigationTab.settings,
              label: loc.navSettings,
              icon: Icons.tune,
              activeIcon: Icons.tune,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required NavigationTab tab,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = tab == currentTab;

    return GestureDetector(
      onTap: () => onTabChanged(tab),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? AppSpacing.s8 : AppSpacing.s4,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: isSelected
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      activeIcon,
                      size: 20,
                      color: AppColors.surface,
                    ),
                    const SizedBox(width: AppSpacing.s6),
                    Text(
                      label,
                      style: AppTypography.metadata.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
