import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

/// Centralized logging utility for the app
/// Replaces raw print() statements with structured logging
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  static AppLogger get instance => _instance;

  late final Logger _logger;

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: _getLogLevel(),
    );
  }

  /// Get log level based on environment
  static Level _getLogLevel() {
    if (AppConstants.enableDebugMode) {
      return Level.debug;
    }
    return Level.warning;
  }

  /// Update log level at runtime
  void updateLogLevel(Level level) {
    // Logger doesn't support runtime level change, but we can filter
  }

  // ================================================================
  // Static convenience methods
  // ================================================================

  /// Log debug message (only in debug mode)
  static void d(String message, {String? tag}) {
    if (AppConstants.enableDebugMode) {
      _instance._logger.d(_formatMessage(tag, message));
    }
  }

  /// Log info message
  static void i(String message, {String? tag}) {
    _instance._logger.i(_formatMessage(tag, message));
  }

  /// Log warning message
  static void w(String message, {String? tag, dynamic error}) {
    _instance._logger.w(_formatMessage(tag, message), error: error);
  }

  /// Log error message
  static void e(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _instance._logger.e(_formatMessage(tag, message), error: error, stackTrace: stackTrace);
  }

  /// Log verbose message (only in debug mode)
  static void v(String message, {String? tag}) {
    if (AppConstants.enableDebugMode) {
      _instance._logger.t(_formatMessage(tag, message));
    }
  }

  /// Format message with optional tag
  static String _formatMessage(String? tag, String message) {
    if (tag != null) {
      return '[$tag] $message';
    }
    return message;
  }

  // ================================================================
  // Network logging helpers
  // ================================================================

  /// Log network request
  static void logRequest(String method, String url, {Map<String, dynamic>? headers, dynamic data}) {
    if (!AppConstants.enableDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('REQUEST $method $url');
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers: $headers');
    }
    if (data != null) {
      buffer.writeln('Data: $data');
    }
    _instance._logger.d(buffer.toString());
  }

  /// Log network response
  static void logResponse(int? statusCode, String url, {dynamic data}) {
    if (!AppConstants.enableDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('RESPONSE $statusCode $url');
    if (data != null) {
      final dataStr = data.toString();
      // Truncate long responses
      if (dataStr.length > 500) {
        buffer.writeln('Data: ${dataStr.substring(0, 500)}...');
      } else {
        buffer.writeln('Data: $data');
      }
    }
    _instance._logger.d(buffer.toString());
  }

  /// Log network error
  static void logNetworkError(String method, String url, {dynamic error, int? statusCode}) {
    final buffer = StringBuffer();
    buffer.writeln('ERROR $method $url');
    if (statusCode != null) {
      buffer.writeln('Status: $statusCode');
    }
    if (error != null) {
      buffer.writeln('Error: $error');
    }
    _instance._logger.e(buffer.toString());
  }

  // ================================================================
  // Lifecycle logging helpers
  // ================================================================

  /// Log app lifecycle event
  static void logLifecycle(String event, {String? details}) {
    i('Lifecycle: $event${details != null ? ' - $details' : ''}', tag: 'App');
  }

  /// Log sync event
  static void logSync(String event, {String? details, bool isError = false}) {
    final message = 'Sync: $event${details != null ? ' - $details' : ''}';
    if (isError) {
      e(message, tag: 'Sync');
    } else {
      i(message, tag: 'Sync');
    }
  }

  /// Log storage event
  static void logStorage(String event, {String? details}) {
    d('Storage: $event${details != null ? ' - $details' : ''}', tag: 'Storage');
  }
}
