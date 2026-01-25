import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';
import '../models/progress_model.dart';

/// Progress Repository
/// Handles user progress, quiz scores, and SRS reviews with offline sync
class ProgressRepository {
  final _apiClient = ApiClient.instance;

  // ================================================================
  // USER PROGRESS
  // ================================================================

  /// Get all progress for current user
  Future<List<ProgressModel>> getUserProgress(int userId) async {
    try {
      final response = await _apiClient.getUserProgress(userId);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['progress'];
        final progressList =
            data.map((json) => ProgressModel.fromJson(json)).toList();

        // Save to local storage
        for (final progress in progressList) {
          await LocalStorage.saveProgress(progress.toJson());
        }

        return progressList;
      }

      // Fallback to local
      return _getLocalProgress(userId);
    } catch (e) {
      print('[ProgressRepository] getUserProgress error: $e');
      return _getLocalProgress(userId);
    }
  }

  /// Get progress for specific lesson
  Future<ProgressModel?> getLessonProgress(
    int userId,
    int lessonId,
  ) async {
    try {
      // Check local first
      final localProgress = await LocalStorage.getLessonProgress(
        userId,
        lessonId,
      );

      // Try to sync with remote
      final response = await _apiClient.getLessonProgress(userId, lessonId);

      if (response.statusCode == 200) {
        final progress = ProgressModel.fromJson(response.data);

        // Update local
        await LocalStorage.saveProgress(progress.toJson());

        return progress;
      }

      // Return local data
      return localProgress;
    } catch (e) {
      print('[ProgressRepository] getLessonProgress error: $e');
      return LocalStorage.getLessonProgress(userId, lessonId);
    }
  }

  /// Start lesson (mark as in_progress)
  Future<ProgressModel> startLesson(int userId, int lessonId) async {
    final now = DateTime.now();

    final progress = ProgressModel(
      id: 0, // Will be set by server
      userId: userId,
      lessonId: lessonId,
      status: 'in_progress',
      timeSpent: 0,
      startedAt: now,
      isSynced: false,
      createdAt: now,
      updatedAt: now,
    );

    // Save locally first
    await LocalStorage.saveProgress(progress.toJson());

    // Add to sync queue
    await LocalStorage.addToSyncQueue({
      'type': 'lesson_start',
      'data': progress.toJson(),
      'created_at': now.toIso8601String(),
    });

    // Try to sync immediately
    try {
      final response = await _apiClient.startLesson(userId, lessonId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final syncedProgress = ProgressModel.fromJson(response.data);

        // Update with server ID and mark as synced
        final updatedProgress = syncedProgress.copyWith(isSynced: true);
        await LocalStorage.saveProgress(updatedProgress.toJson());

        // Remove from sync queue
        await _removeFromSyncQueue('lesson_start', lessonId);

        return updatedProgress;
      }
    } catch (e) {
      print('[ProgressRepository] startLesson sync error: $e');
      // Continue with local data
    }

    return progress;
  }

  /// Complete lesson
  Future<ProgressModel> completeLesson(
    int userId,
    int lessonId, {
    required int quizScore,
    required int timeSpent,
    Map<String, dynamic>? stageProgress,
  }) async {
    final now = DateTime.now();

    // Get existing progress or create new
    var progress = await LocalStorage.getLessonProgress(userId, lessonId);

    progress = (progress ?? ProgressModel(
      id: 0,
      userId: userId,
      lessonId: lessonId,
      status: 'not_started',
      createdAt: now,
      updatedAt: now,
    )).copyWith(
      status: 'completed',
      quizScore: quizScore,
      timeSpent: timeSpent,
      completedAt: now,
      stageProgress: stageProgress,
      attempts: (progress?.attempts ?? 0) + 1,
      isSynced: false,
      updatedAt: now,
    );

    // Save locally
    await LocalStorage.saveProgress(progress.toJson());

    // Add to sync queue
    await LocalStorage.addToSyncQueue({
      'type': 'lesson_complete',
      'data': progress.toJson(),
      'created_at': now.toIso8601String(),
    });

    // Try to sync immediately
    try {
      final response = await _apiClient.completeLesson(
        userId,
        lessonId,
        quizScore: quizScore,
        timeSpent: timeSpent,
        stageProgress: stageProgress,
      );

      if (response.statusCode == 200) {
        final syncedProgress = ProgressModel.fromJson(response.data);

        // Mark as synced
        final updatedProgress = syncedProgress.copyWith(isSynced: true);
        await LocalStorage.saveProgress(updatedProgress.toJson());

        // Remove from sync queue
        await _removeFromSyncQueue('lesson_complete', lessonId);

        return updatedProgress;
      }
    } catch (e) {
      print('[ProgressRepository] completeLesson sync error: $e');
    }

    return progress;
  }

  /// Update stage progress
  Future<void> updateStageProgress(
    int userId,
    int lessonId,
    String stageName,
    dynamic stageData,
  ) async {
    final progress = await LocalStorage.getLessonProgress(userId, lessonId);

    if (progress != null) {
      final currentStageProgress = progress.stageProgress ?? {};
      currentStageProgress[stageName] = stageData;

      final updatedProgress = progress.copyWith(
        stageProgress: currentStageProgress,
        timeSpent: progress.timeSpent + 1, // Increment time
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await LocalStorage.saveProgress(updatedProgress.toJson());

      // Add to sync queue (debounced)
      await LocalStorage.addToSyncQueue({
        'type': 'stage_progress',
        'data': updatedProgress.toJson(),
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // ================================================================
  // SRS REVIEWS
  // ================================================================

  /// Get review schedule for user
  Future<List<ReviewModel>> getReviewSchedule(int userId) async {
    try {
      final response = await _apiClient.getReviewSchedule(userId);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['reviews'];
        final reviews =
            data.map((json) => ReviewModel.fromJson(json)).toList();

        // Save to local
        for (final review in reviews) {
          await LocalStorage.saveReview(review.toJson());
        }

        return reviews;
      }

      return _getLocalReviews(userId);
    } catch (e) {
      print('[ProgressRepository] getReviewSchedule error: $e');
      return _getLocalReviews(userId);
    }
  }

  /// Get due reviews (reviews that need to be done now)
  Future<List<ReviewModel>> getDueReviews(int userId) async {
    final allReviews = await getReviewSchedule(userId);
    return allReviews.where((review) => review.isDue).toList();
  }

  /// Submit review result (updates SRS scheduling)
  Future<ReviewModel?> submitReview(
    int userId,
    int vocabularyId,
    int quality, // 0-5 (SuperMemo SM-2)
  ) async {
    final now = DateTime.now();

    // Get existing review or create new
    var review = await LocalStorage.getVocabularyReview(userId, vocabularyId);

    // Calculate next review using SM-2 algorithm
    final sm2Result = _calculateSM2(
      quality: quality,
      repetitions: review?.repetitions ?? 0,
      easeFactor: review?.easeFactor ?? 2.5,
      interval: review?.interval ?? 1,
    );

    review = (review ?? ReviewModel(
      id: 0,
      userId: userId,
      vocabularyId: vocabularyId,
      nextReview: now,
      createdAt: now,
      updatedAt: now,
    )).copyWith(
      nextReview: now.add(Duration(days: sm2Result['interval'])),
      interval: sm2Result['interval'],
      easeFactor: sm2Result['easeFactor'],
      repetitions: sm2Result['repetitions'],
      lastReviewedAt: now,
      lastQuality: quality,
      updatedAt: now,
    );

    // Save locally
    await LocalStorage.saveReview(review.toJson());

    // Add to sync queue
    await LocalStorage.addToSyncQueue({
      'type': 'review_submit',
      'data': review.toJson(),
      'created_at': now.toIso8601String(),
    });

    // Try to sync
    try {
      final response = await _apiClient.submitReview(
        userId,
        vocabularyId,
        quality: quality,
      );

      if (response.statusCode == 200) {
        final syncedReview = ReviewModel.fromJson(response.data);
        await LocalStorage.saveReview(syncedReview.toJson());

        // Remove from sync queue
        await _removeFromSyncQueue('review_submit', vocabularyId);

        return syncedReview;
      }
    } catch (e) {
      print('[ProgressRepository] submitReview sync error: $e');
    }

    return review;
  }

  // ================================================================
  // SYNCHRONIZATION
  // ================================================================

  /// Sync all pending progress (called by SyncManager)
  Future<SyncResult> syncProgress() async {
    final queue = LocalStorage.getSyncQueue();
    int successCount = 0;
    int failureCount = 0;
    final List<String> errors = [];

    for (final item in queue) {
      try {
        final type = item['type'] as String;
        final data = item['data'] as Map<String, dynamic>;

        bool success = false;

        switch (type) {
          case 'lesson_start':
          case 'lesson_complete':
          case 'stage_progress':
            final progress = ProgressModel.fromJson(data);
            final response = await _apiClient.syncProgress([progress.toJson()]);
            success = response.statusCode == 200;
            break;

          case 'review_submit':
            final review = ReviewModel.fromJson(data);
            final response = await _apiClient.submitReview(
              review.userId,
              review.vocabularyId,
              quality: review.lastQuality ?? 3,
            );
            success = response.statusCode == 200;
            break;
        }

        if (success) {
          successCount++;
          // Remove from queue
          await LocalStorage.removeFromSyncQueue(queue.indexOf(item));
        } else {
          failureCount++;
        }
      } catch (e) {
        failureCount++;
        errors.add('${item['type']}: $e');
        print('[ProgressRepository] Sync error for ${item['type']}: $e');
      }
    }

    return SyncResult(
      success: failureCount == 0,
      syncedCount: successCount,
      failedCount: failureCount,
      errors: errors,
    );
  }

  // ================================================================
  // STATISTICS
  // ================================================================

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStats(int userId) async {
    try {
      final response = await _apiClient.getUserStats(userId);

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('[ProgressRepository] getUserStats error: $e');
    }

    // Calculate from local data
    final allProgress = await _getLocalProgress(userId);
    final completed = allProgress.where((p) => p.isCompleted).length;
    final inProgress = allProgress.where((p) => p.isInProgress).length;

    final totalTime = allProgress.fold<int>(
      0,
      (sum, p) => sum + p.timeSpent,
    );

    final avgScore = allProgress.where((p) => p.quizScore != null).isEmpty
        ? 0.0
        : allProgress
                .where((p) => p.quizScore != null)
                .map((p) => p.quizScore!)
                .reduce((a, b) => a + b) /
            allProgress.where((p) => p.quizScore != null).length;

    return {
      'completed_lessons': completed,
      'in_progress_lessons': inProgress,
      'total_time_spent': totalTime,
      'average_score': avgScore.round(),
    };
  }

  // ================================================================
  // PRIVATE HELPERS
  // ================================================================

  Future<List<ProgressModel>> _getLocalProgress(int userId) async {
    return LocalStorage.getAllProgress()
        .then((list) => list.where((p) => p.userId == userId).toList());
  }

  Future<List<ReviewModel>> _getLocalReviews(int userId) async {
    return LocalStorage.getAllReviews()
        .then((list) => list.where((r) => r.userId == userId).toList());
  }

  Future<void> _removeFromSyncQueue(String type, int id) async {
    final queue = LocalStorage.getSyncQueue();
    queue.removeWhere((item) =>
        item['type'] == type &&
        (item['data'] as Map<String, dynamic>)['id'] == id);
    await LocalStorage.clearSyncQueue();
    for (final item in queue) {
      await LocalStorage.addToSyncQueue(item);
    }
  }

  /// SM-2 Algorithm (SuperMemo)
  /// Quality: 0-5 (0=complete blackout, 5=perfect recall)
  Map<String, dynamic> _calculateSM2({
    required int quality,
    required int repetitions,
    required double easeFactor,
    required int interval,
  }) {
    var newRepetitions = repetitions;
    var newEaseFactor = easeFactor;
    var newInterval = interval;

    if (quality >= 3) {
      // Correct response
      if (newRepetitions == 0) {
        newInterval = 1;
      } else if (newRepetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (newInterval * newEaseFactor).round();
      }
      newRepetitions += 1;
    } else {
      // Incorrect response
      newRepetitions = 0;
      newInterval = 1;
    }

    // Update ease factor
    newEaseFactor = newEaseFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    if (newEaseFactor < 1.3) {
      newEaseFactor = 1.3;
    }

    return {
      'repetitions': newRepetitions,
      'easeFactor': newEaseFactor,
      'interval': newInterval,
    };
  }
}

// ================================================================
// MODELS
// ================================================================

/// Sync result model
class SyncResult {
  final bool success;
  final int syncedCount;
  final int failedCount;
  final List<String> errors;

  SyncResult({
    required this.success,
    required this.syncedCount,
    required this.failedCount,
    required this.errors,
  });

  @override
  String toString() {
    return 'SyncResult(success: $success, synced: $syncedCount, failed: $failedCount)';
  }
}
