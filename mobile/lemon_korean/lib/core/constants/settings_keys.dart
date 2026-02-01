/// Settings Keys for LocalStorage
/// All setting-related constants
class SettingsKeys {
  // ================================================================
  // LANGUAGE SETTINGS
  // ================================================================

  /// Chinese variant setting key
  /// Values: 'simplified' or 'traditional'
  static const String chineseVariant = 'chinese_variant';

  /// App language setting key
  /// Values: 'zh_CN' (Chinese Simplified), 'zh_TW' (Chinese Traditional), 'ko' (Korean), 'en' (English), 'ja' (Japanese), 'es' (Spanish)
  static const String appLanguage = 'app_language';

  // ================================================================
  // NOTIFICATION SETTINGS
  // ================================================================

  /// Master notification toggle
  static const String notificationsEnabled = 'notifications_enabled';

  /// Daily reminder enabled
  static const String dailyReminderEnabled = 'daily_reminder_enabled';

  /// Daily reminder time (stored as "HH:mm" string)
  static const String dailyReminderTime = 'daily_reminder_time';

  /// Review reminders enabled
  static const String reviewRemindersEnabled = 'review_reminders_enabled';

  // ================================================================
  // DEFAULT VALUES
  // ================================================================

  static const String defaultChineseVariant = 'simplified';
  static const String defaultAppLanguage = 'zh_CN';
  static const bool defaultNotificationsEnabled = false;
  static const bool defaultDailyReminderEnabled = true;
  static const String defaultDailyReminderTime = '20:00';
  static const bool defaultReviewRemindersEnabled = true;
}
