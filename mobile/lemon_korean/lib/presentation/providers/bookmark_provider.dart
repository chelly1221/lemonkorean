import 'package:flutter/foundation.dart';

import '../../data/models/bookmark_model.dart';
import '../../data/models/vocabulary_model.dart';
import '../../data/repositories/bookmark_repository.dart';
import '../../core/utils/app_logger.dart';

/// Bookmark Provider
/// Manages vocabulary bookmark state
class BookmarkProvider with ChangeNotifier {
  final _repository = BookmarkRepository();

  // State
  List<BookmarkModel> _bookmarks = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BookmarkModel> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get bookmarkCount => _bookmarks.length;

  // ================================================================
  // PUBLIC API
  // ================================================================

  /// Fetch all bookmarks from server
  Future<void> fetchBookmarks({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _repository.getBookmarks(limit: 100);

    result.when(
      success: (bookmarks, isFromCache) {
        _bookmarks = bookmarks;
        _isLoading = false;
        _errorMessage = null;

        AppLogger.i(
          'Fetched ${bookmarks.length} bookmarks (cache: $isFromCache)',
          tag: 'BookmarkProvider',
        );

        notifyListeners();
      },
      error: (message, code, cachedData) {
        _errorMessage = message;
        _isLoading = false;

        // Use cached data if available
        if (cachedData != null && cachedData.isNotEmpty) {
          _bookmarks = cachedData;
          AppLogger.w(
            'Using ${cachedData.length} cached bookmarks due to error',
            tag: 'BookmarkProvider',
          );
        }

        notifyListeners();
      },
    );
  }

  /// Toggle bookmark (add or remove)
  /// Returns true if bookmarked, false if unbookmarked
  Future<bool> toggleBookmark(
    VocabularyModel vocabulary, {
    String? notes,
  }) async {
    // Check if already bookmarked
    final isCurrentlyBookmarked = await _repository.isBookmarked(vocabulary.id);

    if (isCurrentlyBookmarked) {
      // Remove bookmark
      final result = await _repository.deleteBookmarkByVocabularyId(vocabulary.id);

      return result.when(
        success: (_, __) {
          // Remove from local list
          _bookmarks.removeWhere((b) => b.vocabularyId == vocabulary.id);
          notifyListeners();

          AppLogger.i('Bookmark removed: ${vocabulary.korean}', tag: 'BookmarkProvider');
          return false; // Unbookmarked
        },
        error: (message, code, _) {
          _errorMessage = message;
          AppLogger.e('Failed to remove bookmark: $message', tag: 'BookmarkProvider');
          return isCurrentlyBookmarked; // Return current state on error
        },
      );
    } else {
      // Add bookmark
      final result = await _repository.createBookmark(
        vocabulary.id,
        notes: notes,
      );

      return result.when(
        success: (bookmark, isFromCache) {
          // Add to local list with vocabulary data
          final enrichedBookmark = bookmark.copyWith(vocabulary: vocabulary);
          _bookmarks.insert(0, enrichedBookmark); // Add to top
          notifyListeners();

          AppLogger.i('Bookmark created: ${vocabulary.korean}', tag: 'BookmarkProvider');
          return true; // Bookmarked
        },
        error: (message, code, _) {
          _errorMessage = message;
          AppLogger.e('Failed to create bookmark: $message', tag: 'BookmarkProvider');
          return false; // Failed to bookmark
        },
      );
    }
  }

  /// Update bookmark notes
  Future<bool> updateNotes(int bookmarkId, String notes) async {
    final result = await _repository.updateNotes(bookmarkId, notes);

    return result.when(
      success: (updated, _) {
        // Update in local list
        final index = _bookmarks.indexWhere((b) => b.id == bookmarkId);
        if (index != -1) {
          _bookmarks[index] = updated.copyWith(
            vocabulary: _bookmarks[index].vocabulary,
          );
          notifyListeners();
        }

        AppLogger.i('Bookmark notes updated: $bookmarkId', tag: 'BookmarkProvider');
        return true;
      },
      error: (message, code, _) {
        _errorMessage = message;
        AppLogger.e('Failed to update notes: $message', tag: 'BookmarkProvider');
        return false;
      },
    );
  }

  /// Remove a bookmark
  Future<bool> removeBookmark(int bookmarkId) async {
    final result = await _repository.deleteBookmark(bookmarkId);

    return result.when(
      success: (_, __) {
        _bookmarks.removeWhere((b) => b.id == bookmarkId);
        notifyListeners();

        AppLogger.i('Bookmark removed: $bookmarkId', tag: 'BookmarkProvider');
        return true;
      },
      error: (message, code, _) {
        _errorMessage = message;
        AppLogger.e('Failed to remove bookmark: $message', tag: 'BookmarkProvider');
        return false;
      },
    );
  }

  /// Check if a vocabulary is bookmarked
  Future<bool> isBookmarked(int vocabularyId) async {
    // Check local list first (fast)
    if (_bookmarks.any((b) => b.vocabularyId == vocabularyId)) {
      return true;
    }

    // Double-check with repository (checks local storage)
    return await _repository.isBookmarked(vocabularyId);
  }

  /// Get bookmark by vocabulary ID
  BookmarkModel? getBookmarkByVocabularyId(int vocabularyId) {
    try {
      return _bookmarks.firstWhere((b) => b.vocabularyId == vocabularyId);
    } catch (e) {
      return null;
    }
  }

  /// Sync bookmarks with server
  Future<void> syncWithServer() async {
    await _repository.syncBookmarks();
    await fetchBookmarks(silent: true);
  }

  // ================================================================
  // FILTERING & SEARCH
  // ================================================================

  /// Search bookmarks by Korean, Chinese, or notes
  List<BookmarkModel> searchBookmarks(String query) {
    if (query.isEmpty) return _bookmarks;

    final lowerQuery = query.toLowerCase();
    return _bookmarks.where((bookmark) {
      final vocabulary = bookmark.vocabulary;
      if (vocabulary == null) return false;

      return vocabulary.korean.toLowerCase().contains(lowerQuery) ||
          vocabulary.chinese.toLowerCase().contains(lowerQuery) ||
          (bookmark.notes?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Filter bookmarks by mastery level
  List<BookmarkModel> getBookmarksByMastery(int? masteryLevel) {
    if (masteryLevel == null) return _bookmarks;

    return _bookmarks
        .where((b) => b.masteryLevel == masteryLevel)
        .toList();
  }

  /// Get bookmarks due for review
  List<BookmarkModel> getDueForReview() {
    return _bookmarks.where((b) => b.isDueForReview).toList();
  }

  /// Get bookmarks with notes
  List<BookmarkModel> getBookmarksWithNotes() {
    return _bookmarks.where((b) => b.hasNotes).toList();
  }

  /// Sort bookmarks
  List<BookmarkModel> getSortedBookmarks(BookmarkSortType sortType) {
    final sorted = List<BookmarkModel>.from(_bookmarks);

    switch (sortType) {
      case BookmarkSortType.dateNewest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case BookmarkSortType.dateOldest:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case BookmarkSortType.korean:
        sorted.sort((a, b) {
          final aKorean = a.vocabulary?.korean ?? '';
          final bKorean = b.vocabulary?.korean ?? '';
          return aKorean.compareTo(bKorean);
        });
        break;
      case BookmarkSortType.chinese:
        sorted.sort((a, b) {
          final aChinese = a.vocabulary?.chinese ?? '';
          final bChinese = b.vocabulary?.chinese ?? '';
          return aChinese.compareTo(bChinese);
        });
        break;
      case BookmarkSortType.mastery:
        sorted.sort((a, b) {
          final aMastery = a.masteryLevel ?? 0;
          final bMastery = b.masteryLevel ?? 0;
          return bMastery.compareTo(aMastery); // Higher mastery first
        });
        break;
    }

    return sorted;
  }

  // ================================================================
  // HELPERS
  // ================================================================

  /// Load vocabulary data for all bookmarks
  Future<void> loadVocabularyData() async {
    _bookmarks = await _repository.loadVocabularyForBookmarks(_bookmarks);
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all bookmarks (for logout/reset)
  void clear() {
    _bookmarks = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}

/// Bookmark sort types
enum BookmarkSortType {
  dateNewest,
  dateOldest,
  korean,
  chinese,
  mastery,
}
