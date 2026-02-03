import 'dart:html' as html;

import '../notification_interface.dart';

/// Web implementation of INotificationService using Web Notifications API
/// Note: Limited functionality compared to mobile
class NotificationServiceImpl implements INotificationService {
  bool _permissionGranted = false;

  @override
  Future<bool> init() async {
    if (!html.Notification.supported) {
      print('[NotificationWeb] Notifications not supported in this browser');
      return false;
    }

    final permission = await html.Notification.requestPermission();
    _permissionGranted = permission == 'granted';

    return _permissionGranted;
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  }) async {
    // Web: Limited scheduling capability
    // Could use Service Workers for background scheduling
    // For now, just show a simple notification
    if (_permissionGranted) {
      html.Notification(
        title ?? 'Lemon Korean',
        body: body ?? 'Time to study!',
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    // Web: No way to cancel notifications once shown
    // They auto-dismiss after a few seconds
  }

  @override
  Future<void> cancel(int id) async {
    // Web: No way to cancel specific notifications
  }

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (_permissionGranted) {
      html.Notification(title, body: body);
    }
  }
}
