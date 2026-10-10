import '../models/task_category.dart';
import '../models/task_model.dart';

/// Static mock dataset strictly adhering to "The source of truth · 7 active tasks" in Handoff spec.
class MockTasks {
  MockTasks._();

  static final DateTime baseDate = DateTime(2026, 10, 8); // Thursday, October 8, 2026

  // The 7 Seed Active Tasks
  static final TaskModel taskFinishFlutter = TaskModel(
    id: 'seed-1',
    title: 'Finish Flutter assignment',
    category: TaskCategory.study,
    dueDate: baseDate,
    dueTime: '6:00 PM',
    dueDateLabel: 'Today · 6:00 PM',
    timeOfDayGroup: 'EVENING',
    reminderEnabled: true,
    reminderLabel: '5:50 PM',
    createdAt: DateTime(2026, 10, 7),
    shadowType: ShadowType.peach,
  );

  static final TaskModel taskReadDocs = TaskModel(
    id: 'seed-2',
    title: 'Read Flutter documentation',
    category: TaskCategory.study,
    dueDate: baseDate,
    dueTime: '8:00 PM',
    dueDateLabel: 'Today · 8:00 PM',
    timeOfDayGroup: 'EVENING',
    reminderEnabled: true,
    reminderLabel: '7:50 PM',
    createdAt: DateTime(2026, 10, 7),
    shadowType: ShadowType.peach,
  );

  static final TaskModel taskBuildUI = TaskModel(
    id: 'seed-3',
    title: 'Build Flutter UI',
    category: TaskCategory.study,
    dueDate: DateTime(2026, 10, 9),
    dueTime: '10:00 AM',
    dueDateLabel: 'Tomorrow · 10:00 AM',
    timeOfDayGroup: 'MORNING',
    reminderEnabled: true,
    reminderLabel: '9:50 AM',
    createdAt: DateTime(2026, 10, 7),
    shadowType: ShadowType.peach,
  );

  static final TaskModel taskWeeklyUpdate = TaskModel(
    id: 'seed-4',
    title: 'Send weekly update',
    category: TaskCategory.work,
    dueDate: baseDate,
    dueTime: '2:00 PM',
    dueDateLabel: 'Today · 2:00 PM',
    timeOfDayGroup: 'AFTERNOON',
    reminderEnabled: false,
    createdAt: DateTime(2026, 10, 7),
    shadowType: ShadowType.peach,
  );

  static final TaskModel taskBuyGroceries = TaskModel(
    id: 'seed-5',
    title: 'Buy groceries',
    category: TaskCategory.personal,
    dueDate: DateTime(2026, 10, 9),
    dueTime: '5:00 PM',
    dueDateLabel: 'Tomorrow · 5:00 PM',
    timeOfDayGroup: 'AFTERNOON',
    reminderEnabled: false,
    createdAt: DateTime(2026, 10, 7),
    shadowType: ShadowType.sage,
  );

  static final TaskModel taskStretch = TaskModel(
    id: 'seed-6',
    title: 'Stretch for ten minutes',
    category: TaskCategory.health,
    dueDate: baseDate,
    dueTime: '8:00 AM',
    dueDateLabel: 'Today · 8:00 AM',
    timeOfDayGroup: 'MORNING',
    reminderEnabled: false,
    createdAt: DateTime(2026, 10, 7),
    shadowType: ShadowType.sage,
  );

  static final TaskModel taskWeekendReading = TaskModel(
    id: 'seed-7',
    title: 'Plan weekend reading',
    category: TaskCategory.none,
    dueDate: null,
    dueTime: null,
    dueDateLabel: 'No due date',
    reminderEnabled: false,
    createdAt: DateTime(2026, 10, 7),
    shadowType: ShadowType.peach,
  );

  // Newly created task from Scenario A (Screen 18/19)
  static final TaskModel taskReviewDart = TaskModel(
    id: 'created-1',
    title: 'Review Dart notes',
    category: TaskCategory.study,
    dueDate: baseDate,
    dueTime: '6:00 PM',
    dueDateLabel: 'Today · 6:00 PM',
    timeOfDayGroup: 'EVENING',
    reminderEnabled: true,
    reminderLabel: '5:50 PM',
    createdAt: DateTime(2026, 10, 8),
    shadowType: ShadowType.peach,
  );

  // Undated task from Screen 24
  static final TaskModel taskOrganizeDesk = TaskModel(
    id: 'undated-1',
    title: 'Organize desk',
    category: TaskCategory.none,
    dueDate: null,
    dueTime: null,
    dueDateLabel: 'No due date',
    reminderEnabled: false,
    createdAt: DateTime(2026, 10, 8),
    shadowType: ShadowType.peach,
  );

  // Completed tasks from Screen 10 (Figma Completed Screen)
  static final List<TaskModel> completedTasks = [
    TaskModel(
      id: 'comp-1',
      title: 'Finish Flutter assignment',
      category: TaskCategory.study,
      completedAt: DateTime(2026, 10, 8, 9, 41),
      completedLabel: 'Completed today',
      shadowType: ShadowType.peach,
    ),
    TaskModel(
      id: 'comp-2',
      title: 'Reply to Maya',
      category: TaskCategory.work,
      completedAt: DateTime(2026, 10, 8, 9, 10),
      completedLabel: 'Completed today',
      shadowType: ShadowType.peach,
    ),
    TaskModel(
      id: 'comp-3',
      title: 'Refill water bottle',
      category: TaskCategory.health,
      completedAt: DateTime(2026, 10, 8, 8, 45),
      completedLabel: 'Completed today',
      shadowType: ShadowType.sage,
    ),
  ];

  /// The 7 active tasks matching Screen 01 (Home - All Tasks)
  static List<TaskModel> get allActiveTasks => [
        taskFinishFlutter,
        taskReadDocs,
        taskBuildUI,
        taskWeeklyUpdate,
        taskBuyGroceries,
        taskStretch,
        taskWeekendReading,
      ];

  /// Tasks for Screen 02 (Home - Today) sorted Morning -> Afternoon -> Evening
  static List<TaskModel> get todayTasks => [
        taskStretch,       // MORNING
        taskWeeklyUpdate,  // AFTERNOON
        taskFinishFlutter, // EVENING
        taskReadDocs,      // EVENING
      ];

  /// Tasks for Screen 03 (Home - Upcoming) strictly after Oct 8
  static List<TaskModel> get upcomingTasks => [
        taskBuildUI,       // Tomorrow 10:00 AM
        taskBuyGroceries,  // Tomorrow 5:00 PM
      ];
}
