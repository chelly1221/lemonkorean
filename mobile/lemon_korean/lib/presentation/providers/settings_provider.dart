import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/settings_keys.dart';
import '../../core/network/api_client.dart';
import '../../core/services/notification_service.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';

/// Chinese variant enum
enum ChineseVariant {
  simplified,
  traditional,
}

/// App language enum
enum AppLanguage {
  zhCN('zh_CN', '中文(简体)', '중국어(간체자)'),
  zhTW('zh_TW', '中文(繁體)', '중국어(번체자)'),
  ko('ko', '한국어', '한국어'),
  en('en', 'English', '영어'),
  ja('ja', '日本語', '일본어'),
  es('es', 'Español', '스페인어');

  final String code;
  final String nativeName;
  final String koreanName;

  const AppLanguage(this.code, this.nativeName, this.koreanName);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.zhCN,
    );
  }
}

/// Settings Provider
/// Manages app settings state using Provider pattern
class SettingsProvider extends ChangeNotifier {
  // ================================================================
  // DEPENDENCIES
  // ================================================================

  final _apiClient = ApiClient.instance;

  // ================================================================
  // STATE
  // ================================================================

  ChineseVariant _chineseVariant = ChineseVariant.simplified;
  AppLanguage _appLanguage = AppLanguage.zhCN;
  bool _notificationsEnabled = false;
  bool _dailyReminderEnabled = true;
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _reviewRemindersEnabled = true;

  bool _isInitialized = false;
  int? _userId;

  // ================================================================
  // GETTERS
  // ================================================================

  ChineseVariant get chineseVariant => _chineseVariant;
  AppLanguage get appLanguage => _appLanguage;
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

      // Load app language
      final langCode = LocalStorage.getSetting<String>(
        SettingsKeys.appLanguage,
        defaultValue: SettingsKeys.defaultAppLanguage,
      );
      _appLanguage = AppLanguage.fromCode(langCode ?? 'zh_CN');

      // Sync Chinese variant with language selection
      if (_appLanguage == AppLanguage.zhTW) {
        _chineseVariant = ChineseVariant.traditional;
      } else if (_appLanguage == AppLanguage.zhCN) {
        _chineseVariant = ChineseVariant.simplified;
      }

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
        print('  - App language: ${_appLanguage.code} (${_appLanguage.nativeName})');
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

  /// Set user ID for syncing (call after login)
  void setUserId(int? userId) {
    _userId = userId;
  }

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

    // Sync to backend
    await _syncPreferencesToBackend();
  }

  /// Set app language
  Future<void> setAppLanguage(AppLanguage language) async {
    if (_appLanguage == language) return;

    _appLanguage = language;
    await LocalStorage.saveSetting(
      SettingsKeys.appLanguage,
      language.code,
    );

    // Automatically set Chinese variant based on language selection
    if (language == AppLanguage.zhCN) {
      _chineseVariant = ChineseVariant.simplified;
      await LocalStorage.saveSetting(
        SettingsKeys.chineseVariant,
        ChineseVariant.simplified.name,
      );
    } else if (language == AppLanguage.zhTW) {
      _chineseVariant = ChineseVariant.traditional;
      await LocalStorage.saveSetting(
        SettingsKeys.chineseVariant,
        ChineseVariant.traditional.name,
      );
    }

    notifyListeners();

    if (kDebugMode) {
      print('[SettingsProvider] App language changed to: ${language.code} (${language.nativeName})');
      if (language == AppLanguage.zhCN || language == AppLanguage.zhTW) {
        print('[SettingsProvider] Chinese variant auto-set to: ${_chineseVariant.name}');
      }
    }

    // Sync to backend
    await _syncPreferencesToBackend();
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

    // Sync to backend
    await _syncPreferencesToBackend();

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

    // Sync to backend
    await _syncPreferencesToBackend();
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

    // Sync to backend
    await _syncPreferencesToBackend();
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

    // Sync to backend
    await _syncPreferencesToBackend();
  }

  // ================================================================
  // SYNC
  // ================================================================

  /// Sync preferences to backend
  Future<void> _syncPreferencesToBackend() async {
    if (_userId == null) {
      if (kDebugMode) {
        print('[SettingsProvider] No user ID, skipping sync');
      }
      return;
    }

    final prefs = {
      'user_id': _userId,
      'language_preference': _chineseVariant.name,
      'app_language': _appLanguage.code,
      'notifications_enabled': _notificationsEnabled,
      'daily_reminder_enabled': _dailyReminderEnabled,
      'daily_reminder_time': '${_dailyReminderTime.hour.toString().padLeft(2, '0')}:${_dailyReminderTime.minute.toString().padLeft(2, '0')}',
      'review_reminders_enabled': _reviewRemindersEnabled,
    };

    try {
      final response = await _apiClient.updateUserPreferences(prefs);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('[SettingsProvider] Preferences synced to backend');
        }
      } else {
        // Queue for later sync
        await _queuePreferencesSync(prefs);
      }
    } catch (e) {
      if (kDebugMode) {
        print('[SettingsProvider] Error syncing preferences: $e');
      }
      // Queue for later sync when offline
      await _queuePreferencesSync(prefs);
    }
  }

  /// Queue preferences for later sync (when offline)
  Future<void> _queuePreferencesSync(Map<String, dynamic> prefs) async {
    await LocalStorage.addToSyncQueue({
      'type': 'settings_change',
      'data': prefs,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (kDebugMode) {
      print('[SettingsProvider] Preferences queued for sync');
    }
  }

  /// Load preferences from server (call after login)
  Future<void> loadPreferencesFromServer() async {
    // This would fetch preferences from the server
    // For now, we trust the local storage as the source of truth
    // Server preferences would be fetched via auth/profile endpoint
    if (kDebugMode) {
      print('[SettingsProvider] loadPreferencesFromServer called (using local for now)');
    }
  }

  // ================================================================
  // HELPERS
  // ================================================================

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    _chineseVariant = ChineseVariant.simplified;
    _appLanguage = AppLanguage.zhCN;
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
