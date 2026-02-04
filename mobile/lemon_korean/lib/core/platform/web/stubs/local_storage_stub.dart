/// Web stub for LocalStorage using browser localStorage
/// This file is imported when building for web to avoid importing Hive
/// Provides static methods compatible with mobile API using browser localStorage with JSON encoding
library;

import 'package:web/web.dart' as web;
import 'dart:convert';
import '../../../utils/app_logger.dart';

class LocalStorage {
  /// Initialize (no-op for web, but keeps API compatible)
  static Future<void> init() async {
    // Browser localStorage is always available, no initialization needed
  }

  /// Helper to get all keys from localStorage
  static List<String> _getAllKeys() {
    final keys = <String>[];
    final storage = web.window.localStorage;
    for (var i = 0; i < storage.length; i++) {
      final key = storage.key(i);
      if (key != null) {
        keys.add(key);
      }
    }
    return keys;
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
    try {
      final lessonId = lesson['id'] ?? lesson['lesson_id'];
      if (lessonId == null) return;

      // Ensure 'id' field exists for consistency
      lesson['id'] = lessonId;

      final encoded = jsonEncode(lesson);
      final key = _buildKey('lk_lesson_$lessonId', language: language);
      web.window.localStorage[key] = encoded;

      // Also save to base key for backwards compatibility
      if (language != null) {
        web.window.localStorage['lk_lesson_$lessonId'] = encoded;
      }
    } catch (e) {
      AppLogger.w('Error saving lesson: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get a lesson by ID (with optional language-specific key)
  static Map<String, dynamic>? getLesson(int lessonId, {String? language}) {
    try {
      // Try language-specific key first
      if (language != null) {
        final key = _buildKey('lk_lesson_$lessonId', language: language);
        final encoded = web.window.localStorage[key];
        if (encoded != null) {
          return Map<String, dynamic>.from(jsonDecode(encoded));
        }
      }
      // Fall back to base key
      final encoded = web.window.localStorage['lk_lesson_$lessonId'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      AppLogger.w('Error reading lesson $lessonId: $e', tag: 'LocalStorage', error: e);
      return null;
    }
  }

  /// Get all lessons (with optional language filter)
  static List<Map<String, dynamic>> getAllLessons({String? language}) {
    try {
      final lessons = <Map<String, dynamic>>[];
      final suffix = language != null ? '_$language' : '';
      for (final key in _getAllKeys()) {
        if (key.startsWith('lk_lesson_')) {
          final keyStr = key.toString();
          bool shouldInclude;
          if (language != null) {
            shouldInclude = keyStr.endsWith(suffix);
          } else {
            shouldInclude = !keyStr.contains(RegExp(r'_(ko|en|es|ja|zh|zh_TW)$'));
          }
          if (shouldInclude) {
            final encoded = web.window.localStorage[key];
            if (encoded != null) {
              final lesson = Map<String, dynamic>.from(jsonDecode(encoded));
              lessons.add(lesson);
            }
          }
        }
      }
      return lessons;
    } catch (e) {
      AppLogger.w('Error reading all lessons: $e', tag: 'LocalStorage', error: e);
      return [];
    }
  }

  /// Check if lesson exists
  static bool hasLesson(int lessonId, {String? language}) {
    final key = _buildKey('lk_lesson_$lessonId', language: language);
    return web.window.localStorage.getItem(key) != null;
  }

  /// Delete a lesson
  static Future<void> deleteLesson(int lessonId, {String? language}) async {
    final key = _buildKey('lk_lesson_$lessonId', language: language);
    web.window.localStorage.removeItem(key);
  }

  /// Clear all lessons
  static Future<void> clearLessons() async {
    final keys = _getAllKeys()
        .where((k) => k.startsWith('lk_lesson_'))
        .toList();
    for (final key in keys) {
      web.window.localStorage.removeItem(key);
    }
  }

  // ================================================================
  // VOCABULARY
  // ================================================================

  /// Save vocabulary item (with optional language-specific key)
  static Future<void> saveVocabulary(Map<String, dynamic> vocabulary, {String? language}) async {
    try {
      final vocabId = vocabulary['id'];
      if (vocabId == null) return;
      final key = _buildKey('lk_vocab_$vocabId', language: language);
      web.window.localStorage[key] = jsonEncode(vocabulary);

      // Also save to base key for backwards compatibility
      if (language != null) {
        web.window.localStorage['lk_vocab_$vocabId'] = jsonEncode(vocabulary);
      }
    } catch (e) {
      AppLogger.w('Error saving vocabulary: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get vocabulary by ID (with optional language-specific key)
  static Map<String, dynamic>? getVocabulary(int vocabId, {String? language}) {
    try {
      // Try language-specific key first
      if (language != null) {
        final key = _buildKey('lk_vocab_$vocabId', language: language);
        final encoded = web.window.localStorage[key];
        if (encoded != null) {
          return Map<String, dynamic>.from(jsonDecode(encoded));
        }
      }
      // Fall back to base key
      final encoded = web.window.localStorage['lk_vocab_$vocabId'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      return null;
    }
  }

  /// Get all vocabulary (with optional language filter)
  static List<Map<String, dynamic>> getAllVocabulary({String? language}) {
    try {
      final vocabulary = <Map<String, dynamic>>[];
      final suffix = language != null ? '_$language' : '';
      for (final key in _getAllKeys()) {
        if (key.startsWith('lk_vocab_') && !key.contains('_cache_')) {
          final keyStr = key.toString();
          bool shouldInclude;
          if (language != null) {
            shouldInclude = keyStr.endsWith(suffix);
          } else {
            shouldInclude = !keyStr.contains(RegExp(r'_(ko|en|es|ja|zh|zh_TW)$'));
          }
          if (shouldInclude) {
            final encoded = web.window.localStorage[key];
            if (encoded != null) {
              vocabulary.add(Map<String, dynamic>.from(jsonDecode(encoded)));
            }
          }
        }
      }
      return vocabulary;
    } catch (e) {
      return [];
    }
  }

  /// Clear all vocabulary
  static Future<void> clearVocabulary() async {
    final keys = _getAllKeys()
        .where((k) => k.startsWith('lk_vocab_') && !k.contains('_cache_'))
        .toList();
    for (final key in keys) {
      web.window.localStorage.removeItem(key);
    }
  }

  /// Get vocabulary by level (cached)
  static Future<List<Map<String, dynamic>>?> getVocabularyByLevel(
      int level) async {
    try {
      final encoded = web.window.localStorage['lk_vocab_cache_$level'];
      if (encoded == null) return null;
      final decoded = jsonDecode(encoded) as List;
      return decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      AppLogger.w('Error getting vocabulary cache for level $level: $e', tag: 'LocalStorage', error: e);
      return null;
    }
  }

  /// Save vocabulary by level to cache
  static Future<void> saveVocabularyByLevel(
      int level, List<Map<String, dynamic>> words) async {
    try {
      web.window.localStorage['lk_vocab_cache_$level'] = jsonEncode(words);
      web.window.localStorage['lk_vocab_cache_${level}_timestamp'] =
          DateTime.now().toIso8601String();
    } catch (e) {
      AppLogger.w('Error saving vocabulary cache for level $level: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get vocabulary cache age
  static Future<Duration?> getVocabularyCacheAge(int level) async {
    try {
      final timestampStr =
          web.window.localStorage['lk_vocab_cache_${level}_timestamp'];
      if (timestampStr == null) return null;
      final timestamp = DateTime.parse(timestampStr);
      return DateTime.now().difference(timestamp);
    } catch (e) {
      AppLogger.w('Error getting cache age for level $level: $e', tag: 'LocalStorage', error: e);
      return null;
    }
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  /// Save user progress
  static Future<void> saveProgress(Map<String, dynamic> progress) async {
    try {
      final lessonId = progress['lesson_id'];
      if (lessonId == null) return;

      // Add updated_at if not present
      if (progress['updated_at'] == null) {
        progress['updated_at'] = DateTime.now().toIso8601String();
      }

      web.window.localStorage['lk_progress_$lessonId'] =
          jsonEncode(progress);
    } catch (e) {
      AppLogger.w('Error saving progress: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get progress by lesson ID
  static Map<String, dynamic>? getProgress(int lessonId) {
    try {
      final encoded = web.window.localStorage['lk_progress_$lessonId'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      return null;
    }
  }

  /// Get all progress
  static List<Map<String, dynamic>> getAllProgress() {
    try {
      final progress = <Map<String, dynamic>>[];
      for (final key in _getAllKeys()) {
        if (key.startsWith('lk_progress_')) {
          final encoded = web.window.localStorage[key];
          if (encoded != null) {
            progress.add(Map<String, dynamic>.from(jsonDecode(encoded)));
          }
        }
      }
      return progress;
    } catch (e) {
      return [];
    }
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
    try {
      final reviewId =
          review['id'] ?? '${review['user_id']}_${review['vocabulary_id']}';
      web.window.localStorage['lk_review_$reviewId'] = jsonEncode(review);
    } catch (e) {
      AppLogger.w('Error saving review: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get vocabulary review
  static Future<Map<String, dynamic>?> getVocabularyReview(
    int userId,
    int vocabularyId,
  ) async {
    try {
      final reviewId = '${userId}_${vocabularyId}';
      final encoded = web.window.localStorage['lk_review_$reviewId'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      return null;
    }
  }

  /// Get all reviews
  static Future<List<Map<String, dynamic>>> getAllReviews() async {
    try {
      final reviews = <Map<String, dynamic>>[];
      for (final key in _getAllKeys()) {
        if (key.startsWith('lk_review_')) {
          final encoded = web.window.localStorage[key];
          if (encoded != null) {
            reviews.add(Map<String, dynamic>.from(jsonDecode(encoded)));
          }
        }
      }
      return reviews;
    } catch (e) {
      return [];
    }
  }

  /// Clear all reviews
  static Future<void> clearReviews() async {
    final keys = _getAllKeys()
        .where((k) => k.startsWith('lk_review_'))
        .toList();
    for (final key in keys) {
      web.window.localStorage.removeItem(key);
    }
  }

  // ================================================================
  // BOOKMARKS
  // ================================================================

  /// Save a bookmark
  static Future<void> saveBookmark(Map<String, dynamic> bookmark) async {
    try {
      final bookmarkId = bookmark['id'];
      if (bookmarkId == null) return;
      web.window.localStorage['lk_bookmark_$bookmarkId'] =
          jsonEncode(bookmark);
    } catch (e) {
      AppLogger.w('Error saving bookmark: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get bookmark by ID
  static Map<String, dynamic>? getBookmark(int bookmarkId) {
    try {
      final encoded = web.window.localStorage['lk_bookmark_$bookmarkId'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      return null;
    }
  }

  /// Get all bookmarks
  static List<Map<String, dynamic>> getAllBookmarks() {
    try {
      final bookmarks = <Map<String, dynamic>>[];
      for (final key in _getAllKeys()) {
        if (key.startsWith('lk_bookmark_')) {
          final encoded = web.window.localStorage[key];
          if (encoded != null) {
            bookmarks.add(Map<String, dynamic>.from(jsonDecode(encoded)));
          }
        }
      }
      return bookmarks;
    } catch (e) {
      return [];
    }
  }

  /// Delete a bookmark
  static Future<void> deleteBookmark(int bookmarkId) async {
    web.window.localStorage.removeItem('lk_bookmark_$bookmarkId');
  }

  /// Clear all bookmarks
  static Future<void> clearBookmarks() async {
    final keys = _getAllKeys()
        .where((k) => k.startsWith('lk_bookmark_'))
        .toList();
    for (final key in keys) {
      web.window.localStorage.removeItem(key);
    }
  }

  /// Check if vocabulary is bookmarked
  static bool isBookmarked(int vocabularyId) {
    for (final key in _getAllKeys()) {
      if (key.startsWith('lk_bookmark_')) {
        final encoded = web.window.localStorage[key];
        if (encoded != null) {
          try {
            final b = Map<String, dynamic>.from(jsonDecode(encoded));
            if (b['vocabulary_id'] == vocabularyId) return true;
          } catch (e) {
            // Skip invalid entries
          }
        }
      }
    }
    return false;
  }

  /// Get bookmark by vocabulary ID
  static Map<String, dynamic>? getBookmarkByVocabularyId(int vocabularyId) {
    for (final key in _getAllKeys()) {
      if (key.startsWith('lk_bookmark_')) {
        final encoded = web.window.localStorage[key];
        if (encoded != null) {
          try {
            final b = Map<String, dynamic>.from(jsonDecode(encoded));
            if (b['vocabulary_id'] == vocabularyId) return b;
          } catch (e) {
            // Skip invalid entries
          }
        }
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
    return _getAllKeys()
        .where((k) => k.startsWith('lk_bookmark_'))
        .length;
  }

  // ================================================================
  // SYNC QUEUE (No-op on web - always online)
  // ================================================================

  /// Add item to sync queue (no-op on web - always sync immediately via API)
  static Future<void> addToSyncQueue(Map<String, dynamic> syncItem) async {
    // No-op on web - always sync immediately via API
    AppLogger.d('Sync queue no-op (web always syncs immediately)', tag: 'LocalStorage');
  }

  /// Get sync queue (always empty on web)
  static List<Map<String, dynamic>> getSyncQueue() {
    return []; // Always empty on web
  }

  /// Remove item from sync queue (no-op)
  static Future<void> removeFromSyncQueue(int index) async {
    // No-op
  }

  /// Clear sync queue (no-op)
  static Future<void> clearSyncQueue() async {
    // No-op
  }

  /// Get sync queue size (always 0 on web)
  static int getSyncQueueSize() {
    return 0;
  }

  // ================================================================
  // SETTINGS
  // ================================================================

  /// Save setting
  static Future<void> saveSetting(String key, dynamic value) async {
    try {
      final encoded = jsonEncode(value);
      web.window.localStorage['lk_setting_$key'] = encoded;
    } catch (e) {
      AppLogger.w('Error saving setting $key: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get setting
  static T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      final encoded = web.window.localStorage['lk_setting_$key'];
      if (encoded == null) return defaultValue;

      final decoded = jsonDecode(encoded);
      return decoded as T? ?? defaultValue;
    } catch (e) {
      AppLogger.w('Error reading setting $key: $e', tag: 'LocalStorage', error: e);
      return defaultValue;
    }
  }

  /// Delete setting
  static Future<void> deleteSetting(String key) async {
    web.window.localStorage.removeItem('lk_setting_$key');
  }

  /// Clear all settings
  static Future<void> clearSettings() async {
    final keys = _getAllKeys()
        .where((k) => k.startsWith('lk_setting_'))
        .toList();
    for (final key in keys) {
      web.window.localStorage.removeItem(key);
    }
  }

  // ================================================================
  // USER CACHE (for offline-first auth)
  // ================================================================

  static const String _cachedUserKey = 'cached_user';

  /// Save user to local cache for offline access
  static Future<void> saveCachedUser(Map<String, dynamic> user) async {
    try {
      web.window.localStorage['lk_$_cachedUserKey'] = jsonEncode(user);
    } catch (e) {
      AppLogger.w('Error saving cached user: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get cached user for offline-first auth
  static Map<String, dynamic>? getCachedUser() {
    try {
      final encoded = web.window.localStorage['lk_$_cachedUserKey'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      return null;
    }
  }

  /// Clear cached user on logout
  static Future<void> clearCachedUser() async {
    web.window.localStorage.removeItem('lk_$_cachedUserKey');
  }

  // ================================================================
  // USER DATA
  // ================================================================

  /// Save user ID
  static Future<void> saveUserId(int userId) async {
    await saveSetting('user_id', userId);
  }

  /// Get user ID
  static int? getUserId() {
    return getSetting<int>('user_id');
  }

  /// Clear user ID
  static Future<void> clearUserId() async {
    await deleteSetting('user_id');
  }

  // ================================================================
  // GENERIC BOX ACCESS (for new features like Hangul)
  // ================================================================

  /// Save data to a named box
  static Future<void> saveToBox(String boxName, String key, dynamic value) async {
    try {
      web.window.localStorage['lk_${boxName}_$key'] = jsonEncode(value);
    } catch (e) {
      AppLogger.w('Error saving to box $boxName: $e', tag: 'LocalStorage', error: e);
    }
  }

  /// Get data from a named box
  static T? getFromBox<T>(String boxName, String key) {
    try {
      final encoded = web.window.localStorage['lk_${boxName}_$key'];
      if (encoded == null) return null;
      return jsonDecode(encoded) as T?;
    } catch (e) {
      AppLogger.w('Error reading from box $boxName: $e', tag: 'LocalStorage', error: e);
      return null;
    }
  }

  /// Get all data from a named box
  static List<T> getAllFromBox<T>(String boxName) {
    try {
      final items = <T>[];
      final prefix = 'lk_${boxName}_';
      for (final key in _getAllKeys()) {
        if (key.startsWith(prefix)) {
          final encoded = web.window.localStorage[key];
          if (encoded != null) {
            items.add(jsonDecode(encoded) as T);
          }
        }
      }
      return items;
    } catch (e) {
      AppLogger.w('Error reading all from box $boxName: $e', tag: 'LocalStorage', error: e);
      return [];
    }
  }

  /// Delete data from a named box
  static Future<void> deleteFromBox(String boxName, String key) async {
    web.window.localStorage.removeItem('lk_${boxName}_$key');
  }

  /// Clear a named box
  static Future<void> clearBox(String boxName) async {
    final prefix = 'lk_${boxName}_';
    final keys = _getAllKeys()
        .where((k) => k.startsWith(prefix))
        .toList();
    for (final key in keys) {
      web.window.localStorage.removeItem(key);
    }
  }

  // ================================================================
  // GENERAL
  // ================================================================

  /// Clear all data
  static Future<void> clearAll() async {
    final keys =
        _getAllKeys().where((k) => k.startsWith('lk_')).toList();
    for (final key in keys) {
      web.window.localStorage.removeItem(key);
    }
  }

  /// Close all boxes (no-op for web - localStorage persists)
  static Future<void> close() async {
    // No-op for web (localStorage persists automatically)
  }
}
