/// Voice room model with stage/audience system
class VoiceRoomModel {
  final int id;
  final int creatorId;
  final String creatorName;
  final String? creatorAvatar;
  final String title;
  final String? topic;
  final String languageLevel;
  final int maxSpeakers;
  final String livekitRoomName;
  final String status;
  final int speakerCount;
  final int listenerCount;
  final List<VoiceParticipantModel> participants;
  final DateTime createdAt;

  VoiceRoomModel({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    this.creatorAvatar,
    required this.title,
    this.topic,
    this.languageLevel = 'all',
    this.maxSpeakers = 4,
    this.livekitRoomName = '',
    this.status = 'active',
    this.speakerCount = 0,
    this.listenerCount = 0,
    this.participants = const [],
    required this.createdAt,
  });

  factory VoiceRoomModel.fromJson(Map<String, dynamic> json) {
    List<VoiceParticipantModel> participants = [];
    if (json['participants'] is List) {
      participants = (json['participants'] as List)
          .map((p) => VoiceParticipantModel.fromJson(
              p is Map ? Map<String, dynamic>.from(p) : {}))
          .where((p) => p.userId > 0)
          .toList();
    }

    return VoiceRoomModel(
      id: json['id'] as int,
      creatorId: (json['creator_id'] ?? 0) as int,
      creatorName: (json['creator_name'] ?? '').toString(),
      creatorAvatar: json['creator_avatar']?.toString(),
      title: (json['title'] ?? '').toString(),
      topic: json['topic']?.toString(),
      languageLevel: (json['language_level'] ?? 'all').toString(),
      maxSpeakers: (json['max_speakers'] ?? json['max_participants'] ?? 4) as int,
      livekitRoomName: (json['livekit_room_name'] ?? '').toString(),
      status: (json['status'] ?? 'active').toString(),
      speakerCount: (json['speaker_count'] ?? json['participant_count'] ?? 0) as int,
      listenerCount: (json['listener_count'] ?? 0) as int,
      participants: participants,
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }

  bool get isActive => status == 'active';
  bool get isStageFull => speakerCount >= maxSpeakers;
  int get totalParticipants => speakerCount + listenerCount;
}

/// Voice room participant model with role and character data
class VoiceParticipantModel {
  final int userId;
  final String name;
  final String? avatar;
  final bool isMuted;
  final String role; // 'speaker' or 'listener'
  final Map<String, dynamic>? equippedItems;
  final String? skinColor;

  VoiceParticipantModel({
    required this.userId,
    required this.name,
    this.avatar,
    this.isMuted = false,
    this.role = 'listener',
    this.equippedItems,
    this.skinColor,
  });

  factory VoiceParticipantModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? equipped;
    if (json['equipped_items'] is Map) {
      equipped = Map<String, dynamic>.from(json['equipped_items']);
    } else if (json['equipped_items'] is String) {
      // Handle JSON string
      try {
        equipped = null; // Let provider handle parsing if needed
      } catch (_) {}
    }

    return VoiceParticipantModel(
      userId: (json['user_id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      isMuted: (json['is_muted'] ?? false) as bool,
      role: (json['role'] ?? 'listener').toString(),
      equippedItems: equipped,
      skinColor: json['skin_color']?.toString(),
    );
  }

  bool get isSpeaker => role == 'speaker';
  bool get isListener => role == 'listener';
}

/// Voice room chat message model (ephemeral)
class VoiceChatMessageModel {
  final int? id;
  final int roomId;
  final int userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final String messageType;
  final DateTime createdAt;

  VoiceChatMessageModel({
    this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    this.messageType = 'text',
    required this.createdAt,
  });

  factory VoiceChatMessageModel.fromJson(Map<String, dynamic> json) {
    return VoiceChatMessageModel(
      id: json['id'] as int?,
      roomId: (json['room_id'] ?? 0) as int,
      userId: (json['user_id'] ?? 0) as int,
      userName: (json['name'] ?? '').toString(),
      userAvatar: json['avatar']?.toString(),
      content: (json['content'] ?? '').toString(),
      messageType: (json['message_type'] ?? 'text').toString(),
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }
}

/// Stage request model (raise hand)
class StageRequestModel {
  final int id;
  final int roomId;
  final int userId;
  final String name;
  final String? avatar;
  final String status;
  final DateTime createdAt;

  StageRequestModel({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.name,
    this.avatar,
    this.status = 'pending',
    required this.createdAt,
  });

  factory StageRequestModel.fromJson(Map<String, dynamic> json) {
    return StageRequestModel(
      id: (json['id'] ?? 0) as int,
      roomId: (json['room_id'] ?? 0) as int,
      userId: (json['user_id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      status: (json['status'] ?? 'pending').toString(),
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }
}
