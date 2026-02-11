/// DM Conversation model
class ConversationModel {
  final int id;
  final int otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String? lastMessagePreview;
  final String lastMessageType;
  final int lastMessageSenderId;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  ConversationModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    this.lastMessagePreview,
    this.lastMessageType = 'text',
    this.lastMessageSenderId = 0,
    this.lastMessageAt,
    this.unreadCount = 0,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,
      otherUserId: json['other_user_id'] as int,
      otherUserName: (json['other_user_name'] ?? '').toString(),
      otherUserAvatar: json['other_user_avatar']?.toString(),
      lastMessagePreview: json['last_message_preview']?.toString(),
      lastMessageType: (json['last_message_type'] ?? 'text').toString(),
      lastMessageSenderId: (json['last_message_sender_id'] ?? 0) as int,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'].toString())
          : null,
      unreadCount: (json['unread_count'] ?? 0) as int,
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }

  ConversationModel copyWith({
    int? unreadCount,
    String? lastMessagePreview,
    String? lastMessageType,
    int? lastMessageSenderId,
    DateTime? lastMessageAt,
  }) {
    return ConversationModel(
      id: id,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserAvatar: otherUserAvatar,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt,
    );
  }

  bool get hasUnread => unreadCount > 0;
}
