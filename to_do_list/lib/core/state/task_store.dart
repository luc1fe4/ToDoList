import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mock/mock_tasks.dart';
import '../models/task_model.dart';
import '../services/notification_service.dart';

/// Single source of truth for task data shared across all screens.
///
/// Uses [ChangeNotifier] so widgets can rebuild via [ListenableBuilder] /
/// [AnimatedBuilder] without adding Riverpod, Bloc, or Provider.
class TaskStore extends ChangeNotifier {
  TaskStore._() {
    _activeTasks = List.from(MockTasks.allActiveTasks);
    _completedTasks = List.from(MockTasks.completedTasks);
  }

  static final TaskStore instance = TaskStore._();

  late List<TaskModel> _activeTasks;
  late List<TaskModel> _completedTasks;
  int _completedTodayOffset = 0;
  int _completedWeekOffset = 0;
  SharedPreferences? _prefs;

  /// Loads persisted tasks from SharedPreferences on app startup.
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final activeJson = _prefs?.getString('active_tasks');
      final completedJson = _prefs?.getString('completed_tasks');

      if (activeJson != null && activeJson.isNotEmpty) {
        final List decoded = jsonDecode(activeJson);
        _activeTasks = decoded.map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      if (completedJson != null && completedJson.isNotEmpty) {
        final List decoded = jsonDecode(completedJson);
        _completedTasks = decoded.map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks from preferences: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final activeJson = jsonEncode(_activeTasks.map((t) => t.toJson()).toList());
      final completedJson = jsonEncode(_completedTasks.map((t) => t.toJson()).toList());
      await _prefs?.setString('active_tasks', activeJson);
      await _prefs?.setString('completed_tasks', completedJson);
    } catch (e) {
      debugPrint('Error saving tasks to preferences: $e');
    }
  }

  /// Dynamic completion metrics for "Completed" screen
  int get completedTodayCount => (6 + _completedTodayOffset).clamp(0, 999);
  int get completedThisWeekCount => (18 + _completedWeekOffset).clamp(0, 999);
  double get todayCompletionRate => (completedTodayCount / 10.0).clamp(0.0, 1.0);

  String get completedMotivationalMessage {
    final rate = todayCompletionRate;
    if (rate >= 0.8) {
      return 'Outstanding momentum! You’re nearly there.';
    } else if (rate >= 0.5) {
      return 'You’re building a lovely rhythm.';
    } else if (rate > 0) {
      return 'Every small victory counts.';
    } else {
      return 'Ready to build your daily rhythm.';
    }
  }

  /// Immutable view of active tasks (undated + future-dated + today).
  List<TaskModel> get activeTasks => List.unmodifiable(_activeTasks);

  /// Active tasks due today (same date as [MockTasks.baseDate] or today).
  List<TaskModel> get todayTasks => _activeTasks
      .where((t) =>
          t.dueDate != null &&
          (_isSameDay(t.dueDate!, DateTime.now()) ||
              _isSameDay(t.dueDate!, MockTasks.baseDate)))
      .toList();

  /// Active tasks with a future due date (strictly after [MockTasks.baseDate] or today).
  List<TaskModel> get upcomingTasks => _activeTasks
      .where((t) =>
          t.dueDate != null &&
          (t.dueDate!.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) ||
              t.dueDate!.isAfter(MockTasks.baseDate)))
      .toList();

  /// Immutable view of completed tasks, newest first.
  List<TaskModel> get completedTasks => List.unmodifiable(_completedTasks);

  /// Retrieves a task by [id] from active or completed list, or null if not found.
  TaskModel? getTask(String id) {
    try {
      return _activeTasks.firstWhere((t) => t.id == id);
    } catch (_) {
      try {
        return _completedTasks.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  /// Adds a newly created task to the top of active tasks and notifies listeners.
  TaskModel createTask(TaskModel task) {
    // Determine timeOfDayGroup if missing and dueTime is present
    String? group = task.timeOfDayGroup;
    if (group == null && task.dueTime != null) {
      final upper = task.dueTime!.toUpperCase();
      if (upper.contains('AM')) {
        group = 'MORNING';
      } else {
        final h = int.tryParse(task.dueTime!.split(':').first.trim()) ?? 12;
        if (h < 5 || h == 12) {
          group = 'AFTERNOON';
        } else {
          group = 'EVENING';
        }
      }
    }

    final toAdd = task.copyWith(
      timeOfDayGroup: group,
      dueDateLabel: task.dueDateLabel ??
          (task.dueDate != null
              ? 'Today · ${task.dueTime ?? 'All day'}'
              : 'No due date'),
    );

    _activeTasks.insert(0, toAdd);
    if (toAdd.reminderEnabled && toAdd.dueTime != null) {
      NotificationService.instance.scheduleTaskReminder(toAdd);
    }
    _saveToPrefs();
    notifyListeners();
    return toAdd;
  }

  /// Updates an existing task by matching ID.
  bool updateTask(TaskModel updated) {
    final idx = _activeTasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _activeTasks[idx] = updated;
      if (updated.reminderEnabled && updated.dueTime != null) {
        NotificationService.instance.scheduleTaskReminder(updated);
      } else {
        NotificationService.instance.cancelTaskReminder(updated.id);
      }
      _saveToPrefs();
      notifyListeners();
      return true;
    }
    final compIdx = _completedTasks.indexWhere((t) => t.id == updated.id);
    if (compIdx != -1) {
      _completedTasks[compIdx] = updated;
      _saveToPrefs();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Marks [taskId] as completed with the current timestamp.
  ///
  /// Returns the completed [TaskModel] on success, or `null` if not found.
  TaskModel? completeTask(String taskId) {
    final index = _activeTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return null;

    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final timeLabel = 'Done today · $hour:$minute $period';

    final completed = _activeTasks[index].copyWith(
      completedAt: now,
      completedLabel: timeLabel,
    );

    _activeTasks.removeAt(index);
    _completedTasks.insert(0, completed);
    _completedTodayOffset++;
    _completedWeekOffset++;
    NotificationService.instance.cancelTaskReminder(taskId);
    _saveToPrefs();
    notifyListeners();
    return completed;
  }

  /// Removes a task from active or completed list and cancels its reminder.
  bool deleteTask(String taskId) {
    NotificationService.instance.cancelTaskReminder(taskId);
    final index = _activeTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _activeTasks.removeAt(index);
      _saveToPrefs();
      notifyListeners();
      return true;
    }
    return deleteCompletedTask(taskId);
  }

  /// Restores a previously completed task back to active, identified by [taskId].
  ///
  /// Returns `true` if the task was found and restored.
  bool undoComplete(String taskId) {
    final index = _completedTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;

    final task = _completedTasks[index];
    // Restore without completedAt / completedLabel
    final restored = TaskModel(
      id: task.id,
      title: task.title,
      category: task.category,
      dueDate: task.dueDate,
      dueTime: task.dueTime,
      dueDateLabel: task.dueDateLabel,
      timeOfDayGroup: task.timeOfDayGroup,
      reminderEnabled: task.reminderEnabled,
      reminderLabel: task.reminderLabel,
      createdAt: task.createdAt,
      shadowType: task.shadowType,
      // completedAt intentionally omitted → isCompleted == false
    );

    _completedTasks.removeAt(index);
    // Re-insert at beginning so it appears at the top
    _activeTasks.insert(0, restored);
    _completedTodayOffset--;
    _completedWeekOffset--;
    if (restored.reminderEnabled && restored.dueTime != null) {
      NotificationService.instance.scheduleTaskReminder(restored);
    }
    _saveToPrefs();
    notifyListeners();
    return true;
  }

  /// Removes a task from completed history.
  bool deleteCompletedTask(String taskId) {
    final index = _completedTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;
    _completedTasks.removeAt(index);
    _completedTodayOffset--;
    _completedWeekOffset--;
    _saveToPrefs();
    notifyListeners();
    return true;
  }

  /// For test isolation: resets the store back to the seed mock data.
  @visibleForTesting
  void reset() {
    _activeTasks = List.from(MockTasks.allActiveTasks);
    _completedTasks = List.from(MockTasks.completedTasks);
    _completedTodayOffset = 0;
    _completedWeekOffset = 0;
    notifyListeners();
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
