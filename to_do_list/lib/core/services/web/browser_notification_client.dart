import 'browser_notification_client_stub.dart'
    if (dart.library.js_interop) 'browser_notification_client_web.dart';

enum NotificationPermissionStatus {
  granted,
  denied,
  defaultStatus,
  unsupported,
}

abstract class BrowserNotificationClient {
  factory BrowserNotificationClient() => createBrowserNotificationClient();

  bool get isSupported;
  Future<NotificationPermissionStatus> getPermission();
  Future<NotificationPermissionStatus> requestPermission();
  Future<bool> showNotification({
    required String title,
    required String body,
    required String tag,
    String? icon,
  });
}
