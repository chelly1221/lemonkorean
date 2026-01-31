/// Stub for NotificationService (web build)
/// This file is imported when building for web to avoid importing flutter_local_notifications
class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  Future<bool> init() async {
    // Stub - actual implementation uses PlatformFactory
    return false;
  }

  Future<void> cancelAllNotifications() async {
    // Stub
  }

  // Add other methods as needed for compatibility
}
