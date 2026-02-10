import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/socket_service.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/dm_message_model.dart';
import '../../data/repositories/dm_repository.dart';

/// Provider for DM state management
class DmProvider with ChangeNotifier {
  final DmRepository _repository = DmRepository();
  final SocketService _socket = SocketService.instance;
  final _uuid = const Uuid();

  // State
  List<ConversationModel> _conversations = [];
  Map<int, List<DmMessageModel>> _messageCache = {};
  int _totalUnreadCount = 0;
  bool _isLoadingConversations = false;
  bool _isLoadingMessages = false;
  int? _activeConversationId;
  Map<int, bool> _typingUsers = {};

  // Stream subscriptions
  final List<StreamSubscription> _subscriptions = [];

  // Getters
  List<ConversationModel> get conversations => _conversations;
  int get totalUnreadCount => _totalUnreadCount;
  bool get isLoadingConversations => _isLoadingConversations;
  bool get isLoadingMessages => _isLoadingMessages;
  int? get activeConversationId => _activeConversationId;
  bool isUserTyping(int userId) => _typingUsers[userId] ?? false;

  List<DmMessageModel> getMessages(int conversationId) {
    return _messageCache[conversationId] ?? [];
  }

  DmProvider() {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    _subscriptions.add(
      _socket.onNewMessage.listen(_handleNewMessage),
    );
    _subscriptions.add(
      _socket.onMessageSent.listen(_handleMessageSent),
    );
    _subscriptions.add(
      _socket.onTyping.listen(_handleTyping),
    );
    _subscriptions.add(
      _socket.onReadReceipt.listen(_handleReadReceipt),
    );
    _subscriptions.add(
      _socket.onConversationUpdated.listen(_handleConversationUpdated),
    );
    _subscriptions.add(
      _socket.onMessageDeleted.listen(_handleMessageDeleted),
    );
  }

  // ================================================================
  // CONVERSATIONS
  // ================================================================

  /// Load conversation list
  Future<void> loadConversations({bool refresh = false}) async {
    if (_isLoadingConversations) return;
    _isLoadingConversations = true;
    notifyListeners();

    try {
      _conversations = await _repository.getConversations();
      _totalUnreadCount = await _repository.getUnreadCount();
    } catch (e) {
      AppLogger.e('loadConversations error', tag: 'DmProvider', error: e);
    } finally {
      _isLoadingConversations = false;
      notifyListeners();
    }
  }

  /// Load only unread count (lightweight)
  Future<void> refreshUnreadCount() async {
    try {
      _totalUnreadCount = await _repository.getUnreadCount();
      notifyListeners();
    } catch (e) {
      AppLogger.w('refreshUnreadCount error', tag: 'DmProvider', error: e);
    }
  }

  /// Create or get conversation with a user, returns conversation ID
  Future<int?> openConversation(int otherUserId) async {
    try {
      final conversation = await _repository.createConversation(otherUserId);
      if (conversation != null) {
        // Add to list if not already there
        if (!_conversations.any((c) => c.id == conversation.id)) {
          _conversations.insert(0, conversation);
          notifyListeners();
        }
        return conversation.id;
      }
      return null;
    } catch (e) {
      AppLogger.e('openConversation error', tag: 'DmProvider', error: e);
      return null;
    }
  }

  // ================================================================
  // MESSAGES
  // ================================================================

  /// Load messages for a conversation
  Future<void> loadMessages(int conversationId, {bool refresh = false}) async {
    if (_isLoadingMessages && !refresh) return;
    _isLoadingMessages = true;
    _activeConversationId = conversationId;
    notifyListeners();

    try {
      // Join socket room
      _socket.joinConversation(conversationId);

      final result = await _repository.getMessages(conversationId);
      // Messages come newest-first, reverse for display (oldest at top)
      _messageCache[conversationId] = result.messages.reversed.toList();

      // Mark as read
      if (result.messages.isNotEmpty) {
        final latestId = result.messages.first.id;
        if (latestId != null) {
          _socket.markRead(conversationId, latestId);
          await _repository.markRead(conversationId, latestId);
          // Update unread in conversation list
          _updateConversationUnread(conversationId, 0);
        }
      }
    } catch (e) {
      AppLogger.e('loadMessages error', tag: 'DmProvider', error: e);
    } finally {
      _isLoadingMessages = false;
      notifyListeners();
    }
  }

  /// Load older messages (pagination)
  Future<bool> loadMoreMessages(int conversationId) async {
    final existing = _messageCache[conversationId] ?? [];
    if (existing.isEmpty) return false;

    final oldestId = existing.first.id;
    if (oldestId == null) return false;

    try {
      final result = await _repository.getMessages(
        conversationId,
        cursor: oldestId,
      );

      if (result.messages.isEmpty) return false;

      _messageCache[conversationId] = [
        ...result.messages.reversed,
        ...existing,
      ];
      notifyListeners();
      return result.nextCursor != null;
    } catch (e) {
      AppLogger.e('loadMoreMessages error', tag: 'DmProvider', error: e);
      return false;
    }
  }

  /// Send a text message
  Future<void> sendTextMessage(int conversationId, String content) async {
    final clientId = _uuid.v4();
    final now = DateTime.now();

    // Optimistic add
    final optimistic = DmMessageModel(
      conversationId: conversationId,
      senderId: 0, // Will be set properly by server
      messageType: 'text',
      content: content,
      clientMessageId: clientId,
      createdAt: now,
      status: DmMessageStatus.sending,
    );

    final messages = _messageCache[conversationId] ?? [];
    messages.add(optimistic);
    _messageCache[conversationId] = messages;
    notifyListeners();

    // Send via Socket.IO
    if (_socket.isConnected) {
      _socket.sendMessage(
        conversationId: conversationId,
        messageType: 'text',
        content: content,
        clientMessageId: clientId,
      );
    } else {
      // Fallback to REST
      final sent = await _repository.sendMessage(
        conversationId,
        content: content,
        clientMessageId: clientId,
      );

      if (sent != null) {
        _replaceOptimisticMessage(conversationId, clientId, sent);
      } else {
        _markMessageFailed(conversationId, clientId);
      }
    }
  }

  /// Send a media message (image or voice)
  Future<void> sendMediaMessage(
    int conversationId, {
    required String messageType,
    required List<int> fileBytes,
    required String fileName,
    required String mimeType,
    Map<String, dynamic>? extraMetadata,
  }) async {
    final clientId = _uuid.v4();

    // Optimistic placeholder
    final optimistic = DmMessageModel(
      conversationId: conversationId,
      senderId: 0,
      messageType: messageType,
      content: messageType == 'image' ? '[Uploading image...]' : '[Uploading voice...]',
      clientMessageId: clientId,
      createdAt: DateTime.now(),
      status: DmMessageStatus.sending,
    );

    final messages = _messageCache[conversationId] ?? [];
    messages.add(optimistic);
    _messageCache[conversationId] = messages;
    notifyListeners();

    try {
      // Upload file first
      final uploadResult =
          await _repository.uploadMedia(fileBytes, fileName, mimeType);

      if (uploadResult.mediaUrl == null) {
        _markMessageFailed(conversationId, clientId);
        return;
      }

      final metadata = {
        ...?uploadResult.metadata,
        ...?extraMetadata,
      };

      // Send message with media URL
      if (_socket.isConnected) {
        _socket.sendMessage(
          conversationId: conversationId,
          messageType: messageType,
          mediaUrl: uploadResult.mediaUrl,
          mediaMetadata: metadata,
          clientMessageId: clientId,
        );
      } else {
        final sent = await _repository.sendMessage(
          conversationId,
          messageType: messageType,
          mediaUrl: uploadResult.mediaUrl,
          mediaMetadata: metadata,
          clientMessageId: clientId,
        );

        if (sent != null) {
          _replaceOptimisticMessage(conversationId, clientId, sent);
        } else {
          _markMessageFailed(conversationId, clientId);
        }
      }
    } catch (e) {
      _markMessageFailed(conversationId, clientId);
      AppLogger.e('sendMediaMessage error', tag: 'DmProvider', error: e);
    }
  }

  /// Delete a message
  Future<void> deleteMessage(int conversationId, int messageId) async {
    final success = await _repository.deleteMessage(messageId);
    if (success) {
      final messages = _messageCache[conversationId] ?? [];
      final idx = messages.indexWhere((m) => m.id == messageId);
      if (idx != -1) {
        messages[idx] = messages[idx].copyWith(isDeleted: true);
        notifyListeners();
      }
    }
  }

  // ================================================================
  // TYPING
  // ================================================================

  void sendTypingStart(int conversationId) {
    _socket.startTyping(conversationId);
  }

  void sendTypingStop(int conversationId) {
    _socket.stopTyping(conversationId);
  }

  // ================================================================
  // LEAVE/CLEANUP
  // ================================================================

  void leaveConversation(int conversationId) {
    _socket.leaveConversation(conversationId);
    _activeConversationId = null;
    _typingUsers.clear();
  }

  // ================================================================
  // SOCKET EVENT HANDLERS
  // ================================================================

  void _handleNewMessage(Map<String, dynamic> data) {
    final message = DmMessageModel.fromJson(data);
    final convId = message.conversationId;

    // Check if this is a response to our own optimistic message
    if (message.clientMessageId != null) {
      final messages = _messageCache[convId] ?? [];
      final idx = messages.indexWhere(
          (m) => m.clientMessageId == message.clientMessageId);
      if (idx != -1) {
        messages[idx] = message;
        _messageCache[convId] = messages;
        notifyListeners();
        return;
      }
    }

    // Add to message cache if conversation is active
    final messages = _messageCache[convId] ?? [];
    // Avoid duplicates
    if (!messages.any((m) => m.id == message.id)) {
      messages.add(message);
      _messageCache[convId] = messages;
    }

    // Mark as read if we're viewing this conversation
    if (_activeConversationId == convId && message.id != null) {
      _socket.markRead(convId, message.id!);
      _repository.markRead(convId, message.id!);
    } else {
      // Increment unread
      _totalUnreadCount++;
    }

    // Update conversation list preview
    _updateConversationPreview(convId, message);

    notifyListeners();
  }

  void _handleMessageSent(Map<String, dynamic> data) {
    final messageData = data['message'];
    final clientId = data['client_message_id']?.toString();

    if (messageData is Map && clientId != null) {
      final message =
          DmMessageModel.fromJson(Map<String, dynamic>.from(messageData));
      _replaceOptimisticMessage(message.conversationId, clientId, message);
    }
  }

  void _handleTyping(Map<String, dynamic> data) {
    final userId = data['user_id'] as int?;
    final isTyping = data['is_typing'] as bool? ?? false;
    if (userId != null) {
      _typingUsers[userId] = isTyping;
      notifyListeners();
    }
  }

  void _handleReadReceipt(Map<String, dynamic> data) {
    // Could be used to show read indicators on messages
    notifyListeners();
  }

  void _handleConversationUpdated(Map<String, dynamic> data) {
    // Refresh conversation list
    loadConversations();
  }

  void _handleMessageDeleted(Map<String, dynamic> data) {
    final messageId = data['message_id'] as int?;
    final convId = data['conversation_id'] as int?;
    if (messageId != null && convId != null) {
      final messages = _messageCache[convId] ?? [];
      final idx = messages.indexWhere((m) => m.id == messageId);
      if (idx != -1) {
        messages[idx] = messages[idx].copyWith(isDeleted: true);
        _messageCache[convId] = messages;
        notifyListeners();
      }
    }
  }

  // ================================================================
  // HELPERS
  // ================================================================

  void _replaceOptimisticMessage(
      int convId, String clientId, DmMessageModel serverMessage) {
    final messages = _messageCache[convId] ?? [];
    final idx = messages.indexWhere((m) => m.clientMessageId == clientId);
    if (idx != -1) {
      messages[idx] = serverMessage;
    } else {
      messages.add(serverMessage);
    }
    _messageCache[convId] = messages;

    // Update conversation preview
    _updateConversationPreview(convId, serverMessage);
    notifyListeners();
  }

  void _markMessageFailed(int convId, String clientId) {
    final messages = _messageCache[convId] ?? [];
    final idx = messages.indexWhere((m) => m.clientMessageId == clientId);
    if (idx != -1) {
      messages[idx] = messages[idx].copyWith(status: DmMessageStatus.failed);
      _messageCache[convId] = messages;
      notifyListeners();
    }
  }

  void _updateConversationUnread(int convId, int count) {
    final idx = _conversations.indexWhere((c) => c.id == convId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(unreadCount: count);
    }
    // Recalculate total
    _totalUnreadCount =
        _conversations.fold(0, (sum, c) => sum + c.unreadCount);
  }

  void _updateConversationPreview(int convId, DmMessageModel message) {
    final idx = _conversations.indexWhere((c) => c.id == convId);
    if (idx != -1) {
      final preview = message.isText
          ? (message.content ?? '')
          : message.isImage
              ? '[Image]'
              : '[Voice]';
      _conversations[idx] = _conversations[idx].copyWith(
        lastMessagePreview: preview,
        lastMessageType: message.messageType,
        lastMessageSenderId: message.senderId,
        lastMessageAt: message.createdAt,
      );
      // Move to top
      final conv = _conversations.removeAt(idx);
      _conversations.insert(0, conv);
    }
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
}
