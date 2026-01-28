import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/settings_keys.dart';
import '../../core/services/notification_service.dart';
import '../../core/storage/local_storage.dart';

/// Chinese variant enum
enum ChineseVariant {
  simplified,
  traditional,
}

/// Settings Provider
/// Manages app settings state using Provider pattern
class SettingsProvider extends ChangeNotifier {
  // ================================================================
  // STATE
  // ================================================================

  ChineseVariant _chineseVariant = ChineseVariant.simplified;
  bool _notificationsEnabled = false;
  bool _dailyReminderEnabled = true;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _reviewRemindersEnabled = true;

  bool _isInitialized = false;

  // ================================================================
  // GETTERS
  // ================================================================

  ChineseVariant get chineseVariant => _chineseVariant;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyReminderEnabled => _dailyReminderEnabled;
  TimeOfDay get dailyReminderTime => _dailyReminderTime;
  bool get reviewRemindersEnabled => _reviewRemindersEnabled;
  bool get isInitialized => _isInitialized;

  // ================================================================
  // INITIALIZATION
  // ================================================================

  /// Initialize settings from LocalStorage
  Future<void> init() async {
    try {
      // Load Chinese variant
      final variantStr = LocalStorage.getSetting<String>(
        SettingsKeys.chineseVariant,
        defaultValue: SettingsKeys.defaultChineseVariant,
      );
      _chineseVariant = variantStr == 'traditional'
          ? ChineseVariant.traditional
          : ChineseVariant.simplified;

      // Load notification settings
      _notificationsEnabled = LocalStorage.getSetting<bool>(
        SettingsKeys.notificationsEnabled,
        defaultValue: SettingsKeys.defaultNotificationsEnabled,
      )!;

      _dailyReminderEnabled = LocalStorage.getSetting<bool>(
        SettingsKeys.dailyReminderEnabled,
        defaultValue: SettingsKeys.defaultDailyReminderEnabled,
      )!;

      _reviewRemindersEnabled = LocalStorage.getSetting<bool>(
        SettingsKeys.reviewRemindersEnabled,
        defaultValue: SettingsKeys.defaultReviewRemindersEnabled,
      )!;

      // Load daily reminder time
      final timeStr = LocalStorage.getSetting<String>(
        SettingsKeys.dailyReminderTime,
        defaultValue: SettingsKeys.defaultDailyReminderTime,
      );
      if (timeStr != null) {
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          _dailyReminderTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      }

      _isInitialized = true;
      notifyListeners();

      if (kDebugMode) {
        print('[SettingsProvider] Settings initialized:');
        print('  - Chinese variant: ${_chineseVariant.name}');
        print('  - Notifications: $_notificationsEnabled');
        print('  - Daily reminder: $_dailyReminderEnabled (${_dailyReminderTime.hour}:${_dailyReminderTime.minute.toString().padLeft(2, '0')})');
        print('  - Review reminders: $_reviewRemindersEnabled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[SettingsProvider] Error initializing settings: $e');
      }
      _isInitialized = true;
      notifyListeners();
    }
  }

  // ================================================================
  // LANGUAGE SETTINGS
  // ================================================================

  /// Set Chinese variant (simplified/traditional)
  Future<void> setChineseVariant(ChineseVariant variant) async {
    if (_chineseVariant == variant) return;

    _chineseVariant = variant;
    await LocalStorage.saveSetting(
      SettingsKeys.chineseVariant,
      variant.name,
    );

    notifyListeners();

    if (kDebugMode) {
      print('[SettingsProvider] Chinese variant changed to: ${variant.name}');
    }
  }

  // ================================================================
  // NOTIFICATION SETTINGS
  // ================================================================

  /// Toggle notifications on/off
  Future<bool> toggleNotifications(bool enabled) async {
    if (_notificationsEnabled == enabled) return true;

    final notificationService = NotificationService.instance;

    if (enabled) {
      // Request permissions when enabling
      final permissionGranted = await notificationService.requestPermissions();

      if (!permissionGranted) {
        if (kDebugMode) {
          print('[SettingsProvider] Notification permission denied');
        }
        return false;
      }

      // Schedule daily reminder if enabled
      if (_dailyReminderEnabled) {
        await notificationService.scheduleDailyReminder(
          hour: _dailyReminderTime.hour,
          minute: _dailyReminderTime.minute,
        );
      }
    } else {
      // Cancel all notifications when disabling
      await notificationService.cancelAll();
    }

    _notificationsEnabled = enabled;
    await LocalStorage.saveSetting(
      SettingsKeys.notificationsEnabled,
      enabled,
    );

    notifyListeners();

    if (kDebugMode) {
      print('[SettingsProvider] Notifications ${enabled ? 'enabled' : 'disabled'}');
    }

    return true;
  }

  /// Toggle daily reminder on/off
  Future<void> toggleDailyReminder(bool enabled) async {
    if (_dailyReminderEnabled == enabled) return;

    _dailyReminderEnabled = enabled;
    await LocalStorage.saveSetting(
      SettingsKeys.dailyReminderEnabled,
      enabled,
    );

    // Update notification schedule if notifications are enabled
    if (_notificationsEnabled) {
      final notificationService = NotificationService.instance;

      if (enabled) {
        await notificationService.scheduleDailyReminder(
          hour: _dailyReminderTime.hour,
          minute: _dailyReminderTime.minute,
        );
      } else {
        await notificationService.cancelDailyReminder();
      }
    }

    notifyListeners();

    if (kDebugMode) {
      print('[SettingsProvider] Daily reminder ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Set daily reminder time
  Future<void> setDailyReminderTime(TimeOfDay time) async {
    _dailyReminderTime = time;

    // Store as "HH:mm" string
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    await LocalStorage.saveSetting(
      SettingsKeys.dailyReminderTime,
      timeStr,
    );

    // Reschedule notification if enabled
    if (_notificationsEnabled && _dailyReminderEnabled) {
      final notificationService = NotificationService.instance;
      await notificationService.scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
      );
    }

    notifyListeners();

    if (kDebugMode) {
      print('[SettingsProvider] Daily reminder time set to: $timeStr');
    }
  }

  /// Toggle review reminders on/off
  Future<void> toggleReviewReminders(bool enabled) async {
    if (_reviewRemindersEnabled == enabled) return;

    _reviewRemindersEnabled = enabled;
    await LocalStorage.saveSetting(
      SettingsKeys.reviewRemindersEnabled,
      enabled,
    );

    notifyListeners();

    if (kDebugMode) {
      print('[SettingsProvider] Review reminders ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  // ================================================================
  // HELPERS
  // ================================================================

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    _chineseVariant = ChineseVariant.simplified;
    _notificationsEnabled = SettingsKeys.defaultNotificationsEnabled;
    _dailyReminderEnabled = SettingsKeys.defaultDailyReminderEnabled;
    _dailyReminderTime = const TimeOfDay(hour: 20, minute: 0);
    _reviewRemindersEnabled = SettingsKeys.defaultReviewRemindersEnabled;

    await LocalStorage.clearSettings();

    notifyListeners();

    if (kDebugMode) {
      print('[SettingsProvider] Settings reset to defaults');
    }
  }
}
