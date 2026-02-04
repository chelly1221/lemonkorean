import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

/// Local Storage using Hive
/// Handles offline-first data storage
class LocalStorage {
  static late Box _lessonsBox;
  static late Box _vocabularyBox;
  static late Box _progressBox;
  static late Box _syncQueueBox;
  static late Box _settingsBox;
  static late Box _reviewsBox;
  static late Box _bookmarksBox;

  /// Initialize all Hive boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Open boxes
    _lessonsBox = await Hive.openBox(AppConstants.lessonsBox);
    _vocabularyBox = await Hive.openBox(AppConstants.vocabularyBox);
    _progressBox = await Hive.openBox(AppConstants.progressBox);
    _syncQueueBox = await Hive.openBox(AppConstants.syncQueueBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
    _reviewsBox = await Hive.openBox('reviews');
    _bookmarksBox = await Hive.openBox('bookmarks');
  }

  // ================================================================
  // LESSONS
  // ================================================================

  /// Build storage key with optional language suffix
  static String _buildKey(String baseKey, {String? language}) {
    if (language == null || language.isEmpty) {
      return baseKey;
    }
    return '${baseKey}_$language';
  }

  /// Save a lesson to local storage (with optional language-specific key)
  static Future<void> saveLesson(Map<String, dynamic> lesson, {String? language}) async {
    // 백엔드는 'lesson_id', 일부 코드는 'id' 사용 - 둘 다 지원
    final lessonId = lesson['id'] ?? lesson['lesson_id'];
    if (lessonId == null) {
      return;
    }

    // 일관성을 위해 'id' 필드도 추가
    lesson['id'] = lessonId;

    // Use language-specific key for localized content
    final key = _buildKey('lesson_$lessonId', language: language);
    await _lessonsBox.put(key, lesson);

    // Also save to base key for backwards compatibility
    if (language != null) {
      await _lessonsBox.put('lesson_$lessonId', lesson);
    }
  }

  /// Get a lesson by ID (with optional language-specific key)
  static Map<String, dynamic>? getLesson(int lessonId, {String? language}) {
    // Try language-specific key first
    if (language != null) {
      final key = _buildKey('lesson_$lessonId', language: language);
      final data = _lessonsBox.get(key);
      if (data != null) {
        return Map<String, dynamic>.from(data);
      }
    }
    // Fall back to base key
    final data = _lessonsBox.get('lesson_$lessonId');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all lessons (with optional language filter)
  static List<Map<String, dynamic>> getAllLessons({String? language}) {
    final suffix = language != null ? '_$language' : '';
    return _lessonsBox.keys
        .where((key) {
          final keyStr = key.toString();
          if (language != null) {
            // Only include keys with the language suffix
            return keyStr.startsWith('lesson_') && keyStr.endsWith(suffix);
          } else {
            // Include base keys (no language suffix) only
            return keyStr.startsWith('lesson_') &&
                !keyStr.contains(RegExp(r'_(ko|en|es|ja|zh|zh_TW)$'));
          }
        })
        .map((key) => Map<String, dynamic>.from(_lessonsBox.get(key) as Map))
        .toList();
  }

  /// Check if lesson exists
  static bool hasLesson(int lessonId, {String? language}) {
    final key = _buildKey('lesson_$lessonId', language: language);
    return _lessonsBox.containsKey(key);
  }

  /// Delete a lesson
  static Future<void> deleteLesson(int lessonId, {String? language}) async {
    final key = _buildKey('lesson_$lessonId', language: language);
    await _lessonsBox.delete(key);
  }

  /// Clear all lessons
  static Future<void> clearLessons() async {
    await _lessonsBox.clear();
  }

  // ================================================================
  // VOCABULARY
  // ================================================================

  /// Save vocabulary item (with optional language-specific key)
  static Future<void> saveVocabulary(Map<String, dynamic> vocabulary, {String? language}) async {
    final vocabId = vocabulary['id'];
    final key = _buildKey('vocab_$vocabId', language: language);
    await _vocabularyBox.put(key, vocabulary);

    // Also save to base key for backwards compatibility
    if (language != null) {
      await _vocabularyBox.put('vocab_$vocabId', vocabulary);
    }
  }

  /// Get vocabulary by ID (with optional language-specific key)
  static Map<String, dynamic>? getVocabulary(int vocabId, {String? language}) {
    // Try language-specific key first
    if (language != null) {
      final key = _buildKey('vocab_$vocabId', language: language);
      final data = _vocabularyBox.get(key);
      if (data != null) {
        return Map<String, dynamic>.from(data);
      }
    }
    // Fall back to base key
    final data = _vocabularyBox.get('vocab_$vocabId');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all vocabulary (with optional language filter)
  static List<Map<String, dynamic>> getAllVocabulary({String? language}) {
    final suffix = language != null ? '_$language' : '';
    return _vocabularyBox.keys
        .where((key) {
          final keyStr = key.toString();
          if (language != null) {
            // Only include keys with the language suffix
            return keyStr.startsWith('vocab_') && keyStr.endsWith(suffix);
          } else {
            // Include base keys (no language suffix) only
            return keyStr.startsWith('vocab_') &&
                !keyStr.contains(RegExp(r'_(ko|en|es|ja|zh|zh_TW)$'));
          }
        })
        .map((key) => Map<String, dynamic>.from(_vocabularyBox.get(key) as Map))
        .toList();
  }

  /// Clear all vocabulary
  static Future<void> clearVocabulary() async {
    await _vocabularyBox.clear();
  }

  /// Get vocabulary by level (cached)
  static Future<List<Map<String, dynamic>>?> getVocabularyByLevel(int level) async {
    try {
      final box = await Hive.openBox('vocabulary_cache');
      final data = box.get('level_$level');
      if (data == null) return null;

      return (data as List).map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } catch (e) {
      AppLogger.e('Error getting vocabulary cache for level $level', error: e, tag: 'LocalStorage');
      return null;
    }
  }

  /// Save vocabulary by level to cache
  static Future<void> saveVocabularyByLevel(int level, List<Map<String, dynamic>> words) async {
    try {
      final box = await Hive.openBox('vocabulary_cache');
      await box.put('level_$level', words);
      await box.put('level_${level}_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      AppLogger.e('Error saving vocabulary cache for level $level', error: e, tag: 'LocalStorage');
    }
  }

  /// Get vocabulary cache age
  static Future<Duration?> getVocabularyCacheAge(int level) async {
    try {
      final box = await Hive.openBox('vocabulary_cache');
      final timestampStr = box.get('level_${level}_timestamp');
      if (timestampStr == null) return null;

      final timestamp = DateTime.parse(timestampStr as String);
      return DateTime.now().difference(timestamp);
    } catch (e) {
      AppLogger.e('Error getting cache age for level $level', error: e, tag: 'LocalStorage');
      return null;
    }
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  /// Save user progress
  static Future<void> saveProgress(Map<String, dynamic> progress) async {
    final lessonId = progress['lesson_id'];

    // updated_at이 없으면 현재 시간 추가 (동기화 시 타임스탬프 비교용)
    if (progress['updated_at'] == null) {
      progress['updated_at'] = DateTime.now().toIso8601String();
    }

    await _progressBox.put('progress_$lessonId', progress);
  }

  /// Get progress by lesson ID
  static Map<String, dynamic>? getProgress(int lessonId) {
    final data = _progressBox.get('progress_$lessonId');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all progress
  static List<Map<String, dynamic>> getAllProgress() {
    return _progressBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Update progress
  static Future<void> updateProgress(
    int lessonId,
    Map<String, dynamic> updates,
  ) async {
    final existing = getProgress(lessonId) ?? {};
    final updated = {...existing, ...updates};
    await saveProgress(updated);
  }

  /// Get lesson progress (for compatibility with userId parameter)
  static Future<Map<String, dynamic>?> getLessonProgress(
    int userId,
    int lessonId,
  ) async {
    return getProgress(lessonId);
  }

  // ================================================================
  // REVIEWS
  // ================================================================

  /// Save vocabulary review
  static Future<void> saveReview(Map<String, dynamic> review) async {
    final reviewId = review['id'] ?? '${review['user_id']}_${review['vocabulary_id']}';
    await _reviewsBox.put('review_$reviewId', review);
  }

  /// Get vocabulary review
  static Future<Map<String, dynamic>?> getVocabularyReview(
    int userId,
    int vocabularyId,
  ) async {
    final reviewId = '${userId}_${vocabularyId}';
    final data = _reviewsBox.get('review_$reviewId');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all reviews
  static Future<List<Map<String, dynamic>>> getAllReviews() async {
    return _reviewsBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Clear all reviews
  static Future<void> clearReviews() async {
    await _reviewsBox.clear();
  }

  // ================================================================
  // BOOKMARKS
  // ================================================================

  /// Save a bookmark
  static Future<void> saveBookmark(Map<String, dynamic> bookmark) async {
    final bookmarkId = bookmark['id'];
    if (bookmarkId == null) {
      return;
    }
    await _bookmarksBox.put('bookmark_$bookmarkId', bookmark);
  }

  /// Get bookmark by ID
  static Map<String, dynamic>? getBookmark(int bookmarkId) {
    final data = _bookmarksBox.get('bookmark_$bookmarkId');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all bookmarks
  static List<Map<String, dynamic>> getAllBookmarks() {
    return _bookmarksBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Delete a bookmark
  static Future<void> deleteBookmark(int bookmarkId) async {
    await _bookmarksBox.delete('bookmark_$bookmarkId');
  }

  /// Clear all bookmarks
  static Future<void> clearBookmarks() async {
    await _bookmarksBox.clear();
  }

  /// Check if vocabulary is bookmarked
  static bool isBookmarked(int vocabularyId) {
    return _bookmarksBox.values.any((bookmark) {
      final b = Map<String, dynamic>.from(bookmark as Map);
      return b['vocabulary_id'] == vocabularyId;
    });
  }

  /// Get bookmark by vocabulary ID
  static Map<String, dynamic>? getBookmarkByVocabularyId(int vocabularyId) {
    for (final bookmark in _bookmarksBox.values) {
      final b = Map<String, dynamic>.from(bookmark as Map);
      if (b['vocabulary_id'] == vocabularyId) {
        return b;
      }
    }
    return null;
  }

  /// Delete bookmark by vocabulary ID
  static Future<void> deleteBookmarkByVocabularyId(int vocabularyId) async {
    final bookmark = getBookmarkByVocabularyId(vocabularyId);
    if (bookmark != null && bookmark['id'] != null) {
      await deleteBookmark(bookmark['id'] as int);
    }
  }

  /// Get bookmarks count
  static int getBookmarksCount() {
    return _bookmarksBox.length;
  }

  // ================================================================
  // SYNC QUEUE
  // ================================================================

  /// Add item to sync queue
  static Future<void> addToSyncQueue(Map<String, dynamic> syncItem) async {
    final queue = getSyncQueue();
    queue.add(syncItem);
    await _syncQueueBox.put('queue', queue);
  }

  /// Get sync queue
  static List<Map<String, dynamic>> getSyncQueue() {
    final data = _syncQueueBox.get('queue');
    if (data == null) return [];
    return (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Remove item from sync queue
  static Future<void> removeFromSyncQueue(int index) async {
    final queue = getSyncQueue();
    if (index >= 0 && index < queue.length) {
      queue.removeAt(index);
      await _syncQueueBox.put('queue', queue);
    }
  }

  /// Clear sync queue
  static Future<void> clearSyncQueue() async {
    await _syncQueueBox.put('queue', []);
  }

  /// Get sync queue size
  static int getSyncQueueSize() {
    return getSyncQueue().length;
  }

  // ================================================================
  // SETTINGS
  // ================================================================

  /// Save setting
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Get setting
  static T? getSetting<T>(String key, {T? defaultValue}) {
    final value = _settingsBox.get(key);
    return value as T? ?? defaultValue;
  }

  /// Delete setting
  static Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  /// Clear all settings
  static Future<void> clearSettings() async {
    await _settingsBox.clear();
  }

  // ================================================================
  // USER CACHE (for offline-first auth)
  // ================================================================

  static const String _cachedUserKey = 'cached_user';

  /// Save user to local cache for offline access
  static Future<void> saveCachedUser(Map<String, dynamic> user) async {
    await _settingsBox.put(_cachedUserKey, user);
  }

  /// Get cached user for offline-first auth
  static Map<String, dynamic>? getCachedUser() {
    final data = _settingsBox.get(_cachedUserKey);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Clear cached user on logout
  static Future<void> clearCachedUser() async {
    await _settingsBox.delete(_cachedUserKey);
  }

  // ================================================================
  // USER DATA
  // ================================================================

  /// Save user ID
  static Future<void> saveUserId(int userId) async {
    await saveSetting(AppConstants.userIdKey, userId);
  }

  /// Get user ID
  static int? getUserId() {
    return getSetting<int>(AppConstants.userIdKey);
  }

  /// Clear user ID
  static Future<void> clearUserId() async {
    await deleteSetting(AppConstants.userIdKey);
  }

  // ================================================================
  // GENERIC BOX ACCESS (for new features like Hangul)
  // ================================================================

  /// Save data to a named box
  static Future<void> saveToBox(String boxName, String key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  /// Get data from a named box
  static T? getFromBox<T>(String boxName, String key) {
    try {
      final box = Hive.box(boxName);
      return box.get(key) as T?;
    } catch (e) {
      // Box might not be open
      return null;
    }
  }

  /// Get all data from a named box
  static List<T> getAllFromBox<T>(String boxName) {
    try {
      final box = Hive.box(boxName);
      return box.values.cast<T>().toList();
    } catch (e) {
      // Box might not be open
      return [];
    }
  }

  /// Delete data from a named box
  static Future<void> deleteFromBox(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }

  /// Clear a named box
  static Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  // ================================================================
  // GENERAL
  // ================================================================

  /// Clear all data
  static Future<void> clearAll() async {
    await Future.wait([
      clearLessons(),
      _vocabularyBox.clear(),
      _progressBox.clear(),
      clearSyncQueue(),
      clearSettings(),
      clearReviews(),
    ]);
  }

  /// Close all boxes
  static Future<void> close() async {
    await Future.wait([
      _lessonsBox.close(),
      _vocabularyBox.close(),
      _progressBox.close(),
      _syncQueueBox.close(),
      _settingsBox.close(),
      _reviewsBox.close(),
    ]);
  }
}
