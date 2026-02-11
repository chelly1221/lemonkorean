import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/app_constants.dart';
import '../platform/platform_factory.dart';
import '../utils/app_logger.dart';

/// Singleton Socket.IO service for real-time DM communication
class SocketService {
  static final SocketService instance = SocketService._();
  SocketService._();

  io.Socket? _socket;
  bool _isConnected = false;
  String? _currentToken;

  bool get isConnected => _isConnected;

  // Event stream controllers for reactive listening
  final _onNewMessage = StreamController<Map<String, dynamic>>.broadcast();
  final _onMessageSent = StreamController<Map<String, dynamic>>.broadcast();
  final _onTyping = StreamController<Map<String, dynamic>>.broadcast();
  final _onReadReceipt = StreamController<Map<String, dynamic>>.broadcast();
  final _onUserOnline = StreamController<Map<String, dynamic>>.broadcast();
  final _onUserOffline = StreamController<Map<String, dynamic>>.broadcast();
  final _onConversationUpdated =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onMessageDeleted =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onConnectionChanged = StreamController<bool>.broadcast();

  // Voice room event stream controllers
  final _onVoiceParticipantJoined =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceParticipantLeft =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceParticipantMuted =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceRoomClosed =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceNewMessage =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceRoleChanged =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceStageRequest =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceStageRequestCancelled =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceStageGranted =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceStageRemoved =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceCharacterPosition =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceReaction =
      StreamController<Map<String, dynamic>>.broadcast();
  final _onVoiceGesture =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onNewMessage => _onNewMessage.stream;
  Stream<Map<String, dynamic>> get onMessageSent => _onMessageSent.stream;
  Stream<Map<String, dynamic>> get onTyping => _onTyping.stream;
  Stream<Map<String, dynamic>> get onReadReceipt => _onReadReceipt.stream;
  Stream<Map<String, dynamic>> get onUserOnline => _onUserOnline.stream;
  Stream<Map<String, dynamic>> get onUserOffline => _onUserOffline.stream;
  Stream<Map<String, dynamic>> get onConversationUpdated =>
      _onConversationUpdated.stream;
  Stream<Map<String, dynamic>> get onMessageDeleted =>
      _onMessageDeleted.stream;
  Stream<bool> get onConnectionChanged => _onConnectionChanged.stream;

  // Voice room event streams
  Stream<Map<String, dynamic>> get onVoiceParticipantJoined =>
      _onVoiceParticipantJoined.stream;
  Stream<Map<String, dynamic>> get onVoiceParticipantLeft =>
      _onVoiceParticipantLeft.stream;
  Stream<Map<String, dynamic>> get onVoiceParticipantMuted =>
      _onVoiceParticipantMuted.stream;
  Stream<Map<String, dynamic>> get onVoiceRoomClosed =>
      _onVoiceRoomClosed.stream;
  Stream<Map<String, dynamic>> get onVoiceNewMessage =>
      _onVoiceNewMessage.stream;
  Stream<Map<String, dynamic>> get onVoiceRoleChanged =>
      _onVoiceRoleChanged.stream;
  Stream<Map<String, dynamic>> get onVoiceStageRequest =>
      _onVoiceStageRequest.stream;
  Stream<Map<String, dynamic>> get onVoiceStageRequestCancelled =>
      _onVoiceStageRequestCancelled.stream;
  Stream<Map<String, dynamic>> get onVoiceStageGranted =>
      _onVoiceStageGranted.stream;
  Stream<Map<String, dynamic>> get onVoiceStageRemoved =>
      _onVoiceStageRemoved.stream;
  Stream<Map<String, dynamic>> get onVoiceCharacterPosition =>
      _onVoiceCharacterPosition.stream;
  Stream<Map<String, dynamic>> get onVoiceReaction =>
      _onVoiceReaction.stream;
  Stream<Map<String, dynamic>> get onVoiceGesture =>
      _onVoiceGesture.stream;

  /// Connect to Socket.IO server with JWT token
  Future<void> connect() async {
    if (_isConnected && _socket != null) return;

    try {
      final storage = PlatformFactory.createSecureStorage();
      final token = await storage.read(key: AppConstants.tokenKey);
      if (token == null) {
        AppLogger.w('No auth token, skipping socket connection',
            tag: 'SocketService');
        return;
      }

      _currentToken = token;
      final baseUrl = AppConstants.baseUrl;

      _socket = io.io(
        baseUrl,
        io.OptionBuilder()
            .setPath('/api/sns/socket.io')
            .setTransports(['websocket', 'polling'])
            .setAuth({'token': token})
            .disableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(10)
            .build(),
      );

      _setupEventHandlers();
      _socket!.connect();
    } catch (e) {
      AppLogger.e('Socket connect error', tag: 'SocketService', error: e);
    }
  }

  void _setupEventHandlers() {
    final s = _socket!;

    s.onConnect((_) {
      _isConnected = true;
      _onConnectionChanged.add(true);
      AppLogger.i('Socket connected', tag: 'SocketService');
    });

    s.onDisconnect((_) {
      _isConnected = false;
      _onConnectionChanged.add(false);
      AppLogger.i('Socket disconnected', tag: 'SocketService');
    });

    s.onConnectError((error) {
      _isConnected = false;
      _onConnectionChanged.add(false);
      AppLogger.w('Socket connect error: $error', tag: 'SocketService');
    });

    // DM Events
    s.on('dm:new_message', (data) {
      if (data is Map) {
        _onNewMessage.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('dm:message_sent', (data) {
      if (data is Map) {
        _onMessageSent.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('dm:typing', (data) {
      if (data is Map) {
        _onTyping.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('dm:read_receipt', (data) {
      if (data is Map) {
        _onReadReceipt.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('dm:user_online', (data) {
      if (data is Map) {
        _onUserOnline.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('dm:user_offline', (data) {
      if (data is Map) {
        _onUserOffline.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('dm:conversation_updated', (data) {
      if (data is Map) {
        _onConversationUpdated.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('dm:message_deleted', (data) {
      if (data is Map) {
        _onMessageDeleted.add(Map<String, dynamic>.from(data));
      }
    });

    // Voice room events
    s.on('voice:participant_joined', (data) {
      if (data is Map) {
        _onVoiceParticipantJoined.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:participant_left', (data) {
      if (data is Map) {
        _onVoiceParticipantLeft.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:participant_muted', (data) {
      if (data is Map) {
        _onVoiceParticipantMuted.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:room_closed', (data) {
      if (data is Map) {
        _onVoiceRoomClosed.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:new_message', (data) {
      if (data is Map) {
        _onVoiceNewMessage.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:role_changed', (data) {
      if (data is Map) {
        _onVoiceRoleChanged.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:stage_request', (data) {
      if (data is Map) {
        _onVoiceStageRequest.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:stage_request_cancelled', (data) {
      if (data is Map) {
        _onVoiceStageRequestCancelled.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:stage_granted', (data) {
      if (data is Map) {
        _onVoiceStageGranted.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:stage_removed', (data) {
      if (data is Map) {
        _onVoiceStageRemoved.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:character_position', (data) {
      if (data is Map) {
        _onVoiceCharacterPosition.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:reaction', (data) {
      if (data is Map) {
        _onVoiceReaction.add(Map<String, dynamic>.from(data));
      }
    });

    s.on('voice:gesture', (data) {
      if (data is Map) {
        _onVoiceGesture.add(Map<String, dynamic>.from(data));
      }
    });
  }

  /// Join a conversation room for real-time updates
  void joinConversation(int conversationId) {
    _socket?.emit('dm:join_conversation', {'conversation_id': conversationId});
  }

  /// Leave a conversation room
  void leaveConversation(int conversationId) {
    _socket?.emit('dm:leave_conversation',
        {'conversation_id': conversationId});
  }

  /// Join a voice room socket room for real-time updates
  void joinVoiceRoom(int roomId) {
    _socket?.emit('voice:join_room', {'room_id': roomId});
  }

  /// Leave a voice room socket room
  void leaveVoiceRoom(int roomId) {
    _socket?.emit('voice:leave_room', {'room_id': roomId});
  }

  /// Send a voice chat message via socket
  void sendVoiceMessage(int roomId, String content) {
    _socket?.emit('voice:send_message', {
      'room_id': roomId,
      'content': content,
    });
  }

  /// Send character position update (stage walking)
  void sendCharacterPosition(int roomId, double x, double y, String direction) {
    _socket?.emit('voice:character_position', {
      'room_id': roomId,
      'x': x,
      'y': y,
      'direction': direction,
    });
  }

  /// Send emoji reaction
  void sendVoiceReaction(int roomId, String emoji) {
    _socket?.emit('voice:reaction', {
      'room_id': roomId,
      'emoji': emoji,
    });
  }

  /// Send character gesture (speakers only)
  void sendVoiceGesture(int roomId, String gesture) {
    _socket?.emit('voice:gesture', {
      'room_id': roomId,
      'gesture': gesture,
    });
  }

  /// Send a message via Socket.IO
  void sendMessage({
    required int conversationId,
    String messageType = 'text',
    String? content,
    String? mediaUrl,
    Map<String, dynamic>? mediaMetadata,
    String? clientMessageId,
  }) {
    _socket?.emit('dm:send_message', {
      'conversation_id': conversationId,
      'message_type': messageType,
      if (content != null) 'content': content,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (mediaMetadata != null) 'media_metadata': mediaMetadata,
      if (clientMessageId != null) 'client_message_id': clientMessageId,
    });
  }

  /// Send typing start indicator
  void startTyping(int conversationId) {
    _socket?.emit('dm:typing_start', {'conversation_id': conversationId});
  }

  /// Send typing stop indicator
  void stopTyping(int conversationId) {
    _socket?.emit('dm:typing_stop', {'conversation_id': conversationId});
  }

  /// Mark messages as read
  void markRead(int conversationId, int messageId) {
    _socket?.emit('dm:mark_read', {
      'conversation_id': conversationId,
      'message_id': messageId,
    });
  }

  /// Disconnect from Socket.IO
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _currentToken = null;
  }

  /// Dispose all stream controllers
  void dispose() {
    disconnect();
    _onNewMessage.close();
    _onMessageSent.close();
    _onTyping.close();
    _onReadReceipt.close();
    _onUserOnline.close();
    _onUserOffline.close();
    _onConversationUpdated.close();
    _onMessageDeleted.close();
    _onConnectionChanged.close();
    _onVoiceParticipantJoined.close();
    _onVoiceParticipantLeft.close();
    _onVoiceParticipantMuted.close();
    _onVoiceRoomClosed.close();
    _onVoiceNewMessage.close();
    _onVoiceRoleChanged.close();
    _onVoiceStageRequest.close();
    _onVoiceStageRequestCancelled.close();
    _onVoiceStageGranted.close();
    _onVoiceStageRemoved.close();
    _onVoiceCharacterPosition.close();
    _onVoiceReaction.close();
    _onVoiceGesture.close();
  }
}
