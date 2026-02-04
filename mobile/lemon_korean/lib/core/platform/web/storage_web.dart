import 'package:idb_shim/idb_browser.dart';

import '../storage_interface.dart';

/// Web implementation of ILocalStorage using IndexedDB
class LocalStorageImpl implements ILocalStorage {
  late Database _db;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    final idbFactory = getIdbFactory()!;
    _db = await idbFactory.open(
      'lemon_korean',
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
        final db = event.database;

        // Create object stores (tables)
        if (!db.objectStoreNames.contains('lessons')) {
          db.createObjectStore('lessons', keyPath: 'id');
        }
        if (!db.objectStoreNames.contains('vocabulary')) {
          db.createObjectStore('vocabulary', keyPath: 'id');
        }
        if (!db.objectStoreNames.contains('progress')) {
          db.createObjectStore('progress', keyPath: 'lesson_id');
        }
        if (!db.objectStoreNames.contains('bookmarks')) {
          db.createObjectStore('bookmarks', keyPath: 'id');
        }
        if (!db.objectStoreNames.contains('settings')) {
          db.createObjectStore('settings');
        }
      },
    );

    _initialized = true;
  }

  // ================================================================
  // LESSONS
  // ================================================================

  @override
  Future<void> saveLesson(Map<String, dynamic> lesson) async {
    final txn = _db.transaction('lessons', 'readwrite');
    final store = txn.objectStore('lessons');
    await store.put(lesson);
    await txn.completed;
  }

  @override
  Future<Map<String, dynamic>?> getLesson(int lessonId) async {
    final txn = _db.transaction('lessons', 'readonly');
    final store = txn.objectStore('lessons');
    final result = await store.getObject(lessonId);
    return result != null ? Map<String, dynamic>.from(result as Map) : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllLessons() async {
    final txn = _db.transaction('lessons', 'readonly');
    final store = txn.objectStore('lessons');
    final cursor = store.openCursor();

    final lessons = <Map<String, dynamic>>[];
    await for (final cursorWithValue in cursor) {
      lessons.add(Map<String, dynamic>.from(cursorWithValue.value as Map));
      cursorWithValue.next();
    }

    return lessons;
  }

  @override
  Future<bool> hasLesson(int lessonId) async {
    final lesson = await getLesson(lessonId);
    return lesson != null;
  }

  @override
  Future<void> deleteLesson(int lessonId) async {
    final txn = _db.transaction('lessons', 'readwrite');
    final store = txn.objectStore('lessons');
    await store.delete(lessonId);
    await txn.completed;
  }

  @override
  Future<void> clearLessons() async {
    final txn = _db.transaction('lessons', 'readwrite');
    final store = txn.objectStore('lessons');
    await store.clear();
    await txn.completed;
  }

  // ================================================================
  // VOCABULARY
  // ================================================================

  @override
  Future<void> saveVocabulary(Map<String, dynamic> vocabulary) async {
    final txn = _db.transaction('vocabulary', 'readwrite');
    final store = txn.objectStore('vocabulary');
    await store.put(vocabulary);
    await txn.completed;
  }

  @override
  Future<Map<String, dynamic>?> getVocabulary(int vocabId) async {
    final txn = _db.transaction('vocabulary', 'readonly');
    final store = txn.objectStore('vocabulary');
    final result = await store.getObject(vocabId);
    return result != null ? Map<String, dynamic>.from(result as Map) : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllVocabulary() async {
    final txn = _db.transaction('vocabulary', 'readonly');
    final store = txn.objectStore('vocabulary');
    final cursor = store.openCursor();

    final vocabulary = <Map<String, dynamic>>[];
    await for (final cursorWithValue in cursor) {
      vocabulary.add(Map<String, dynamic>.from(cursorWithValue.value as Map));
      cursorWithValue.next();
    }

    return vocabulary;
  }

  @override
  Future<void> clearVocabulary() async {
    final txn = _db.transaction('vocabulary', 'readwrite');
    final store = txn.objectStore('vocabulary');
    await store.clear();
    await txn.completed;
  }

  // ================================================================
  // PROGRESS
  // ================================================================

  @override
  Future<void> saveProgress(Map<String, dynamic> progress) async {
    final txn = _db.transaction('progress', 'readwrite');
    final store = txn.objectStore('progress');
    await store.put(progress);
    await txn.completed;
  }

  @override
  Future<Map<String, dynamic>?> getProgress(int userId, int lessonId) async {
    final txn = _db.transaction('progress', 'readonly');
    final store = txn.objectStore('progress');
    final result = await store.getObject(lessonId);
    return result != null ? Map<String, dynamic>.from(result as Map) : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllProgress() async {
    final txn = _db.transaction('progress', 'readonly');
    final store = txn.objectStore('progress');
    final cursor = store.openCursor();

    final progress = <Map<String, dynamic>>[];
    await for (final cursorWithValue in cursor) {
      progress.add(Map<String, dynamic>.from(cursorWithValue.value as Map));
      cursorWithValue.next();
    }

    return progress;
  }

  @override
  Future<void> deleteProgress(int userId, int lessonId) async {
    final txn = _db.transaction('progress', 'readwrite');
    final store = txn.objectStore('progress');
    await store.delete(lessonId);
    await txn.completed;
  }

  @override
  Future<void> clearProgress() async {
    final txn = _db.transaction('progress', 'readwrite');
    final store = txn.objectStore('progress');
    await store.clear();
    await txn.completed;
  }

  // ================================================================
  // SYNC QUEUE (no-op on web - always sync immediately)
  // ================================================================

  @override
  Future<void> addToSyncQueue(Map<String, dynamic> syncItem) async {
    // No-op on web - sync happens immediately
  }

  @override
  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    return []; // Always empty on web
  }

  @override
  Future<void> removeSyncItem(String syncId) async {
    // No-op on web
  }

  @override
  Future<void> clearSyncQueue() async {
    // No-op on web
  }

  // ================================================================
  // BOOKMARKS
  // ================================================================

  @override
  Future<void> saveBookmark(Map<String, dynamic> bookmark) async {
    final txn = _db.transaction('bookmarks', 'readwrite');
    final store = txn.objectStore('bookmarks');
    await store.put(bookmark);
    await txn.completed;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    final txn = _db.transaction('bookmarks', 'readonly');
    final store = txn.objectStore('bookmarks');
    final cursor = store.openCursor();

    final bookmarks = <Map<String, dynamic>>[];
    await for (final cursorWithValue in cursor) {
      bookmarks.add(Map<String, dynamic>.from(cursorWithValue.value as Map));
      cursorWithValue.next();
    }

    return bookmarks;
  }

  @override
  Future<void> deleteBookmark(String bookmarkId) async {
    final txn = _db.transaction('bookmarks', 'readwrite');
    final store = txn.objectStore('bookmarks');
    await store.delete(int.parse(bookmarkId));
    await txn.completed;
  }

  @override
  Future<void> clearBookmarks() async {
    final txn = _db.transaction('bookmarks', 'readwrite');
    final store = txn.objectStore('bookmarks');
    await store.clear();
    await txn.completed;
  }

  // ================================================================
  // SETTINGS
  // ================================================================

  @override
  Future<void> saveSetting(String key, dynamic value) async {
    final txn = _db.transaction('settings', 'readwrite');
    final store = txn.objectStore('settings');
    await store.put(value, key);
    await txn.completed;
  }

  @override
  Future<dynamic> getSetting(String key) async {
    final txn = _db.transaction('settings', 'readonly');
    final store = txn.objectStore('settings');
    return await store.getObject(key);
  }

  @override
  Future<void> deleteSetting(String key) async {
    final txn = _db.transaction('settings', 'readwrite');
    final store = txn.objectStore('settings');
    await store.delete(key);
    await txn.completed;
  }

  @override
  Future<void> clearSettings() async {
    final txn = _db.transaction('settings', 'readwrite');
    final store = txn.objectStore('settings');
    await store.clear();
    await txn.completed;
  }
}
