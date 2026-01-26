import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';
import '../models/lesson_model.dart';
import '../models/vocabulary_model.dart';

/// Content Repository
/// Handles lessons and vocabulary with offline-first pattern
class ContentRepository {
  final _apiClient = ApiClient.instance;

  // ================================================================
  // LESSONS
  // ================================================================

  /// Get all lessons (with optional level filter)
  Future<List<LessonModel>> getLessons({int? level}) async {
    try {
      // Try remote first
      final response = await _apiClient.getLessons(level: level);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['lessons'];
        final lessons = data.map((json) => LessonModel.fromJson(json)).toList();

        // Save to local storage
        for (final lesson in lessons) {
          await LocalStorage.saveLesson(lesson.toJson());
        }

        return lessons;
      }

      // If status not 200, fallback to local
      return _getLocalLessons(level: level);
    } catch (e) {
      print('[ContentRepository] getLessons error: $e');
      // Network error, use local
      return _getLocalLessons(level: level);
    }
  }

  /// Get single lesson by ID
  Future<LessonModel?> getLesson(int id) async {
    try {
      // Check local first for better UX
      final localLesson = LocalStorage.getLesson(id);

      // Try to fetch fresh data in background
      final response = await _apiClient.getLesson(id);

      if (response.statusCode == 200) {
        final lesson = LessonModel.fromJson(response.data);

        // Update local storage
        await LocalStorage.saveLesson(lesson.toJson());

        return lesson;
      }

      // If remote fails, return local
      return localLesson != null ? LessonModel.fromJson(localLesson) : null;
    } catch (e) {
      print('[ContentRepository] getLesson error: $e');
      // Return local data
      final local = LocalStorage.getLesson(id);
      return local != null ? LessonModel.fromJson(local) : null;
    }
  }

  /// Download lesson package (full content + media URLs)
  Future<LessonModel?> downloadLessonPackage(int id) async {
    try {
      final response = await _apiClient.downloadLessonPackage(id);

      if (response.statusCode == 200) {
        final lesson = LessonModel.fromJson(response.data);

        // Save complete package locally
        await LocalStorage.saveLesson(lesson.toJson());

        // Mark as downloaded
        final updatedLesson = lesson.copyWith(
          isDownloaded: true,
          downloadedAt: DateTime.now(),
        );
        await LocalStorage.saveLesson(updatedLesson.toJson());

        return updatedLesson;
      }

      return null;
    } catch (e) {
      print('[ContentRepository] downloadLessonPackage error: $e');
      return null;
    }
  }

  /// Check for lesson updates
  Future<List<int>> checkForUpdates(Map<int, String> localVersions) async {
    try {
      final response = await _apiClient.checkLessonUpdates(localVersions);

      if (response.statusCode == 200) {
        final List<dynamic> outdatedIds = response.data['outdated_lessons'];
        return outdatedIds.cast<int>();
      }

      return [];
    } catch (e) {
      print('[ContentRepository] checkForUpdates error: $e');
      return [];
    }
  }

  /// Get downloaded lessons (offline)
  Future<List<LessonModel>> getDownloadedLessons() async {
    final allLessons = await _getLocalLessons();
    return allLessons.where((lesson) => lesson.isDownloaded).toList();
  }

  /// Delete downloaded lesson
  Future<void> deleteDownloadedLesson(int id) async {
    final lessonJson = LocalStorage.getLesson(id);
    if (lessonJson != null) {
      final lesson = LessonModel.fromJson(lessonJson);
      final updatedLesson = lesson.copyWith(
        isDownloaded: false,
        downloadedAt: null,
        content: null, // Clear content
        mediaUrls: null, // Clear media URLs
      );
      await LocalStorage.saveLesson(updatedLesson.toJson());
    }
  }

  // ================================================================
  // VOCABULARY
  // ================================================================

  /// Get vocabulary by lesson ID
  Future<List<VocabularyModel>> getVocabularyByLesson(int lessonId) async {
    try {
      final response = await _apiClient.getVocabularyByLesson(lessonId);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['vocabulary'];
        final vocabulary =
            data.map((json) => VocabularyModel.fromJson(json)).toList();

        // Save to local storage
        for (final word in vocabulary) {
          await LocalStorage.saveVocabulary(word.toJson());
        }

        return vocabulary;
      }

      // Fallback to local
      return _getLocalVocabulary(lessonId: lessonId);
    } catch (e) {
      print('[ContentRepository] getVocabularyByLesson error: $e');
      return _getLocalVocabulary(lessonId: lessonId);
    }
  }

  /// Get vocabulary by level
  Future<List<VocabularyModel>> getVocabularyByLevel(int level) async {
    try {
      final response = await _apiClient.getVocabularyByLevel(level);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['vocabulary'];
        final vocabulary =
            data.map((json) => VocabularyModel.fromJson(json)).toList();

        // Save to local storage
        for (final word in vocabulary) {
          await LocalStorage.saveVocabulary(word.toJson());
        }

        return vocabulary;
      }

      return _getLocalVocabulary(level: level);
    } catch (e) {
      print('[ContentRepository] getVocabularyByLevel error: $e');
      return _getLocalVocabulary(level: level);
    }
  }

  /// Search vocabulary (local only for fast search)
  Future<List<VocabularyModel>> searchVocabulary(String query) async {
    final allVocabulary = await _getLocalVocabulary();

    if (query.isEmpty) return allVocabulary;

    final lowerQuery = query.toLowerCase();
    return allVocabulary.where((word) {
      return word.korean.toLowerCase().contains(lowerQuery) ||
          word.chinese.toLowerCase().contains(lowerQuery) ||
          (word.hanja?.toLowerCase().contains(lowerQuery) ?? false) ||
          (word.pinyin?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get vocabulary by IDs
  Future<List<VocabularyModel>> getVocabularyByIds(List<int> ids) async {
    try {
      final response = await _apiClient.getVocabularyByIds(ids);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['vocabulary'];
        return data.map((json) => VocabularyModel.fromJson(json)).toList();
      }

      // Fallback to local
      return _getLocalVocabularyByIds(ids);
    } catch (e) {
      print('[ContentRepository] getVocabularyByIds error: $e');
      return _getLocalVocabularyByIds(ids);
    }
  }

  /// Get similar vocabulary (by similarity score)
  Future<List<VocabularyModel>> getSimilarVocabulary(
    String korean, {
    double minScore = 0.7,
  }) async {
    try {
      final response = await _apiClient.getSimilarVocabulary(
        korean,
        minScore: minScore,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['similar_words'];
        return data.map((json) => VocabularyModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('[ContentRepository] getSimilarVocabulary error: $e');
      return [];
    }
  }

  // ================================================================
  // PRIVATE HELPERS
  // ================================================================

  Future<List<LessonModel>> _getLocalLessons({int? level}) async {
    final allLessons = LocalStorage.getAllLessons()
        .map((json) => LessonModel.fromJson(json))
        .toList();

    if (level != null) {
      return allLessons.where((lesson) => lesson.level == level).toList();
    }

    return allLessons;
  }

  Future<List<VocabularyModel>> _getLocalVocabulary({
    int? lessonId,
    int? level,
  }) async {
    final allVocabulary = LocalStorage.getAllVocabulary()
        .map((json) => VocabularyModel.fromJson(json))
        .toList();

    if (lessonId != null) {
      // Note: VocabularyModel doesn't have lessonId field
      // This would need to be fetched from lesson content
      // For now, return all vocabulary
      return allVocabulary;
    }

    if (level != null) {
      return allVocabulary.where((word) => word.level == level).toList();
    }

    return allVocabulary;
  }

  Future<List<VocabularyModel>> _getLocalVocabularyByIds(
    List<int> ids,
  ) async {
    final results = <VocabularyModel>[];

    for (final id in ids) {
      final word = LocalStorage.getVocabulary(id);
      if (word != null) {
        results.add(VocabularyModel.fromJson(word));
      }
    }

    return results;
  }

  // ================================================================
  // CACHE MANAGEMENT
  // ================================================================

  /// Clear all cached content
  Future<void> clearCache() async {
    await LocalStorage.clearLessons();
    await LocalStorage.clearVocabulary();
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    final lessons = LocalStorage.getAllLessons();
    final vocabulary = LocalStorage.getAllVocabulary();
    final downloadedLessons =
        lessons.where((l) => l['isDownloaded'] == true).toList();

    return {
      'total_lessons': lessons.length,
      'downloaded_lessons': downloadedLessons.length,
      'total_vocabulary': vocabulary.length,
      'cache_size_mb': 0, // TODO: Calculate actual size
    };
  }
}
