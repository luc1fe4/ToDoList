import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/task_model.dart';
import '../utils/time_utils.dart';
import 'notification_adapter.dart';
import 'web/browser_notification_client.dart';

NotificationAdapter createNotificationAdapter() => NotificationAdapterIo();

/// Android / Mobile notification adapter preserving local notifications implementation.
class NotificationAdapterIo implements NotificationAdapter {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  @override
  void Function(String taskId, String title, String body)? onInAppReminder;

  @override
  Future<void> init() async {
    if (_initialized) return;

    try {
      tz.initializeTimeZones();
      final offset = DateTime.now().timeZoneOffset;
      tz.Location? matched;
      for (final entry in tz.timeZoneDatabase.locations.entries) {
        if (entry.value.currentTimeZone.offset == offset) {
          matched = entry.value;
          break;
        }
      }
      tz.setLocalLocation(matched ?? tz.timeZoneDatabase.locations.values.first);
    } catch (e) {
      debugPrint('Timezone initialization error: $e');
    }

    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
      );

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification tapped with payload: ${details.payload}');
        },
      );

      // Create high-importance Android notification channel
      final androidPlatform = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        const channel = AndroidNotificationChannel(
          'task_reminders',
          'Task Reminders',
          description: 'Notifications for upcoming task deadlines',
          importance: Importance.max,
        );
        await androidPlatform.createNotificationChannel(channel);
        await androidPlatform.requestNotificationsPermission();
      }

      _initialized = true;
    } catch (e) {
      debugPrint('NotificationAdapterIo init error: $e');
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      final androidPlatform = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        final granted = await androidPlatform.requestNotificationsPermission();
        return granted ?? false;
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  @override
  Future<NotificationPermissionStatus> getPermissionStatus() async {
    try {
      final androidPlatform = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        final granted = await androidPlatform.areNotificationsEnabled();
        if (granted == true) return NotificationPermissionStatus.granted;
        if (granted == false) return NotificationPermissionStatus.denied;
      }
      return NotificationPermissionStatus.granted;
    } catch (_) {
      return NotificationPermissionStatus.defaultStatus;
    }
  }

  int _notificationId(String taskId) {
    return taskId.hashCode.abs() % 100000;
  }

  @override
  Future<void> scheduleTaskReminder(TaskModel task) async {
    if (!task.reminderEnabled || task.dueTime == null) return;

    try {
      await init();

      final now = DateTime.now();
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

      final reminderDateTime = dueDateTime.subtract(const Duration(minutes: 10));
      final id = _notificationId(task.id);

      const androidDetails = AndroidNotificationDetails(
        'task_reminders',
        'Task Reminders',
        channelDescription: 'Notifications for upcoming task deadlines',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );
      const notificationDetails = NotificationDetails(android: androidDetails);

      if (reminderDateTime.isAfter(now)) {
        // Normal case: deadline is > 10 minutes in the future, schedule for reminderDateTime
        final tzScheduledDate = tz.TZDateTime.from(reminderDateTime, tz.local);
        try {
          await _plugin.zonedSchedule(
            id: id,
            title: 'Reminder: ${task.title}',
            body: 'Due in 10 minutes (at ${task.dueTime})',
            scheduledDate: tzScheduledDate,
            notificationDetails: notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
          debugPrint('Scheduled 10-min reminder for "${task.title}" at $reminderDateTime');
        } catch (e) {
          debugPrint('exactAllowWhileIdle failed ($e), falling back to inexactAllowWhileIdle');
          await _plugin.zonedSchedule(
            id: id,
            title: 'Reminder: ${task.title}',
            body: 'Due in 10 minutes (at ${task.dueTime})',
            scheduledDate: tzScheduledDate,
            notificationDetails: notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
          debugPrint('Scheduled fallback reminder for "${task.title}" at $reminderDateTime');
        }
      } else if (dueDateTime.isAfter(now)) {
        // Immediate case: due time is within the next 10 minutes
        await _plugin.show(
          id: id,
          title: 'Reminder: ${task.title}',
          body: 'Due soon at ${task.dueTime} (in less than 10 minutes)!',
          notificationDetails: notificationDetails,
        );
        debugPrint('Fired immediate reminder for "${task.title}" due at ${task.dueTime}');
      } else {
        debugPrint('Task "${task.title}" deadline $dueDateTime is already in the past; no reminder scheduled.');
      }
    } catch (e) {
      debugPrint('Error scheduling task reminder: $e');
    }
  }

  @override
  Future<void> cancelTaskReminder(String taskId) async {
    if (!_initialized) return;
    try {
      final id = _notificationId(taskId);
      await _plugin.cancel(id: id);
      debugPrint('Cancelled notification for task $taskId');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  @override
  Future<void> showTestNotification() async {
    try {
      await init();
      const androidDetails = AndroidNotificationDetails(
        'task_reminders',
        'Task Reminders',
        channelDescription: 'Notifications for upcoming task deadlines',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const notificationDetails = NotificationDetails(android: androidDetails);
      await _plugin.show(
        id: 99999,
        title: 'Test Notification 🔔',
        body: 'Your 10-minute task reminders are configured and working!',
        notificationDetails: notificationDetails,
      );
    } catch (e) {
      debugPrint('Error sending test notification: $e');
    }
  }

  @override
  Future<void> reconcileTasks(List<TaskModel> activeTasks) async {
    for (final task in activeTasks) {
      if (task.reminderEnabled && task.dueTime != null) {
        await scheduleTaskReminder(task);
      }
    }
  }
}
