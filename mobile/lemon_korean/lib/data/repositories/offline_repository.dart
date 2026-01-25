import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../core/storage/local_storage.dart';
import '../../core/storage/database_helper.dart';
import '../../core/utils/download_manager.dart';
import '../../core/utils/sync_manager.dart';
import '../models/lesson_model.dart';
import '../models/progress_model.dart';
import '../models/vocabulary_model.dart';

/// Offline Repository
/// Unified interface for offline data management
class OfflineRepository {
  final _downloadManager = DownloadManager();
  final _syncManager = SyncManager();
  final _dbHelper = DatabaseHelper();

  // ================================================================
  // INITIALIZATION
  // ================================================================

  /// Initialize offline functionality
  Future<void> init() async {
    await LocalStorage.init();
    await _dbHelper.init();
    await _syncManager.init();
  }

  // ================================================================
  // DOWNLOAD MANAGEMENT
  // ================================================================

  /// Download lesson with all media files
  Future<bool> downloadLesson(
    int lessonId, {
    Function(int, DownloadProgress)? onProgress,
    Function(int)? onComplete,
  }) async {
    return _downloadManager.downloadLesson(
      lessonId,
      onProgress: onProgress,
      onComplete: onComplete,
    );
  }

  /// Cancel lesson download
  void cancelDownload(int lessonId) {
    _downloadManager.cancelDownload(lessonId);
  }

  /// Get download progress for lesson
  DownloadProgress? getDownloadProgress(int lessonId) {
    return _downloadManager.getProgress(lessonId);
  }

  /// Check if lesson is currently downloading
  bool isDownloading(int lessonId) {
    return _downloadManager.isDownloading(lessonId);
  }

  /// Get all active downloads
  Map<int, DownloadProgress> getActiveDownloads() {
    return _downloadManager.getAllProgress();
  }

  // ================================================================
  // OFFLINE AVAILABILITY
  // ================================================================

  /// Check if lesson is available offline
  Future<bool> isLessonAvailableOffline(int lessonId) async {
    final lesson = await LocalStorage.getLesson(lessonId);
    if (lesson == null || !lesson.isDownloaded) {
      return false;
    }

    // Check if media files are downloaded
    if (lesson.mediaUrls != null && lesson.mediaUrls!.isNotEmpty) {
      for (final remoteKey in lesson.mediaUrls!.keys) {
        final localPath = await _dbHelper.getLocalPath(remoteKey);
        if (localPath == null || !await File(localPath).exists()) {
          return false;
        }
      }
    }

    return true;
  }

  /// Get all lessons available offline
  Future<List<LessonModel>> getOfflineLessons() async {
    final allLessons = await LocalStorage.getAllLessons();
    final offlineLessons = <LessonModel>[];

    for (final lesson in allLessons) {
      if (await isLessonAvailableOffline(lesson.id)) {
        offlineLessons.add(lesson);
      }
    }

    return offlineLessons;
  }

  /// Get offline vocabulary
  Future<List<VocabularyModel>> getOfflineVocabulary() async {
    return LocalStorage.getAllVocabulary();
  }

  /// Get offline progress
  Future<List<ProgressModel>> getOfflineProgress(int userId) async {
    final allProgress = await LocalStorage.getAllProgress();
    return allProgress.where((p) => p.userId == userId).toList();
  }

  // ================================================================
  // SYNCHRONIZATION
  // ================================================================

  /// Sync all offline data
  Future<SyncResult> syncAll() async {
    return _syncManager.sync();
  }

  /// Check if network is available
  bool isOnline() {
    return _syncManager.isOnline;
  }

  /// Get sync queue size
  int getSyncQueueSize() {
    return LocalStorage.getSyncQueue().length;
  }

  /// Get pending sync items
  List<Map<String, dynamic>> getPendingSyncItems() {
    return LocalStorage.getSyncQueue();
  }

  /// Clear sync queue (use with caution)
  Future<void> clearSyncQueue() async {
    await LocalStorage.clearSyncQueue();
  }

  // ================================================================
  // STORAGE MANAGEMENT
  // ================================================================

  /// Get storage statistics
  Future<OfflineStorageStats> getStorageStats() async {
    final lessons = await LocalStorage.getAllLessons();
    final vocabulary = await LocalStorage.getAllVocabulary();
    final progress = await LocalStorage.getAllProgress();
    final reviews = await LocalStorage.getAllReviews();

    final downloadedLessons = lessons.where((l) => l.isDownloaded).length;

    // Calculate media storage
    final mediaStats = await _dbHelper.getStorageStats();

    // Calculate cache directory size
    final cacheDir = await getTemporaryDirectory();
    final cacheSize = await _getDirectorySize(cacheDir);

    // Calculate app documents size
    final appDir = await getApplicationDocumentsDirectory();
    final appSize = await _getDirectorySize(appDir);

    return OfflineStorageStats(
      totalLessons: lessons.length,
      downloadedLessons: downloadedLessons,
      totalVocabulary: vocabulary.length,
      totalProgress: progress.length,
      totalReviews: reviews.length,
      mediaFileCount: mediaStats['count'] as int,
      mediaStorageBytes: mediaStats['size'] as int,
      cacheStorageBytes: cacheSize,
      totalStorageBytes: appSize + cacheSize,
      syncQueueSize: getSyncQueueSize(),
    );
  }

  /// Delete lesson and associated media
  Future<void> deleteLesson(int lessonId) async {
    final lesson = await LocalStorage.getLesson(lessonId);
    if (lesson == null) return;

    // Delete media files
    if (lesson.mediaUrls != null) {
      for (final remoteKey in lesson.mediaUrls!.keys) {
        await _dbHelper.deleteMediaFile(remoteKey);
      }
    }

    // Update lesson (mark as not downloaded)
    final updatedLesson = lesson.copyWith(
      isDownloaded: false,
      downloadedAt: null,
      content: null,
      mediaUrls: null,
    );
    await LocalStorage.saveLesson(updatedLesson.toJson());
  }

  /// Delete all downloaded content
  Future<void> deleteAllDownloads() async {
    final lessons = await LocalStorage.getAllLessons();

    for (final lesson in lessons) {
      if (lesson.isDownloaded) {
        await deleteLesson(lesson.id);
      }
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    // Clear image cache
    final cacheDir = await getTemporaryDirectory();
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
      await cacheDir.create();
    }

    // Clear network cache
    await LocalStorage.clearLessons();
    await LocalStorage.clearVocabulary();

    // Note: Don't clear progress or reviews
  }

  /// Clear everything (use with extreme caution)
  Future<void> clearAllData() async {
    await LocalStorage.clearAll();
    await _dbHelper.clearAll();

    final cacheDir = await getTemporaryDirectory();
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
      await cacheDir.create();
    }
  }

  /// Cleanup old files based on LRU
  Future<void> cleanupOldFiles({int maxSizeMB = 500}) async {
    final maxSizeBytes = maxSizeMB * 1024 * 1024;
    await _dbHelper.cleanupOldFiles(maxSizeBytes);
  }

  // ================================================================
  // DATA EXPORT/IMPORT
  // ================================================================

  /// Export user data for backup
  Future<Map<String, dynamic>> exportUserData(int userId) async {
    final progress = await getOfflineProgress(userId);
    final reviews = await LocalStorage.getAllReviews();
    final userReviews = reviews.where((r) => r.userId == userId).toList();

    return {
      'user_id': userId,
      'exported_at': DateTime.now().toIso8601String(),
      'progress': progress.map((p) => p.toJson()).toList(),
      'reviews': userReviews.map((r) => r.toJson()).toList(),
    };
  }

  /// Import user data from backup
  Future<void> importUserData(Map<String, dynamic> data) async {
    final progress = (data['progress'] as List)
        .map((json) => ProgressModel.fromJson(json))
        .toList();

    final reviews = (data['reviews'] as List)
        .map((json) => ReviewModel.fromJson(json))
        .toList();

    // Save progress
    for (final p in progress) {
      await LocalStorage.saveProgress(p.toJson());
    }

    // Save reviews
    for (final r in reviews) {
      await LocalStorage.saveReview(r.toJson());
    }
  }

  // ================================================================
  // DIAGNOSTICS
  // ================================================================

  /// Get diagnostic information
  Future<Map<String, dynamic>> getDiagnostics() async {
    final stats = await getStorageStats();
    final syncQueue = getPendingSyncItems();
    final mediaStats = await _dbHelper.getStorageStats();

    return {
      'storage': {
        'total_mb': (stats.totalStorageBytes / 1024 / 1024).toStringAsFixed(2),
        'media_mb': (stats.mediaStorageBytes / 1024 / 1024).toStringAsFixed(2),
        'cache_mb': (stats.cacheStorageBytes / 1024 / 1024).toStringAsFixed(2),
      },
      'content': {
        'lessons': stats.totalLessons,
        'downloaded_lessons': stats.downloadedLessons,
        'vocabulary': stats.totalVocabulary,
        'progress_records': stats.totalProgress,
        'review_records': stats.totalReviews,
      },
      'sync': {
        'is_online': isOnline(),
        'queue_size': stats.syncQueueSize,
        'pending_items': syncQueue.map((item) => item['type']).toList(),
      },
      'media': {
        'file_count': mediaStats['count'],
        'oldest_file': mediaStats['oldest'],
        'newest_file': mediaStats['newest'],
      },
      'downloads': {
        'active_downloads': getActiveDownloads().length,
        'downloading_lessons':
            getActiveDownloads().keys.toList(),
      },
    };
  }

  /// Verify data integrity
  Future<List<String>> verifyIntegrity() async {
    final issues = <String>[];

    // Check for downloaded lessons with missing media
    final lessons = await LocalStorage.getAllLessons();
    for (final lesson in lessons) {
      if (lesson.isDownloaded && lesson.mediaUrls != null) {
        for (final entry in lesson.mediaUrls!.entries) {
          final localPath = await _dbHelper.getLocalPath(entry.key);
          if (localPath == null || !await File(localPath).exists()) {
            issues.add(
              'Lesson ${lesson.id}: Missing media file ${entry.key}',
            );
          }
        }
      }
    }

    // Check for orphaned media files
    final allMediaFiles = await _dbHelper.getAllMediaFiles();
    for (final media in allMediaFiles) {
      if (!await File(media['local_path'] as String).exists()) {
        issues.add(
          'Orphaned media record: ${media['remote_key']}',
        );
      }
    }

    // Check for unsynced progress older than 30 days
    final allProgress = await LocalStorage.getAllProgress();
    final oldUnsynced = allProgress.where((p) =>
        !p.isSynced &&
        DateTime.now().difference(p.updatedAt).inDays > 30);

    if (oldUnsynced.isNotEmpty) {
      issues.add(
        'Found ${oldUnsynced.length} progress records unsynced for >30 days',
      );
    }

    return issues;
  }

  // ================================================================
  // PRIVATE HELPERS
  // ================================================================

  Future<int> _getDirectorySize(Directory dir) async {
    int totalSize = 0;

    if (!await dir.exists()) return 0;

    try {
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    } catch (e) {
      print('[OfflineRepository] Error calculating directory size: $e');
    }

    return totalSize;
  }
}

// ================================================================
// MODELS
// ================================================================

/// Offline storage statistics
class OfflineStorageStats {
  final int totalLessons;
  final int downloadedLessons;
  final int totalVocabulary;
  final int totalProgress;
  final int totalReviews;
  final int mediaFileCount;
  final int mediaStorageBytes;
  final int cacheStorageBytes;
  final int totalStorageBytes;
  final int syncQueueSize;

  OfflineStorageStats({
    required this.totalLessons,
    required this.downloadedLessons,
    required this.totalVocabulary,
    required this.totalProgress,
    required this.totalReviews,
    required this.mediaFileCount,
    required this.mediaStorageBytes,
    required this.cacheStorageBytes,
    required this.totalStorageBytes,
    required this.syncQueueSize,
  });

  double get totalStorageMB => totalStorageBytes / 1024 / 1024;
  double get mediaStorageMB => mediaStorageBytes / 1024 / 1024;
  double get cacheStorageMB => cacheStorageBytes / 1024 / 1024;

  @override
  String toString() {
    return 'OfflineStorageStats('
        'lessons: $downloadedLessons/$totalLessons, '
        'storage: ${totalStorageMB.toStringAsFixed(2)}MB, '
        'syncQueue: $syncQueueSize)';
  }
}

/// Sync result from progress repository
class SyncResult {
  final bool success;
  final int syncedCount;
  final int failedCount;
  final List<String> errors;

  SyncResult({
    required this.success,
    required this.syncedCount,
    required this.failedCount,
    required this.errors,
  });

  @override
  String toString() {
    return 'SyncResult(success: $success, synced: $syncedCount, failed: $failedCount)';
  }
}
