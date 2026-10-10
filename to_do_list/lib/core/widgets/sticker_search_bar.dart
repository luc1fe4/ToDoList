import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_borders.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class StickerSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool readOnly;
  final bool autoFocus;
  final String hintText;

  const StickerSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.readOnly = false,
    this.autoFocus = false,
    this.hintText = 'Search your tasks',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.control),
          border: Border.all(
            color: AppColors.outline,
            width: AppBorders.cardWidth,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 22,
              color: AppColors.outline,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: readOnly
                  ? Text(
                      controller?.text.isNotEmpty == true
                          ? controller!.text
                          : hintText,
                      style: controller?.text.isNotEmpty == true
                          ? AppTypography.body
                          : AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                    )
                  : TextField(
                      controller: controller,
                      autofocus: autoFocus,
                      onChanged: onChanged,
                      style: AppTypography.body,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
            ),
            if (controller != null && controller!.text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.outline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
