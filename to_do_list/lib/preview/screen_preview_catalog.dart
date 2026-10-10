import 'package:flutter/material.dart';
import '../core/mock/mock_tasks.dart';
import '../core/models/task_model.dart';
import '../core/state/task_store.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_borders.dart';
import '../core/theme/app_radii.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/filter_tabs.dart';
import '../core/widgets/floating_bottom_navigation.dart';
import '../features/completed/screens/completed_screen.dart';
import '../features/schedule/screens/date_selection_screen.dart';
import '../features/schedule/screens/time_selection_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/tasks/screens/home_screen.dart';
import '../features/tasks/screens/task_detail_screen.dart';
import '../features/tasks/screens/task_form_screen.dart';

/// Preview Catalog allowing inspection of every approved Figma screen variant independently.
class ScreenPreviewCatalog extends StatefulWidget {
  const ScreenPreviewCatalog({super.key});

  @override
  State<ScreenPreviewCatalog> createState() => _ScreenPreviewCatalogState();
}

class _ScreenPreviewCatalogState extends State<ScreenPreviewCatalog> {
  String _activeScreenKey = '01 Home - All Tasks';
  String _lastHomeScreenKey = '01 Home - All Tasks';
  bool _isMenuOpen = false;
  TaskModel? _selectedTask;

  final GlobalKey<State<HomeScreen>> _homeKey = GlobalKey();

  void _onHomeFilterChanged(TaskFilterTab tab) {
    setState(() {
      switch (tab) {
        case TaskFilterTab.all:
          _activeScreenKey = '01 Home - All Tasks';
          break;
        case TaskFilterTab.today:
          _activeScreenKey = '02 Home - Today';
          break;
        case TaskFilterTab.upcoming:
          _activeScreenKey = '03 Home - Upcoming';
          break;
      }
      _lastHomeScreenKey = _activeScreenKey;
    });
  }

  final List<String> _screenKeys = [
    '01 Home - All Tasks',
    '02 Home - Today',
    '03 Home - Upcoming',
    '04 Search - Results',
    '05 Create Task',
    '06 Date Selection',
    '07 Time Selection',
    '08 Task Detail',
    '09 Edit Task',
    '10 Completed',
    '11 Empty - No Tasks',
    '12 Empty - Today',
    '13 Empty - Upcoming',
    '14 Empty - Search Results',
    '15 Settings',
    '16 Search - Initial',
    '17 Completed - Empty',
    '18 Create Task - Ready',
    '19 Home - Task Created (Snackbar)',
    '20 Completion - Feedback (Undo)',
    '25 Task Detail - Edited',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          // Active Screen Render
          Positioned.fill(
            child: _buildActiveScreen(),
          ),

          // Floating Preview Switcher Pill (Top Right)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _isMenuOpen = !_isMenuOpen),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      border: Border.all(
                        color: AppColors.surface,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.peachShadow,
                          offset: const Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: AppColors.surface,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Figma Screen: ${_activeScreenKey.split(" ")[0]}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 16,
                          color: AppColors.surface,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Modal Screen Switcher Menu
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _isMenuOpen = false),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(
                      top: 60, left: 20, right: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () {}, // Prevent dismissal when tapping list
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 520),
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        border: Border.all(
                          color: AppColors.outline,
                          width: AppBorders.cardWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.sageShadow,
                            offset: const Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Figma Screen Variant',
                                style: AppTypography.h3,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () =>
                                    setState(() => _isMenuOpen = false),
                              ),
                            ],
                          ),
                          Divider(height: 16, color: AppColors.outline),
                          Expanded(
                            child: ListView.separated(
                              itemCount: _screenKeys.length,
                              separatorBuilder: (context, _) =>
                                  const SizedBox(height: 4),
                              itemBuilder: (context, index) {
                                final key = _screenKeys[index];
                                final isSelected = key == _activeScreenKey;
                                return ListTile(
                                  dense: true,
                                  selected: isSelected,
                                  selectedTileColor: AppColors.cream,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.control),
                                    side: isSelected
                                        ? BorderSide(
                                            color: AppColors.outline,
                                            width: 1.5)
                                        : BorderSide.none,
                                  ),
                                  title: Text(
                                    key,
                                    style: AppTypography.body.copyWith(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check,
                                          size: 18, color: AppColors.outline)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _activeScreenKey = key;
                                      if (key.startsWith('0') &&
                                          key != '08 Task Detail' &&
                                          key != '09 Edit Task') {
                                        _lastHomeScreenKey = key;
                                      }
                                      _isMenuOpen = false;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveScreen() {
    switch (_activeScreenKey) {
      // -------------------------------------------------------------------
      // Home screens — all three initial-filter variants share the same
      // HomeScreen widget instance (via key) so the state (filter tab,
      // animated lists, snackbar timer) is NOT destroyed on completion.
      // -------------------------------------------------------------------
      case '01 Home - All Tasks':
        return HomeScreen(
          key: _homeKey,
          initialFilter: TaskFilterTab.all,
          onFilterChanged: _onHomeFilterChanged,
          onSearchTap: () =>
              setState(() => _activeScreenKey = '04 Search - Results'),
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onTaskTap: (t) => setState(() {
            _selectedTask = t;
            _activeScreenKey = '08 Task Detail';
          }),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '02 Home - Today':
        return HomeScreen(
          key: _homeKey,
          initialFilter: TaskFilterTab.today,
          onFilterChanged: _onHomeFilterChanged,
          onSearchTap: () =>
              setState(() => _activeScreenKey = '04 Search - Results'),
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onTaskTap: (t) => setState(() {
            _selectedTask = t;
            _activeScreenKey = '08 Task Detail';
          }),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '03 Home - Upcoming':
        return HomeScreen(
          key: _homeKey,
          initialFilter: TaskFilterTab.upcoming,
          onFilterChanged: _onHomeFilterChanged,
          onSearchTap: () =>
              setState(() => _activeScreenKey = '04 Search - Results'),
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onTaskTap: (t) => setState(() {
            _selectedTask = t;
            _activeScreenKey = '08 Task Detail';
          }),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '04 Search - Results':
        return SearchScreen(
          initialVariant: SearchStateVariant.results,
          onCancel: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onTaskTap: (t) => setState(() {
            _selectedTask = t;
            _activeScreenKey = '08 Task Detail';
          }),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '05 Create Task':
        return TaskFormScreen(
          mode: FormMode.create,
          onBack: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onCancel: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onSubmit: (task) {
            _selectedTask = task;
            setState(() => _activeScreenKey = '19 Home - Task Created (Snackbar)');
          },
        );

      case '06 Date Selection':
        return DateSelectionScreen(
          initialDate: DateTime(2026, 10, 8),
          taskTitlePreview: 'Review Dart notes',
          onBack: () =>
              setState(() => _activeScreenKey = '05 Create Task'),
          onConfirm: (date) =>
              setState(() => _activeScreenKey = '18 Create Task - Ready'),
          onClear: () =>
              setState(() => _activeScreenKey = '05 Create Task'),
        );

      case '07 Time Selection':
        return TimeSelectionScreen(
          initialHour: 6,
          initialMinute: 0,
          initialIsPm: true,
          taskTitlePreview: 'Review Dart notes',
          onBack: () =>
              setState(() => _activeScreenKey = '05 Create Task'),
          onConfirm: (h, m, pm) =>
              setState(() => _activeScreenKey = '18 Create Task - Ready'),
          onClear: () =>
              setState(() => _activeScreenKey = '05 Create Task'),
        );

      case '08 Task Detail':
        final detailTask = _selectedTask ?? MockTasks.taskFinishFlutter;
        return TaskDetailScreen(
          task: detailTask,
          onBack: () =>
              setState(() => _activeScreenKey = _lastHomeScreenKey),
          onComplete: () {
            TaskStore.instance.completeTask(detailTask.id);
            setState(() => _activeScreenKey = _lastHomeScreenKey);
          },
          onEdit: () => setState(() => _activeScreenKey = '09 Edit Task'),
          onDelete: () {
            TaskStore.instance.deleteTask(detailTask.id);
            setState(() => _activeScreenKey = _lastHomeScreenKey);
          },
        );

      case '09 Edit Task':
        final editTask = _selectedTask ?? MockTasks.taskFinishFlutter;
        return TaskFormScreen(
          mode: FormMode.edit,
          initialTask: editTask,
          onBack: () =>
              setState(() => _activeScreenKey = '08 Task Detail'),
          onCancel: () =>
              setState(() => _activeScreenKey = '08 Task Detail'),
          onSubmit: (task) {
            _selectedTask = task;
            setState(() => _activeScreenKey = '08 Task Detail');
          },
        );

      case '10 Completed':
        return CompletedScreen(
          isEmpty: false,
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '11 Empty - No Tasks':
        return HomeScreen(
          initialFilter: TaskFilterTab.all,
          emptyVariant: HomeEmptyVariant.allEmpty,
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '12 Empty - Today':
        return HomeScreen(
          initialFilter: TaskFilterTab.today,
          emptyVariant: HomeEmptyVariant.todayEmpty,
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '13 Empty - Upcoming':
        return HomeScreen(
          initialFilter: TaskFilterTab.upcoming,
          emptyVariant: HomeEmptyVariant.upcomingEmpty,
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '14 Empty - Search Results':
        return SearchScreen(
          initialVariant: SearchStateVariant.empty,
          onCancel: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '15 Settings':
        return SettingsScreen(
          onNavTabChanged: (tab) => _handleBottomNav(tab),
          onPreviewEmptyState: () =>
              setState(() => _activeScreenKey = '11 Empty - No Tasks'),
        );

      case '16 Search - Initial':
        return SearchScreen(
          initialVariant: SearchStateVariant.initial,
          onCancel: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '17 Completed - Empty':
        return CompletedScreen(
          isEmpty: true,
          onGoToTasks: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '18 Create Task - Ready':
        return TaskFormScreen(
          mode: FormMode.create,
          isReadyState: true,
          onBack: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onCancel: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onDateTap: () =>
              setState(() => _activeScreenKey = '06 Date Selection'),
          onTimeTap: () =>
              setState(() => _activeScreenKey = '07 Time Selection'),
          onSubmit: (task) => setState(
              () => _activeScreenKey = '19 Home - Task Created (Snackbar)'),
        );

      case '19 Home - Task Created (Snackbar)':
        return HomeScreen(
          initialFilter: TaskFilterTab.all,
          showCreatedSnackbar: true,
          onFilterChanged: _onHomeFilterChanged,
          onSearchTap: () =>
              setState(() => _activeScreenKey = '04 Search - Results'),
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onTaskTap: (t) => setState(() {
            _selectedTask = t;
            _activeScreenKey = '08 Task Detail';
          }),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '20 Completion - Feedback (Undo)':
        return HomeScreen(
          initialFilter: TaskFilterTab.all,
          showCompletedSnackbar: true,
          onFilterChanged: _onHomeFilterChanged,
          onSearchTap: () =>
              setState(() => _activeScreenKey = '04 Search - Results'),
          onAddTap: () => setState(() => _activeScreenKey = '05 Create Task'),
          onTaskTap: (t) => setState(() {
            _selectedTask = t;
            _activeScreenKey = '08 Task Detail';
          }),
          onNavTabChanged: (tab) => _handleBottomNav(tab),
        );

      case '25 Task Detail - Edited':
        return TaskDetailScreen(
          task: MockTasks.taskFinishFlutter,
          isEditedPreview: true,
          onBack: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
          onComplete: () => setState(
              () => _activeScreenKey = '20 Completion - Feedback (Undo)'),
          onEdit: () => setState(() => _activeScreenKey = '09 Edit Task'),
          onDelete: () =>
              setState(() => _activeScreenKey = '01 Home - All Tasks'),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  /// Handle bottom-nav tab changes without resetting the current home filter.
  ///
  /// Tasks tab → return to whichever Home screen is active (or default to All).
  /// The key-based approach ensures the same HomeScreen State instance is reused
  /// when the user returns from Completed/Settings.
  void _handleBottomNav(NavigationTab tab) {
    setState(() {
      switch (tab) {
        case NavigationTab.tasks:
          if (!_activeScreenKey.startsWith('0') ||
              _activeScreenKey == '08 Task Detail' ||
              _activeScreenKey == '09 Edit Task') {
            _activeScreenKey = _lastHomeScreenKey;
          }
          break;
        case NavigationTab.completed:
          if (_activeScreenKey.startsWith('0') &&
              _activeScreenKey != '08 Task Detail' &&
              _activeScreenKey != '09 Edit Task') {
            _lastHomeScreenKey = _activeScreenKey;
          }
          _activeScreenKey = '10 Completed';
          break;
        case NavigationTab.settings:
          if (_activeScreenKey.startsWith('0') &&
              _activeScreenKey != '08 Task Detail' &&
              _activeScreenKey != '09 Edit Task') {
            _lastHomeScreenKey = _activeScreenKey;
          }
          _activeScreenKey = '15 Settings';
          break;
      }
    });
  }
}
