import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/result.dart';
import '../local/bundled_learning_content.dart';
import '../models/lesson_model.dart';
import '../models/vocabulary_model.dart';

/// Content Repository (bundled-content first)
///
/// Content metadata and lesson bodies are bundled into the app.
/// Server is used only for user-specific state (e.g., review schedule).
class ContentRepository {
  final _apiClient = ApiClient.instance;

  List<LessonModel> _bundledLessons({int? level}) {
    final lessons = BundledLearningContent.lessons;
    if (level == null) return lessons;
    return lessons.where((lesson) => lesson.level == level).toList();
  }

  List<VocabularyModel> _bundledVocabulary({int? level, int? lessonId}) {
    var words = BundledLearningContent.vocabulary;
    if (level != null) {
      words = words.where((word) => word.level == level).toList();
    }
    if (lessonId != null) {
      final ids =
          BundledLearningContent.lessonVocabularyMap[lessonId] ?? const <int>[];
      words = words.where((word) => ids.contains(word.id)).toList();
    }
    return words;
  }

  Future<void> _cacheBundled({String? language}) async {
    for (final lesson in BundledLearningContent.lessons) {
      await LocalStorage.saveLesson(lesson.toJson(), language: language);
    }
    for (final word in BundledLearningContent.vocabulary) {
      await LocalStorage.saveVocabulary(word.toJson(), language: language);
    }
  }

  Future<Result<List<LessonModel>>> getLessonsResult(
      {int? level, String? language}) async {
    try {
      await _cacheBundled(language: language);
      return Success(_bundledLessons(level: level), isFromCache: true);
    } catch (e) {
      AppLogger.w('getLessonsResult local error: $e', tag: 'ContentRepository');
      final cached = await _getLocalLessons(level: level, language: language);
      return Error(
        'Failed to load bundled lessons',
        code: ErrorCodes.serverError,
        cachedData: cached,
      );
    }
  }

  Future<List<LessonModel>> getLessons({int? level, String? language}) async {
    final result = await getLessonsResult(level: level, language: language);
    return result.when(
      success: (data, _) => data,
      error: (_, __, cachedData) => cachedData ?? [],
    );
  }

  Future<LessonModel?> getLesson(int id, {String? language}) async {
    LessonModel? lesson;
    for (final item in BundledLearningContent.lessons) {
      if (item.id == id) {
        lesson = item;
        break;
      }
    }
    if (lesson != null) {
      await LocalStorage.saveLesson(lesson.toJson(), language: language);
      return lesson;
    }

    final local = LocalStorage.getLesson(id, language: language);
    if (local != null) {
      return LessonModel.fromJson(local);
    }

    return null;
  }

  Future<LessonModel?> downloadLessonPackage(int id, {String? language}) async {
    final lesson = await getLesson(id, language: language);
    if (lesson == null) return null;

    final downloaded = lesson.copyWith(
      isDownloaded: true,
      downloadedAt: DateTime.now(),
    );
    await LocalStorage.saveLesson(downloaded.toJson(), language: language);
    return downloaded;
  }

  Future<List<int>> checkForUpdates(Map<int, String> localVersions) async {
    final outdated = <int>[];
    for (final lesson in BundledLearningContent.lessons) {
      final localVersion = localVersions[lesson.id];
      if (localVersion != null && localVersion != lesson.version) {
        outdated.add(lesson.id);
      }
    }
    return outdated;
  }

  Future<List<LessonModel>> getDownloadedLessons() async {
    final allLessons = await _getLocalLessons();
    return allLessons.where((lesson) => lesson.isDownloaded).toList();
  }

  Future<void> deleteDownloadedLesson(int id) async {
    final lessonJson = LocalStorage.getLesson(id);
    if (lessonJson == null) return;

    final lesson = LessonModel.fromJson(lessonJson);
    final updatedLesson = lesson.copyWith(
      isDownloaded: false,
      downloadedAt: null,
      content: lesson.content,
      mediaUrls: null,
    );
    await LocalStorage.saveLesson(updatedLesson.toJson());
  }

  Future<List<VocabularyModel>> getVocabularyByLesson(int lessonId,
      {String? language}) async {
    final words = _bundledVocabulary(lessonId: lessonId);
    for (final word in words) {
      await LocalStorage.saveVocabulary(word.toJson(), language: language);
    }
    return words;
  }

  Future<List<VocabularyModel>> getVocabularyByLevel(int level,
      {String? language}) async {
    final words = _bundledVocabulary(level: level);
    for (final word in words) {
      await LocalStorage.saveVocabulary(word.toJson(), language: language);
    }
    return words;
  }

  Future<List<VocabularyModel>> searchVocabulary(String query) async {
    final allVocabulary = _bundledVocabulary();
    if (query.isEmpty) return allVocabulary;

    final lowerQuery = query.toLowerCase();
    return allVocabulary.where((word) {
      return word.korean.toLowerCase().contains(lowerQuery) ||
          word.translation.toLowerCase().contains(lowerQuery) ||
          (word.hanja?.toLowerCase().contains(lowerQuery) ?? false) ||
          (word.pronunciation?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<List<VocabularyModel>> getVocabularyByIds(List<int> ids) async {
    final idSet = ids.toSet();
    return _bundledVocabulary()
        .where((word) => idSet.contains(word.id))
        .toList();
  }

  Future<List<VocabularyModel>> getSimilarVocabulary(
    String korean, {
    double minScore = 0.7,
  }) async {
    return _bundledVocabulary()
        .where((word) {
          if (word.korean == korean) return false;
          final score = word.similarityScore ?? 0.0;
          return score >= minScore;
        })
        .take(20)
        .toList();
  }

  Future<List<LessonModel>> _getLocalLessons(
      {int? level, String? language}) async {
    final allLessons = LocalStorage.getAllLessons(language: language)
        .map((json) => LessonModel.fromJson(json))
        .toList();

    if (level != null) {
      return allLessons.where((lesson) => lesson.level == level).toList();
    }

    return allLessons;
  }

  Future<List<VocabularyModel>> getReviewSchedule(int userId,
      {int limit = 20}) async {
    try {
      final response = await _apiClient.getReviewSchedule(userId, limit: limit);

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        return items.map((json) => VocabularyModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      AppLogger.w('[ContentRepository] getReviewSchedule error: $e');
      return [];
    }
  }

  Future<bool> markReviewDone(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.markReviewDone(data);
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.w('[ContentRepository] markReviewDone error: $e');
      return false;
    }
  }

  Future<void> clearCache() async {
    await LocalStorage.clearLessons();
    await LocalStorage.clearVocabulary();
  }

  Future<Map<String, dynamic>> getCacheStats() async {
    final lessons = LocalStorage.getAllLessons();
    final vocabulary = LocalStorage.getAllVocabulary();
    final downloadedLessons =
        lessons.where((l) => l['isDownloaded'] == true).toList();

    double cacheSizeMB = 0.0;
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      if (await appDir.exists()) {
        await for (final entity in appDir.list(recursive: true)) {
          if (entity is File) {
            try {
              final fileStat = await entity.stat();
              cacheSizeMB += fileStat.size / (1024 * 1024);
            } catch (_) {
              // Ignore unreadable files.
            }
          }
        }
      }
    } catch (e) {
      AppLogger.w('[ContentRepository] Error calculating cache size: $e');
      cacheSizeMB = 0.0;
    }

    return {
      'total_lessons': lessons.length,
      'downloaded_lessons': downloadedLessons.length,
      'total_vocabulary': vocabulary.length,
      'cache_size_mb': cacheSizeMB.toStringAsFixed(2),
    };
  }
}
