import 'package:flutter/foundation.dart';

import '../../core/utils/app_logger.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/sns_repository.dart';

/// Feed Provider
/// Manages feed and discover post state with cursor-based pagination
class FeedProvider with ChangeNotifier {
  final _repository = SnsRepository();

  // Feed state
  List<PostModel> _feedPosts = [];
  bool _isLoadingFeed = false;
  String? _feedCursor;
  bool _hasMoreFeed = true;

  // Discover state
  List<PostModel> _discoverPosts = [];
  bool _isLoadingDiscover = false;
  String? _discoverCursor;
  bool _hasMoreDiscover = true;
  String? _selectedCategory;

  // Error state
  String? _errorMessage;

  // Getters - Feed
  List<PostModel> get feedPosts => _feedPosts;
  bool get isLoadingFeed => _isLoadingFeed;
  bool get hasMoreFeed => _hasMoreFeed;

  // Getters - Discover
  List<PostModel> get discoverPosts => _discoverPosts;
  bool get isLoadingDiscover => _isLoadingDiscover;
  bool get hasMoreDiscover => _hasMoreDiscover;
  String? get selectedCategory => _selectedCategory;

  // Getters - Error
  String? get errorMessage => _errorMessage;

  // ================================================================
  // FEED
  // ================================================================

  /// Load feed posts. If refresh is true, resets pagination.
  Future<void> loadFeed({bool refresh = false}) async {
    if (_isLoadingFeed) return;

    if (refresh) {
      _feedCursor = null;
      _hasMoreFeed = true;
    }

    if (!_hasMoreFeed && !refresh) return;

    _isLoadingFeed = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getFeed(
        cursor: _feedCursor,
        limit: 20,
      );

      if (refresh) {
        _feedPosts = result.posts;
      } else {
        _feedPosts = [..._feedPosts, ...result.posts];
      }

      _feedCursor = result.nextCursor;
      _hasMoreFeed = result.nextCursor != null && result.posts.isNotEmpty;

      AppLogger.d(
        'Feed loaded: ${result.posts.length} posts, hasMore=$_hasMoreFeed',
        tag: 'FeedProvider',
      );
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('loadFeed error', tag: 'FeedProvider', error: e);
    }

    _isLoadingFeed = false;
    notifyListeners();
  }

  /// Load more feed posts (pagination)
  Future<void> loadMoreFeed() async {
    if (_isLoadingFeed || !_hasMoreFeed) return;
    await loadFeed();
  }

  // ================================================================
  // DISCOVER
  // ================================================================

  /// Load discover posts. If refresh is true, resets pagination.
  /// Optionally filter by category.
  Future<void> loadDiscover({bool refresh = false, String? category}) async {
    if (_isLoadingDiscover) return;

    // If category changed, treat as refresh
    if (category != null && category != _selectedCategory) {
      refresh = true;
      _selectedCategory = category;
    }

    if (refresh) {
      _discoverCursor = null;
      _hasMoreDiscover = true;
    }

    if (!_hasMoreDiscover && !refresh) return;

    _isLoadingDiscover = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getDiscover(
        cursor: _discoverCursor,
        limit: 20,
        category: _selectedCategory,
      );

      if (refresh) {
        _discoverPosts = result.posts;
      } else {
        _discoverPosts = [..._discoverPosts, ...result.posts];
      }

      _discoverCursor = result.nextCursor;
      _hasMoreDiscover = result.nextCursor != null && result.posts.isNotEmpty;

      AppLogger.d(
        'Discover loaded: ${result.posts.length} posts, category=$_selectedCategory, hasMore=$_hasMoreDiscover',
        tag: 'FeedProvider',
      );
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('loadDiscover error', tag: 'FeedProvider', error: e);
    }

    _isLoadingDiscover = false;
    notifyListeners();
  }

  /// Load more discover posts (pagination)
  Future<void> loadMoreDiscover() async {
    if (_isLoadingDiscover || !_hasMoreDiscover) return;
    await loadDiscover();
  }

  // ================================================================
  // POST ACTIONS
  // ================================================================

  /// Create a new post and prepend to feed
  Future<PostModel?> createPost({
    required String content,
    String category = 'general',
    List<String> tags = const [],
    String visibility = 'public',
    List<String> imageUrls = const [],
  }) async {
    _errorMessage = null;

    try {
      final post = await _repository.createPost(
        content: content,
        category: category,
        tags: tags,
        visibility: visibility,
        imageUrls: imageUrls,
      );

      if (post != null) {
        // Prepend to feed
        _feedPosts = [post, ..._feedPosts];

        // Also add to discover if public
        if (post.isPublic) {
          _discoverPosts = [post, ..._discoverPosts];
        }

        notifyListeners();
        AppLogger.i('Post created and added to feed: ${post.id}', tag: 'FeedProvider');
        return post;
      }

      _errorMessage = 'Failed to create post';
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('createPost error', tag: 'FeedProvider', error: e);
      notifyListeners();
      return null;
    }
  }

  /// Delete a post and remove from both lists
  Future<bool> deletePost(int postId) async {
    _errorMessage = null;

    try {
      final success = await _repository.deletePost(postId);

      if (success) {
        _feedPosts = _feedPosts.where((p) => p.id != postId).toList();
        _discoverPosts = _discoverPosts.where((p) => p.id != postId).toList();
        notifyListeners();
        AppLogger.i('Post deleted from feed: $postId', tag: 'FeedProvider');
        return true;
      }

      _errorMessage = 'Failed to delete post';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('deletePost error', tag: 'FeedProvider', error: e);
      notifyListeners();
      return false;
    }
  }

  /// Toggle like on a post (optimistic update)
  Future<void> toggleLike(int postId) async {
    // Find the post in both lists
    final feedIndex = _feedPosts.indexWhere((p) => p.id == postId);
    final discoverIndex = _discoverPosts.indexWhere((p) => p.id == postId);

    PostModel? targetPost;
    if (feedIndex != -1) {
      targetPost = _feedPosts[feedIndex];
    } else if (discoverIndex != -1) {
      targetPost = _discoverPosts[discoverIndex];
    }

    if (targetPost == null) return;

    final wasLiked = targetPost.isLiked;
    final newLikeCount = wasLiked
        ? targetPost.likeCount - 1
        : targetPost.likeCount + 1;

    // Optimistic update
    final updatedPost = targetPost.copyWith(
      isLiked: !wasLiked,
      likeCount: newLikeCount < 0 ? 0 : newLikeCount,
    );

    if (feedIndex != -1) {
      _feedPosts[feedIndex] = updatedPost;
    }
    if (discoverIndex != -1) {
      _discoverPosts[discoverIndex] = updatedPost;
    }
    notifyListeners();

    // Make API call
    bool success;
    if (wasLiked) {
      success = await _repository.unlikePost(postId);
    } else {
      success = await _repository.likePost(postId);
    }

    // Revert on failure
    if (!success) {
      if (feedIndex != -1) {
        _feedPosts[feedIndex] = targetPost;
      }
      if (discoverIndex != -1) {
        _discoverPosts[discoverIndex] = targetPost;
      }
      notifyListeners();
      AppLogger.w('toggleLike failed, reverted: postId=$postId', tag: 'FeedProvider');
    }
  }

  /// Update comment count for a post (called after adding/deleting a comment)
  void updateCommentCount(int postId, int delta) {
    final feedIndex = _feedPosts.indexWhere((p) => p.id == postId);
    final discoverIndex = _discoverPosts.indexWhere((p) => p.id == postId);

    if (feedIndex != -1) {
      final post = _feedPosts[feedIndex];
      final newCount = post.commentCount + delta;
      _feedPosts[feedIndex] = post.copyWith(
        commentCount: newCount < 0 ? 0 : newCount,
      );
    }
    if (discoverIndex != -1) {
      final post = _discoverPosts[discoverIndex];
      final newCount = post.commentCount + delta;
      _discoverPosts[discoverIndex] = post.copyWith(
        commentCount: newCount < 0 ? 0 : newCount,
      );
    }

    if (feedIndex != -1 || discoverIndex != -1) {
      notifyListeners();
    }
  }

  // ================================================================
  // REFRESH
  // ================================================================

  /// Refresh both feed and discover
  Future<void> refreshAll() async {
    await Future.wait([
      loadFeed(refresh: true),
      loadDiscover(refresh: true),
    ]);
  }

  // ================================================================
  // HELPERS
  // ================================================================

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all state (for logout/reset)
  void clear() {
    _feedPosts = [];
    _discoverPosts = [];
    _isLoadingFeed = false;
    _isLoadingDiscover = false;
    _feedCursor = null;
    _discoverCursor = null;
    _hasMoreFeed = true;
    _hasMoreDiscover = true;
    _selectedCategory = null;
    _errorMessage = null;
    notifyListeners();
  }
}
