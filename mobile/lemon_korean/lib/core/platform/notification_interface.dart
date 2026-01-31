/// Platform-agnostic notification service interface
/// Mobile: Uses flutter_local_notifications
/// Web: Uses Web Notifications API (limited functionality)
abstract class INotificationService {
  /// Initialize the notification service
  Future<bool> init();

  /// Schedule a daily reminder
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  });

  /// Cancel all scheduled notifications
  Future<void> cancelAll();

  /// Cancel a specific notification
  Future<void> cancel(int id);

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  });
}
