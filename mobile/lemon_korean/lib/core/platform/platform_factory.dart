import 'storage_interface.dart';
import 'secure_storage_interface.dart';
import 'media_loader_interface.dart';
import 'notification_interface.dart';

import 'io/storage_io.dart';
import 'io/secure_storage_io.dart';
import 'io/media_loader_io.dart';
import 'io/notification_io.dart';

/// Platform factory for creating platform-specific implementations
class PlatformFactory {
  /// Create a local storage instance
  static ILocalStorage createLocalStorage() => LocalStorageImpl();

  /// Create a secure storage instance
  static ISecureStorage createSecureStorage() => SecureStorageImpl();

  /// Create a media loader instance
  static IMediaLoader createMediaLoader() => MediaLoaderImpl();

  /// Create a notification service instance
  static INotificationService createNotificationService() =>
      NotificationServiceImpl();
}
