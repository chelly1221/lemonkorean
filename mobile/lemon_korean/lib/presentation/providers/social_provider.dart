import 'package:flutter/foundation.dart';

import '../../core/utils/app_logger.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/sns_user_model.dart';
import '../../data/repositories/sns_repository.dart';

/// Social Provider
/// Manages user profiles, follows, search, comments, and moderation
class SocialProvider with ChangeNotifier {
  final _repository = SnsRepository();

  // Search state
  List<SnsUserModel> _searchResults = [];
  bool _isSearching = false;

  // Suggested users state
  List<SnsUserModel> _suggestedUsers = [];

  // Profile state
  SnsUserModel? _viewingProfile;
  bool _isLoadingProfile = false;

  // Followers / Following state
  List<SnsUserModel> _followers = [];
  List<SnsUserModel> _following = [];

  // Comments state
  List<CommentModel> _comments = [];
  bool _isLoadingComments = false;

  // Follow toggle tracking (for UI loading states)
  final Set<int> _togglingUserIds = {};

  // Local follow state overrides (for optimistic updates across screens)
  final Map<int, bool> _followOverrides = {};

  // General loading & error state
  bool _isLoading = false;
  String? _errorMessage;

  // Getters - Search
  List<SnsUserModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  // Getters - Suggested
  List<SnsUserModel> get suggestedUsers => _suggestedUsers;

  // Getters - Profile
  SnsUserModel? get viewingProfile => _viewingProfile;
  bool get isLoadingProfile => _isLoadingProfile;

  // Getters - Followers / Following
  List<SnsUserModel> get followers => _followers;
  List<SnsUserModel> get following => _following;

  // Getters - Comments
  List<CommentModel> get comments => _comments;
  bool get isLoadingComments => _isLoadingComments;

  // Getters - General
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Check if a user is being followed (from local override or profile/lists)
  bool? isFollowing(int userId) {
    if (_followOverrides.containsKey(userId)) {
      return _followOverrides[userId];
    }
    if (_viewingProfile != null && _viewingProfile!.id == userId) {
      return _viewingProfile!.isFollowing;
    }
    final inSearch = _searchResults.where((u) => u.id == userId);
    if (inSearch.isNotEmpty) return inSearch.first.isFollowing;
    final inSuggested = _suggestedUsers.where((u) => u.id == userId);
    if (inSuggested.isNotEmpty) return inSuggested.first.isFollowing;
    return null;
  }

  /// Check if a follow toggle is in progress for a user
  bool isToggling(int userId) => _togglingUserIds.contains(userId);

  /// Get a user profile (returns Future<SnsUserModel?> for direct use)
  Future<SnsUserModel?> getUserProfile(int userId) async {
    try {
      return await _repository.getProfile(userId);
    } catch (e) {
      AppLogger.e('getUserProfile error: userId=$userId', tag: 'SocialProvider', error: e);
      return null;
    }
  }

  /// Get suggested users (returns list for direct use)
  Future<List<SnsUserModel>> getSuggestedUsers() async {
    try {
      final users = await _repository.getSuggestedUsers();
      _suggestedUsers = users;
      notifyListeners();
      return users;
    } catch (e) {
      AppLogger.e('getSuggestedUsers error', tag: 'SocialProvider', error: e);
      return [];
    }
  }

  /// Search users (returns list for direct use)
  Future<List<SnsUserModel>> searchUsersQuery(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final results = await _repository.searchUsers(query);
      _searchResults = results;
      notifyListeners();
      return results;
    } catch (e) {
      AppLogger.e('searchUsersQuery error', tag: 'SocialProvider', error: e);
      return [];
    }
  }

  // ================================================================
  // SEARCH
  // ================================================================

  /// Search for users by query
  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchUsers(query);
      AppLogger.d('Search found ${_searchResults.length} users for "$query"', tag: 'SocialProvider');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('searchUsers error', tag: 'SocialProvider', error: e);
    }

    _isSearching = false;
    notifyListeners();
  }

  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  // ================================================================
  // SUGGESTED USERS
  // ================================================================

  /// Load suggested users to follow
  Future<void> loadSuggestedUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _suggestedUsers = await _repository.getSuggestedUsers();
      AppLogger.d('Loaded ${_suggestedUsers.length} suggested users', tag: 'SocialProvider');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('loadSuggestedUsers error', tag: 'SocialProvider', error: e);
    }

    _isLoading = false;
    notifyListeners();
  }

  // ================================================================
  // PROFILE
  // ================================================================

  /// Load a user's profile
  Future<void> loadProfile(int userId) async {
    _isLoadingProfile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _viewingProfile = await _repository.getProfile(userId);

      if (_viewingProfile == null) {
        _errorMessage = 'User not found';
      }

      AppLogger.d('Loaded profile: userId=$userId', tag: 'SocialProvider');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('loadProfile error: userId=$userId', tag: 'SocialProvider', error: e);
    }

    _isLoadingProfile = false;
    notifyListeners();
  }

  /// Clear viewing profile
  void clearProfile() {
    _viewingProfile = null;
    _followers = [];
    _following = [];
    notifyListeners();
  }

  // ================================================================
  // FOLLOW / UNFOLLOW
  // ================================================================

  /// Toggle follow state (optimistic update)
  Future<void> toggleFollow(int userId) async {
    if (_togglingUserIds.contains(userId)) return;

    _togglingUserIds.add(userId);
    notifyListeners();

    // Find user in various lists
    SnsUserModel? targetUser;
    int? profileMatch;
    int searchIndex = -1;
    int suggestedIndex = -1;
    int followerIndex = -1;
    int followingIndex = -1;

    // Check if viewing profile matches
    if (_viewingProfile != null && _viewingProfile!.id == userId) {
      targetUser = _viewingProfile;
      profileMatch = userId;
    }

    // Check search results
    searchIndex = _searchResults.indexWhere((u) => u.id == userId);
    if (searchIndex != -1) {
      targetUser ??= _searchResults[searchIndex];
    }

    // Check suggested users
    suggestedIndex = _suggestedUsers.indexWhere((u) => u.id == userId);
    if (suggestedIndex != -1) {
      targetUser ??= _suggestedUsers[suggestedIndex];
    }

    // Check followers list
    followerIndex = _followers.indexWhere((u) => u.id == userId);
    if (followerIndex != -1) {
      targetUser ??= _followers[followerIndex];
    }

    // Check following list
    followingIndex = _following.indexWhere((u) => u.id == userId);
    if (followingIndex != -1) {
      targetUser ??= _following[followingIndex];
    }

    if (targetUser == null) {
      _togglingUserIds.remove(userId);
      notifyListeners();
      return;
    }

    final wasFollowing = targetUser.isFollowing;
    final followerDelta = wasFollowing ? -1 : 1;

    // Optimistic update
    final updatedUser = targetUser.copyWith(
      isFollowing: !wasFollowing,
      followerCount: targetUser.followerCount + followerDelta < 0
          ? 0
          : targetUser.followerCount + followerDelta,
    );

    _followOverrides[userId] = !wasFollowing;
    _applyUserUpdate(updatedUser, profileMatch, searchIndex, suggestedIndex, followerIndex, followingIndex);
    notifyListeners();

    // Make API call
    bool success;
    if (wasFollowing) {
      success = await _repository.unfollowUser(userId);
    } else {
      success = await _repository.followUser(userId);
    }

    // Revert on failure
    if (!success) {
      _followOverrides[userId] = wasFollowing;
      _applyUserUpdate(targetUser, profileMatch, searchIndex, suggestedIndex, followerIndex, followingIndex);
      AppLogger.w('toggleFollow failed, reverted: userId=$userId', tag: 'SocialProvider');
    }

    _togglingUserIds.remove(userId);
    notifyListeners();
  }

  /// Apply a user update across all relevant lists
  void _applyUserUpdate(
    SnsUserModel user,
    int? profileMatch,
    int searchIndex,
    int suggestedIndex,
    int followerIndex,
    int followingIndex,
  ) {
    if (profileMatch != null) {
      _viewingProfile = user;
    }
    if (searchIndex != -1 && searchIndex < _searchResults.length) {
      _searchResults[searchIndex] = user;
    }
    if (suggestedIndex != -1 && suggestedIndex < _suggestedUsers.length) {
      _suggestedUsers[suggestedIndex] = user;
    }
    if (followerIndex != -1 && followerIndex < _followers.length) {
      _followers[followerIndex] = user;
    }
    if (followingIndex != -1 && followingIndex < _following.length) {
      _following[followingIndex] = user;
    }
  }

  // ================================================================
  // FOLLOWERS / FOLLOWING
  // ================================================================

  /// Load followers of a user
  Future<void> loadFollowers(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _followers = await _repository.getFollowers(userId);
      AppLogger.d('Loaded ${_followers.length} followers for userId=$userId', tag: 'SocialProvider');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('loadFollowers error: userId=$userId', tag: 'SocialProvider', error: e);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load following list of a user
  Future<void> loadFollowing(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _following = await _repository.getFollowing(userId);
      AppLogger.d('Loaded ${_following.length} following for userId=$userId', tag: 'SocialProvider');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('loadFollowing error: userId=$userId', tag: 'SocialProvider', error: e);
    }

    _isLoading = false;
    notifyListeners();
  }

  // ================================================================
  // COMMENTS
  // ================================================================

  /// Load comments for a post
  Future<void> loadComments(int postId) async {
    _isLoadingComments = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _comments = await _repository.getComments(postId);
      AppLogger.d('Loaded ${_comments.length} comments for postId=$postId', tag: 'SocialProvider');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('loadComments error: postId=$postId', tag: 'SocialProvider', error: e);
    }

    _isLoadingComments = false;
    notifyListeners();
  }

  /// Create a comment on a post, returns the created comment or null
  Future<CommentModel?> createComment(int postId, {required String content, int? parentId}) async {
    _errorMessage = null;

    try {
      final comment = await _repository.createComment(
        postId,
        content: content,
        parentId: parentId,
      );

      if (comment != null) {
        _comments = [..._comments, comment];
        notifyListeners();
        AppLogger.i('Comment created on post $postId', tag: 'SocialProvider');
        return comment;
      }

      _errorMessage = 'Failed to create comment';
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('createComment error: postId=$postId', tag: 'SocialProvider', error: e);
      notifyListeners();
      return null;
    }
  }

  /// Delete a comment
  Future<bool> deleteComment(int commentId) async {
    _errorMessage = null;

    try {
      final success = await _repository.deleteComment(commentId);

      if (success) {
        _comments = _comments.where((c) => c.id != commentId).toList();
        notifyListeners();
        AppLogger.i('Comment deleted: $commentId', tag: 'SocialProvider');
        return true;
      }

      _errorMessage = 'Failed to delete comment';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('deleteComment error: commentId=$commentId', tag: 'SocialProvider', error: e);
      notifyListeners();
      return false;
    }
  }

  /// Clear comments (e.g., when leaving a post detail view)
  void clearComments() {
    _comments = [];
    notifyListeners();
  }

  // ================================================================
  // MODERATION
  // ================================================================

  /// Report content (post or comment)
  Future<bool> reportContent({
    required String targetType,
    required int targetId,
    required String reason,
  }) async {
    _errorMessage = null;

    try {
      final success = await _repository.reportContent(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
      );

      if (!success) {
        _errorMessage = 'Failed to submit report';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('reportContent error: $targetType/$targetId', tag: 'SocialProvider', error: e);
      notifyListeners();
      return false;
    }
  }

  /// Block a user
  Future<bool> blockUser(int userId) async {
    _errorMessage = null;

    try {
      final success = await _repository.blockUser(userId);

      if (success) {
        // Remove user from all lists
        _searchResults = _searchResults.where((u) => u.id != userId).toList();
        _suggestedUsers = _suggestedUsers.where((u) => u.id != userId).toList();
        _followers = _followers.where((u) => u.id != userId).toList();
        _following = _following.where((u) => u.id != userId).toList();

        if (_viewingProfile?.id == userId) {
          _viewingProfile = null;
        }

        notifyListeners();
        AppLogger.i('User blocked: $userId', tag: 'SocialProvider');
        return true;
      }

      _errorMessage = 'Failed to block user';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('blockUser error: userId=$userId', tag: 'SocialProvider', error: e);
      notifyListeners();
      return false;
    }
  }

  /// Unblock a user
  Future<bool> unblockUser(int userId) async {
    _errorMessage = null;

    try {
      final success = await _repository.unblockUser(userId);

      if (!success) {
        _errorMessage = 'Failed to unblock user';
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.e('unblockUser error: userId=$userId', tag: 'SocialProvider', error: e);
      notifyListeners();
      return false;
    }
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
    _searchResults = [];
    _suggestedUsers = [];
    _viewingProfile = null;
    _followers = [];
    _following = [];
    _comments = [];
    _isSearching = false;
    _isLoading = false;
    _isLoadingProfile = false;
    _isLoadingComments = false;
    _errorMessage = null;
    notifyListeners();
  }
}
