import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants/app_constants.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart'
    if (dart.library.html) '../platform/web/stubs/local_storage_stub.dart';
import 'app_logger.dart';

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
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

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
      final results = await _connectivity.checkConnectivity();
      _isOnline = !results.contains(ConnectivityResult.none);
      _notifyStatusChange();
    } catch (e) {
      _isOnline = false;
      AppLogger.logSync('Error checking connectivity', details: e.toString(), isError: true);
    }
  }

  /// Monitor connectivity changes
  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final wasOffline = !_isOnline;
        _isOnline = !results.contains(ConnectivityResult.none);

        AppLogger.logSync('Connectivity changed', details: 'isOnline: $_isOnline');

        if (wasOffline && _isOnline) {
          // Just came online - trigger sync
          AppLogger.logSync('Network recovered, starting sync');
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
        AppLogger.logSync('Auto sync triggered');
        sync();
      }
    });
  }

  // ================================================================
  // SYNC OPERATIONS
  // ================================================================

  /// Main sync function
  Future<SyncResult> sync() async {
    // Web: No sync queue, always sync immediately (no offline queue)
    if (kIsWeb) {
      return SyncResult(
        success: true,
        syncedItems: 0,
        failedItems: 0,
      );
    }

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
      AppLogger.logSync('Starting sync');

      final queue = LocalStorage.getSyncQueue();
      AppLogger.logSync('Queue size', details: '${queue.length} items');

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
      // Include all progress-related types (lesson_start, lesson_complete, stage_progress, progress_update)
      final progressTypes = ['lesson_start', 'lesson_complete', 'stage_progress', 'progress_update'];
      final progressItems = queue.where((item) => progressTypes.contains(item['type'])).toList();
      // Include both 'review_complete' and 'review_submit' types
      final reviewItems = queue.where((item) =>
          item['type'] == 'review_complete' || item['type'] == 'review_submit').toList();
      // Vocabulary batch updates from lesson quiz
      final vocabularyBatchItems = queue.where((item) => item['type'] == 'vocabulary_batch').toList();
      final eventItems = queue.where((item) => item['type'] == 'event_log').toList();
      // Settings/preferences sync
      final settingsItems = queue.where((item) => item['type'] == 'settings_change').toList();
      // Session end tracking
      final sessionItems = queue.where((item) => item['type'] == 'session_end').toList();
      // Bookmark operations (create, update, delete)
      final bookmarkTypes = ['bookmark_create', 'bookmark_update', 'bookmark_delete'];
      final bookmarkItems = queue.where((item) => bookmarkTypes.contains(item['type'])).toList();
      // Character customization operations
      final characterTypes = ['character_equip', 'character_purchase', 'room_update', 'lemon_spend'];
      final characterItems = queue.where((item) => characterTypes.contains(item['type'])).toList();

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

      // Sync vocabulary batch
      if (vocabularyBatchItems.isNotEmpty) {
        final result = await _syncVocabularyBatch(vocabularyBatchItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      // Sync events
      if (eventItems.isNotEmpty) {
        final result = await _syncEvents(eventItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      // Sync settings/preferences
      if (settingsItems.isNotEmpty) {
        final result = await _syncSettings(settingsItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      // Sync session end events
      if (sessionItems.isNotEmpty) {
        final result = await _syncSessions(sessionItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      // Sync bookmarks
      if (bookmarkItems.isNotEmpty) {
        final result = await _syncBookmarks(bookmarkItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      // Sync character customization
      if (characterItems.isNotEmpty) {
        final result = await _syncCharacter(characterItems);
        syncedCount += result.syncedCount;
        failedCount += result.failedCount;
      }

      _lastSyncTime = DateTime.now();

      AppLogger.logSync('Sync complete', details: '$syncedCount synced, $failedCount failed');

      return SyncResult(
        success: failedCount == 0,
        syncedItems: syncedCount,
        failedItems: failedCount,
      );
    } catch (e) {
      errorMessage = e.toString();
      AppLogger.logSync('Sync error', details: e.toString(), isError: true);

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
      final progressData = items
          .map((item) => item['data'] as Map<String, dynamic>)
          .toList();

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
      AppLogger.logSync('Error syncing progress', details: e.toString(), isError: true);
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
        // Call review API endpoint
        final response = await _apiClient.markReviewDone(item['data']);

        if (response.statusCode == 200) {
          // Successfully synced - remove from queue
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(item);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
        } else {
          // API call failed
          AppLogger.logSync('Review sync failed', details: 'status: ${response.statusCode}', isError: true);
          failedCount++;
        }
      } catch (e) {
        AppLogger.logSync('Error syncing review', details: e.toString(), isError: true);
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
        AppLogger.logSync('Error syncing event', details: e.toString(), isError: true);
        failedCount++;
      }
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  /// Sync user settings/preferences
  Future<_SyncItemResult> _syncSettings(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    for (final item in items) {
      try {
        final settingsData = item['data'] as Map<String, dynamic>;

        final response = await _apiClient.updateUserPreferences(settingsData);

        if (response.statusCode == 200) {
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(item);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
        } else {
          AppLogger.logSync('Settings sync failed', details: 'status: ${response.statusCode}', isError: true);
          failedCount++;
        }
      } catch (e) {
        AppLogger.logSync('Error syncing settings', details: e.toString(), isError: true);
        failedCount++;
      }
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  /// Sync vocabulary batch items
  Future<_SyncItemResult> _syncVocabularyBatch(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    for (final item in items) {
      try {
        final data = item['data'] as Map<String, dynamic>;
        final userId = data['user_id'] as int;
        final lessonId = data['lesson_id'] as int;
        final results = List<Map<String, dynamic>>.from(data['vocabulary_results'] ?? []);

        if (results.isEmpty) {
          // Empty batch, just remove from queue
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(item);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
          continue;
        }

        final response = await _apiClient.updateVocabularyBatch(
          userId: userId,
          lessonId: lessonId,
          vocabularyResults: results,
        );

        if (response.statusCode == 200) {
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(item);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
        } else {
          AppLogger.logSync('Vocabulary batch sync failed', details: 'status: ${response.statusCode}', isError: true);
          failedCount++;
        }
      } catch (e) {
        AppLogger.logSync('Error syncing vocabulary batch', details: e.toString(), isError: true);
        failedCount++;
      }
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  /// Sync session end events
  Future<_SyncItemResult> _syncSessions(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    for (final item in items) {
      try {
        final sessionData = item['data'] as Map<String, dynamic>;

        final response = await _apiClient.endLearningSession(
          sessionId: sessionData['session_id'] as int,
          itemsStudied: sessionData['items_studied'] as int? ?? 0,
          correctAnswers: sessionData['correct_answers'] as int? ?? 0,
          incorrectAnswers: sessionData['incorrect_answers'] as int? ?? 0,
        );

        if (response.statusCode == 200) {
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(item);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
        } else {
          AppLogger.logSync('Session sync failed', details: 'status: ${response.statusCode}', isError: true);
          failedCount++;
        }
      } catch (e) {
        AppLogger.logSync('Error syncing session', details: e.toString(), isError: true);
        failedCount++;
      }
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  /// Sync bookmark operations (create, update, delete)
  Future<_SyncItemResult> _syncBookmarks(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    for (final item in items) {
      try {
        final type = item['type'] as String;
        final data = item['data'] as Map<String, dynamic>;
        bool success = false;

        switch (type) {
          case 'bookmark_create':
            // Create new bookmark
            final vocabularyId = data['vocabulary_id'] as int;
            final notes = data['notes'] as String?;

            final response = await _apiClient.createBookmark(vocabularyId, notes: notes);

            if (response.statusCode == 200 || response.statusCode == 201) {
              // Update local bookmark with server ID
              final serverBookmark = response.data;
              if (serverBookmark != null && serverBookmark['id'] != null) {
                final localBookmarkId = data['local_id'] as int?;
                if (localBookmarkId != null) {
                  // Update local bookmark with server ID
                  final localBookmark = LocalStorage.getBookmark(localBookmarkId);
                  if (localBookmark != null) {
                    localBookmark['id'] = serverBookmark['id'];
                    localBookmark['is_synced'] = true;
                    await LocalStorage.saveBookmark(localBookmark);
                  }
                }
              }
              success = true;
            }
            break;

          case 'bookmark_update':
            // Update bookmark notes
            final bookmarkId = data['id'] as int;
            final notes = data['notes'] as String;

            final response = await _apiClient.updateBookmarkNotes(bookmarkId, notes);

            if (response.statusCode == 200) {
              // Update local bookmark sync status
              final localBookmark = LocalStorage.getBookmark(bookmarkId);
              if (localBookmark != null) {
                localBookmark['is_synced'] = true;
                await LocalStorage.saveBookmark(localBookmark);
              }
              success = true;
            }
            break;

          case 'bookmark_delete':
            // Delete bookmark
            final bookmarkId = data['id'] as int;

            final response = await _apiClient.deleteBookmark(bookmarkId);

            if (response.statusCode == 200 || response.statusCode == 204) {
              // Already deleted locally, just confirm server deletion
              success = true;
            }
            break;
        }

        if (success) {
          // Remove successfully synced item from queue
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(item);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
        } else {
          AppLogger.logSync('Bookmark sync failed', details: 'type: $type', isError: true);
          failedCount++;
        }
      } catch (e) {
        AppLogger.logSync('Error syncing bookmark', details: e.toString(), isError: true);
        failedCount++;
      }
    }

    return _SyncItemResult(
      syncedCount: syncedCount,
      failedCount: failedCount,
    );
  }

  /// Sync character customization items (equip, purchase, room update)
  Future<_SyncItemResult> _syncCharacter(List<Map<String, dynamic>> items) async {
    int syncedCount = 0;
    int failedCount = 0;

    for (final item in items) {
      try {
        final type = item['type'] as String;
        final data = item['data'] as Map<String, dynamic>;
        bool success = false;

        switch (type) {
          case 'character_equip':
            // Equip or update skin color
            if (data.containsKey('skin_color')) {
              final response = await _apiClient.dio.put(
                '/api/progress/character/skin-color',
                data: {'skin_color': data['skin_color']},
              );
              success = response.statusCode == 200;
            } else {
              final response = await _apiClient.dio.put(
                '/api/progress/character/equip',
                data: {
                  'category': data['category'],
                  'item_id': data['item_id'],
                },
              );
              success = response.statusCode == 200;
            }
            break;

          case 'character_purchase':
            final response = await _apiClient.dio.post(
              '/api/progress/shop/purchase',
              data: {'item_id': data['item_id']},
            );
            // 200 = purchased, 409 = already owned (both count as synced)
            success = response.statusCode == 200 || response.statusCode == 409;
            break;

          case 'room_update':
            final response = await _apiClient.dio.put(
              '/api/progress/room/furniture',
              data: {'furniture': data['furniture']},
            );
            success = response.statusCode == 200;
            break;

          case 'lemon_spend':
            // Lemon spending is handled server-side during purchase
            // Just remove from queue
            success = true;
            break;
        }

        if (success) {
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(item);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
            syncedCount++;
          }
        } else {
          AppLogger.logSync('Character sync failed', details: 'type: $type', isError: true);
          failedCount++;
        }
      } catch (e) {
        AppLogger.logSync('Error syncing character', details: e.toString(), isError: true);
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
    AppLogger.logSync('Force sync requested');
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
    if (_isSyncing) return '동기화 중...';
    if (!_isOnline) return '오프라인 모드';
    if (queueSize > 0) return '동기화 대기 중: $queueSize 항목';
    return '동기화 완료';
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
    required this.queueSize, this.lastSyncTime,
  });

  String get statusMessage {
    if (isSyncing) return '동기화 중...';
    if (!isOnline) return '오프라인 모드';
    if (queueSize > 0) return '동기화 대기 중: $queueSize 항목';
    return '동기화 완료';
  }

  String? get lastSyncTimeFormatted {
    if (lastSyncTime == null) return null;

    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);

    if (difference.inMinutes < 1) return '방금';
    if (difference.inMinutes < 60) return '${difference.inMinutes}분 전';
    if (difference.inHours < 24) return '${difference.inHours}시간 전';
    return '${difference.inDays}일 전';
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
  vocabularyBatch,
}

/// Sync priority enum
enum SyncPriority {
  low,
  normal,
  high,
  urgent,
}
