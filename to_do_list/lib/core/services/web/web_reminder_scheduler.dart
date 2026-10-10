import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/task_model.dart';
import '../../utils/time_utils.dart';
import 'browser_notification_client.dart';

/// Pure Dart scheduler for Flutter Web task deadline reminders.
///
/// Features:
/// - Stable taskId-based timers (no duplicates).
/// - 10 minutes prior reminder scheduling (`dueDateTime - 10 minutes`).
/// - Re-checks eligibility and latest title upon firing.
/// - Tab throttling and app resume reconciliation.
/// - Clear policy for deadlines <= 10 min away and missed reminders.
/// - In-app fallback callback when browser permission is denied/unsupported.
class WebReminderScheduler {
  WebReminderScheduler({
    BrowserNotificationClient? client,
    DateTime Function()? clock,
    this.taskLookup,
  })  : client = client ?? BrowserNotificationClient(),
        clock = clock ?? DateTime.now;

  final BrowserNotificationClient client;
  final DateTime Function() clock;
  final TaskModel? Function(String taskId)? taskLookup;

  final Map<String, Timer> _pendingTimers = {};
  final Map<String, DateTime> _scheduledReminderTimes = {};
  final Set<String> _firedReminders = {};

  /// Callback for in-app fallback alerts (e.g. SnackBars, toasts)
  void Function(String taskId, String title, String body)? onInAppNotification;

  /// Callback when a reminder is triggered (for testing or logging)
  void Function(String taskId, String title, String body)? onReminderTriggered;

  /// Number of currently active pending timers
  int get pendingTimerCount => _pendingTimers.length;

  /// Whether a pending timer exists for [taskId]
  bool hasPendingTimer(String taskId) => _pendingTimers.containsKey(taskId);

  /// Target reminder time scheduled for [taskId]
  DateTime? getScheduledTime(String taskId) => _scheduledReminderTimes[taskId];

  /// Set of tasks that have fired their reminder in this session
  Set<String> get firedTaskIds => Set.unmodifiable(_firedReminders);

  /// Schedules a reminder 10 minutes prior to the deadline for [task].
  Future<void> scheduleTask(TaskModel task) async {
    if (!task.reminderEnabled || task.dueTime == null || task.isCompleted) {
      cancelTask(task.id);
      return;
    }

    final now = clock();
    DateTime dueDate = task.dueDate ?? now;
    final todayDate = DateTime(now.year, now.month, now.day);
    if (dueDate.isBefore(todayDate)) {
      if (task.createdAt != null &&
          task.createdAt!.year == now.year &&
          task.createdAt!.month == now.month &&
          task.createdAt!.day == now.day) {
        dueDate = todayDate;
      }
    }

    final dueDateTime = combineDateAndTime(dueDate, task.dueTime!);
    if (dueDateTime == null) return;

    // Rule: Deadline already passed -> do not schedule
    if (dueDateTime.isBefore(now)) {
      debugPrint('Task "${task.title}" deadline $dueDateTime is already in the past; no reminder scheduled.');
      cancelTask(task.id);
      return;
    }

    final reminderDateTime = dueDateTime.subtract(const Duration(minutes: 10));

    if (reminderDateTime.isAfter(now)) {
      // Normal case: deadline is > 10 minutes away.
      // Cancel any existing timer for this task
      _pendingTimers[task.id]?.cancel();

      final delay = reminderDateTime.difference(now);
      _pendingTimers[task.id] = Timer(delay, () => _handleTimerFired(task.id));
      _scheduledReminderTimes[task.id] = reminderDateTime;
      _firedReminders.remove(task.id);

      debugPrint('Web scheduler: scheduled 10-min reminder for "${task.title}" at $reminderDateTime (in ${delay.inMinutes}m)');
    } else {
      // Deadline is <= 10 minutes away, but still in the future!
      // Documented policy: Intentionally trigger immediate alert so user knows deadline is imminent.
      cancelTask(task.id);
      _scheduledReminderTimes[task.id] = dueDateTime;
      _firedReminders.add(task.id);

      await _triggerNotification(
        taskId: task.id,
        title: 'Reminder: ${task.title}',
        body: 'Due soon at ${task.dueTime} (in less than 10 minutes)!',
      );
      debugPrint('Web scheduler: fired immediate reminder for "${task.title}" due soon at ${task.dueTime}');
    }
  }

  /// Cancels any scheduled reminder timer for [taskId].
  void cancelTask(String taskId) {
    _pendingTimers[taskId]?.cancel();
    _pendingTimers.remove(taskId);
    _scheduledReminderTimes.remove(taskId);
    _firedReminders.remove(taskId);
    debugPrint('Web scheduler: cancelled reminder for task $taskId');
  }

  /// Reconciles all active tasks against current time.
  ///
  /// Useful on app startup, tab visibility change, or application resume.
  Future<void> reconcileTasks(List<TaskModel> activeTasks) async {
    final now = clock();
    final activeIds = activeTasks.map((t) => t.id).toSet();

    // 1. Remove timers for tasks no longer active
    final pendingIds = List<String>.from(_pendingTimers.keys);
    for (final id in pendingIds) {
      if (!activeIds.contains(id)) {
        cancelTask(id);
      }
    }

    // 2. Re-evaluate all active tasks
    for (final task in activeTasks) {
      if (!task.reminderEnabled || task.dueTime == null || task.isCompleted) {
        cancelTask(task.id);
        continue;
      }

      DateTime dueDate = task.dueDate ?? now;
      final todayDate = DateTime(now.year, now.month, now.day);
      if (dueDate.isBefore(todayDate)) {
        if (task.createdAt != null &&
            task.createdAt!.year == now.year &&
            task.createdAt!.month == now.month &&
            task.createdAt!.day == now.day) {
          dueDate = todayDate;
        }
      }

      final dueDateTime = combineDateAndTime(dueDate, task.dueTime!);
      if (dueDateTime == null) continue;

      if (dueDateTime.isBefore(now)) {
        // Deadline has passed while app was suspended / inactive.
        // Documented policy: Do not fire stale notifications for past deadlines.
        cancelTask(task.id);
        continue;
      }

      final reminderDateTime = dueDateTime.subtract(const Duration(minutes: 10));

      if (reminderDateTime.isAfter(now)) {
        // Future reminder: ensure timer is scheduled
        if (!_pendingTimers.containsKey(task.id) ||
            _scheduledReminderTimes[task.id] != reminderDateTime) {
          await scheduleTask(task);
        }
      } else {
        // reminderDateTime <= now and dueDateTime > now
        // Missed while app was suspended / asleep?
        if (!_firedReminders.contains(task.id)) {
          // Documented policy: Fire missed reminder because task is still due in the future!
          await _triggerNotification(
            taskId: task.id,
            title: 'Reminder: ${task.title}',
            body: 'Due soon at ${task.dueTime} (in less than 10 minutes)!',
          );
          _firedReminders.add(task.id);
        }
      }
    }
  }

  /// Sends a sample notification immediately to verify browser permissions and in-app alerts.
  Future<void> showTestNotification() async {
    await _triggerNotification(
      taskId: 'test-preview',
      title: 'Test Notification 🔔',
      body: 'Your Web task reminders are configured and working!',
    );
  }

  void _handleTimerFired(String taskId) {
    _pendingTimers.remove(taskId);
    final now = clock();

    // Re-check actual task existence and latest title from store
    final currentTask = taskLookup != null ? taskLookup!(taskId) : null;
    if (currentTask == null ||
        currentTask.isCompleted ||
        !currentTask.reminderEnabled ||
        currentTask.dueTime == null) {
      debugPrint('Timer fired for $taskId, but task is completed, deleted, or reminder was disabled. Discarding.');
      cancelTask(taskId);
      return;
    }

    DateTime dueDate = currentTask.dueDate ?? now;
    final dueDateTime = combineDateAndTime(dueDate, currentTask.dueTime!);
    if (dueDateTime == null) return;

    // Check if browser throttling delayed this timer until AFTER deadline
    if (dueDateTime.isBefore(now)) {
      debugPrint('Timer fired for "${currentTask.title}", but deadline $dueDateTime passed while throttled. Discarding.');
      cancelTask(taskId);
      return;
    }

    _firedReminders.add(taskId);
    _triggerNotification(
      taskId: taskId,
      title: 'Reminder: ${currentTask.title}',
      body: 'Due in 10 minutes (at ${currentTask.dueTime})',
    );
  }

  Future<bool> _triggerNotification({
    required String taskId,
    required String title,
    required String body,
  }) async {
    // 1. Notify test/logging hook
    onReminderTriggered?.call(taskId, title, body);

    // 2. Always trigger in-app fallback (SnackBar / Toast) so user never misses alert
    onInAppNotification?.call(taskId, title, body);

    // 3. Show browser notification if supported and granted
    if (client.isSupported) {
      final perm = await client.getPermission();
      if (perm == NotificationPermissionStatus.granted) {
        return client.showNotification(
          title: title,
          body: body,
          tag: 'task-$taskId',
        );
      }
    }
    return false;
  }

  /// Releases all timers and resources.
  void dispose() {
    for (final timer in _pendingTimers.values) {
      timer.cancel();
    }
    _pendingTimers.clear();
    _scheduledReminderTimes.clear();
    _firedReminders.clear();
  }
}
