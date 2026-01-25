import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
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

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
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
