import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reactive store managing user settings and preferences.
class SettingsStore extends ChangeNotifier {
  SettingsStore._();

  static final SettingsStore instance = SettingsStore._();

  SharedPreferences? _prefs;

  String _reminderPreference = '10 minutes before';
  String _appearance = 'Light & bright';
  String _weekStartsOn = 'Monday';
  String _language = 'English';
  bool _notificationPermissionAllowed = true;

  String get reminderPreference => _reminderPreference;
  String get appearance => _appearance;
  String get weekStartsOn => _weekStartsOn;
  String get language => _language;
  bool get isVietnamese => _language == 'Tiếng Việt';
  Locale get locale => isVietnamese ? const Locale('vi') : const Locale('en');
  bool get notificationPermissionAllowed => _notificationPermissionAllowed;

  /// Loads saved settings from SharedPreferences on app startup.
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedLang = _prefs?.getString('app_language');
      if (savedLang != null && savedLang.isNotEmpty) {
        _language = savedLang;
      }
      final savedRem = _prefs?.getString('reminder_preference');
      if (savedRem != null && savedRem.isNotEmpty) {
        _reminderPreference = savedRem;
      }
      final savedApp = _prefs?.getString('appearance');
      if (savedApp != null && savedApp.isNotEmpty) {
        _appearance = savedApp;
      }
      final savedWeek = _prefs?.getString('week_starts_on');
      if (savedWeek != null && savedWeek.isNotEmpty) {
        _weekStartsOn = savedWeek;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings from preferences: $e');
    }
  }

  Future<void> setLanguage(String value) async {
    if (_language != value) {
      _language = value;
      notifyListeners();
      try {
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs?.setString('app_language', value);
      } catch (e) {
        debugPrint('Error saving language to preferences: $e');
      }
    }
  }

  void setReminderPreference(String value) {
    if (_reminderPreference != value) {
      _reminderPreference = value;
      notifyListeners();
      _saveString('reminder_preference', value);
    }
  }

  void setAppearance(String value) {
    if (_appearance != value) {
      _appearance = value;
      notifyListeners();
      _saveString('appearance', value);
    }
  }

  void setWeekStartsOn(String value) {
    if (_weekStartsOn != value) {
      _weekStartsOn = value;
      notifyListeners();
      _saveString('week_starts_on', value);
    }
  }

  void toggleNotificationPermission() {
    _notificationPermissionAllowed = !_notificationPermissionAllowed;
    notifyListeners();
  }

  Future<void> _saveString(String key, String value) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs?.setString(key, value);
    } catch (e) {
      debugPrint('Error saving $key to preferences: $e');
    }
  }

  @visibleForTesting
  void reset() {
    _reminderPreference = '10 minutes before';
    _appearance = 'Light & bright';
    _weekStartsOn = 'Monday';
    _language = 'English';
    _notificationPermissionAllowed = true;
    notifyListeners();
  }
}
