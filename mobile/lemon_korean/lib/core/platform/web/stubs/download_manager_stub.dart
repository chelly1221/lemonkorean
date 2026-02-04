/// Download Manager - Web Stub
/// Web platform doesn't support offline downloads - always operates in online mode
library;

/// Download Manager
/// Stub implementation for web - no actual downloads, always online mode
class DownloadManager {
  static final DownloadManager instance = DownloadManager._init();

  final Map<int, DownloadProgress> _progressMap = {};

  // Callbacks
  Function(int lessonId, double progress)? onProgress;
  Function(int lessonId)? onComplete;
  Function(int lessonId, String error)? onError;

  DownloadManager._init();

  /// Download lesson (stub - immediately returns success)
  Future<bool> downloadLesson(int lessonId, {String? language}) async {
    // Create progress entry
    _progressMap[lessonId] = DownloadProgress(
      lessonId: lessonId,
      totalFiles: 0,
      downloadedFiles: 0,
      totalBytes: 0,
      downloadedBytes: 0,
      status: DownloadStatus.downloading,
    );

    // Simulate quick progress
    onProgress?.call(lessonId, 0.5);

    await Future.delayed(const Duration(milliseconds: 100));

    // Mark as complete
    _progressMap[lessonId] = _progressMap[lessonId]!.copyWith(
      status: DownloadStatus.completed,
      progress: 1.0,
    );

    onProgress?.call(lessonId, 1.0);
    onComplete?.call(lessonId);

    return true;
  }

  /// Cancel download (no-op)
  void cancelDownload(int lessonId) {
    if (_progressMap.containsKey(lessonId)) {
      _progressMap[lessonId] = _progressMap[lessonId]!.copyWith(
        status: DownloadStatus.cancelled,
      );
    }
  }

  /// Pause download (no-op)
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

  /// Download multiple lessons (stub)
  Future<void> downloadLessons(List<int> lessonIds, {String? language}) async {
    for (final lessonId in lessonIds) {
      await downloadLesson(lessonId, language: language);
    }
  }

  /// Estimate download size (returns 0 for web)
  Future<int> estimateDownloadSize(List<int> lessonIds) async {
    return 0;
  }

  /// Delete lesson (no-op on web)
  Future<void> deleteLesson(int lessonId) async {
    _progressMap.remove(lessonId);
  }

  /// Clear all downloads (no-op on web)
  Future<void> clearAllDownloads() async {
    _progressMap.clear();
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
    required this.status,
    this.progress = 0.0,
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
