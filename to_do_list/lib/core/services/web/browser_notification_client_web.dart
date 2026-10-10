import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'browser_notification_client.dart';

BrowserNotificationClient createBrowserNotificationClient() => BrowserNotificationClientWeb();

class BrowserNotificationClientWeb implements BrowserNotificationClient {
  @override
  bool get isSupported {
    try {
      return (web.window as JSObject).hasProperty('Notification'.toJS).toDart;
    } catch (e) {
      debugPrint('Error checking Web Notification support: $e');
      return false;
    }
  }

  @override
  Future<NotificationPermissionStatus> getPermission() async {
    if (!isSupported) return NotificationPermissionStatus.unsupported;
    try {
      final perm = web.Notification.permission;
      switch (perm) {
        case 'granted':
          return NotificationPermissionStatus.granted;
        case 'denied':
          return NotificationPermissionStatus.denied;
        default:
          return NotificationPermissionStatus.defaultStatus;
      }
    } catch (e) {
      debugPrint('Error reading Notification.permission: $e');
      return NotificationPermissionStatus.defaultStatus;
    }
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    if (!isSupported) return NotificationPermissionStatus.unsupported;
    try {
      final perm = await web.Notification.requestPermission().toDart;
      final permStr = perm.toDart;
      switch (permStr) {
        case 'granted':
          return NotificationPermissionStatus.granted;
        case 'denied':
          return NotificationPermissionStatus.denied;
        default:
          return NotificationPermissionStatus.defaultStatus;
      }
    } catch (e) {
      debugPrint('Error requesting Notification permission: $e');
      return NotificationPermissionStatus.denied;
    }
  }

  @override
  Future<bool> showNotification({
    required String title,
    required String body,
    required String tag,
    String? icon,
  }) async {
    if (!isSupported) return false;
    try {
      final current = await getPermission();
      if (current != NotificationPermissionStatus.granted) {
        debugPrint('Cannot show Web Notification: permission is $current');
        return false;
      }

      web.Notification(
        title,
        web.NotificationOptions(
          body: body,
          tag: tag,
          icon: icon ?? 'icons/Icon-192.png',
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Error displaying Web Notification: $e');
      return false;
    }
  }
}
