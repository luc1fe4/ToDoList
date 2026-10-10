import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/core/models/task_category.dart';
import 'package:to_do_list/core/models/task_model.dart';
import 'package:to_do_list/core/services/web/browser_notification_client.dart';
import 'package:to_do_list/core/services/web/web_reminder_scheduler.dart';
import 'package:to_do_list/core/utils/time_utils.dart';

class MockBrowserNotificationClient implements BrowserNotificationClient {
  bool supported = true;
  NotificationPermissionStatus permission = NotificationPermissionStatus.defaultStatus;
  final List<({String title, String body, String tag})> shownNotifications = [];
  int requestCount = 0;

  @override
  bool get isSupported => supported;

  @override
  Future<NotificationPermissionStatus> getPermission() async => permission;

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    requestCount++;
    return permission;
  }

  @override
  Future<bool> showNotification({
    required String title,
    required String body,
    required String tag,
    String? icon,
  }) async {
    shownNotifications.add((title: title, body: body, tag: tag));
    return true;
  }

  void clear() {
    shownNotifications.clear();
    requestCount = 0;
  }
}

void main() {
  late MockBrowserNotificationClient mockClient;
  late DateTime simulatedNow;
  late Map<String, TaskModel> taskStoreMap;
  late WebReminderScheduler scheduler;
  final List<({String taskId, String title, String body})> inAppAlerts = [];

  setUp(() {
    mockClient = MockBrowserNotificationClient();
    simulatedNow = DateTime(2026, 10, 10, 10, 0); // 10:00 AM
    taskStoreMap = {};
    inAppAlerts.clear();

    scheduler = WebReminderScheduler(
      client: mockClient,
      clock: () => simulatedNow,
      taskLookup: (id) => taskStoreMap[id],
    );

    scheduler.onInAppNotification = (id, title, body) {
      inAppAlerts.add((taskId: id, title: title, body: body));
    };
  });

  tearDown(() {
    scheduler.dispose();
  });

  group('WebReminderScheduler Core Requirements', () {
    test('Scenario 1: Create a task with a deadline more than 10 minutes away', () {
      // 10:00 AM now, deadline is 10:30 AM (30 min away) -> reminder at 10:20 AM (10 min before)
      final task = TaskModel(
        id: 'task-1',
        title: 'Review PRs',
        category: TaskCategory.work,
        dueDate: simulatedNow,
        dueTime: '10:30 AM',
        reminderEnabled: true,
        reminderLabel: formatReminderTimeBefore('10:30 AM'),
      );
      taskStoreMap[task.id] = task;

      scheduler.scheduleTask(task);

      expect(scheduler.hasPendingTimer('task-1'), isTrue);
      expect(scheduler.pendingTimerCount, equals(1));
      expect(scheduler.getScheduledTime('task-1'), equals(DateTime(2026, 10, 10, 10, 20)));
      expect(mockClient.shownNotifications, isEmpty);
      expect(inAppAlerts, isEmpty);
    });

    test('Scenario 2: Create a task without a deadline', () {
      final task = TaskModel(
        id: 'task-no-deadline',
        title: 'Read a book',
        category: TaskCategory.personal,
        dueDate: null,
        dueTime: null,
        reminderEnabled: false,
      );
      taskStoreMap[task.id] = task;

      scheduler.scheduleTask(task);

      expect(scheduler.hasPendingTimer('task-no-deadline'), isFalse);
      expect(scheduler.pendingTimerCount, equals(0));
      expect(mockClient.shownNotifications, isEmpty);
    });

    test('Scenario 3: Edit a deadline after scheduling', () {
      // Initially scheduled for 10:30 AM (reminder at 10:20 AM)
      final initial = TaskModel(
        id: 'task-edit',
        title: 'Team Sync',
        dueDate: simulatedNow,
        dueTime: '10:30 AM',
        reminderEnabled: true,
      );
      taskStoreMap[initial.id] = initial;
      scheduler.scheduleTask(initial);

      expect(scheduler.getScheduledTime('task-edit'), equals(DateTime(2026, 10, 10, 10, 20)));

      // Edit deadline to 11:00 AM (reminder at 10:50 AM)
      final edited = initial.copyWith(dueTime: '11:00 AM');
      taskStoreMap[edited.id] = edited;
      scheduler.scheduleTask(edited);

      // Verify old reminder was cancelled and replaced with new time
      expect(scheduler.pendingTimerCount, equals(1));
      expect(scheduler.getScheduledTime('task-edit'), equals(DateTime(2026, 10, 10, 10, 50)));
    });

    test('Scenario 4: Complete and restore a task', () {
      final task = TaskModel(
        id: 'task-toggle',
        title: 'Daily Exercise',
        dueDate: simulatedNow,
        dueTime: '10:30 AM',
        reminderEnabled: true,
      );
      taskStoreMap[task.id] = task;
      scheduler.scheduleTask(task);
      expect(scheduler.hasPendingTimer('task-toggle'), isTrue);

      // Task completed -> cancel pending reminder
      final completed = task.copyWith(completedAt: simulatedNow);
      taskStoreMap[completed.id] = completed;
      scheduler.scheduleTask(completed);
      expect(scheduler.hasPendingTimer('task-toggle'), isFalse);

      // Task restored -> restore reminder
      final restored = TaskModel(
        id: task.id,
        title: task.title,
        dueDate: task.dueDate,
        dueTime: task.dueTime,
        reminderEnabled: true,
      );
      taskStoreMap[restored.id] = restored;
      scheduler.scheduleTask(restored);
      expect(scheduler.hasPendingTimer('task-toggle'), isTrue);
      expect(scheduler.getScheduledTime('task-toggle'), equals(DateTime(2026, 10, 10, 10, 20)));
    });

    test('Scenario 5: Delete a task', () {
      final task = TaskModel(
        id: 'task-delete',
        title: 'Temporary Task',
        dueDate: simulatedNow,
        dueTime: '10:30 AM',
        reminderEnabled: true,
      );
      taskStoreMap[task.id] = task;
      scheduler.scheduleTask(task);
      expect(scheduler.hasPendingTimer('task-delete'), isTrue);

      // Task deleted
      taskStoreMap.remove(task.id);
      scheduler.cancelTask(task.id);

      expect(scheduler.hasPendingTimer('task-delete'), isFalse);
      expect(scheduler.pendingTimerCount, equals(0));
    });

    test('Scenario 6: Restart the Web application and reconstruct reminders from active tasks', () async {
      final activeTasks = [
        TaskModel(
          id: 'reconstruct-1',
          title: 'Task A',
          dueDate: simulatedNow,
          dueTime: '10:30 AM',
          reminderEnabled: true,
        ),
        TaskModel(
          id: 'reconstruct-2',
          title: 'Task B',
          dueDate: simulatedNow,
          dueTime: '11:00 AM',
          reminderEnabled: true,
        ),
        TaskModel(
          id: 'reconstruct-3',
          title: 'Task C',
          dueDate: simulatedNow,
          dueTime: null, // no deadline
          reminderEnabled: false,
        ),
      ];

      for (final t in activeTasks) {
        taskStoreMap[t.id] = t;
      }

      // Fresh scheduler simulates app restart
      final freshScheduler = WebReminderScheduler(
        client: mockClient,
        clock: () => simulatedNow,
        taskLookup: (id) => taskStoreMap[id],
      );

      await freshScheduler.reconcileTasks(activeTasks);

      expect(freshScheduler.hasPendingTimer('reconstruct-1'), isTrue);
      expect(freshScheduler.getScheduledTime('reconstruct-1'), equals(DateTime(2026, 10, 10, 10, 20)));
      expect(freshScheduler.hasPendingTimer('reconstruct-2'), isTrue);
      expect(freshScheduler.getScheduledTime('reconstruct-2'), equals(DateTime(2026, 10, 10, 10, 50)));
      expect(freshScheduler.hasPendingTimer('reconstruct-3'), isFalse);
      expect(freshScheduler.pendingTimerCount, equals(2));

      freshScheduler.dispose();
    });

    test('Scenario 7: Deny browser notification permission provides in-app fallback', () async {
      mockClient.permission = NotificationPermissionStatus.denied;

      // Schedule deadline <= 10 min away (e.g. 5 min from now, at 10:05 AM)
      final task = TaskModel(
        id: 'task-denied',
        title: 'Emergency Bugfix',
        dueDate: simulatedNow,
        dueTime: '10:05 AM',
        reminderEnabled: true,
      );
      taskStoreMap[task.id] = task;

      await scheduler.scheduleTask(task);

      // Browser notifications blocked: mock client does not show system notification
      expect(mockClient.shownNotifications, isEmpty);

      // In-app fallback SnackBar was triggered
      expect(inAppAlerts.length, equals(1));
      expect(inAppAlerts.first.taskId, equals('task-denied'));
      expect(inAppAlerts.first.title, contains('Emergency Bugfix'));
      expect(inAppAlerts.first.body, contains('10:05 AM'));
    });

    test('Scenario 8: Grant browser notification permission displays browser notification', () async {
      mockClient.permission = NotificationPermissionStatus.granted;

      final task = TaskModel(
        id: 'task-granted',
        title: 'Sprint Planning',
        dueDate: simulatedNow,
        dueTime: '10:05 AM',
        reminderEnabled: true,
      );
      taskStoreMap[task.id] = task;

      await scheduler.scheduleTask(task);

      // Browser notification displayed
      expect(mockClient.shownNotifications.length, equals(1));
      expect(mockClient.shownNotifications.first.tag, equals('task-task-granted'));
      expect(mockClient.shownNotifications.first.title, contains('Sprint Planning'));

      // In-app alert also triggered
      expect(inAppAlerts.length, equals(1));
    });

    test('Scenario 9: Trigger reminder with controlled test deadline without waiting 10 real minutes', () async {
      mockClient.permission = NotificationPermissionStatus.granted;

      // Create task with deadline within 10 minutes (10:08 AM, 8 minutes away)
      final task = TaskModel(
        id: 'controlled-test',
        title: 'Quick Checkup',
        dueDate: simulatedNow,
        dueTime: '10:08 AM',
        reminderEnabled: true,
      );
      taskStoreMap[task.id] = task;

      await scheduler.scheduleTask(task);

      // Intentional policy: Imminent deadline triggers immediate alert
      expect(mockClient.shownNotifications.length, equals(1));
      expect(mockClient.shownNotifications.first.body, contains('in less than 10 minutes'));
      expect(inAppAlerts.length, equals(1));
    });

    test('Scenario 10: Verify no duplicate reminders occur after edits, navigation, or app resume', () async {
      mockClient.permission = NotificationPermissionStatus.granted;

      final task = TaskModel(
        id: 'dedup-1',
        title: 'Dentist Appointment',
        dueDate: simulatedNow,
        dueTime: '10:30 AM',
        reminderEnabled: true,
      );
      taskStoreMap[task.id] = task;
      await scheduler.scheduleTask(task);

      // 1. Title edited:
      final updatedTitle = task.copyWith(title: 'Doctor Appointment');
      taskStoreMap[updatedTitle.id] = updatedTitle;
      await scheduler.scheduleTask(updatedTitle);
      expect(scheduler.pendingTimerCount, equals(1));

      // 2. Simulated tab resume / reconcile called multiple times:
      await scheduler.reconcileTasks([updatedTitle]);
      await scheduler.reconcileTasks([updatedTitle]);
      await scheduler.reconcileTasks([updatedTitle]);

      expect(scheduler.pendingTimerCount, equals(1));
      expect(mockClient.shownNotifications, isEmpty); // not fired yet because reminder is at 10:20 AM

      // 3. Move time forward to 10:21 AM (11 minutes later, reminder passed while tab active/resumed):
      simulatedNow = DateTime(2026, 10, 10, 10, 21);
      await scheduler.reconcileTasks([updatedTitle]);

      // Fired once:
      expect(mockClient.shownNotifications.length, equals(1));
      expect(mockClient.shownNotifications.first.title, contains('Doctor Appointment')); // uses latest title!

      // Multiple subsequent resumes should NOT duplicate:
      await scheduler.reconcileTasks([updatedTitle]);
      await scheduler.reconcileTasks([updatedTitle]);
      expect(mockClient.shownNotifications.length, equals(1));
    });

    test('Tab throttling / sleep policy: overdue deadlines do not fire stale reminders', () {
      mockClient.permission = NotificationPermissionStatus.granted;

      final task = TaskModel(
        id: 'task-overdue',
        title: 'Submit Paper',
        dueDate: simulatedNow,
        dueTime: '10:30 AM',
        reminderEnabled: true,
      );
      taskStoreMap[task.id] = task;
      scheduler.scheduleTask(task);

      // App was asleep. User opens browser tab at 11:15 AM (45 mins AFTER deadline):
      simulatedNow = DateTime(2026, 10, 10, 11, 15);
      scheduler.reconcileTasks([task]);

      // Policy: Overdue deadline already passed -> do NOT fire stale "due in 10 minutes" reminder
      expect(mockClient.shownNotifications, isEmpty);
      expect(scheduler.hasPendingTimer('task-overdue'), isFalse);
    });

    test('showTestNotification triggers test notification and in-app fallback', () async {
      mockClient.permission = NotificationPermissionStatus.granted;

      await scheduler.showTestNotification();

      expect(mockClient.shownNotifications.length, equals(1));
      expect(mockClient.shownNotifications.first.title, contains('Test Notification'));
      expect(inAppAlerts.length, equals(1));
      expect(inAppAlerts.first.title, contains('Test Notification'));
    });
  });
}
