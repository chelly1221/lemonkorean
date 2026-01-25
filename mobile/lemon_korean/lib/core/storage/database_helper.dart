import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite Database Helper
/// Manages media file metadata and download queue
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lemon_korean.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Media files table
    await db.execute('''
      CREATE TABLE media_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        remote_key TEXT NOT NULL UNIQUE,
        local_path TEXT NOT NULL,
        file_type TEXT NOT NULL,
        file_size INTEGER NOT NULL,
        lesson_id INTEGER,
        downloaded_at INTEGER NOT NULL,
        last_accessed INTEGER NOT NULL,
        checksum TEXT
      )
    ''');

    // Download queue table
    await db.execute('''
      CREATE TABLE download_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        remote_key TEXT NOT NULL UNIQUE,
        remote_url TEXT NOT NULL,
        file_type TEXT NOT NULL,
        lesson_id INTEGER,
        priority INTEGER DEFAULT 0,
        status TEXT DEFAULT 'pending',
        progress REAL DEFAULT 0.0,
        error_message TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Create indexes
    await db.execute(
      'CREATE INDEX idx_media_remote_key ON media_files(remote_key)',
    );
    await db.execute(
      'CREATE INDEX idx_media_lesson_id ON media_files(lesson_id)',
    );
    await db.execute(
      'CREATE INDEX idx_queue_status ON download_queue(status)',
    );
    await db.execute(
      'CREATE INDEX idx_queue_priority ON download_queue(priority DESC)',
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }

  // ================================================================
  // MEDIA FILES
  // ================================================================

  /// Insert media file metadata
  Future<int> insertMediaFile(Map<String, dynamic> mediaFile) async {
    final db = await database;
    return await db.insert(
      'media_files',
      mediaFile,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get local path for remote key
  Future<String?> getLocalPath(String remoteKey) async {
    final db = await database;
    final results = await db.query(
      'media_files',
      columns: ['local_path'],
      where: 'remote_key = ?',
      whereArgs: [remoteKey],
    );

    if (results.isNotEmpty) {
      // Update last_accessed timestamp
      await updateLastAccessed(remoteKey);
      return results.first['local_path'] as String;
    }
    return null;
  }

  /// Get media file by remote key
  Future<Map<String, dynamic>?> getMediaFile(String remoteKey) async {
    final db = await database;
    final results = await db.query(
      'media_files',
      where: 'remote_key = ?',
      whereArgs: [remoteKey],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  /// Get all media files for a lesson
  Future<List<Map<String, dynamic>>> getMediaFilesByLesson(
    int lessonId,
  ) async {
    final db = await database;
    return await db.query(
      'media_files',
      where: 'lesson_id = ?',
      whereArgs: [lessonId],
    );
  }

  /// Update last accessed timestamp
  Future<void> updateLastAccessed(String remoteKey) async {
    final db = await database;
    await db.update(
      'media_files',
      {'last_accessed': DateTime.now().millisecondsSinceEpoch},
      where: 'remote_key = ?',
      whereArgs: [remoteKey],
    );
  }

  /// Delete media file
  Future<void> deleteMediaFile(String remoteKey) async {
    final db = await database;

    // Get local path first
    final mediaFile = await getMediaFile(remoteKey);
    if (mediaFile != null) {
      final localPath = mediaFile['local_path'] as String;

      // Delete physical file
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
      }

      // Delete from database
      await db.delete(
        'media_files',
        where: 'remote_key = ?',
        whereArgs: [remoteKey],
      );
    }
  }

  /// Delete all media files for a lesson
  Future<void> deleteMediaFilesByLesson(int lessonId) async {
    final mediaFiles = await getMediaFilesByLesson(lessonId);

    for (final mediaFile in mediaFiles) {
      await deleteMediaFile(mediaFile['remote_key'] as String);
    }
  }

  /// Get total storage used (bytes)
  Future<int> getTotalStorageUsed() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(file_size) as total FROM media_files',
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  /// Clean up old files (LRU cache)
  Future<void> cleanupOldFiles(int maxSizeBytes) async {
    final totalSize = await getTotalStorageUsed();

    if (totalSize > maxSizeBytes) {
      final db = await database;

      // Get files ordered by last_accessed (oldest first)
      final files = await db.query(
        'media_files',
        orderBy: 'last_accessed ASC',
      );

      int deletedSize = 0;
      for (final file in files) {
        if (totalSize - deletedSize <= maxSizeBytes) break;

        await deleteMediaFile(file['remote_key'] as String);
        deletedSize += file['file_size'] as int;
      }
    }
  }

  // ================================================================
  // DOWNLOAD QUEUE
  // ================================================================

  /// Add download to queue
  Future<int> addToDownloadQueue(Map<String, dynamic> download) async {
    final db = await database;
    return await db.insert(
      'download_queue',
      download,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get pending downloads
  Future<List<Map<String, dynamic>>> getPendingDownloads() async {
    final db = await database;
    return await db.query(
      'download_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'priority DESC, created_at ASC',
    );
  }

  /// Update download status
  Future<void> updateDownloadStatus(
    int id,
    String status, {
    double? progress,
    String? errorMessage,
  }) async {
    final db = await database;

    final updates = <String, dynamic>{
      'status': status,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };

    if (progress != null) updates['progress'] = progress;
    if (errorMessage != null) updates['error_message'] = errorMessage;

    await db.update(
      'download_queue',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Remove from download queue
  Future<void> removeFromDownloadQueue(int id) async {
    final db = await database;
    await db.delete(
      'download_queue',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Clear completed downloads
  Future<void> clearCompletedDownloads() async {
    final db = await database;
    await db.delete(
      'download_queue',
      where: 'status = ?',
      whereArgs: ['completed'],
    );
  }

  /// Get download queue size
  Future<int> getDownloadQueueSize() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM download_queue WHERE status = ?',
      ['pending'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ================================================================
  // GENERAL
  // ================================================================

  /// Clear all data
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('media_files');
    await db.delete('download_queue');
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
