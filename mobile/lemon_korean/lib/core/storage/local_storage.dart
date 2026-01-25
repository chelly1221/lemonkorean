import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Local Storage using Hive
/// Handles offline-first data storage
class LocalStorage {
  static late Box _lessonsBox;
  static late Box _vocabularyBox;
  static late Box _progressBox;
  static late Box _syncQueueBox;
  static late Box _settingsBox;

  /// Initialize all Hive boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Open boxes
    _lessonsBox = await Hive.openBox(AppConstants.lessonsBox);
    _vocabularyBox = await Hive.openBox(AppConstants.vocabularyBox);
    _progressBox = await Hive.openBox(AppConstants.progressBox);
    _syncQueueBox = await Hive.openBox(AppConstants.syncQueueBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  // ================================================================
  // LESSONS
  // ================================================================

  /// Save a lesson to local storage
  static Future<void> saveLesson(Map<String, dynamic> lesson) async {
    final lessonId = lesson['id'];
    await _lessonsBox.put('lesson_$lessonId', lesson);
  }

  /// Get a lesson by ID
  static Map<String, dynamic>? getLesson(int lessonId) {
    final data = _lessonsBox.get('lesson_$lessonId');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all lessons
  static List<Map<String, dynamic>> getAllLessons() {
    return _lessonsBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Check if lesson exists
  static bool hasLesson(int lessonId) {
    return _lessonsBox.containsKey('lesson_$lessonId');
  }

  /// Delete a lesson
  static Future<void> deleteLesson(int lessonId) async {
    await _lessonsBox.delete('lesson_$lessonId');
  }

  /// Clear all lessons
  static Future<void> clearLessons() async {
    await _lessonsBox.clear();
  }

  // ================================================================
  // VOCABULARY
  // ================================================================

  /// Save vocabulary item
  static Future<void> saveVocabulary(Map<String, dynamic> vocabulary) async {
    final vocabId = vocabulary['id'];
    await _vocabularyBox.put('vocab_$vocabId', vocabulary);
  }

  /// Get vocabulary by ID
  static Map<String, dynamic>? getVocabulary(int vocabId) {
    final data = _vocabularyBox.get('vocab_$vocabId');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Get all vocabulary
  static List<Map<String, dynamic>> getAllVocabulary() {
    return _vocabularyBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  /// Save user progress
  static Future<void> saveProgress(Map<String, dynamic> progress) async {
    final lessonId = progress['lesson_id'];
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
  // GENERAL
  // ================================================================

  /// Get total storage size (in bytes)
  static int getTotalStorageSize() {
    int total = 0;

    total += _lessonsBox.length;
    total += _vocabularyBox.length;
    total += _progressBox.length;
    total += _syncQueueBox.length;
    total += _settingsBox.length;

    return total;
  }

  /// Clear all data
  static Future<void> clearAll() async {
    await Future.wait([
      clearLessons(),
      _vocabularyBox.clear(),
      _progressBox.clear(),
      clearSyncQueue(),
      clearSettings(),
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
    ]);
  }
}
