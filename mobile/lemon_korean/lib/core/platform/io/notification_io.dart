import '../../services/notification_service.dart' as legacy;
import '../notification_interface.dart';

/// Mobile implementation of INotificationService
/// Wraps the existing NotificationService class
class NotificationServiceImpl implements INotificationService {
  final legacy.NotificationService _service = legacy.NotificationService.instance;

  @override
  Future<bool> init() => _service.init();

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? title,
    String? body,
  }) {
    return _service.scheduleDailyReminder(
      hour: hour,
      minute: minute,
      notificationTitle: title ?? 'Time to study!',
      notificationBody: body ?? "Don't forget your daily Korean practice~",
    );
  }

  @override
  Future<void> cancelAll() => _service.cancelAll();

  @override
  Future<void> cancel(int id) => _service.cancelReviewReminder(id);

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // The underlying service doesn't have a generic showNotification method
    // This is a no-op for now since the service handles specific notification types
  }
}
