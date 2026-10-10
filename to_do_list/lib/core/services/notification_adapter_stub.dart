import '../models/task_model.dart';
import 'notification_adapter.dart';
import 'web/browser_notification_client.dart';

NotificationAdapter createNotificationAdapter() => NotificationAdapterStub();

class NotificationAdapterStub implements NotificationAdapter {
  @override
  void Function(String taskId, String title, String body)? onInAppReminder;

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<NotificationPermissionStatus> getPermissionStatus() async =>
      NotificationPermissionStatus.unsupported;

  @override
  Future<void> scheduleTaskReminder(TaskModel task) async {}

  @override
  Future<void> cancelTaskReminder(String taskId) async {}

  @override
  Future<void> showTestNotification() async {}

  @override
  Future<void> reconcileTasks(List<TaskModel> activeTasks) async {}
}
