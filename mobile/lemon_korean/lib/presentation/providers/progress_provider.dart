import 'package:flutter/foundation.dart';

import '../../core/constants/settings_keys.dart';
import '../../core/network/api_client.dart';
import '../../core/services/notification_service.dart';
import '../../core/storage/local_storage.dart';

class ProgressProvider with ChangeNotifier {
  final _apiClient = ApiClient.instance;

  List<Map<String, dynamic>> _progressList = [];
  Map<String, dynamic>? _userStats;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get progressList => _progressList;
  Map<String, dynamic>? get userStats => _userStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Stats getters (with defaults)
  int get completedLessons => _userStats?['completed_lessons'] ?? 0;
  int get totalLessons => _userStats?['total_lessons'] ?? 0;
  int get totalStudyDays => _userStats?['study_days'] ?? 0;
  int get masteredWords => _userStats?['mastered_words'] ?? 0;
  int get currentStreak => _userStats?['current_streak'] ?? 0;
  int get totalTimeMinutes => _userStats?['total_time_minutes'] ?? 0;

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

  /// Fetch user statistics
  Future<void> fetchUserStats(int userId) async {
    try {
      final response = await _apiClient.getUserStats(userId);

      if (response.statusCode == 200) {
        _userStats = response.data['stats'] as Map<String, dynamic>?;
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('[ProgressProvider] Failed to fetch stats: $e');
    }

    // Calculate stats from local progress if API fails
    _calculateLocalStats();
    notifyListeners();
  }

  /// Calculate stats from local progress data
  void _calculateLocalStats() {
    final allProgress = LocalStorage.getAllProgress();

    int completedCount = 0;
    int totalTime = 0;
    final studyDates = <String>{};

    for (final p in allProgress) {
      if (p['status'] == 'completed') {
        completedCount++;
      }
      if (p['time_spent_minutes'] != null) {
        totalTime += (p['time_spent_minutes'] as int);
      }
      if (p['completed_at'] != null) {
        final date = DateTime.parse(p['completed_at']).toIso8601String().substring(0, 10);
        studyDates.add(date);
      }
    }

    _userStats = {
      'completed_lessons': completedCount,
      'total_lessons': allProgress.length,
      'study_days': studyDates.length,
      'mastered_words': completedCount * 5, // Estimate 5 words per lesson
      'total_time_minutes': totalTime,
      'current_streak': 0, // Would need more complex calculation
    };
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

  /// Get list of completed lessons with details
  List<Map<String, dynamic>> getCompletedLessons() {
    final allProgress = LocalStorage.getAllProgress();
    final completedList = allProgress
        .where((p) => p['status'] == 'completed')
        .toList();

    // Sort by completion date (most recent first)
    completedList.sort((a, b) {
      final dateA = a['completed_at'] != null
          ? DateTime.parse(a['completed_at'])
          : DateTime(1970);
      final dateB = b['completed_at'] != null
          ? DateTime.parse(b['completed_at'])
          : DateTime(1970);
      return dateB.compareTo(dateA);
    });

    // Enrich with lesson details from local storage
    return completedList.map((progress) {
      final lessonId = progress['lesson_id'] as int;
      final lessonData = LocalStorage.getLesson(lessonId);

      return {
        ...progress,
        'title_ko': lessonData?['title_ko'] ?? '레슨 $lessonId',
        'title_zh': lessonData?['title_zh'] ?? '课程 $lessonId',
        'level': lessonData?['level'] ?? 1,
        'vocabulary_count': lessonData?['vocabulary_count'] ?? 0,
      };
    }).toList();
  }

  /// Get list of mastered vocabulary words
  List<Map<String, dynamic>> getMasteredWords() {
    final allVocabulary = LocalStorage.getAllVocabulary();

    // If no vocabulary data, generate from completed lessons
    if (allVocabulary.isEmpty) {
      return _generateVocabularyFromProgress();
    }

    return allVocabulary;
  }

  /// Generate vocabulary list from completed lesson progress
  List<Map<String, dynamic>> _generateVocabularyFromProgress() {
    final completedLessons = getCompletedLessons();
    final vocabularyList = <Map<String, dynamic>>[];

    for (final lesson in completedLessons) {
      final lessonId = lesson['lesson_id'] as int;
      final lessonData = LocalStorage.getLesson(lessonId);

      // Try to get vocabulary from lesson content
      if (lessonData != null && lessonData['content'] != null) {
        final content = lessonData['content'] as Map<String, dynamic>?;
        final vocabStage = content?['stage2_vocabulary'] as Map<String, dynamic>?;
        final words = vocabStage?['words'] as List?;

        if (words != null) {
          for (final word in words) {
            vocabularyList.add(Map<String, dynamic>.from(word as Map));
          }
        }
      } else {
        // Generate sample vocabulary for the lesson
        final vocabCount = lesson['vocabulary_count'] as int? ?? 5;
        for (int i = 1; i <= vocabCount; i++) {
          vocabularyList.add({
            'id': lessonId * 100 + i,
            'korean': '단어$lessonId-$i',
            'chinese': '单词$lessonId-$i',
            'pinyin': 'dān cí',
            'lesson_id': lessonId,
            'mastery_level': 100,
          });
        }
      }
    }

    return vocabularyList;
  }
}
