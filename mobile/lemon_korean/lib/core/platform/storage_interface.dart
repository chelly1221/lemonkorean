/// Platform-agnostic storage interface
/// Implemented by IO (Hive) and Web (IndexedDB) storage
abstract class ILocalStorage {
  /// Initialize the storage
  Future<void> init();

  // ================================================================
  // LESSONS
  // ================================================================

  /// Save a lesson to local storage
  Future<void> saveLesson(Map<String, dynamic> lesson);

  /// Get a lesson by ID
  Future<Map<String, dynamic>?> getLesson(int lessonId);

  /// Get all lessons
  Future<List<Map<String, dynamic>>> getAllLessons();

  /// Check if lesson exists
  Future<bool> hasLesson(int lessonId);

  /// Delete a lesson
  Future<void> deleteLesson(int lessonId);

  /// Clear all lessons
  Future<void> clearLessons();

  // ================================================================
  // VOCABULARY
  // ================================================================

  /// Save vocabulary item
  Future<void> saveVocabulary(Map<String, dynamic> vocabulary);

  /// Get vocabulary by ID
  Future<Map<String, dynamic>?> getVocabulary(int vocabId);

  /// Get all vocabulary
  Future<List<Map<String, dynamic>>> getAllVocabulary();

  /// Clear all vocabulary
  Future<void> clearVocabulary();

  // ================================================================
  // PROGRESS
  // ================================================================

  /// Save user progress
  Future<void> saveProgress(Map<String, dynamic> progress);

  /// Get progress for a specific lesson
  Future<Map<String, dynamic>?> getProgress(int userId, int lessonId);

  /// Get all progress records
  Future<List<Map<String, dynamic>>> getAllProgress();

  /// Delete progress for a specific lesson
  Future<void> deleteProgress(int userId, int lessonId);

  /// Clear all progress
  Future<void> clearProgress();

  // ================================================================
  // SYNC QUEUE
  // ================================================================

  /// Add an item to sync queue (mobile only, no-op on web)
  Future<void> addToSyncQueue(Map<String, dynamic> syncItem);

  /// Get all pending sync items
  Future<List<Map<String, dynamic>>> getSyncQueue();

  /// Remove a sync item
  Future<void> removeSyncItem(String syncId);

  /// Clear sync queue
  Future<void> clearSyncQueue();

  // ================================================================
  // BOOKMARKS
  // ================================================================

  /// Save a bookmark
  Future<void> saveBookmark(Map<String, dynamic> bookmark);

  /// Get all bookmarks
  Future<List<Map<String, dynamic>>> getAllBookmarks();

  /// Delete a bookmark
  Future<void> deleteBookmark(String bookmarkId);

  /// Clear all bookmarks
  Future<void> clearBookmarks();

  // ================================================================
  // SETTINGS
  // ================================================================

  /// Save a setting
  Future<void> saveSetting(String key, dynamic value);

  /// Get a setting
  Future<dynamic> getSetting(String key);

  /// Delete a setting
  Future<void> deleteSetting(String key);

  /// Clear all settings
  Future<void> clearSettings();
}
