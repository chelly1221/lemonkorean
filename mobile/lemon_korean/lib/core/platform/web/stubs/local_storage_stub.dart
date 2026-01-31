/// Web stub for LocalStorage using browser localStorage
/// This file is imported when building for web to avoid importing Hive
/// Provides static methods compatible with mobile API using browser localStorage with JSON encoding
import 'dart:html' as html;
import 'dart:convert';

class LocalStorage {
  static bool _initialized = false;

  /// Initialize (no-op for web, but keeps API compatible)
  static Future<void> init() async {
    _initialized = true;
    // Browser localStorage is always available, no initialization needed
  }

  // ================================================================
  // LESSONS
  // ================================================================

  /// Save a lesson to local storage
  static Future<void> saveLesson(Map<String, dynamic> lesson) async {
    try {
      final lessonId = lesson['id'] ?? lesson['lesson_id'];
      if (lessonId == null) return;

      // Ensure 'id' field exists for consistency
      lesson['id'] = lessonId;

      final encoded = jsonEncode(lesson);
      html.window.localStorage['lk_lesson_$lessonId'] = encoded;
    } catch (e) {
      print('[LocalStorage.web] Error saving lesson: $e');
    }
  }

  /// Get a lesson by ID
  static Map<String, dynamic>? getLesson(int lessonId) {
    try {
      final encoded = html.window.localStorage['lk_lesson_$lessonId'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      print('[LocalStorage.web] Error reading lesson $lessonId: $e');
      return null;
    }
  }

  /// Get all lessons
  static List<Map<String, dynamic>> getAllLessons() {
    try {
      final lessons = <Map<String, dynamic>>[];
      for (final key in html.window.localStorage.keys) {
        if (key.startsWith('lk_lesson_')) {
          final encoded = html.window.localStorage[key];
          if (encoded != null) {
            final lesson = Map<String, dynamic>.from(jsonDecode(encoded));
            lessons.add(lesson);
          }
        }
      }
      return lessons;
    } catch (e) {
      print('[LocalStorage.web] Error reading all lessons: $e');
      return [];
    }
  }

  /// Check if lesson exists
  static bool hasLesson(int lessonId) {
    return html.window.localStorage.containsKey('lk_lesson_$lessonId');
  }

  /// Delete a lesson
  static Future<void> deleteLesson(int lessonId) async {
    html.window.localStorage.remove('lk_lesson_$lessonId');
  }

  /// Clear all lessons
  static Future<void> clearLessons() async {
    final keys = html.window.localStorage.keys
        .where((k) => k.startsWith('lk_lesson_'))
        .toList();
    for (final key in keys) {
      html.window.localStorage.remove(key);
    }
  }

  // ================================================================
  // VOCABULARY
  // ================================================================

  /// Save vocabulary item
  static Future<void> saveVocabulary(Map<String, dynamic> vocabulary) async {
    try {
      final vocabId = vocabulary['id'];
      if (vocabId == null) return;
      html.window.localStorage['lk_vocab_$vocabId'] = jsonEncode(vocabulary);
    } catch (e) {
      print('[LocalStorage.web] Error saving vocabulary: $e');
    }
  }

  /// Get vocabulary by ID
  static Map<String, dynamic>? getVocabulary(int vocabId) {
    try {
      final encoded = html.window.localStorage['lk_vocab_$vocabId'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      return null;
    }
  }

  /// Get all vocabulary
  static List<Map<String, dynamic>> getAllVocabulary() {
    try {
      final vocabulary = <Map<String, dynamic>>[];
      for (final key in html.window.localStorage.keys) {
        if (key.startsWith('lk_vocab_') && !key.contains('_cache_')) {
          final encoded = html.window.localStorage[key];
          if (encoded != null) {
            vocabulary.add(Map<String, dynamic>.from(jsonDecode(encoded)));
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
    final keys = html.window.localStorage.keys
        .where((k) => k.startsWith('lk_vocab_') && !k.contains('_cache_'))
        .toList();
    for (final key in keys) {
      html.window.localStorage.remove(key);
    }
  }

  /// Get vocabulary by level (cached)
  static Future<List<Map<String, dynamic>>?> getVocabularyByLevel(
      int level) async {
    try {
      final encoded = html.window.localStorage['lk_vocab_cache_$level'];
      if (encoded == null) return null;
      final decoded = jsonDecode(encoded) as List;
      return decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      print('[LocalStorage.web] Error getting vocabulary cache for level $level: $e');
      return null;
    }
  }

  /// Save vocabulary by level to cache
  static Future<void> saveVocabularyByLevel(
      int level, List<Map<String, dynamic>> words) async {
    try {
      html.window.localStorage['lk_vocab_cache_$level'] = jsonEncode(words);
      html.window.localStorage['lk_vocab_cache_${level}_timestamp'] =
          DateTime.now().toIso8601String();
    } catch (e) {
      print('[LocalStorage.web] Error saving vocabulary cache for level $level: $e');
    }
  }

  /// Get vocabulary cache age
  static Future<Duration?> getVocabularyCacheAge(int level) async {
    try {
      final timestampStr =
          html.window.localStorage['lk_vocab_cache_${level}_timestamp'];
      if (timestampStr == null) return null;
      final timestamp = DateTime.parse(timestampStr);
      return DateTime.now().difference(timestamp);
    } catch (e) {
      print('[LocalStorage.web] Error getting cache age for level $level: $e');
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

      html.window.localStorage['lk_progress_$lessonId'] =
          jsonEncode(progress);
    } catch (e) {
      print('[LocalStorage.web] Error saving progress: $e');
    }
  }

  /// Get progress by lesson ID
  static Map<String, dynamic>? getProgress(int lessonId) {
    try {
      final encoded = html.window.localStorage['lk_progress_$lessonId'];
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
      for (final key in html.window.localStorage.keys) {
        if (key.startsWith('lk_progress_')) {
          final encoded = html.window.localStorage[key];
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
      html.window.localStorage['lk_review_$reviewId'] = jsonEncode(review);
    } catch (e) {
      print('[LocalStorage.web] Error saving review: $e');
    }
  }

  /// Get vocabulary review
  static Future<Map<String, dynamic>?> getVocabularyReview(
    int userId,
    int vocabularyId,
  ) async {
    try {
      final reviewId = '${userId}_${vocabularyId}';
      final encoded = html.window.localStorage['lk_review_$reviewId'];
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
      for (final key in html.window.localStorage.keys) {
        if (key.startsWith('lk_review_')) {
          final encoded = html.window.localStorage[key];
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
    final keys = html.window.localStorage.keys
        .where((k) => k.startsWith('lk_review_'))
        .toList();
    for (final key in keys) {
      html.window.localStorage.remove(key);
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
      html.window.localStorage['lk_bookmark_$bookmarkId'] =
          jsonEncode(bookmark);
    } catch (e) {
      print('[LocalStorage.web] Error saving bookmark: $e');
    }
  }

  /// Get bookmark by ID
  static Map<String, dynamic>? getBookmark(int bookmarkId) {
    try {
      final encoded = html.window.localStorage['lk_bookmark_$bookmarkId'];
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
      for (final key in html.window.localStorage.keys) {
        if (key.startsWith('lk_bookmark_')) {
          final encoded = html.window.localStorage[key];
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
    html.window.localStorage.remove('lk_bookmark_$bookmarkId');
  }

  /// Clear all bookmarks
  static Future<void> clearBookmarks() async {
    final keys = html.window.localStorage.keys
        .where((k) => k.startsWith('lk_bookmark_'))
        .toList();
    for (final key in keys) {
      html.window.localStorage.remove(key);
    }
  }

  /// Check if vocabulary is bookmarked
  static bool isBookmarked(int vocabularyId) {
    for (final key in html.window.localStorage.keys) {
      if (key.startsWith('lk_bookmark_')) {
        final encoded = html.window.localStorage[key];
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
    for (final key in html.window.localStorage.keys) {
      if (key.startsWith('lk_bookmark_')) {
        final encoded = html.window.localStorage[key];
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
    return html.window.localStorage.keys
        .where((k) => k.startsWith('lk_bookmark_'))
        .length;
  }

  // ================================================================
  // SYNC QUEUE (No-op on web - always online)
  // ================================================================

  /// Add item to sync queue (no-op on web - always sync immediately via API)
  static Future<void> addToSyncQueue(Map<String, dynamic> syncItem) async {
    // No-op on web - always sync immediately via API
    print('[LocalStorage.web] Sync queue no-op (web always syncs immediately)');
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
      html.window.localStorage['lk_setting_$key'] = encoded;
    } catch (e) {
      print('[LocalStorage.web] Error saving setting $key: $e');
    }
  }

  /// Get setting
  static T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      final encoded = html.window.localStorage['lk_setting_$key'];
      if (encoded == null) return defaultValue;

      final decoded = jsonDecode(encoded);
      return decoded as T? ?? defaultValue;
    } catch (e) {
      print('[LocalStorage.web] Error reading setting $key: $e');
      return defaultValue;
    }
  }

  /// Delete setting
  static Future<void> deleteSetting(String key) async {
    html.window.localStorage.remove('lk_setting_$key');
  }

  /// Clear all settings
  static Future<void> clearSettings() async {
    final keys = html.window.localStorage.keys
        .where((k) => k.startsWith('lk_setting_'))
        .toList();
    for (final key in keys) {
      html.window.localStorage.remove(key);
    }
  }

  // ================================================================
  // USER CACHE (for offline-first auth)
  // ================================================================

  static const String _cachedUserKey = 'cached_user';

  /// Save user to local cache for offline access
  static Future<void> saveCachedUser(Map<String, dynamic> user) async {
    try {
      html.window.localStorage['lk_$_cachedUserKey'] = jsonEncode(user);
    } catch (e) {
      print('[LocalStorage.web] Error saving cached user: $e');
    }
  }

  /// Get cached user for offline-first auth
  static Map<String, dynamic>? getCachedUser() {
    try {
      final encoded = html.window.localStorage['lk_$_cachedUserKey'];
      if (encoded == null) return null;
      return Map<String, dynamic>.from(jsonDecode(encoded));
    } catch (e) {
      return null;
    }
  }

  /// Clear cached user on logout
  static Future<void> clearCachedUser() async {
    html.window.localStorage.remove('lk_$_cachedUserKey');
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
  // GENERAL
  // ================================================================

  /// Clear all data
  static Future<void> clearAll() async {
    final keys =
        html.window.localStorage.keys.where((k) => k.startsWith('lk_')).toList();
    for (final key in keys) {
      html.window.localStorage.remove(key);
    }
  }

  /// Close all boxes (no-op for web - localStorage persists)
  static Future<void> close() async {
    // No-op for web (localStorage persists automatically)
  }
}
