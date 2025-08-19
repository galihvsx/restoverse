import 'package:flutter/foundation.dart';

import '../../../../core/notifications/notification_helper.dart';
import '../../../../core/preferences/preferences_helper.dart';

class ReminderProvider extends ChangeNotifier {
  final PreferencesHelper _prefs;
  final NotificationHelper _notificationHelper;

  bool _isReminderEnabled = false;

  ReminderProvider({required PreferencesHelper preferencesHelper, required NotificationHelper notificationHelper})
      : _prefs = preferencesHelper,
        _notificationHelper = notificationHelper {
    _loadReminderSetting();
  }

  bool get isReminderEnabled => _isReminderEnabled;

  Future<void> _loadReminderSetting() async {
    _isReminderEnabled = _prefs.getDailyReminder();
    // Ensure scheduled state matches preference
    if (_isReminderEnabled) {
      await _notificationHelper.scheduleDailyReminder();
    } else {
      await _notificationHelper.cancelDailyReminder();
    }
    notifyListeners();
  }

  Future<void> setReminderEnabled(bool enabled) async {
    _isReminderEnabled = enabled;
    await _prefs.setDailyReminder(enabled);
    if (enabled) {
      await _notificationHelper.scheduleDailyReminder();
    } else {
      await _notificationHelper.cancelDailyReminder();
    }
    notifyListeners();
  }

  void toggleReminder() {
    setReminderEnabled(!_isReminderEnabled);
  }
}