import 'package:flutter/foundation.dart';

/// Reactive store managing user settings and preferences.
class SettingsStore extends ChangeNotifier {
  SettingsStore._();

  static final SettingsStore instance = SettingsStore._();

  String _reminderPreference = '10 minutes before';
  String _appearance = 'Light & bright';
  String _weekStartsOn = 'Monday';
  bool _notificationPermissionAllowed = true;

  String get reminderPreference => _reminderPreference;
  String get appearance => _appearance;
  String get weekStartsOn => _weekStartsOn;
  bool get notificationPermissionAllowed => _notificationPermissionAllowed;

  void setReminderPreference(String value) {
    if (_reminderPreference != value) {
      _reminderPreference = value;
      notifyListeners();
    }
  }

  void setAppearance(String value) {
    if (_appearance != value) {
      _appearance = value;
      notifyListeners();
    }
  }

  void setWeekStartsOn(String value) {
    if (_weekStartsOn != value) {
      _weekStartsOn = value;
      notifyListeners();
    }
  }

  void toggleNotificationPermission() {
    _notificationPermissionAllowed = !_notificationPermissionAllowed;
    notifyListeners();
  }

  @visibleForTesting
  void reset() {
    _reminderPreference = '10 minutes before';
    _appearance = 'Light & bright';
    _weekStartsOn = 'Monday';
    _notificationPermissionAllowed = true;
    notifyListeners();
  }
}
