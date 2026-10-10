import 'browser_notification_client.dart';

BrowserNotificationClient createBrowserNotificationClient() => BrowserNotificationClientStub();

class BrowserNotificationClientStub implements BrowserNotificationClient {
  @override
  bool get isSupported => false;

  @override
  Future<NotificationPermissionStatus> getPermission() async =>
      NotificationPermissionStatus.unsupported;

  @override
  Future<NotificationPermissionStatus> requestPermission() async =>
      NotificationPermissionStatus.unsupported;

  @override
  Future<bool> showNotification({
    required String title,
    required String body,
    required String tag,
    String? icon,
  }) async {
    return false;
  }
}
