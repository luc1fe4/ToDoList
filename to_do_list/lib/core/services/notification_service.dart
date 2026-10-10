import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'notification_adapter.dart';
import 'web/browser_notification_client.dart';

/// Unified service managing reminders across platforms.
///
/// On Android: preserves high-importance local notifications and exact alarms.
/// On Web: utilizes in-memory timers and the Web Notifications API with in-app SnackBar fallback.
class NotificationService {
  NotificationService._() {
    _adapter = NotificationAdapter();
    _adapter.onInAppReminder = _showInAppSnackBar;
  }

  static final NotificationService instance = NotificationService._();

  late NotificationAdapter _adapter;

  /// Global key used to show in-app notification snackbars across screens.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @visibleForTesting
  void setAdapterForTesting(NotificationAdapter adapter) {
    _adapter = adapter;
    _adapter.onInAppReminder = _showInAppSnackBar;
  }

  Future<void> init() async {
    await _adapter.init();
  }

  Future<bool> requestPermissions() async {
    return _adapter.requestPermissions();
  }

  Future<NotificationPermissionStatus> getPermissionStatus() async {
    return _adapter.getPermissionStatus();
  }

  Future<void> scheduleTaskReminder(TaskModel task) async {
    await _adapter.scheduleTaskReminder(task);
  }

  Future<void> cancelTaskReminder(String taskId) async {
    await _adapter.cancelTaskReminder(taskId);
  }

  Future<void> showTestNotification() async {
    await _adapter.showTestNotification();
  }

  Future<void> reconcileTasks(List<TaskModel> activeTasks) async {
    await _adapter.reconcileTasks(activeTasks);
  }

  void _showInAppSnackBar(String taskId, String title, String body) {
    final messenger = messengerKey.currentState;
    if (messenger != null) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                color: Color(0xFF72BF5A),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E241E),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF3B483B), width: 1),
          ),
        ),
      );
    }
  }
}
