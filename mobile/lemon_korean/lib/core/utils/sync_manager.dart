import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../constants/app_constants.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';

/// Sync Manager
/// Handles offline data synchronization with the server
class SyncManager {
  static final SyncManager instance = SyncManager._init();

  final _apiClient = ApiClient.instance;
  final _connectivity = Connectivity();

  bool _isSyncing = false;
  bool _isOnline = false;
  DateTime? _lastSyncTime;
  Timer? _syncTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // Callbacks
  Function(SyncStatus status)? onSyncStatusChanged;
  Function(int queueSize)? onQueueSizeChanged;
  Function(String error)? onSyncError;

  SyncManager._init();

  // ================================================================
  // INITIALIZATION
  // ================================================================

  /// Initialize sync manager
  Future<void> init() async {
    await _checkConnectivity();
    _startConnectivityMonitoring();
    _startAutoSync();
  }

  /// Check initial connectivity
  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;
      _notifyStatusChange();
    } catch (e) {
      _isOnline = false;
      print('[SyncManager] Error checking connectivity: $e');
    }
  }

  /// Monitor connectivity changes
  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        final wasOffline = !_isOnline;
        _isOnline = result != ConnectivityResult.none;

        print('[SyncManager] Connectivity changed: $_isOnline');

        if (wasOffline && _isOnline) {
          // Just came online - trigger sync
          print('[SyncManager] Network recovered, starting sync...');
          sync();
        }

        _notifyStatusChange();
      },
    );
  }

  /// Start automatic sync timer
  void _startAutoSync() {
    if (!AppConstants.enableAutoSync) return;

    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(AppConstants.syncInterval, (timer) {
      if (_isOnline && !_isSyncing) {
        print('[SyncManager] Auto sync triggered');
        sync();
      }
    });
  }

  // ================================================================
  // SYNC OPERATIONS
  // ================================================================

  /// Main sync function
  Future<SyncResult> sync() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        syncedItems: 0,
        failedItems: 0,
        error: 'Sync already in progress',
      );
    }

    if (!_isOnline) {
      return SyncResult(
        success: false,
        syncedItems: 0,
        failedItems: 0,
        error: AppConstants.networkErrorMessage,
      );
    }

    _isSyncing = true;
    _notifyStatusChange();

    int syncedCount = 0;
    int failedCount = 0;
    String? errorMessage;

    try {
      print('[SyncManager] Starting sync...');

      final queue = LocalStorage.getSyncQueue();
      print('[SyncManager] Queue size: ${queue.length}');

      if (queue.isEmpty) {
        _lastSyncTime = DateTime.now();
        _isSyncing = false;
        _notifyStatusChange();

        return SyncResult(
          success: true,
          syncedItems: 0,
          failedItems: 0,
        );
      }

      // Group items by type
      final progressItems = queue.where((item) => item['type'] == 'lesson_complete').toList();
      final reviewItems = queue.where((item) => item['type'] == 'review_complete').toList();
      final eventItems = queue.where((item) => item['type'] == 'event_log').toList();

      // Sync progress
      if (progressItems.isNotEmpty) {
        final result = await _syncProgress(progressItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      // Sync reviews
      if (reviewItems.isNotEmpty) {
        final result = await _syncReviews(reviewItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      // Sync events
      if (eventItems.isNotEmpty) {
        final result = await _syncEvents(eventItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      _lastSyncTime = DateTime.now();

      print('[SyncManager] Sync complete: $syncedCount synced, $failedCount failed');

      return SyncResult(
        success: failedCount == 0,
        syncedItems: syncedCount,
        failedItems: failedCount,
      );
    } catch (e) {
      errorMessage = e.toString();
      print('[SyncManager] Sync error: $e');

      onSyncError?.call(errorMessage);

      return SyncResult(
        success: false,
        syncedItems: syncedCount,
        failedItems: failedCount,
        error: errorMessage,
      );
    } finally {
      _isSyncing = false;
      _notifyStatusChange();
      _notifyQueueSize();
    }
  }

  /// Sync progress items
  Future<_SyncItemResult> _syncProgress(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    try {
      // Batch sync progress
      final progressData = items.map((item) => item['data']).toList();

      final response = await _apiClient.syncProgress(progressData);

      if (response.statusCode == 200) {
        // Remove successfully synced items
        for (var i = items.length - 1; i >= 0; i--) {
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(items[i]);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
        }
      } else {
        failedCount = items.length;
      }
    } catch (e) {
      print('[SyncManager] Error syncing progress: $e');
      failedCount = items.length;
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  /// Sync review items
  Future<_SyncItemResult> _syncReviews(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    // Sync reviews individually
    for (final item in items) {
      try {
        final reviewData = item['data'];

        // Call review API endpoint
        // final response = await _apiClient.markReviewDone(reviewData);

        // For now, just remove from queue
        // TODO: Implement actual review sync when API is ready

        final queue = LocalStorage.getSyncQueue();
        final index = queue.indexOf(item);
        if (index != -1) {
          await LocalStorage.removeFromSyncQueue(index);
          syncedCount++;
        }
      } catch (e) {
        print('[SyncManager] Error syncing review: $e');
        failedCount++;
      }
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  /// Sync event logs
  Future<_SyncItemResult> _syncEvents(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    // Batch sync events
    for (final item in items) {
      try {
        final eventData = item['data'];

        await _apiClient.logEvent(
          eventType: eventData['event_type'],
          eventData: eventData['event_data'],
        );

        final queue = LocalStorage.getSyncQueue();
        final index = queue.indexOf(item);
        if (index != -1) {
          await LocalStorage.removeFromSyncQueue(index);
          syncedCount++;
        }
      } catch (e) {
        print('[SyncManager] Error syncing event: $e');
        failedCount++;
      }
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  // ================================================================
  // SYNC CONTROL
  // ================================================================

  /// Force immediate sync
  Future<SyncResult> forceSync() async {
    print('[SyncManager] Force sync requested');
    return await sync();
  }

  /// Stop auto sync
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Resume auto sync
  void resumeAutoSync() {
    _startAutoSync();
  }

  /// Clear sync queue
  Future<void> clearQueue() async {
    await LocalStorage.clearSyncQueue();
    _notifyQueueSize();
  }

  // ================================================================
  // GETTERS
  // ================================================================

  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;
  DateTime? get lastSyncTime => _lastSyncTime;

  int get queueSize => LocalStorage.getSyncQueueSize();

  String get statusMessage {
    if (_isSyncing) return '正在同步...';
    if (!_isOnline) return '离线模式';
    if (queueSize > 0) return '有 $queueSize 项待同步';
    return '已同步';
  }

  // ================================================================
  // NOTIFICATIONS
  // ================================================================

  void _notifyStatusChange() {
    final status = SyncStatus(
      isSyncing: _isSyncing,
      isOnline: _isOnline,
      lastSyncTime: _lastSyncTime,
      queueSize: queueSize,
    );

    onSyncStatusChanged?.call(status);
  }

  void _notifyQueueSize() {
    onQueueSizeChanged?.call(queueSize);
  }

  // ================================================================
  // CLEANUP
  // ================================================================

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}

// ================================================================
// HELPER CLASSES
// ================================================================

class _SyncItemResult {
  final int syncedCount;
  final int failedCount;

  _SyncItemResult({
    required this.syncedCount,
    required this.failedCount,
  });
}

// ================================================================
// MODELS
// ================================================================

/// Sync result model
class SyncResult {
  final bool success;
  final int syncedItems;
  final int failedItems;
  final String? error;

  SyncResult({
    required this.success,
    required this.syncedItems,
    required this.failedItems,
    this.error,
  });

  int get totalItems => syncedItems + failedItems;

  double get successRate =>
      totalItems > 0 ? syncedItems / totalItems : 0.0;

  @override
  String toString() {
    return 'SyncResult(success: $success, synced: $syncedItems, failed: $failedItems)';
  }
}

/// Sync status model
class SyncStatus {
  final bool isSyncing;
  final bool isOnline;
  final DateTime? lastSyncTime;
  final int queueSize;

  SyncStatus({
    required this.isSyncing,
    required this.isOnline,
    this.lastSyncTime,
    required this.queueSize,
  });

  String get statusMessage {
    if (isSyncing) return '正在同步...';
    if (!isOnline) return '离线模式';
    if (queueSize > 0) return '有 $queueSize 项待同步';
    return '已同步';
  }

  String? get lastSyncTimeFormatted {
    if (lastSyncTime == null) return null;

    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);

    if (difference.inMinutes < 1) return '刚刚';
    if (difference.inMinutes < 60) return '${difference.inMinutes} 分钟前';
    if (difference.inHours < 24) return '${difference.inHours} 小时前';
    return '${difference.inDays} 天前';
  }

  @override
  String toString() {
    return 'SyncStatus(isSyncing: $isSyncing, isOnline: $isOnline, queueSize: $queueSize)';
  }
}

/// Sync item type enum
enum SyncItemType {
  lessonComplete,
  reviewComplete,
  eventLog,
  settingChange,
}

/// Sync priority enum
enum SyncPriority {
  low,
  normal,
  high,
  urgent,
}
