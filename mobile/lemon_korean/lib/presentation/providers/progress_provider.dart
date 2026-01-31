import 'package:flutter/foundation.dart';

import '../../core/constants/settings_keys.dart';
import '../../core/network/api_client.dart';
import '../../core/services/notification_service.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';

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

    // getMasteredWords()와 동일한 로직 사용하여 일관성 보장
    final actualMasteredWords = getMasteredWords().length;

    _userStats = {
      'completed_lessons': completedCount,
      'total_lessons': allProgress.length,
      'study_days': studyDates.length,
      'mastered_words': actualMasteredWords,
      'total_time_minutes': totalTime,
      'current_streak': 0,
    };
  }

  /// 서버와 동기화 (스플래시에서 호출)
  Future<void> syncWithServer(int userId) async {
    try {
      // 1. 로컬 큐 먼저 동기화 (오프라인 변경사항 업로드)
      await _syncLocalQueue();

      // 2. 서버에서 최신 데이터 가져오기
      final responses = await Future.wait([
        _apiClient.getUserProgress(userId),
        _apiClient.getUserStats(userId),
      ]);

      final progressResponse = responses[0];
      final statsResponse = responses[1];

      // 3. 진도 데이터 병합 (최신 우선)
      if (progressResponse.statusCode == 200) {
        final serverProgress = List<Map<String, dynamic>>.from(
          progressResponse.data['progress'] ?? [],
        );
        await _mergeProgress(serverProgress);
      }

      // 4. 통계 데이터 업데이트
      if (statsResponse.statusCode == 200) {
        _userStats = statsResponse.data['stats'] as Map<String, dynamic>?;
      } else {
        // 서버 통계 없으면 로컬에서 계산
        _calculateLocalStats();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('[ProgressProvider] Sync failed: $e');
      // 실패 시 로컬 데이터 사용
      _progressList = LocalStorage.getAllProgress();
      _calculateLocalStats();
      notifyListeners();
    }
  }

  /// 로컬 큐 동기화
  Future<void> _syncLocalQueue() async {
    final queue = LocalStorage.getSyncQueue();
    if (queue.isEmpty) return;

    try {
      final response = await _apiClient.syncProgress(queue);
      if (response.statusCode == 200) {
        await LocalStorage.clearSyncQueue();
      }
    } catch (e) {
      debugPrint('[ProgressProvider] Queue sync failed: $e');
    }
  }

  /// 진도 데이터 병합 (최신 우선)
  Future<void> _mergeProgress(List<Map<String, dynamic>> serverProgress) async {
    for (final serverItem in serverProgress) {
      final lessonId = serverItem['lesson_id'] as int?;
      if (lessonId == null) continue;

      final localItem = LocalStorage.getProgress(lessonId);

      if (localItem == null) {
        // 로컬에 없음 → 서버 데이터 저장
        await LocalStorage.saveProgress(serverItem);
        continue;
      }

      // 타임스탬프 비교
      final serverUpdatedAt = _parseDateTime(serverItem['updated_at']);
      final localUpdatedAt = _parseDateTime(localItem['updated_at']);

      if (serverUpdatedAt == null || localUpdatedAt == null) {
        // 타임스탬프 없으면 서버 우선
        await LocalStorage.saveProgress(serverItem);
        continue;
      }

      if (serverUpdatedAt.isAfter(localUpdatedAt)) {
        // 서버가 최신 → 서버 데이터 저장
        await LocalStorage.saveProgress(serverItem);
      }
      // 로컬이 최신 → 유지 (다음 동기화 때 업로드됨)
    }

    // 로컬 리스트 업데이트
    _progressList = LocalStorage.getAllProgress();
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Update vocabulary progress from quiz results
  Future<bool> updateVocabularyBatch({
    required int lessonId,
    required List<Map<String, dynamic>> vocabularyResults,
  }) async {
    if (vocabularyResults.isEmpty) return true;

    try {
      final userId = LocalStorage.getUserId();
      if (userId == null) {
        debugPrint('[ProgressProvider] No user ID for vocabulary batch');
        return false;
      }

      // Save locally first
      for (final result in vocabularyResults) {
        final vocabId = result['vocabulary_id'] as int;
        final isCorrect = result['is_correct'] as bool;

        // Update local vocabulary progress
        final existing = LocalStorage.getVocabulary(vocabId) ?? {};
        final updated = {
          ...existing,
          'id': vocabId,
          'mastery_level': isCorrect ? 2 : 1, // 2=learning, 1=seen
          'last_reviewed_at': DateTime.now().toIso8601String(),
        };
        await LocalStorage.saveVocabulary(updated);
      }

      // Add to sync queue
      await LocalStorage.addToSyncQueue({
        'type': 'vocabulary_batch',
        'data': {
          'user_id': userId,
          'lesson_id': lessonId,
          'vocabulary_results': vocabularyResults,
        },
        'created_at': DateTime.now().toIso8601String(),
      });

      try {
        // Try to sync immediately
        final response = await _apiClient.updateVocabularyBatch(
          userId: userId,
          lessonId: lessonId,
          vocabularyResults: vocabularyResults,
        );

        if (response.statusCode == 200) {
          // Remove from sync queue if successful
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexWhere(
            (item) =>
                item['type'] == 'vocabulary_batch' &&
                item['data']['lesson_id'] == lessonId,
          );
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
          }
          debugPrint('[ProgressProvider] Vocabulary batch synced: ${vocabularyResults.length} items');
        }
      } catch (e) {
        // Network error - will be synced later
        debugPrint('[ProgressProvider] Failed to sync vocabulary batch: $e');
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[ProgressProvider] Error updating vocabulary batch: $e');
      return false;
    }
  }

  /// Complete lesson
  Future<bool> completeLesson({
    required int userId,
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

          // Refresh stats and progress immediately
          await fetchUserStats(userId);
          await fetchProgress(userId);
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

      if (lessonData == null) continue;

      // 1순위: 레슨 패키지의 vocabulary 배열 (올바른 경로)
      final vocabulary = lessonData['vocabulary'] as List?;
      if (vocabulary != null && vocabulary.isNotEmpty) {
        for (final word in vocabulary) {
          vocabularyList.add({
            ...Map<String, dynamic>.from(word as Map),
            'lesson_id': lessonId,
          });
        }
        continue;
      }

      // 2순위: content 내부 (레거시 구조)
      final content = lessonData['content'] as Map<String, dynamic>?;
      if (content != null) {
        // v2 구조: stages 배열
        final stages = content['stages'] as List?;
        if (stages != null) {
          for (final stage in stages) {
            if (stage['type'] == 'vocabulary' && stage['data'] != null) {
              final words = stage['data']['words'] as List?;
              if (words != null) {
                for (final word in words) {
                  vocabularyList.add({
                    ...Map<String, dynamic>.from(word as Map),
                    'lesson_id': lessonId,
                  });
                }
              }
            }
          }
          continue;
        }

        // v1 구조: stage2_vocabulary
        final vocabStage = content['stage2_vocabulary'] as Map<String, dynamic>?;
        final words = vocabStage?['words'] as List?;
        if (words != null) {
          for (final word in words) {
            vocabularyList.add({
              ...Map<String, dynamic>.from(word as Map),
              'lesson_id': lessonId,
            });
          }
        }
      }

      // 더미 데이터 생성하지 않음 - 실제 데이터만 반환
    }

    return vocabularyList;
  }
}
