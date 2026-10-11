import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/task_model.dart';
import '../../../core/state/task_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/floating_bottom_navigation.dart';
import '../../../core/widgets/task_card.dart';

class CompletedScreen extends StatefulWidget {
  final bool isEmpty;
  final VoidCallback? onMoreTap;
  final VoidCallback? onGoToTasks;
  final ValueChanged<NavigationTab>? onNavTabChanged;

  const CompletedScreen({
    super.key,
    this.isEmpty = false,
    this.onMoreTap,
    this.onGoToTasks,
    this.onNavTabChanged,
  });

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  void initState() {
    super.initState();
    TaskStore.instance.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    TaskStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  void _handleUncompleteTask(TaskModel task) {
    final restored = TaskStore.instance.undoComplete(task.id);
    if (restored) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          backgroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
            side: BorderSide(color: AppColors.surface, width: 1.5),
          ),
          content: Text(
            AppLocalizations.of(context).movedBackToActive(task.title),
            style: TextStyle(
              color: AppColors.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
          action: SnackBarAction(
            label: AppLocalizations.of(context).undo,
            textColor: AppColors.peachAccent,
            onPressed: () {
              TaskStore.instance.completeTask(task.id);
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showCelebrationModal(BuildContext context) {
    final store = TaskStore.instance;
    final loc = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.outline,
              width: AppBorders.cardWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.sageShadow,
                offset: const Offset(0, -4),
                blurRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Sparkle Badge
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCF5D6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outline,
                      width: AppBorders.cardWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.peachShadow,
                        offset: const Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SparkleIcon(size: 32, color: AppColors.outline),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  loc.celebrationTitle,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  loc.celebrationSubtitle(store.completedTodayCount),
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Quick stats row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5DC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outline,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${store.completedTodayCount}',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loc.todayStat,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 32, color: AppColors.outline.withValues(alpha: 0.3)),
                      Column(
                        children: [
                          Text(
                            '${store.completedThisWeekCount}',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loc.thisWeekStat,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 32, color: AppColors.outline.withValues(alpha: 0.3)),
                      Column(
                        children: [
                          Text(
                            '${(store.todayCompletionRate * 100).round()}%',
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF72BF5A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loc.paceStat,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Close button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: AppColors.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      loc.keepUpMomentum,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTaskDetailSheet(TaskModel task) {
    final loc = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.outline,
              width: AppBorders.cardWidth,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  task.title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.translateCompletedLabel(task.completedLabel),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.outline, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _handleUncompleteTask(task);
                        },
                        child: Text(
                          loc.markIncomplete,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB5493B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          TaskStore.instance.deleteCompletedTask(task.id);
                        },
                        child: Text(
                          loc.delete,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color? _getCardShadow(int index) {
    switch (index % 3) {
      case 1:
        return const Color(0xFFA9E6D8); // Mint shadow (Card 2)
      case 2:
        return const Color(0xFFB9E0A0); // Sage shadow (Card 3)
      default:
        return null; // Card 1 clean black outline / subtle
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final store = TaskStore.instance;
    final completedTasks = store.completedTasks;
    final showEmpty = widget.isEmpty || completedTasks.isEmpty;

    final completedTodayCount = store.completedTodayCount;
    final completedThisWeekCount = store.completedThisWeekCount;
    final completionRate = store.todayCompletionRate;
    final motivationalMessage = store.completedMotivationalMessage;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  // Top Header & Subhead matching Figma frame
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageInset,
                        AppSpacing.s16,
                        AppSpacing.pageInset,
                        AppSpacing.s16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kicker label: YOUR LITTLE WINS
                          Text(
                            loc.kickerLittleWins,
                            style: AppTypography.uppercaseLabel.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Row: Completed title + Sparkle circular button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  loc.completedTitle,
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showCelebrationModal(context),
                                child: Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCF5D6),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.outline,
                                      width: 2.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.sageShadow,
                                        offset: const Offset(2, 2),
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: SparkleIcon(size: 20, color: AppColors.outline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.s20),

                          // Large Hero Stat Card
                          if (!showEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.s20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5DC),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppColors.outline,
                                  width: AppBorders.cardWidth,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.peachShadow,
                                    offset: const Offset(3, 3),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top row: 6 done today + Circular Progress 60%
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$completedTodayCount',
                                            style: TextStyle(
                                              fontFamily: AppTypography.fontFamily,
                                              fontSize: 48,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.textPrimary,
                                              height: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            loc.doneToday,
                                            style: TextStyle(
                                              fontFamily: AppTypography.fontFamily,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      CircularProgressWidget(
                                        percentage: completionRate,
                                        size: 64,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Linear progress bar
                                  Container(
                                    height: 10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.outline,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: completionRate.clamp(0.02, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF72BF5A),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Rhythm motivational text
                                  Text(
                                    loc.translateMotivationalMessage(motivationalMessage),
                                    style: TextStyle(
                                      fontFamily: AppTypography.fontFamily,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Divider
                                  Container(
                                    height: 1.0,
                                    color: AppColors.outline.withValues(alpha: 0.25),
                                  ),
                                  const SizedBox(height: 14),

                                  // Bottom row: Completed this week + 18 tasks
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          loc.completedThisWeek,
                                          style: TextStyle(
                                            fontFamily: AppTypography.fontFamily,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        loc.tasksCount(completedThisWeekCount),
                                        style: TextStyle(
                                          fontFamily: AppTypography.fontFamily,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s24),

                            // Section header: Today's wins | 3 shown
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    loc.todaysWins,
                                    style: TextStyle(
                                      fontFamily: AppTypography.fontFamily,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  loc.shownCount(completedTasks.length),
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Main Content: List of Completed Tasks or Empty State
                  if (showEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.s32),
                        child: EmptyState(
                          title: loc.emptyCompletedTitle,
                          description: loc.emptyCompletedDesc,
                          buttonLabel: loc.goToTasks,
                          onButtonPressed: widget.onGoToTasks,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageInset,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final task = completedTasks[index];
                            return TaskCard(
                              task: task,
                              showMoreButton: false,
                              customShadowColor: _getCardShadow(index),
                              onTap: () => _showTaskDetailSheet(task),
                              onToggleComplete: (checked) {
                                if (!checked) {
                                  _handleUncompleteTask(task);
                                }
                              },
                            );
                          },
                          childCount: completedTasks.length,
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 120),
                  ),
                ],
              ),
            ),

            // Fixed Floating Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingBottomNavigation(
                currentTab: NavigationTab.completed,
                onTabChanged: (tab) => widget.onNavTabChanged?.call(tab),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular Progress ring with percentage text matching Figma frame
class CircularProgressWidget extends StatelessWidget {
  final double percentage; // 0.0 to 1.0
  final double size;

  const CircularProgressWidget({
    super.key,
    required this.percentage,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(percentage: percentage),
        child: Center(
          child: Text(
            '${(percentage * 100).round()}%',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percentage;

  _CircularProgressPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 9) / 2;
    const strokeWidth = 7.5;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFFE9F5E6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = const Color(0xFF72BF5A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * percentage.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}

/// 4-pointed crisp sparkle star icon matching Figma frame
class SparkleIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const SparkleIcon({
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SparklePainter(color: color ?? AppColors.outline),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final Color color;

  _SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.5, 0);
    path.quadraticBezierTo(w * 0.5, h * 0.5, w, h * 0.5);
    path.quadraticBezierTo(w * 0.5, h * 0.5, w * 0.5, h);
    path.quadraticBezierTo(w * 0.5, h * 0.5, 0, h * 0.5);
    path.quadraticBezierTo(w * 0.5, h * 0.5, w * 0.5, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.color != color;
}
