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
      title: title,
      body: body,
    );
  }

  @override
  Future<void> cancelAll() => _service.cancelAllNotifications();

  @override
  Future<void> cancel(int id) => _service.cancelNotification(id);

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) {
    return _service.showNotification(
      id: id,
      title: title,
      body: body,
    );
  }
}
