import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/result.dart';
import '../../core/utils/app_exception.dart';
import '../models/bookmark_model.dart';
import '../models/vocabulary_model.dart';

/// Bookmark Repository
/// Handles vocabulary bookmarks with offline-first pattern
class BookmarkRepository {
  final _apiClient = ApiClient.instance;

  // ================================================================
  // CREATE
  // ================================================================

  /// Create a bookmark (offline-first)
  /// 1. Save locally immediately
  /// 2. Queue for sync
  /// 3. Try immediate upload
  Future<Result<BookmarkModel>> createBookmark(
    int vocabularyId, {
    String? notes,
  }) async {
    try {
      // Generate temporary ID for local storage
      final tempId = DateTime.now().millisecondsSinceEpoch;

      // Create local bookmark
      final localBookmark = BookmarkModel(
        id: tempId,
        vocabularyId: vocabularyId,
        notes: notes,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      // Save locally immediately for instant UX
      await LocalStorage.saveBookmark(localBookmark.toLocalJson());

      // Queue for sync
      await LocalStorage.addToSyncQueue({
        'type': 'bookmark_create',
        'data': {
          'vocabulary_id': vocabularyId,
          'notes': notes,
          'temp_id': tempId,
        },
        'created_at': DateTime.now().toIso8601String(),
      });

      // Try immediate upload
      try {
        final response = await _apiClient.createBookmark(vocabularyId, notes: notes);

        if (response.statusCode == 201 || response.statusCode == 200) {
          final serverBookmark = BookmarkModel.fromJson(response.data['bookmark']);

          // Update local with server ID
          await LocalStorage.deleteBookmark(tempId);
          await LocalStorage.saveBookmark(serverBookmark.copyWith(isSynced: true).toLocalJson());

          AppLogger.i('Bookmark created and synced: ${serverBookmark.id}',
              tag: 'BookmarkRepository');

          return Success(serverBookmark, isFromCache: false);
        }
      } catch (e) {
        AppLogger.w('Immediate upload failed, will sync later: $e',
            tag: 'BookmarkRepository');
        // Continue with local bookmark
      }

      // Return local bookmark if upload failed
      return Success(localBookmark, isFromCache: true);
    } catch (e, stackTrace) {
      AppLogger.e('createBookmark error', tag: 'BookmarkRepository', error: e);
      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(exception.message, code: exception.code);
    }
  }

  // ================================================================
  // READ
  // ================================================================

  /// Get all user bookmarks
  /// Tries server first, falls back to local
  Future<Result<List<BookmarkModel>>> getBookmarks({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Try server first
      final response = await _apiClient.getUserBookmarks(page: page, limit: limit);

      if (response.statusCode == 200) {
        final List<dynamic> bookmarksData = response.data['bookmarks'];
        final bookmarks = bookmarksData
            .map((json) => BookmarkModel.fromJson(json))
            .toList();

        // Save to local storage (replace all)
        await LocalStorage.clearBookmarks();
        for (final bookmark in bookmarks) {
          await LocalStorage.saveBookmark(
            bookmark.copyWith(isSynced: true).toLocalJson(),
          );
        }

        AppLogger.i('Fetched ${bookmarks.length} bookmarks from server',
            tag: 'BookmarkRepository');

        return Success(bookmarks, isFromCache: false);
      }

      // Fallback to local
      return Success(await _getLocalBookmarks(), isFromCache: true);
    } catch (e, stackTrace) {
      AppLogger.w('getBookmarks error, using cache', tag: 'BookmarkRepository', error: e);

      // Return cached data
      final cachedBookmarks = await _getLocalBookmarks();
      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(
        exception.message,
        code: exception.code,
        cachedData: cachedBookmarks,
      );
    }
  }

  /// Get single bookmark by ID
  Future<BookmarkModel?> getBookmark(int bookmarkId) async {
    try {
      // Check local first
      final local = LocalStorage.getBookmark(bookmarkId);

      // Try server
      final response = await _apiClient.getBookmark(bookmarkId);

      if (response.statusCode == 200) {
        final bookmark = BookmarkModel.fromJson(response.data['bookmark']);
        await LocalStorage.saveBookmark(bookmark.copyWith(isSynced: true).toLocalJson());
        return bookmark;
      }

      // Return local if server fails
      return local != null ? BookmarkModel.fromLocalJson(local) : null;
    } catch (e) {
      AppLogger.w('getBookmark error: $e', tag: 'BookmarkRepository');
      final local = LocalStorage.getBookmark(bookmarkId);
      return local != null ? BookmarkModel.fromLocalJson(local) : null;
    }
  }

  /// Check if vocabulary is bookmarked
  Future<bool> isBookmarked(int vocabularyId) async {
    // Check local first (fast)
    return LocalStorage.isBookmarked(vocabularyId);
  }

  // ================================================================
  // UPDATE
  // ================================================================

  /// Update bookmark notes
  Future<Result<BookmarkModel>> updateNotes(int bookmarkId, String notes) async {
    try {
      // Update locally first
      final local = LocalStorage.getBookmark(bookmarkId);
      if (local != null) {
        local['notes'] = notes;
        local['is_synced'] = false;
        await LocalStorage.saveBookmark(local);
      }

      // Queue for sync
      await LocalStorage.addToSyncQueue({
        'type': 'bookmark_update',
        'data': {
          'id': bookmarkId,
          'notes': notes,
        },
        'created_at': DateTime.now().toIso8601String(),
      });

      // Try immediate upload
      try {
        final response = await _apiClient.updateBookmarkNotes(bookmarkId, notes);

        if (response.statusCode == 200) {
          final updated = BookmarkModel.fromJson(response.data['bookmark']);
          await LocalStorage.saveBookmark(updated.copyWith(isSynced: true).toLocalJson());

          AppLogger.i('Bookmark notes updated: $bookmarkId', tag: 'BookmarkRepository');
          return Success(updated, isFromCache: false);
        }
      } catch (e) {
        AppLogger.w('Immediate update failed, will sync later: $e',
            tag: 'BookmarkRepository');
      }

      // Return local bookmark if upload failed
      if (local != null) {
        return Success(BookmarkModel.fromLocalJson(local), isFromCache: true);
      }

      return Error('Bookmark not found', code: ErrorCodes.notFound);
    } catch (e, stackTrace) {
      AppLogger.e('updateNotes error', tag: 'BookmarkRepository', error: e);
      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(exception.message, code: exception.code);
    }
  }

  // ================================================================
  // DELETE
  // ================================================================

  /// Delete a bookmark
  Future<Result<bool>> deleteBookmark(int bookmarkId) async {
    try {
      // Delete locally first
      await LocalStorage.deleteBookmark(bookmarkId);

      // Queue for sync
      await LocalStorage.addToSyncQueue({
        'type': 'bookmark_delete',
        'data': {
          'id': bookmarkId,
        },
        'created_at': DateTime.now().toIso8601String(),
      });

      // Try immediate delete
      try {
        final response = await _apiClient.deleteBookmark(bookmarkId);

        if (response.statusCode == 200) {
          AppLogger.i('Bookmark deleted: $bookmarkId', tag: 'BookmarkRepository');
          return const Success(true, isFromCache: false);
        }
      } catch (e) {
        AppLogger.w('Immediate delete failed, will sync later: $e',
            tag: 'BookmarkRepository');
      }

      // Even if upload failed, local delete succeeded
      return const Success(true, isFromCache: true);
    } catch (e, stackTrace) {
      AppLogger.e('deleteBookmark error', tag: 'BookmarkRepository', error: e);
      final exception = ExceptionHandler.handle(e, stackTrace);
      return Error(exception.message, code: exception.code);
    }
  }

  /// Delete bookmark by vocabulary ID
  Future<Result<bool>> deleteBookmarkByVocabularyId(int vocabularyId) async {
    final bookmark = LocalStorage.getBookmarkByVocabularyId(vocabularyId);
    if (bookmark != null && bookmark['id'] != null) {
      return await deleteBookmark(bookmark['id'] as int);
    }
    return Error('Bookmark not found', code: ErrorCodes.notFound);
  }

  // ================================================================
  // SYNC
  // ================================================================

  /// Sync bookmarks with server
  /// Called by SyncManager
  Future<void> syncBookmarks() async {
    try {
      // Get fresh bookmarks from server
      final result = await getBookmarks(limit: 100);

      result.when(
        success: (bookmarks, _) {
          AppLogger.i('Synced ${bookmarks.length} bookmarks', tag: 'BookmarkRepository');
        },
        error: (message, code, _) {
          AppLogger.w('Bookmark sync failed: $message', tag: 'BookmarkRepository');
        },
      );
    } catch (e) {
      AppLogger.e('syncBookmarks error', tag: 'BookmarkRepository', error: e);
    }
  }

  /// Merge server bookmarks with local
  Future<void> _mergeBookmarks(List<BookmarkModel> serverBookmarks) async {
    final localBookmarks = await _getLocalBookmarks();

    // Create map of server bookmarks by vocabulary_id
    final serverMap = {
      for (var b in serverBookmarks) b.vocabularyId: b,
    };

    // Merge: server data takes precedence for synced items
    for (final local in localBookmarks) {
      if (!local.isSynced) {
        // Keep unsynced local bookmarks
        continue;
      }

      final server = serverMap[local.vocabularyId];
      if (server == null) {
        // Deleted on server, remove from local
        await LocalStorage.deleteBookmark(local.id);
      }
    }

    // Add/update all server bookmarks
    for (final server in serverBookmarks) {
      await LocalStorage.saveBookmark(
        server.copyWith(isSynced: true).toLocalJson(),
      );
    }
  }

  // ================================================================
  // HELPERS
  // ================================================================

  /// Get local bookmarks
  Future<List<BookmarkModel>> _getLocalBookmarks() async {
    final bookmarksData = LocalStorage.getAllBookmarks();
    return bookmarksData
        .map((json) => BookmarkModel.fromLocalJson(json))
        .toList();
  }

  /// Load vocabulary data for bookmarks
  Future<List<BookmarkModel>> loadVocabularyForBookmarks(
    List<BookmarkModel> bookmarks,
  ) async {
    final enrichedBookmarks = <BookmarkModel>[];

    for (final bookmark in bookmarks) {
      final vocabData = LocalStorage.getVocabulary(bookmark.vocabularyId);
      if (vocabData != null) {
        final vocabulary = VocabularyModel.fromJson(vocabData);
        enrichedBookmarks.add(bookmark.copyWith(vocabulary: vocabulary));
      } else {
        enrichedBookmarks.add(bookmark);
      }
    }

    return enrichedBookmarks;
  }
}
