import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../constants/app_constants.dart';
import '../network/api_client.dart';
import '../storage/database_helper.dart';
import '../storage/local_storage.dart';

/// Download Manager
/// Handles lesson package and media file downloads
class DownloadManager {
  static final DownloadManager instance = DownloadManager._init();

  final _apiClient = ApiClient.instance;
  final _dbHelper = DatabaseHelper.instance;
  final Map<int, CancelToken> _cancelTokens = {};
  final Map<int, DownloadProgress> _progressMap = {};

  // Callbacks
  Function(int lessonId, double progress)? onProgress;
  Function(int lessonId)? onComplete;
  Function(int lessonId, String error)? onError;

  DownloadManager._init();

  // ================================================================
  // LESSON DOWNLOAD
  // ================================================================

  /// Download complete lesson package with media files
  Future<bool> downloadLesson(int lessonId) async {
    try {
      // Create cancel token
      final cancelToken = CancelToken();
      _cancelTokens[lessonId] = cancelToken;

      // Initialize progress
      _progressMap[lessonId] = DownloadProgress(
        lessonId: lessonId,
        totalFiles: 0,
        downloadedFiles: 0,
        totalBytes: 0,
        downloadedBytes: 0,
        status: DownloadStatus.downloading,
      );

      // Step 1: Download lesson package metadata
      _updateProgress(lessonId, 0.1, 'Downloading lesson data...');

      final response = await _apiClient.downloadLessonPackage(lessonId);

      if (response.statusCode != 200) {
        throw Exception('Failed to download lesson package');
      }

      final packageData = response.data;

      // Save lesson metadata to local storage
      await LocalStorage.saveLesson(packageData);

      // Step 2: Extract media URLs
      final mediaUrls = _extractMediaUrls(packageData);
      final totalFiles = mediaUrls.length;

      _progressMap[lessonId] = _progressMap[lessonId]!.copyWith(
        totalFiles: totalFiles,
      );

      _updateProgress(lessonId, 0.2, 'Downloading $totalFiles media files...');

      // Step 3: Download media files
      int downloadedCount = 0;

      for (final mediaEntry in mediaUrls.entries) {
        final remoteKey = mediaEntry.key;
        final remoteUrl = mediaEntry.value;

        try {
          // Check if already downloaded
          final localPath = await _dbHelper.getLocalPath(remoteKey);
          if (localPath != null && await File(localPath).exists()) {
            downloadedCount++;
            continue;
          }

          // Download media file
          final savedPath = await _downloadMediaFile(
            remoteKey: remoteKey,
            remoteUrl: remoteUrl,
            lessonId: lessonId,
            cancelToken: cancelToken,
          );

          if (savedPath != null) {
            downloadedCount++;

            // Update progress
            final progress = 0.2 + (downloadedCount / totalFiles) * 0.8;
            _updateProgress(
              lessonId,
              progress,
              'Downloaded $downloadedCount/$totalFiles files',
            );
          }
        } catch (e) {
          print('[DownloadManager] Error downloading $remoteKey: $e');
          // Continue with other files
        }
      }

      // Step 4: Mark as complete
      _progressMap[lessonId] = _progressMap[lessonId]!.copyWith(
        downloadedFiles: downloadedCount,
        status: DownloadStatus.completed,
      );

      _updateProgress(lessonId, 1.0, 'Download complete');
      onComplete?.call(lessonId);

      // Cleanup
      _cancelTokens.remove(lessonId);

      return true;
    } catch (e) {
      // Handle error
      _progressMap[lessonId] = _progressMap[lessonId]!.copyWith(
        status: DownloadStatus.failed,
        errorMessage: e.toString(),
      );

      onError?.call(lessonId, e.toString());
      _cancelTokens.remove(lessonId);

      return false;
    }
  }

  /// Download single media file
  Future<String?> _downloadMediaFile({
    required String remoteKey,
    required String remoteUrl,
    required int lessonId,
    CancelToken? cancelToken,
  }) async {
    try {
      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final mediaDir = Directory(path.join(directory.path, 'media'));

      // Create directory if not exists
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      // Generate local file path
      final fileName = _sanitizeFileName(remoteKey);
      final localPath = path.join(mediaDir.path, fileName);

      // Download file
      await _apiClient.dio.download(
        remoteUrl,
        localPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Update file progress
            final progress = received / total;
            print(
              '[DownloadManager] Downloading $remoteKey: ${(progress * 100).toStringAsFixed(1)}%',
            );
          }
        },
      );

      // Get file info
      final file = File(localPath);
      final fileSize = await file.length();
      final fileType = _getFileType(remoteKey);

      // Save to database
      await _dbHelper.insertMediaFile({
        'remote_key': remoteKey,
        'local_path': localPath,
        'file_type': fileType,
        'file_size': fileSize,
        'lesson_id': lessonId,
        'downloaded_at': DateTime.now().millisecondsSinceEpoch,
        'last_accessed': DateTime.now().millisecondsSinceEpoch,
      });

      return localPath;
    } catch (e) {
      print('[DownloadManager] Error downloading media file: $e');
      return null;
    }
  }

  /// Extract media URLs from lesson package
  Map<String, String> _extractMediaUrls(Map<String, dynamic> packageData) {
    final Map<String, String> mediaUrls = {};

    // Extract from media_urls field
    if (packageData['media_urls'] != null) {
      final urls = packageData['media_urls'] as Map<String, dynamic>;
      urls.forEach((key, value) {
        mediaUrls[key] = value.toString();
      });
    }

    // Extract from content stages
    if (packageData['content'] != null) {
      final content = packageData['content'] as Map<String, dynamic>;

      // Check each stage for media references
      content.forEach((stageKey, stageData) {
        if (stageData is Map) {
          _extractMediaFromStage(stageData, mediaUrls);
        }
      });
    }

    return mediaUrls;
  }

  /// Recursively extract media from stage data
  void _extractMediaFromStage(Map<dynamic, dynamic> data, Map<String, String> mediaUrls) {
    data.forEach((key, value) {
      // Check for media URL keys (image, audio, video, avatar, thumbnail)
      if (key == 'image_url' ||
          key == 'imageUrl' ||
          key == 'audio_url' ||
          key == 'audioUrl' ||
          key == 'thumbnail_url' ||
          key == 'thumbnailUrl' ||
          key == 'avatar_url' ||
          key == 'avatarUrl') {
        if (value is String && !mediaUrls.containsKey(value)) {
          // Generate full URL if needed
          final fullUrl = value.startsWith('http')
              ? value
              : '${AppConstants.mediaUrl}/$value';
          mediaUrls[value] = fullUrl;
        }
      } else if (value is Map) {
        _extractMediaFromStage(value, mediaUrls);
      } else if (value is List) {
        for (final item in value) {
          if (item is Map) {
            _extractMediaFromStage(item, mediaUrls);
          }
        }
      }
    });
  }

  // ================================================================
  // DOWNLOAD CONTROL
  // ================================================================

  /// Cancel download
  void cancelDownload(int lessonId) {
    final cancelToken = _cancelTokens[lessonId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Download cancelled by user');
    }

    _progressMap[lessonId] = _progressMap[lessonId]!.copyWith(
      status: DownloadStatus.cancelled,
    );

    _cancelTokens.remove(lessonId);
  }

  /// Pause download (same as cancel for now)
  void pauseDownload(int lessonId) {
    cancelDownload(lessonId);
  }

  /// Resume download
  Future<bool> resumeDownload(int lessonId) async {
    return await downloadLesson(lessonId);
  }

  /// Get download progress
  DownloadProgress? getProgress(int lessonId) {
    return _progressMap[lessonId];
  }

  /// Get all download progress
  Map<int, DownloadProgress> getAllProgress() {
    return Map.from(_progressMap);
  }

  /// Check if download is in progress
  bool isDownloading(int lessonId) {
    final progress = _progressMap[lessonId];
    return progress?.status == DownloadStatus.downloading;
  }

  /// Clear completed downloads
  void clearCompleted() {
    _progressMap.removeWhere(
      (key, value) => value.status == DownloadStatus.completed,
    );
  }

  // ================================================================
  // HELPER METHODS
  // ================================================================

  /// Update progress and notify listeners
  void _updateProgress(int lessonId, double progress, String message) {
    final currentProgress = _progressMap[lessonId];
    if (currentProgress != null) {
      _progressMap[lessonId] = currentProgress.copyWith(
        progress: progress,
        message: message,
      );

      onProgress?.call(lessonId, progress);
    }
  }

  /// Sanitize file name
  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll('/', '_')
        .replaceAll('\\', '_')
        .replaceAll(':', '_');
  }

  /// Get file type from extension
  String _getFileType(String fileName) {
    final ext = path.extension(fileName).toLowerCase();

    if (['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(ext)) {
      return 'image';
    } else if (['.mp3', '.wav', '.ogg', '.m4a'].contains(ext)) {
      return 'audio';
    } else if (['.mp4', '.webm', '.mov'].contains(ext)) {
      return 'video';
    }

    return 'unknown';
  }

  // ================================================================
  // BATCH OPERATIONS
  // ================================================================

  /// Download multiple lessons
  Future<void> downloadLessons(List<int> lessonIds) async {
    for (final lessonId in lessonIds) {
      await downloadLesson(lessonId);
    }
  }

  /// Get total download size for lessons
  Future<int> estimateDownloadSize(List<int> lessonIds) async {
    int totalSize = 0;

    for (final lessonId in lessonIds) {
      try {
        final response = await _apiClient.downloadLessonPackage(lessonId);
        final packageData = response.data;

        // Estimate size from package metadata
        if (packageData['estimated_size'] != null) {
          totalSize += packageData['estimated_size'] as int;
        }
      } catch (e) {
        // Skip if error
        print('[DownloadManager] Error estimating size: $e');
      }
    }

    return totalSize;
  }

  // ================================================================
  // CLEANUP
  // ================================================================

  /// Delete downloaded lesson
  Future<void> deleteLesson(int lessonId) async {
    // Delete media files
    await _dbHelper.deleteMediaFilesByLesson(lessonId);

    // Delete lesson data
    await LocalStorage.deleteLesson(lessonId);

    // Remove progress
    _progressMap.remove(lessonId);
  }

  /// Clear all downloads
  Future<void> clearAllDownloads() async {
    // Cancel all active downloads
    _cancelTokens.forEach((lessonId, cancelToken) {
      if (!cancelToken.isCancelled) {
        cancelToken.cancel('Clearing all downloads');
      }
    });

    _cancelTokens.clear();
    _progressMap.clear();

    // Clear database
    await _dbHelper.clearAll();
    await LocalStorage.clearAll();
  }
}

// ================================================================
// MODELS
// ================================================================

/// Download progress model
class DownloadProgress {
  final int lessonId;
  final int totalFiles;
  final int downloadedFiles;
  final int totalBytes;
  final int downloadedBytes;
  final double progress;
  final DownloadStatus status;
  final String? message;
  final String? errorMessage;

  DownloadProgress({
    required this.lessonId,
    required this.totalFiles,
    required this.downloadedFiles,
    required this.totalBytes,
    required this.downloadedBytes,
    required this.status, this.progress = 0.0,
    this.message,
    this.errorMessage,
  });

  DownloadProgress copyWith({
    int? totalFiles,
    int? downloadedFiles,
    int? totalBytes,
    int? downloadedBytes,
    double? progress,
    DownloadStatus? status,
    String? message,
    String? errorMessage,
  }) {
    return DownloadProgress(
      lessonId: lessonId,
      totalFiles: totalFiles ?? this.totalFiles,
      downloadedFiles: downloadedFiles ?? this.downloadedFiles,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get percentComplete => progress * 100;

  bool get isComplete => status == DownloadStatus.completed;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isCancelled => status == DownloadStatus.cancelled;
  bool get isDownloading => status == DownloadStatus.downloading;
}

/// Download status enum
enum DownloadStatus {
  pending,
  downloading,
  completed,
  failed,
  cancelled,
}
