import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/app_logger.dart';
import '../models/conversation_model.dart';
import '../models/dm_message_model.dart';

/// DM Repository - handles REST API calls for direct messaging
/// Uses ApiClient.instance.dio which auto-attaches JWT via interceptors.
class DmRepository {
  final Dio _dio = ApiClient.instance.dio;

  // ================================================================
  // CONVERSATIONS
  // ================================================================

  /// Get conversation list (most recent first)
  Future<List<ConversationModel>> getConversations({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/sns/conversations',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['conversations'] ?? [];
        return data
            .map((json) =>
                ConversationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.w('getConversations error', tag: 'DmRepository', error: e);
      return [];
    }
  }

  /// Create or get existing conversation with a user
  Future<ConversationModel?> createConversation(int otherUserId) async {
    try {
      final response = await _dio.post(
        '/sns/conversations',
        data: {'user_id': otherUserId},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['conversation'] as Map<String, dynamic>?;
        if (data != null) {
          return ConversationModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      AppLogger.e('createConversation error', tag: 'DmRepository', error: e);
      return null;
    }
  }

  /// Mark conversation as read up to message ID
  Future<bool> markRead(int conversationId, int messageId) async {
    try {
      final response = await _dio.post(
        '/sns/conversations/$conversationId/read',
        data: {'message_id': messageId},
      );
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.w('markRead error', tag: 'DmRepository', error: e);
      return false;
    }
  }

  /// Get total unread count
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get('/sns/conversations/unread-count');
      if (response.statusCode == 200) {
        return (response.data['unread_count'] ?? 0) as int;
      }
      return 0;
    } catch (e) {
      AppLogger.w('getUnreadCount error', tag: 'DmRepository', error: e);
      return 0;
    }
  }

  // ================================================================
  // MESSAGES
  // ================================================================

  /// Get message history (cursor-based, newest first)
  Future<({List<DmMessageModel> messages, int? nextCursor})> getMessages(
    int conversationId, {
    int? cursor,
    int limit = 30,
  }) async {
    try {
      final response = await _dio.get(
        '/sns/conversations/$conversationId/messages',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['messages'] ?? [];
        final messages = data
            .map((json) =>
                DmMessageModel.fromJson(json as Map<String, dynamic>))
            .toList();
        final nextCursor = response.data['next_cursor'] as int?;
        return (messages: messages, nextCursor: nextCursor);
      }

      return (messages: <DmMessageModel>[], nextCursor: null);
    } catch (e) {
      AppLogger.w('getMessages error', tag: 'DmRepository', error: e);
      return (messages: <DmMessageModel>[], nextCursor: null);
    }
  }

  /// Send message via REST (fallback when Socket.IO unavailable)
  Future<DmMessageModel?> sendMessage(
    int conversationId, {
    String messageType = 'text',
    String? content,
    String? mediaUrl,
    Map<String, dynamic>? mediaMetadata,
    String? clientMessageId,
  }) async {
    try {
      final response = await _dio.post(
        '/sns/conversations/$conversationId/messages',
        data: {
          'message_type': messageType,
          if (content != null) 'content': content,
          if (mediaUrl != null) 'media_url': mediaUrl,
          if (mediaMetadata != null) 'media_metadata': mediaMetadata,
          if (clientMessageId != null) 'client_message_id': clientMessageId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['message'] as Map<String, dynamic>?;
        if (data != null) {
          return DmMessageModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      AppLogger.e('sendMessage error', tag: 'DmRepository', error: e);
      return null;
    }
  }

  /// Delete a message
  Future<bool> deleteMessage(int messageId) async {
    try {
      final response = await _dio.delete('/sns/messages/$messageId');
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('deleteMessage error', tag: 'DmRepository', error: e);
      return false;
    }
  }

  // ================================================================
  // MEDIA UPLOAD
  // ================================================================

  /// Upload media file for DM (image or voice)
  Future<({String? mediaUrl, Map<String, dynamic>? metadata})> uploadMedia(
    List<int> fileBytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        '/sns/dm/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return (
          mediaUrl: response.data['media_url'] as String?,
          metadata:
              response.data['media_metadata'] as Map<String, dynamic>?,
        );
      }

      return (mediaUrl: null, metadata: null);
    } catch (e) {
      AppLogger.e('uploadMedia error', tag: 'DmRepository', error: e);
      return (mediaUrl: null, metadata: null);
    }
  }
}
