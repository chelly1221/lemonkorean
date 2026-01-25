import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';

class SyncProvider with ChangeNotifier {
  final _apiClient = ApiClient.instance;
  final _connectivity = Connectivity();

  bool _isSyncing = false;
  bool _isOnline = false;
  int _syncQueueSize = 0;
  DateTime? _lastSyncTime;
  String? _errorMessage;
  Timer? _syncTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // Getters
  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;
  int get syncQueueSize => _syncQueueSize;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get errorMessage => _errorMessage;

  SyncProvider() {
    _initConnectivity();
    _startAutoSync();
  }

  /// Initialize connectivity monitoring
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) {
          final wasOffline = !_isOnline;
          _isOnline = result != ConnectivityResult.none;

          if (wasOffline && _isOnline) {
            // Just came online - trigger sync
            sync();
          }

          notifyListeners();
        },
      );
    } catch (e) {
      _isOnline = false;
    }

    _updateSyncQueueSize();
    notifyListeners();
  }

  /// Start automatic sync timer
  void _startAutoSync() {
    if (!AppConstants.enableAutoSync) return;

    _syncTimer = Timer.periodic(AppConstants.syncInterval, (timer) {
      if (_isOnline && !_isSyncing) {
        sync();
      }
    });
  }

  /// Update sync queue size
  void _updateSyncQueueSize() {
    _syncQueueSize = LocalStorage.getSyncQueueSize();
    notifyListeners();
  }

  /// Sync offline data to server
  Future<void> sync() async {
    if (_isSyncing || !_isOnline) return;

    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final queue = LocalStorage.getSyncQueue();

      if (queue.isEmpty) {
        _isSyncing = false;
        _lastSyncTime = DateTime.now();
        notifyListeners();
        return;
      }

      // Group by type
      final progressItems = queue
          .where((item) => item['type'] == 'lesson_complete')
          .toList();

      // Sync progress
      if (progressItems.isNotEmpty) {
        await _syncProgress(progressItems);
      }

      // Update last sync time
      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      _updateSyncQueueSize();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isSyncing = false;
      notifyListeners();

      // Retry after delay
      Future.delayed(AppConstants.syncRetryDelay, () {
        if (_isOnline) sync();
      });
    }
  }

  /// Sync progress data
  Future<void> _syncProgress(List<Map<String, dynamic>> items) async {
    final progressData = items.map((item) => item['data']).toList();

    try {
      final response = await _apiClient.syncProgress(progressData);

      if (response.statusCode == 200) {
        // Remove successfully synced items
        for (var i = items.length - 1; i >= 0; i--) {
          final queue = LocalStorage.getSyncQueue();
          final index = queue.indexOf(items[i]);
          if (index != -1) {
            await LocalStorage.removeFromSyncQueue(index);
          }
        }
      }
    } catch (e) {
      // Failed to sync - items remain in queue
      rethrow;
    }
  }

  /// Force sync now
  Future<void> forceSync() async {
    if (!_isOnline) {
      _errorMessage = AppConstants.networkErrorMessage;
      notifyListeners();
      return;
    }

    await sync();
  }

  /// Clear sync queue (use with caution)
  Future<void> clearSyncQueue() async {
    await LocalStorage.clearSyncQueue();
    _updateSyncQueueSize();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
