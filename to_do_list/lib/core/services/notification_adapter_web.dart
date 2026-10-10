import 'dart:js_interop';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;
import '../models/task_model.dart';
import '../state/task_store.dart';
import 'notification_adapter.dart';
import 'web/browser_notification_client.dart';
import 'web/web_reminder_scheduler.dart';

NotificationAdapter createNotificationAdapter() => NotificationAdapterWeb();

/// Web notification adapter implementing browser notifications and in-memory timers.
class NotificationAdapterWeb with WidgetsBindingObserver implements NotificationAdapter {
  late final WebReminderScheduler _scheduler;
  bool _initialized = false;

  @override
  void Function(String taskId, String title, String body)? onInAppReminder;

  @override
  Future<void> init() async {
    if (_initialized) return;

    _scheduler = WebReminderScheduler(
      taskLookup: (id) => TaskStore.instance.getTask(id),
    );

    _scheduler.onInAppNotification = (id, title, body) {
      onInAppReminder?.call(id, title, body);
    };

    WidgetsBinding.instance.addObserver(this);

    // Listen to browser document visibility change to detect background tab switching
    try {
      web.document.addEventListener(
        'visibilitychange',
        (web.Event e) {
          if (web.document.visibilityState == 'visible') {
            debugPrint('Web visibility change: tab visible, reconciling tasks...');
            reconcileTasks(TaskStore.instance.activeTasks);
          }
        }.toJS,
      );
    } catch (e) {
      debugPrint('Could not bind visibilitychange listener: $e');
    }

    _initialized = true;
    debugPrint('NotificationAdapterWeb initialized successfully.');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed, reconciling web reminder tasks...');
      reconcileTasks(TaskStore.instance.activeTasks);
    }
  }

  @override
  Future<bool> requestPermissions() async {
    await init();
    final status = await _scheduler.client.requestPermission();
    return status == NotificationPermissionStatus.granted;
  }

  @override
  Future<NotificationPermissionStatus> getPermissionStatus() async {
    await init();
    return _scheduler.client.getPermission();
  }

  @override
  Future<void> scheduleTaskReminder(TaskModel task) async {
    await init();
    _scheduler.scheduleTask(task);
  }

  @override
  Future<void> cancelTaskReminder(String taskId) async {
    await init();
    _scheduler.cancelTask(taskId);
  }

  @override
  Future<void> showTestNotification() async {
    await init();
    await _scheduler.showTestNotification();
  }

  @override
  Future<void> reconcileTasks(List<TaskModel> activeTasks) async {
    await init();
    _scheduler.reconcileTasks(activeTasks);
  }
}
