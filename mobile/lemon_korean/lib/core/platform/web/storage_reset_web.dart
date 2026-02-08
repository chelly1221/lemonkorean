import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

import '../../constants/app_constants.dart';
import '../../utils/app_logger.dart';

/// Check and handle storage reset flag from admin (web-only)
Future<void> checkAndHandleStorageReset() async {
  if (!kIsWeb) return;

  try {
    final storage = web.window.localStorage;
    final cachedUserJson = storage['lk_cached_user'];
    int? userId;

    if (cachedUserJson != null && cachedUserJson.isNotEmpty) {
      try {
        final cachedUser = jsonDecode(cachedUserJson);
        userId = cachedUser['id'] as int?;
      } catch (e) {
        AppLogger.w('Failed to parse cached user', tag: 'StorageReset', error: e);
      }
    }

    final queryParams = userId != null ? '?user_id=$userId' : '';
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/storage-reset/check$queryParams'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['reset_required'] == true) {
        final flagId = data['flag_id'];
        final reason = data['reason'] ?? 'Administrator requested reset';

        AppLogger.i('Storage reset flag detected. Reason: $reason',
            tag: 'StorageReset');

        await _clearAppStorage();

        await http.post(
          Uri.parse('${AppConstants.baseUrl}/api/storage-reset/complete'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'flag_id': flagId}),
        );

        AppLogger.i('Storage cleared successfully. Flag marked complete.',
            tag: 'StorageReset');
      }
    }
  } catch (e) {
    AppLogger.w('Storage reset check failed, continuing normally',
        tag: 'StorageReset', error: e);
  }
}

/// Clear all app storage: localStorage, IndexedDB, Service Worker caches
Future<void> _clearAppStorage() async {
  if (!kIsWeb) return;

  try {
    // 1. Clear localStorage (lk_ prefixed keys)
    final storage = web.window.localStorage;
    final allKeys = <String>[];

    for (var i = 0; i < storage.length; i++) {
      final key = storage.key(i);
      if (key != null) {
        allKeys.add(key);
      }
    }

    int clearedCount = 0;
    for (final key in allKeys) {
      if (key.startsWith('lk_')) {
        storage.removeItem(key);
        clearedCount++;
      }
    }
    AppLogger.i('localStorage cleared ($clearedCount lk_* keys)', tag: 'StorageReset');

    // 2. Clear IndexedDB database
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          try {
            indexedDB.deleteDatabase('lemon_korean');
            console.log('[StorageReset] IndexedDB deletion triggered');
          } catch (e) {
            console.warn('[StorageReset] Failed to delete IndexedDB:', e);
          }
        })();
        '''
      ]);
      AppLogger.i('IndexedDB deletion triggered', tag: 'StorageReset');
    } catch (e) {
      AppLogger.w('Failed to clear IndexedDB', error: e, tag: 'StorageReset');
    }

    // 3. Clear Service Worker caches
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          if ('caches' in window) {
            caches.keys().then(function(cacheNames) {
              return Promise.all(
                cacheNames.map(function(cacheName) {
                  console.log('[StorageReset] Clearing cache:', cacheName);
                  return caches.delete(cacheName);
                })
              );
            }).then(function() {
              console.log('[StorageReset] All caches cleared');
            }).catch(function(e) {
              console.warn('[StorageReset] Failed to clear caches:', e);
            });
          }
        })();
        '''
      ]);
      AppLogger.i('Service Worker cache clearing triggered', tag: 'StorageReset');
    } catch (e) {
      AppLogger.w('Failed to clear Service Worker caches', error: e, tag: 'StorageReset');
    }

    // 4. Unregister Service Workers
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          if ('serviceWorker' in navigator) {
            navigator.serviceWorker.getRegistrations().then(function(registrations) {
              registrations.forEach(function(registration) {
                console.log('[StorageReset] Unregistering service worker');
                registration.unregister();
              });
              console.log('[StorageReset] All service workers unregistered');
            }).catch(function(e) {
              console.warn('[StorageReset] Failed to unregister service workers:', e);
            });
          }
        })();
        '''
      ]);
      AppLogger.i('Service Worker unregistration triggered', tag: 'StorageReset');
    } catch (e) {
      AppLogger.w('Failed to unregister Service Workers', error: e, tag: 'StorageReset');
    }

    AppLogger.i('Complete storage reset: localStorage, IndexedDB, Service Worker caches, and registrations', tag: 'StorageReset');
  } catch (e) {
    AppLogger.e('Error during storage reset', tag: 'StorageReset', error: e);
  }
}
