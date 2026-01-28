import 'package:flutter/foundation.dart';

import '../../core/constants/settings_keys.dart';
import '../../core/network/api_client.dart';
import '../../core/services/notification_service.dart';
import '../../core/storage/local_storage.dart';

class ProgressProvider with ChangeNotifier {
  final _apiClient = ApiClient.instance;

  List<Map<String, dynamic>> _progressList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get progressList => _progressList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch user progress
  Future<void> fetchProgress(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.getUserProgress(userId);

      if (response.statusCode == 200) {
        _progressList = List<Map<String, dynamic>>.from(
          response.data['progress'],
        );

        // Save to local storage
        for (final progress in _progressList) {
          await LocalStorage.saveProgress(progress);
        }

        _isLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    // Fallback to local storage
    _progressList = LocalStorage.getAllProgress();
    _isLoading = false;
    notifyListeners();
  }

  /// Complete lesson
  Future<bool> completeLesson({
    required int lessonId,
    required int quizScore,
    required int timeSpent,
    String? lessonTitle,
  }) async {
    try {
      final progressData = {
        'lesson_id': lessonId,
        'quiz_score': quizScore,
        'time_spent': timeSpent,
        'completed_at': DateTime.now().toIso8601String(),
        'status': 'completed',
      };

      // Save locally first
      await LocalStorage.saveProgress(progressData);

      // Add to sync queue
      await LocalStorage.addToSyncQueue({
        'type': 'lesson_complete',
        'data': progressData,
        'created_at': DateTime.now().toIso8601String(),
      });

      try {
        // Try to sync immediately
        final response = await _apiClient.completeLesson(
          lessonId: lessonId,
          quizScore: quizScore,
          timeSpent: timeSpent,
        );

        if (response.statusCode == 200) {
          // Remove from sync queue if successful
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexWhere(
            (item) =>
                item['type'] == 'lesson_complete' &&
                item['data']['lesson_id'] == lessonId,
          );
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
          }
        }
      } catch (e) {
        // Network error - will be synced later
        debugPrint('Failed to sync immediately: $e');
      }

      // Schedule review reminder if enabled
      await _scheduleReviewReminder(lessonId, lessonTitle);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Schedule review reminder based on SRS algorithm
  Future<void> _scheduleReviewReminder(int lessonId, String? lessonTitle) async {
    try {
      // Check if notifications and review reminders are enabled
      final notificationsEnabled = LocalStorage.getSetting<bool>(
        SettingsKeys.notificationsEnabled,
        defaultValue: false,
      );
      final reviewRemindersEnabled = LocalStorage.getSetting<bool>(
        SettingsKeys.reviewRemindersEnabled,
        defaultValue: true,
      );

      if (notificationsEnabled != true || reviewRemindersEnabled != true) {
        return;
      }

      // Get review history for this lesson
      final allProgress = LocalStorage.getAllProgress();
      final lessonReviews = allProgress
          .where((p) => p['lesson_id'] == lessonId && p['status'] == 'completed')
          .length;

      // SRS intervals: 1, 3, 7, 14, 30, 60, 90 days
      const intervals = [1, 3, 7, 14, 30, 60, 90];
      final days = lessonReviews < intervals.length
          ? intervals[lessonReviews]
          : intervals.last;

      final reviewDate = DateTime.now().add(Duration(days: days));

      // Schedule notification
      final title = lessonTitle ?? '第 $lessonId 课';
      await NotificationService.instance.scheduleReviewReminder(
        lessonId: lessonId,
        reviewDate: reviewDate,
        lessonTitle: title,
      );

      if (kDebugMode) {
        print('[ProgressProvider] Review reminder scheduled for $lessonId in $days days');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[ProgressProvider] Error scheduling review reminder: $e');
      }
    }
  }

  /// Get progress for specific lesson
  Map<String, dynamic>? getLessonProgress(int lessonId) {
    return LocalStorage.getProgress(lessonId);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
