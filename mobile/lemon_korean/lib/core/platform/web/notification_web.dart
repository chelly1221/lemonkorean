import 'package:web/web.dart' as web;

import '../../utils/app_logger.dart';
import '../notification_interface.dart';

/// Web implementation of INotificationService using Web Notifications API
/// Note: Limited functionality compared to mobile
class NotificationServiceImpl implements INotificationService {
  bool _permissionGranted = false;

  @override
  Future<bool> init() async {
    try {
      // Note: web.Notification.requestPermission() returns a sync string in modern web package
      final permission = web.Notification.permission;
      _permissionGranted = permission == 'granted';

      // If permission is 'default', try to request it (simplified approach for web)
      if (!_permissionGranted && permission == 'default') {
        // Notification.requestPermission() is available but needs user interaction
        AppLogger.i('Notification permission is default, user needs to grant permission', tag: 'NotificationWeb');
      }

      return _permissionGranted;
    } catch (e) {
      AppLogger.w('Notifications not supported in this browser', error: e, tag: 'NotificationWeb');
      return false;
    }
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
      web.Notification(
        title ?? 'Lemon Korean',
        web.NotificationOptions(body: body ?? 'Time to study!'),
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
      web.Notification(title, web.NotificationOptions(body: body));
    }
  }
}
