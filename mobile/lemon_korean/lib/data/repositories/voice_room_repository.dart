import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/app_logger.dart';
import '../models/voice_room_model.dart';

/// Voice Room Repository - REST API calls for voice chat rooms
class VoiceRoomRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// Get active voice rooms
  Future<List<VoiceRoomModel>> getActiveRooms({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/sns/voice-rooms',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['rooms'] ?? [];
        return data
            .map((json) =>
                VoiceRoomModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.w('getActiveRooms error', tag: 'VoiceRoomRepo', error: e);
      return [];
    }
  }

  /// Create a voice room (creator auto-joins as speaker)
  Future<
      ({
        VoiceRoomModel? room,
        String? livekitToken,
        String? livekitUrl,
        String? role,
        List<VoiceParticipantModel> speakers,
      })> createRoom({
    required String title,
    String? topic,
    String languageLevel = 'all',
    int maxSpeakers = 4,
  }) async {
    try {
      final response = await _dio.post(
        '/sns/voice-rooms',
        data: {
          'title': title,
          if (topic != null) 'topic': topic,
          'language_level': languageLevel,
          'max_speakers': maxSpeakers,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final roomData = response.data['room'] as Map<String, dynamic>?;
        final speakersData = response.data['speakers'] as List<dynamic>? ?? [];
        return (
          room: roomData != null ? VoiceRoomModel.fromJson(roomData) : null,
          livekitToken: response.data['livekit_token'] as String?,
          livekitUrl: response.data['livekit_url'] as String?,
          role: response.data['role'] as String?,
          speakers: speakersData
              .map((s) =>
                  VoiceParticipantModel.fromJson(s as Map<String, dynamic>))
              .toList(),
        );
      }
      return (
        room: null,
        livekitToken: null,
        livekitUrl: null,
        role: null,
        speakers: <VoiceParticipantModel>[],
      );
    } catch (e) {
      AppLogger.e('createRoom error', tag: 'VoiceRoomRepo', error: e);
      return (
        room: null,
        livekitToken: null,
        livekitUrl: null,
        role: null,
        speakers: <VoiceParticipantModel>[],
      );
    }
  }

  /// Get room details with speakers/listeners/pending requests
  Future<
      ({
        VoiceRoomModel? room,
        List<VoiceParticipantModel> speakers,
        List<VoiceParticipantModel> listeners,
        List<StageRequestModel> pendingRequests,
      })> getRoom(int roomId) async {
    try {
      final response = await _dio.get('/sns/voice-rooms/$roomId');

      if (response.statusCode == 200) {
        final roomData = response.data['room'] as Map<String, dynamic>?;
        final speakersData = response.data['speakers'] as List<dynamic>? ?? [];
        final listenersData =
            response.data['listeners'] as List<dynamic>? ?? [];
        final requestsData =
            response.data['pending_requests'] as List<dynamic>? ?? [];

        return (
          room: roomData != null ? VoiceRoomModel.fromJson(roomData) : null,
          speakers: speakersData
              .map((s) =>
                  VoiceParticipantModel.fromJson(s as Map<String, dynamic>))
              .toList(),
          listeners: listenersData
              .map((l) =>
                  VoiceParticipantModel.fromJson(l as Map<String, dynamic>))
              .toList(),
          pendingRequests: requestsData
              .map((r) =>
                  StageRequestModel.fromJson(r as Map<String, dynamic>))
              .toList(),
        );
      }
      return (
        room: null,
        speakers: <VoiceParticipantModel>[],
        listeners: <VoiceParticipantModel>[],
        pendingRequests: <StageRequestModel>[],
      );
    } catch (e) {
      AppLogger.w('getRoom error', tag: 'VoiceRoomRepo', error: e);
      return (
        room: null,
        speakers: <VoiceParticipantModel>[],
        listeners: <VoiceParticipantModel>[],
        pendingRequests: <StageRequestModel>[],
      );
    }
  }

  /// Join a voice room as listener, returns LiveKit token
  Future<({String? livekitToken, String? livekitUrl, String? role, String? error})>
      joinRoom(int roomId) async {
    try {
      final response = await _dio.post('/sns/voice-rooms/$roomId/join');

      if (response.statusCode == 200) {
        return (
          livekitToken: response.data['livekit_token'] as String?,
          livekitUrl: response.data['livekit_url'] as String?,
          role: response.data['role'] as String?,
          error: null,
        );
      }
      return (livekitToken: null, livekitUrl: null, role: null, error: 'Failed to join');
    } catch (e) {
      final message = e is DioException
          ? (e.response?.data?['error']?.toString() ?? e.message)
          : e.toString();
      AppLogger.e('joinRoom error', tag: 'VoiceRoomRepo', error: e);
      return (livekitToken: null, livekitUrl: null, role: null, error: message);
    }
  }

  /// Leave a voice room
  Future<bool> leaveRoom(int roomId) async {
    try {
      final response = await _dio.post('/sns/voice-rooms/$roomId/leave');
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('leaveRoom error', tag: 'VoiceRoomRepo', error: e);
      return false;
    }
  }

  /// Close a room (creator only)
  Future<bool> closeRoom(int roomId) async {
    try {
      final response = await _dio.delete('/sns/voice-rooms/$roomId');
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('closeRoom error', tag: 'VoiceRoomRepo', error: e);
      return false;
    }
  }

  /// Toggle mute
  Future<bool?> toggleMute(int roomId) async {
    try {
      final response = await _dio.post('/sns/voice-rooms/$roomId/mute');
      if (response.statusCode == 200) {
        return response.data['is_muted'] as bool?;
      }
      return null;
    } catch (e) {
      AppLogger.e('toggleMute error', tag: 'VoiceRoomRepo', error: e);
      return null;
    }
  }

  /// Get chat messages for a room
  Future<List<VoiceChatMessageModel>> getMessages(int roomId,
      {int limit = 50, int? before}) async {
    try {
      final response = await _dio.get(
        '/sns/voice-rooms/$roomId/messages',
        queryParameters: {
          'limit': limit,
          if (before != null) 'before': before,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['messages'] ?? [];
        return data
            .map((json) =>
                VoiceChatMessageModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.w('getMessages error', tag: 'VoiceRoomRepo', error: e);
      return [];
    }
  }

  /// Send a chat message
  Future<VoiceChatMessageModel?> sendMessage(int roomId, String content) async {
    try {
      final response = await _dio.post(
        '/sns/voice-rooms/$roomId/messages',
        data: {'content': content},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final msgData = response.data['message'] as Map<String, dynamic>?;
        return msgData != null
            ? VoiceChatMessageModel.fromJson(msgData)
            : null;
      }
      return null;
    } catch (e) {
      AppLogger.e('sendMessage error', tag: 'VoiceRoomRepo', error: e);
      return null;
    }
  }

  /// Request to join stage (raise hand)
  Future<bool> requestStage(int roomId) async {
    try {
      final response =
          await _dio.post('/sns/voice-rooms/$roomId/request-stage');
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('requestStage error', tag: 'VoiceRoomRepo', error: e);
      return false;
    }
  }

  /// Cancel own stage request
  Future<bool> cancelStageRequest(int roomId) async {
    try {
      final response =
          await _dio.delete('/sns/voice-rooms/$roomId/request-stage');
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('cancelStageRequest error', tag: 'VoiceRoomRepo', error: e);
      return false;
    }
  }

  /// Grant stage access (creator only)
  Future<({bool success, String? livekitToken})> grantStage(
      int roomId, int userId) async {
    try {
      final response = await _dio.post(
        '/sns/voice-rooms/$roomId/grant-stage',
        data: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        return (
          success: true,
          livekitToken: response.data['livekit_token'] as String?,
        );
      }
      return (success: false, livekitToken: null);
    } catch (e) {
      AppLogger.e('grantStage error', tag: 'VoiceRoomRepo', error: e);
      return (success: false, livekitToken: null);
    }
  }

  /// Remove from stage (creator only)
  Future<bool> removeFromStage(int roomId, int userId) async {
    try {
      final response = await _dio.post(
        '/sns/voice-rooms/$roomId/remove-from-stage',
        data: {'user_id': userId},
      );
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('removeFromStage error', tag: 'VoiceRoomRepo', error: e);
      return false;
    }
  }

  /// Leave stage voluntarily (demote self to listener)
  Future<({bool success, String? livekitToken, String? livekitUrl})>
      leaveStage(int roomId) async {
    try {
      final response =
          await _dio.post('/sns/voice-rooms/$roomId/leave-stage');

      if (response.statusCode == 200) {
        return (
          success: true,
          livekitToken: response.data['livekit_token'] as String?,
          livekitUrl: response.data['livekit_url'] as String?,
        );
      }
      return (success: false, livekitToken: null, livekitUrl: null);
    } catch (e) {
      AppLogger.e('leaveStage error', tag: 'VoiceRoomRepo', error: e);
      return (success: false, livekitToken: null, livekitUrl: null);
    }
  }

  /// Kick a participant from the room (creator only)
  Future<bool> kickParticipant(int roomId, int userId) async {
    try {
      final response = await _dio.post(
        '/sns/voice-rooms/$roomId/kick',
        data: {'user_id': userId},
      );
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('kickParticipant error', tag: 'VoiceRoomRepo', error: e);
      return false;
    }
  }

  /// Invite a listener to stage (creator only)
  Future<bool> inviteToStage(int roomId, int userId) async {
    try {
      final response = await _dio.post(
        '/sns/voice-rooms/$roomId/invite-to-stage',
        data: {'user_id': userId},
      );
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('inviteToStage error', tag: 'VoiceRoomRepo', error: e);
      return false;
    }
  }
}
