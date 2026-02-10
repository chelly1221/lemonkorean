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
  }
}
