import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/app_logger.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/sns_user_model.dart';

/// SNS Repository
/// Handles social network API calls. Online-only (no offline caching).
/// Uses ApiClient.instance.dio which auto-attaches JWT via interceptors.
/// All paths are relative to the base URL (e.g., /sns/posts/feed).
class SnsRepository {
  final Dio _dio = ApiClient.instance.dio;

  // ================================================================
  // POSTS - FEED & DISCOVERY
  // ================================================================

  /// Get personalized feed (posts from followed users)
  /// Returns paginated posts with cursor-based pagination
  Future<({List<PostModel> posts, String? nextCursor})> getFeed({
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/sns/posts/feed',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsData = response.data['posts'] ?? [];
        final posts = postsData
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
        final nextCursor = response.data['next_cursor'] as String?;

        return (posts: posts, nextCursor: nextCursor);
      }

      return (posts: <PostModel>[], nextCursor: null);
    } catch (e) {
      AppLogger.w('getFeed error', tag: 'SnsRepository', error: e);
      return (posts: <PostModel>[], nextCursor: null);
    }
  }

  /// Get discover feed (public posts, optionally filtered by category)
  Future<({List<PostModel> posts, String? nextCursor})> getDiscover({
    String? cursor,
    int limit = 20,
    String? category,
  }) async {
    try {
      final response = await _dio.get(
        '/sns/posts/discover',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
          if (category != null) 'category': category,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsData = response.data['posts'] ?? [];
        final posts = postsData
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
        final nextCursor = response.data['next_cursor'] as String?;

        return (posts: posts, nextCursor: nextCursor);
      }

      return (posts: <PostModel>[], nextCursor: null);
    } catch (e) {
      AppLogger.w('getDiscover error', tag: 'SnsRepository', error: e);
      return (posts: <PostModel>[], nextCursor: null);
    }
  }

  // ================================================================
  // POSTS - CRUD
  // ================================================================

  /// Get a single post by ID
  Future<PostModel?> getPostById(int postId) async {
    try {
      final response = await _dio.get('/sns/posts/$postId');

      if (response.statusCode == 200) {
        final postData = response.data['post'] as Map<String, dynamic>?;
        if (postData != null) {
          return PostModel.fromJson(postData);
        }
      }

      return null;
    } catch (e) {
      AppLogger.w('getPostById error: postId=$postId', tag: 'SnsRepository', error: e);
      return null;
    }
  }

  /// Get posts by a specific user
  Future<({List<PostModel> posts, String? nextCursor})> getPostsByUser(
    int userId, {
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/sns/posts/user/$userId',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsData = response.data['posts'] ?? [];
        final posts = postsData
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
        final nextCursor = response.data['next_cursor'] as String?;

        return (posts: posts, nextCursor: nextCursor);
      }

      return (posts: <PostModel>[], nextCursor: null);
    } catch (e) {
      AppLogger.w('getPostsByUser error: userId=$userId', tag: 'SnsRepository', error: e);
      return (posts: <PostModel>[], nextCursor: null);
    }
  }

  /// Create a new post
  Future<PostModel?> createPost({
    required String content,
    String category = 'general',
    List<String> tags = const [],
    String visibility = 'public',
    List<String> imageUrls = const [],
  }) async {
    try {
      final response = await _dio.post(
        '/sns/posts',
        data: {
          'content': content,
          'category': category,
          'tags': tags,
          'visibility': visibility,
          'image_urls': imageUrls,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final postData = response.data['post'] as Map<String, dynamic>?;
        if (postData != null) {
          AppLogger.i('Post created: ${postData['id']}', tag: 'SnsRepository');
          return PostModel.fromJson(postData);
        }
      }

      return null;
    } catch (e) {
      AppLogger.e('createPost error', tag: 'SnsRepository', error: e);
      return null;
    }
  }

  /// Delete a post
  Future<bool> deletePost(int postId) async {
    try {
      final response = await _dio.delete('/sns/posts/$postId');

      if (response.statusCode == 200) {
        AppLogger.i('Post deleted: $postId', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.e('deletePost error: postId=$postId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  // ================================================================
  // LIKES
  // ================================================================

  /// Like a post
  Future<bool> likePost(int postId) async {
    try {
      final response = await _dio.post('/sns/posts/$postId/like');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.w('likePost error: postId=$postId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  /// Unlike a post
  Future<bool> unlikePost(int postId) async {
    try {
      final response = await _dio.delete('/sns/posts/$postId/like');

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.w('unlikePost error: postId=$postId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  // ================================================================
  // COMMENTS
  // ================================================================

  /// Get comments for a post
  Future<List<CommentModel>> getComments(
    int postId, {
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/sns/posts/$postId/comments',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> commentsData = response.data['comments'] ?? [];
        return commentsData
            .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      AppLogger.w('getComments error: postId=$postId', tag: 'SnsRepository', error: e);
      return [];
    }
  }

  /// Create a comment on a post
  Future<CommentModel?> createComment(
    int postId, {
    required String content,
    int? parentId,
  }) async {
    try {
      final response = await _dio.post(
        '/sns/posts/$postId/comments',
        data: {
          'content': content,
          if (parentId != null) 'parent_id': parentId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final commentData = response.data['comment'] as Map<String, dynamic>?;
        if (commentData != null) {
          AppLogger.i('Comment created on post $postId', tag: 'SnsRepository');
          return CommentModel.fromJson(commentData);
        }
      }

      return null;
    } catch (e) {
      AppLogger.e('createComment error: postId=$postId', tag: 'SnsRepository', error: e);
      return null;
    }
  }

  /// Delete a comment
  Future<bool> deleteComment(int commentId) async {
    try {
      final response = await _dio.delete('/sns/comments/$commentId');

      if (response.statusCode == 200) {
        AppLogger.i('Comment deleted: $commentId', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.e('deleteComment error: commentId=$commentId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  // ================================================================
  // FOLLOW / UNFOLLOW
  // ================================================================

  /// Follow a user
  Future<bool> followUser(int userId) async {
    try {
      final response = await _dio.post('/sns/users/$userId/follow');

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.i('Followed user: $userId', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.w('followUser error: userId=$userId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  /// Unfollow a user
  Future<bool> unfollowUser(int userId) async {
    try {
      final response = await _dio.delete('/sns/users/$userId/follow');

      if (response.statusCode == 200) {
        AppLogger.i('Unfollowed user: $userId', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.w('unfollowUser error: userId=$userId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  /// Get followers of a user
  Future<List<SnsUserModel>> getFollowers(int userId) async {
    try {
      final response = await _dio.get('/sns/users/$userId/followers');

      if (response.statusCode == 200) {
        final List<dynamic> usersData = response.data['followers'] ?? [];
        return usersData
            .map((json) => SnsUserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      AppLogger.w('getFollowers error: userId=$userId', tag: 'SnsRepository', error: e);
      return [];
    }
  }

  /// Get users that a user is following
  Future<List<SnsUserModel>> getFollowing(int userId) async {
    try {
      final response = await _dio.get('/sns/users/$userId/following');

      if (response.statusCode == 200) {
        final List<dynamic> usersData = response.data['following'] ?? [];
        return usersData
            .map((json) => SnsUserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      AppLogger.w('getFollowing error: userId=$userId', tag: 'SnsRepository', error: e);
      return [];
    }
  }

  // ================================================================
  // PROFILES
  // ================================================================

  /// Get a user's profile
  Future<SnsUserModel?> getProfile(int userId) async {
    try {
      final response = await _dio.get('/sns/users/$userId');

      if (response.statusCode == 200) {
        final userData = response.data['user'] as Map<String, dynamic>?;
        if (userData != null) {
          return SnsUserModel.fromJson(userData);
        }
      }

      return null;
    } catch (e) {
      AppLogger.w('getProfile error: userId=$userId', tag: 'SnsRepository', error: e);
      return null;
    }
  }

  /// Update the current user's profile (bio only for now)
  Future<bool> updateProfile({String? bio}) async {
    try {
      final response = await _dio.put(
        '/sns/users/me',
        data: {
          if (bio != null) 'bio': bio,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Profile updated', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.e('updateProfile error', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  // ================================================================
  // SEARCH & SUGGESTIONS
  // ================================================================

  /// Search for users by query string
  Future<List<SnsUserModel>> searchUsers(String query) async {
    try {
      final response = await _dio.get(
        '/sns/profiles/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersData = response.data['users'] ?? [];
        return usersData
            .map((json) => SnsUserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      AppLogger.w('searchUsers error: query=$query', tag: 'SnsRepository', error: e);
      return [];
    }
  }

  /// Get suggested users to follow
  Future<List<SnsUserModel>> getSuggestedUsers() async {
    try {
      final response = await _dio.get('/sns/profiles/suggested');

      if (response.statusCode == 200) {
        final List<dynamic> usersData = response.data['users'] ?? [];
        return usersData
            .map((json) => SnsUserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      AppLogger.w('getSuggestedUsers error', tag: 'SnsRepository', error: e);
      return [];
    }
  }

  // ================================================================
  // MODERATION
  // ================================================================

  /// Report a post or comment
  Future<bool> reportContent({
    required String targetType,
    required int targetId,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '/sns/reports',
        data: {
          'target_type': targetType,
          'target_id': targetId,
          'reason': reason,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.i('Content reported: $targetType/$targetId', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.e('reportContent error: $targetType/$targetId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  /// Block a user
  Future<bool> blockUser(int userId) async {
    try {
      final response = await _dio.post('/sns/users/$userId/block');

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.i('User blocked: $userId', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.e('blockUser error: userId=$userId', tag: 'SnsRepository', error: e);
      return false;
    }
  }

  /// Unblock a user
  Future<bool> unblockUser(int userId) async {
    try {
      final response = await _dio.delete('/sns/users/$userId/block');

      if (response.statusCode == 200) {
        AppLogger.i('User unblocked: $userId', tag: 'SnsRepository');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.e('unblockUser error: userId=$userId', tag: 'SnsRepository', error: e);
      return false;
    }
  }
}
