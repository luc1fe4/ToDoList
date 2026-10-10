import '../models/task_model.dart';
import 'notification_adapter_stub.dart'
    if (dart.library.js_interop) 'notification_adapter_web.dart'
    if (dart.library.io) 'notification_adapter_io.dart';
import 'web/browser_notification_client.dart';

abstract class NotificationAdapter {
  factory NotificationAdapter() => createNotificationAdapter();

  Future<void> init();
  Future<bool> requestPermissions();
  Future<NotificationPermissionStatus> getPermissionStatus();
  Future<void> scheduleTaskReminder(TaskModel task);
  Future<void> cancelTaskReminder(String taskId);
  Future<void> showTestNotification();
  Future<void> reconcileTasks(List<TaskModel> activeTasks);

  void Function(String taskId, String title, String body)? onInAppReminder;
}
