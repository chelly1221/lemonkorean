import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/download_manager.dart';
import '../../core/utils/storage_utils.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/repositories/offline_repository.dart';

/// Download Provider
/// Manages lesson downloads and storage
class DownloadProvider extends ChangeNotifier {
  final DownloadManager _downloadManager = DownloadManager.instance;
  final ContentRepository _contentRepository = ContentRepository();
  final OfflineRepository _offlineRepository = OfflineRepository();

  // State
  Map<int, DownloadProgress> _activeDownloads = {};
  List<LessonModel> _downloadedLessons = [];
  List<LessonModel> _availableLessons = [];
  OfflineStorageStats? _storageStats;
  bool _isLoading = false;
  String? _error;

  // Device storage (actual)
  int _availableStorageBytes = 0;
  int _totalStorageBytes = 0;

  // Getters
  Map<int, DownloadProgress> get activeDownloads => _activeDownloads;
  List<LessonModel> get downloadedLessons => _downloadedLessons;
  List<LessonModel> get availableLessons => _availableLessons;
  OfflineStorageStats? get storageStats => _storageStats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get availableStorageBytes => _availableStorageBytes;
  int get totalStorageBytes => _totalStorageBytes;

  // Timer for updating progress
  Timer? _progressTimer;

  // ================================================================
  // INITIALIZATION
  // ================================================================

  Future<void> init() async {
    await _offlineRepository.init();
    await loadData();
    _startProgressMonitoring();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  // ================================================================
  // DATA LOADING
  // ================================================================

  Future<void> loadData() async {
    _setLoading(true);

    try {
      // Load downloaded lessons
      _downloadedLessons = await _offlineRepository.getOfflineLessons();

      // Load all lessons
      final allLessons = await _contentRepository.getLessons();

      // Filter available lessons (not downloaded)
      _availableLessons = allLessons
          .where((lesson) => !_downloadedLessons.any((dl) => dl.id == lesson.id))
          .toList();

      // Load storage stats
      _storageStats = await _offlineRepository.getStorageStats();

      // Load actual device storage
      _availableStorageBytes = await StorageUtils.getAvailableStorageBytes();
      _totalStorageBytes = await StorageUtils.getTotalStorageBytes();

      if (kDebugMode) {
        print('[DownloadProvider] Device storage:');
        print('  - Available: ${StorageUtils.formatMB(_availableStorageBytes)} MB');
        print('  - Total: ${StorageUtils.formatMB(_totalStorageBytes)} MB');
        print('  - App used: ${StorageUtils.formatMB(_storageStats?.mediaStorageBytes ?? 0)} MB');
      }

      _clearError();
      _setLoading(false);
    } catch (e) {
      _setError('加载数据失败: $e');
      _setLoading(false);
    }
  }

  // ================================================================
  // DOWNLOAD MANAGEMENT
  // ================================================================

  /// Download a lesson
  Future<void> downloadLesson(LessonModel lesson) async {
    try {
      // Set callbacks
      _downloadManager.onProgress = (lessonId, progress) {
        // Get the full progress from download manager
        final fullProgress = _downloadManager.getProgress(lessonId);
        if (fullProgress != null) {
          _updateDownloadProgress(lessonId, fullProgress);
        }
      };
      _downloadManager.onComplete = (lessonId) {
        _onDownloadComplete(lessonId);
      };

      final success = await _downloadManager.downloadLesson(lesson.id);

      if (!success) {
        _setError('下载失败: ${lesson.titleZh}');
      }
    } catch (e) {
      _setError('下载错误: $e');
    }
  }

  /// Cancel download
  void cancelDownload(int lessonId) {
    _downloadManager.cancelDownload(lessonId);
    _activeDownloads.remove(lessonId);
    notifyListeners();
  }

  /// Delete downloaded lesson
  Future<void> deleteLesson(LessonModel lesson) async {
    try {
      await _offlineRepository.deleteLesson(lesson.id);

      // Move from downloaded to available
      _downloadedLessons.removeWhere((l) => l.id == lesson.id);
      _availableLessons.add(lesson);

      // Update storage stats
      _storageStats = await _offlineRepository.getStorageStats();

      notifyListeners();
    } catch (e) {
      _setError('删除失败: $e');
    }
  }

  /// Delete all downloads
  Future<void> deleteAllDownloads() async {
    try {
      await _offlineRepository.deleteAllDownloads();

      // Move all to available
      _availableLessons.addAll(_downloadedLessons);
      _downloadedLessons.clear();

      // Update storage stats
      _storageStats = await _offlineRepository.getStorageStats();

      notifyListeners();
    } catch (e) {
      _setError('清空失败: $e');
    }
  }

  // ================================================================
  // PROGRESS MONITORING
  // ================================================================

  void _startProgressMonitoring() {
    _progressTimer = Timer.periodic(AppConstants.progressUpdateInterval, (_) {
      _updateActiveDownloads();
    });
  }

  void _updateActiveDownloads() {
    final newActiveDownloads = _downloadManager.getAllProgress();

    if (!_mapsEqual(_activeDownloads, newActiveDownloads)) {
      _activeDownloads = newActiveDownloads;
      notifyListeners();
    }
  }

  void _updateDownloadProgress(int lessonId, DownloadProgress progress) {
    _activeDownloads[lessonId] = progress;
    notifyListeners();
  }

  void _onDownloadComplete(int lessonId) {
    _activeDownloads.remove(lessonId);

    // Reload data to update lists
    loadData();
  }

  bool _mapsEqual(Map<int, DownloadProgress> map1, Map<int, DownloadProgress> map2) {
    if (map1.length != map2.length) return false;

    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      if (map1[key]?.progress != map2[key]?.progress) return false;
    }

    return true;
  }

  // ================================================================
  // STORAGE MANAGEMENT
  // ================================================================

  Future<void> cleanupOldFiles({int maxSizeMB = 500}) async {
    try {
      await _offlineRepository.cleanupOldFiles(maxSizeMB: maxSizeMB);
      _storageStats = await _offlineRepository.getStorageStats();
      notifyListeners();
    } catch (e) {
      _setError('清理失败: $e');
    }
  }

  String getStorageUsedText() {
    if (_storageStats == null) return '0 MB';
    return '${_storageStats!.mediaStorageMB.toStringAsFixed(1)} MB';
  }

  String getStoragePercentageText() {
    if (_storageStats == null) return '0%';
    final percentage = (_storageStats!.mediaStorageMB / 500 * 100).clamp(0, 100);
    return '${percentage.toStringAsFixed(0)}%';
  }

  // ================================================================
  // HELPERS
  // ================================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
