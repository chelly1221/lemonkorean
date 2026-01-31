import 'storage_interface.dart';
import 'secure_storage_interface.dart';
import 'media_loader_interface.dart';
import 'notification_interface.dart';

// Conditional imports based on platform
import 'io/storage_io.dart' if (dart.library.html) 'web/storage_web.dart';
import 'io/secure_storage_io.dart'
    if (dart.library.html) 'web/secure_storage_web.dart';
import 'io/media_loader_io.dart'
    if (dart.library.html) 'web/media_loader_web.dart';
import 'io/notification_io.dart'
    if (dart.library.html) 'web/notification_web.dart';

/// Platform factory for creating platform-specific implementations
/// Uses conditional imports to select IO or Web implementations at compile time
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
