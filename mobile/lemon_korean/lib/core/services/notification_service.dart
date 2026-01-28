import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Notification Service
/// Handles all notification scheduling and management
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Notification IDs
  static const int dailyReminderNotificationId = 1;
  static const int reviewReminderBaseId = 1000; // Base ID for review reminders

  // ================================================================
  // INITIALIZATION
  // ================================================================

  /// Initialize notification service
  Future<bool> init() async {
    if (_isInitialized) return true;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Shanghai')); // China timezone

      // Android settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize notifications
      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = initialized ?? false;

      if (kDebugMode) {
        print('[NotificationService] Initialized: $_isInitialized');
      }

      return _isInitialized;
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Init error: $e');
      }
      return false;
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('[NotificationService] Notification tapped: ${response.payload}');
    }
    // TODO: Navigate to appropriate screen based on payload
  }

  // ================================================================
  // PERMISSIONS
  // ================================================================

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await init();
    }

    // Request Android 13+ permissions
    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      if (kDebugMode) {
        print('[NotificationService] Permission granted: $granted');
      }
      return granted ?? false;
    }

    // Request iOS permissions
    final iosImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        print('[NotificationService] iOS permission granted: $granted');
      }
      return granted ?? false;
    }

    return true;
  }

  /// Check if permissions are granted
  Future<bool> areNotificationsEnabled() async {
    if (!_isInitialized) {
      await init();
    }

    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final enabled = await androidImplementation.areNotificationsEnabled();
      return enabled ?? false;
    }

    return true; // Assume enabled on other platforms
  }

  // ================================================================
  // DAILY REMINDER
  // ================================================================

  /// Schedule daily learning reminder
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      // Cancel existing daily reminder
      await _notifications.cancel(dailyReminderNotificationId);

      // Create notification time
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If the scheduled time is in the past, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        'daily_reminder',
        '每日学习提醒',
        channelDescription: '每天固定时间提醒你学习韩语',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        dailyReminderNotificationId,
        '📚 学习时间到了！',
        '今天的韩语学习还没完成哦~ / 오늘의 한국어 학습을 완료하세요~',
        scheduledDate,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      if (kDebugMode) {
        print('[NotificationService] Daily reminder scheduled at $hour:$minute');
        print('[NotificationService] Next notification: $scheduledDate');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Error scheduling daily reminder: $e');
      }
    }
  }

  /// Cancel daily reminder
  Future<void> cancelDailyReminder() async {
    if (!_isInitialized) return;

    try {
      await _notifications.cancel(dailyReminderNotificationId);
      if (kDebugMode) {
        print('[NotificationService] Daily reminder cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Error cancelling daily reminder: $e');
      }
    }
  }

  // ================================================================
  // REVIEW REMINDERS (SRS)
  // ================================================================

  /// Schedule review reminder for a lesson
  Future<void> scheduleReviewReminder({
    required int lessonId,
    required DateTime reviewDate,
    required String lessonTitle,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      final notificationId = reviewReminderBaseId + lessonId;

      // Convert to TZDateTime
      final scheduledDate = tz.TZDateTime.from(reviewDate, tz.local);

      // Don't schedule if the date is in the past
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        if (kDebugMode) {
          print('[NotificationService] Review date in past, skipping: $reviewDate');
        }
        return;
      }

      const androidDetails = AndroidNotificationDetails(
        'review_reminder',
        '复习提醒',
        channelDescription: '基于间隔重复算法的复习提醒',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        notificationId,
        '🔄 复习时间到了！',
        '该复习「$lessonTitle」了~ / 「$lessonTitle」을(를) 복습할 시간입니다~',
        scheduledDate,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'review_lesson_$lessonId',
      );

      if (kDebugMode) {
        print('[NotificationService] Review reminder scheduled:');
        print('  - Lesson: $lessonTitle (ID: $lessonId)');
        print('  - Date: $scheduledDate');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Error scheduling review reminder: $e');
      }
    }
  }

  /// Cancel review reminder for a lesson
  Future<void> cancelReviewReminder(int lessonId) async {
    if (!_isInitialized) return;

    try {
      final notificationId = reviewReminderBaseId + lessonId;
      await _notifications.cancel(notificationId);

      if (kDebugMode) {
        print('[NotificationService] Review reminder cancelled for lesson $lessonId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Error cancelling review reminder: $e');
      }
    }
  }

  // ================================================================
  // UTILITIES
  // ================================================================

  /// Cancel all notifications
  Future<void> cancelAll() async {
    if (!_isInitialized) return;

    try {
      await _notifications.cancelAll();
      if (kDebugMode) {
        print('[NotificationService] All notifications cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Error cancelling all notifications: $e');
      }
    }
  }

  /// Get pending notifications count
  Future<int> getPendingNotificationsCount() async {
    if (!_isInitialized) return 0;

    try {
      final pending = await _notifications.pendingNotificationRequests();
      return pending.length;
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Error getting pending notifications: $e');
      }
      return 0;
    }
  }

  /// Get all pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) return [];

    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      if (kDebugMode) {
        print('[NotificationService] Error getting pending notifications: $e');
      }
      return [];
    }
  }
}
