import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/mock/mock_tasks.dart';
import '../../../core/models/task_model.dart';
import '../../../core/state/task_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circular_icon_button.dart';
import '../../../core/widgets/completion_snackbar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/filter_tabs.dart';
import '../../../core/widgets/floating_bottom_navigation.dart';
import '../../../core/widgets/sticker_container.dart';
import '../../../core/widgets/sticker_search_bar.dart';
import '../../../core/widgets/task_card.dart';
import '../../../core/widgets/task_section_header.dart';

enum HomeEmptyVariant {
  none,
  allEmpty,
  todayEmpty,
  upcomingEmpty,
}

// ---------------------------------------------------------------------------
// Snackbar state bundle
// ---------------------------------------------------------------------------

class _SnackbarState {
  final String taskId;
  final String message;
  final Timer timer;
  bool dismissed = false;

  _SnackbarState({
    required this.taskId,
    required this.message,
    required this.timer,
  });
}

// ---------------------------------------------------------------------------
// Animated task card wrapper (SizeTransition + FadeTransition)
// ---------------------------------------------------------------------------

class _AnimatedTaskCard extends StatefulWidget {
  final TaskModel task;
  final bool isCompleted;
  final bool isCollapsing;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleComplete;
  final VoidCallback onDismissFinished;

  const _AnimatedTaskCard({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.isCollapsing,
    this.onTap,
    this.onToggleComplete,
    required this.onDismissFinished,
  });

  @override
  State<_AnimatedTaskCard> createState() => _AnimatedTaskCardState();
}

class _AnimatedTaskCardState extends State<_AnimatedTaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && mounted) {
        widget.onDismissFinished();
      }
    });
  }

  @override
  void didUpdateWidget(_AnimatedTaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsing && !oldWidget.isCollapsing) {
      _controller.reverse();
    } else if (!widget.isCollapsing && oldWidget.isCollapsing) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _animation,
        child: TaskCard(
          key: ValueKey(widget.task.id),
          task: widget.task,
          onTap: widget.onTap,
          onToggleComplete: widget.onToggleComplete,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HomeScreen
// ---------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  final TaskFilterTab initialFilter;
  final HomeEmptyVariant emptyVariant;
  final bool showCreatedSnackbar;
  final bool showCompletedSnackbar;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAddTap;
  final ValueChanged<TaskModel>? onTaskTap;
  final ValueChanged<NavigationTab>? onNavTabChanged;
  final VoidCallback? onProfileTap;
  final ValueChanged<TaskFilterTab>? onFilterChanged;

  const HomeScreen({
    super.key,
    this.initialFilter = TaskFilterTab.all,
    this.emptyVariant = HomeEmptyVariant.none,
    this.showCreatedSnackbar = false,
    this.showCompletedSnackbar = false,
    this.onSearchTap,
    this.onAddTap,
    this.onTaskTap,
    this.onNavTabChanged,
    this.onProfileTap,
    this.onFilterChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _HomeScreenState extends State<HomeScreen> {
  late TaskFilterTab _currentFilter;

  // Set of task IDs currently undergoing completion (blocks duplicate taps)
  final Set<String> _animatingTaskIds = {};

  // Map of task ID to the modified TaskModel showing strikethrough & checked box
  final Map<String, TaskModel> _completedVisualTasks = {};

  // Set of task IDs that have completed the feedback delay and are now collapsing
  final Set<String> _collapsingTaskIds = {};

  // Delay timers for each animating task before collapsing begins
  final Map<String, Timer> _pendingTimers = {};

  // Active completion snackbar state (null = hidden)
  _SnackbarState? _snackbar;
  Timer? _snackbarTimer;

  // Tracks whether the creation snackbar has been manually dismissed
  bool _createdSnackbarDismissed = false;

  static const Duration _feedbackDelay = Duration(milliseconds: 500);
  static const Duration _snackDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    TaskStore.instance.addListener(_onStoreChanged);

    if (widget.showCompletedSnackbar) {
      final initialCompleted = TaskStore.instance.completedTasks.isNotEmpty
          ? TaskStore.instance.completedTasks.first
          : MockTasks.completedTasks.first;
      _showCompletionSnackbar(
        initialCompleted.id,
        initialCompleted.title,
        message: 'Task complete · 6 today / 19 this week',
      );
    }
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFilter != oldWidget.initialFilter) {
      _currentFilter = widget.initialFilter;
    }
    if (widget.showCompletedSnackbar && !oldWidget.showCompletedSnackbar) {
      final initialCompleted = TaskStore.instance.completedTasks.isNotEmpty
          ? TaskStore.instance.completedTasks.first
          : MockTasks.completedTasks.first;
      _showCompletionSnackbar(
        initialCompleted.id,
        initialCompleted.title,
        message: 'Task complete · 6 today / 19 this week',
      );
    }
  }

  @override
  void dispose() {
    TaskStore.instance.removeListener(_onStoreChanged);
    for (final timer in _pendingTimers.values) {
      timer.cancel();
    }
    _pendingTimers.clear();
    _snackbarTimer?.cancel();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Store listener
  // -------------------------------------------------------------------------

  void _onStoreChanged() {
    if (!mounted) return;
    setState(() {});
  }

  // -------------------------------------------------------------------------
  // Completion logic
  // -------------------------------------------------------------------------

  void _onToggleComplete(TaskModel task) {
    // Ignore if already animating
    if (_animatingTaskIds.contains(task.id)) return;
    // Ignore if task is not in active tasks
    if (!TaskStore.instance.activeTasks.any((t) => t.id == task.id)) return;

    _animatingTaskIds.add(task.id);

    // 1. Immediately update visual state: strikethrough + checked checkbox
    final completedCopy = task.copyWith(
      completedAt: DateTime.now(),
      completedLabel: 'Done today · just now',
    );
    _completedVisualTasks[task.id] = completedCopy;
    if (mounted) setState(() {});

    // 2. Keep card visible briefly so user perceives completion feedback
    _pendingTimers[task.id] = Timer(_feedbackDelay, () {
      if (!mounted) return;

      // 3. Begin smooth collapse exit animation
      setState(() {
        _collapsingTaskIds.add(task.id);
      });
    });
  }

  void _onCardDismissFinished(String taskId, String taskTitle) {
    _pendingTimers.remove(taskId)?.cancel();
    _animatingTaskIds.remove(taskId);
    _completedVisualTasks.remove(taskId);
    _collapsingTaskIds.remove(taskId);

    // Move task from active to completed in TaskStore (single source of truth)
    final stored = TaskStore.instance.completeTask(taskId);
    if (!mounted || stored == null) return;

    // Show completion snackbar with 3-second auto-dismiss and Undo action
    _showCompletionSnackbar(taskId, taskTitle);
  }

  // -------------------------------------------------------------------------
  // Snackbar
  // -------------------------------------------------------------------------

  void _showCompletionSnackbar(String taskId, String taskTitle, {String? message}) {
    if (!mounted) return;
    _snackbarTimer?.cancel();

    _snackbarTimer = Timer(_snackDuration, () {
      if (!mounted) return;
      setState(() => _snackbar = null);
    });

    final count = TaskStore.instance.completedTasks.length;
    final msg = message ?? 'Task complete · $count completed today';

    setState(() {
      _snackbar = _SnackbarState(
        taskId: taskId,
        message: msg,
        timer: _snackbarTimer!,
      );
    });
  }

  void _onUndo() {
    final s = _snackbar;
    if (s == null || s.dismissed) return;
    s.dismissed = true;
    _snackbarTimer?.cancel();

    final taskId = s.taskId;
    setState(() => _snackbar = null);

    // Cancel pending animation if undone while animating
    _pendingTimers.remove(taskId)?.cancel();
    _animatingTaskIds.remove(taskId);
    _completedVisualTasks.remove(taskId);
    _collapsingTaskIds.remove(taskId);

    // Restore task back to active in TaskStore
    TaskStore.instance.undoComplete(taskId);
  }

  // -------------------------------------------------------------------------
  // Filter
  // -------------------------------------------------------------------------

  void _onFilterChanged(TaskFilterTab tab) {
    if (_currentFilter == tab) return;
    setState(() => _currentFilter = tab);
    widget.onFilterChanged?.call(tab);
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable Content
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  // Top App Bar & Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageInset,
                        AppSpacing.s16,
                        AppSpacing.pageInset,
                        AppSpacing.s12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row: Tasks H1 + Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Tasks', style: AppTypography.h1),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularIconButton(
                                    variant: CircularButtonVariant.standard,
                                    icon: Icon(
                                      Icons.person_outline,
                                      size: 22,
                                      color: AppColors.outline,
                                    ),
                                    onTap: widget.onProfileTap,
                                  ),
                                  const SizedBox(width: AppSpacing.s12),
                                  CircularIconButton(
                                    variant: CircularButtonVariant.accent,
                                    icon: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: AppColors.outline,
                                    ),
                                    onTap: widget.onAddTap,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          StickerSearchBar(
                            readOnly: true,
                            onTap: widget.onSearchTap,
                          ),
                          const SizedBox(height: AppSpacing.s12),
                          FilterTabs(
                            selectedTab: _currentFilter,
                            onTabSelected: _onFilterChanged,
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          _buildSubheadRow(),
                        ],
                      ),
                    ),
                  ),

                  // Main Content
                  _buildContentSliver(),

                  // Bottom padding to clear fixed navigation & snackbar
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 120),
                  ),
                ],
              ),
            ),

            // Fixed Floating Overlays: Snackbar + Bottom Nav
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSnackbarOverlay(),
                  FloatingBottomNavigation(
                    currentTab: NavigationTab.tasks,
                    onTabChanged: (tab) => widget.onNavTabChanged?.call(tab),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Subhead row
  // -------------------------------------------------------------------------

  Widget _buildSubheadRow() {
    final now = DateTime.now();
    const weekdayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekday = weekdayNames[now.weekday - 1];
    final month = monthNames[now.month - 1];

    if (widget.emptyVariant != HomeEmptyVariant.none) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text('$weekday, $month ${now.day}, ${now.year}',
                  style: AppTypography.metadata)),
          Text('0 tasks', style: AppTypography.metadata),
        ],
      );
    }

    String heading;
    String dateLabel;
    String countLabel;

    final allCount = TaskStore.instance.activeTasks.length;
    final todayCount = TaskStore.instance.todayTasks.length;
    final upcomingCount = TaskStore.instance.upcomingTasks.length;

    switch (_currentFilter) {
      case TaskFilterTab.all:
        heading = 'A little more done.';
        dateLabel = '$weekday, $month ${now.day}';
        countLabel = '$allCount tasks';
        break;
      case TaskFilterTab.today:
        heading = 'Make today yours.';
        dateLabel = '$weekday, $month ${now.day}, ${now.year}';
        countLabel = '$todayCount tasks';
        break;
      case TaskFilterTab.upcoming:
        heading = 'On the horizon.';
        dateLabel = 'After today · $month ${now.day}, ${now.year}';
        countLabel = '$upcomingCount tasks';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: Text(heading, style: AppTypography.h2)),
            const SizedBox(width: AppSpacing.s8),
            Text(countLabel, style: AppTypography.metadata),
          ],
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(dateLabel, style: AppTypography.metadata),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Content sliver dispatcher
  // -------------------------------------------------------------------------

  Widget _buildContentSliver() {
    if (widget.emptyVariant == HomeEmptyVariant.allEmpty ||
        (_currentFilter == TaskFilterTab.all &&
            widget.emptyVariant != HomeEmptyVariant.none)) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s32),
          child: EmptyState(
            title: 'Start with one small thing.',
            description:
                'A blank page, a clear head. Add a task whenever you\'re ready.',
            buttonLabel: 'Create your first task',
            onButtonPressed: widget.onAddTap,
          ),
        ),
      );
    }

    if (widget.emptyVariant == HomeEmptyVariant.todayEmpty ||
        (_currentFilter == TaskFilterTab.today &&
            widget.emptyVariant != HomeEmptyVariant.none)) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s32),
          child: EmptyState(
            title: 'Today has room to breathe.',
            description:
                'Nothing is due today. Enjoy the space, or add a little something.',
            buttonLabel: 'Add a task for today',
            onButtonPressed: widget.onAddTap,
          ),
        ),
      );
    }

    if (widget.emptyVariant == HomeEmptyVariant.upcomingEmpty ||
        (_currentFilter == TaskFilterTab.upcoming &&
            widget.emptyVariant != HomeEmptyVariant.none)) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s32),
          child: EmptyState(
            title: 'Nothing on the horizon.',
            description:
                'No future tasks yet. Give a task a date after today and it\'ll show up here.',
            buttonLabel: 'Plan a future task',
            onButtonPressed: widget.onAddTap,
          ),
        ),
      );
    }

    switch (_currentFilter) {
      case TaskFilterTab.all:
        return _buildAllTasksSliver();
      case TaskFilterTab.today:
        return _buildTodayTasksSliver();
      case TaskFilterTab.upcoming:
        return _buildUpcomingTasksSliver();
    }
  }

  // -------------------------------------------------------------------------
  // All Tasks Sliver
  // -------------------------------------------------------------------------

  Widget _buildAllTasksSliver() {
    final activeTasks = TaskStore.instance.activeTasks;
    if (activeTasks.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s32),
          child: EmptyState(
            title: 'All done!',
            description: 'Every task has been completed. Ready to add more?',
            buttonLabel: 'Add a task',
            onButtonPressed: widget.onAddTap,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageInset),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = activeTasks[index];
            return _buildAnimatedCard(task);
          },
          childCount: activeTasks.length,
          findChildIndexCallback: (Key key) {
            if (key is ValueKey<String>) {
              final idx = activeTasks.indexWhere((t) => t.id == key.value);
              return idx == -1 ? null : idx;
            }
            return null;
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Today Tasks Sliver
  // -------------------------------------------------------------------------

  Widget _buildTodayTasksSliver() {
    final todayTasks = TaskStore.instance.todayTasks;
    final morningTasks =
        todayTasks.where((t) => t.timeOfDayGroup == 'MORNING').toList();
    final afternoonTasks =
        todayTasks.where((t) => t.timeOfDayGroup == 'AFTERNOON').toList();
    final eveningTasks =
        todayTasks.where((t) => t.timeOfDayGroup == 'EVENING').toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageInset),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (morningTasks.isNotEmpty) ...[
            TaskSectionHeader(title: 'MORNING', count: morningTasks.length),
            ...morningTasks.map((t) => _buildAnimatedCard(t)),
          ],
          if (afternoonTasks.isNotEmpty) ...[
            TaskSectionHeader(title: 'AFTERNOON', count: afternoonTasks.length),
            ...afternoonTasks.map((t) => _buildAnimatedCard(t)),
          ],
          if (eveningTasks.isNotEmpty) ...[
            TaskSectionHeader(title: 'EVENING', count: eveningTasks.length),
            ...eveningTasks.map((t) => _buildAnimatedCard(t)),
          ],
          if (todayTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s32),
              child: EmptyState(
                title: 'Today has room to breathe.',
                description:
                    'All tasks for today are done. Enjoy the space!',
                buttonLabel: 'Add a task for today',
                onButtonPressed: widget.onAddTap,
              ),
            ),
        ]),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Upcoming Tasks Sliver
  // -------------------------------------------------------------------------

  Widget _buildUpcomingTasksSliver() {
    final upcomingTasks = TaskStore.instance.upcomingTasks;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageInset),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          TaskSectionHeader(
            title: 'FRIDAY, OCTOBER 9',
            count: upcomingTasks.length,
          ),
          ...upcomingTasks.map((t) => _buildAnimatedCard(t)),
          const SizedBox(height: AppSpacing.s16),
          // Callout note banner
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
                    'Only tasks with a future date live here. Your undated ideas stay in All.',
                    style: AppTypography.metadata,
                  ),
                ),
              ],
            ),
          ),
          if (upcomingTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s32),
              child: EmptyState(
                title: 'Nothing on the horizon.',
                description:
                    'No future tasks yet. Give a task a date after today and it\'ll show up here.',
                buttonLabel: 'Plan a future task',
                onButtonPressed: widget.onAddTap,
              ),
            ),
        ]),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Animated card builder
  // -------------------------------------------------------------------------

  Widget _buildAnimatedCard(TaskModel task) {
    final visualTask = _completedVisualTasks[task.id] ?? task;
    final isCollapsing = _collapsingTaskIds.contains(task.id);
    final isAnimating = _animatingTaskIds.contains(task.id);

    return _AnimatedTaskCard(
      key: ValueKey(task.id),
      task: visualTask,
      isCompleted: visualTask.isCompleted,
      isCollapsing: isCollapsing,
      onTap: isAnimating ? null : () => widget.onTaskTap?.call(task),
      onToggleComplete: isAnimating ? null : (_) => _onToggleComplete(task),
      onDismissFinished: () => _onCardDismissFinished(task.id, task.title),
    );
  }

  // -------------------------------------------------------------------------
  // Snackbar overlay
  // -------------------------------------------------------------------------

  Widget _buildSnackbarOverlay() {
    // Creation snackbar (from widget prop, static)
    if (widget.showCreatedSnackbar && !_createdSnackbarDismissed) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
        child: CompletionSnackbar(
          icon: Icons.info_outline,
          message: 'Task created · also added to Today',
          actionLabel: 'Dismiss',
          onActionPressed: () =>
              setState(() => _createdSnackbarDismissed = true),
        ),
      );
    }

    // Completion snackbar (live, auto-dismisses after 3 seconds)
    final s = _snackbar;
    if (s != null && !s.dismissed) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s12),
        child: CompletionSnackbar(
          icon: Icons.check_circle_outline,
          message: s.message,
          actionLabel: 'Undo',
          onActionPressed: _onUndo,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
