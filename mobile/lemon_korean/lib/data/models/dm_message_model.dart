/// DM Message model
enum DmMessageStatus { sending, sent, failed }

class DmMessageModel {
  final int? id;
  final int conversationId;
  final int senderId;
  final String senderName;
  final String? senderAvatar;
  final String messageType; // 'text', 'image', 'voice'
  final String? content;
  final String? mediaUrl;
  final Map<String, dynamic> mediaMetadata;
  final String? clientMessageId;
  final bool isDeleted;
  final DateTime createdAt;
  final DmMessageStatus status;

  DmMessageModel({
    this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName = '',
    this.senderAvatar,
    this.messageType = 'text',
    this.content,
    this.mediaUrl,
    this.mediaMetadata = const {},
    this.clientMessageId,
    this.isDeleted = false,
    required this.createdAt,
    this.status = DmMessageStatus.sent,
  });

  factory DmMessageModel.fromJson(Map<String, dynamic> json) {
    return DmMessageModel(
      id: json['id'] as int?,
      conversationId: (json['conversation_id'] ?? 0) as int,
      senderId: (json['sender_id'] ?? 0) as int,
      senderName: (json['sender_name'] ?? '').toString(),
      senderAvatar: json['sender_avatar']?.toString(),
      messageType: (json['message_type'] ?? 'text').toString(),
      content: json['content']?.toString(),
      mediaUrl: json['media_url']?.toString(),
      mediaMetadata: json['media_metadata'] is Map
          ? Map<String, dynamic>.from(json['media_metadata'] as Map)
          : {},
      clientMessageId: json['client_message_id']?.toString(),
      isDeleted: (json['is_deleted'] ?? false) as bool,
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
      status: DmMessageStatus.sent,
    );
  }

  DmMessageModel copyWith({
    int? id,
    DmMessageStatus? status,
    bool? isDeleted,
  }) {
    return DmMessageModel(
      id: id ?? this.id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      messageType: messageType,
      content: content,
      mediaUrl: mediaUrl,
      mediaMetadata: mediaMetadata,
      clientMessageId: clientMessageId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }

  bool get isText => messageType == 'text';
  bool get isImage => messageType == 'image';
  bool get isVoice => messageType == 'voice';
}
