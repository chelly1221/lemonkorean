import 'package:flutter/material.dart';
import 'package:lemon_korean/l10n/generated/app_localizations.dart';

/// Room type constants
class RoomTypes {
  static const String freeTalk = 'free_talk';
  static const String pronunciation = 'pronunciation';
  static const String roleplay = 'roleplay';
  static const String qna = 'qna';
  static const String listening = 'listening';
  static const String debate = 'debate';

  static const List<String> all = [
    freeTalk,
    pronunciation,
    roleplay,
    qna,
    listening,
    debate,
  ];
}

/// Voice room model with stage/audience system
class VoiceRoomModel {
  final int id;
  final int creatorId;
  final String creatorName;
  final String? creatorAvatar;
  final String title;
  final String? topic;
  final String languageLevel;
  final String roomType;
  final int maxSpeakers;
  final int? duration; // session duration in minutes, null = no limit
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
    required this.title,
    required this.createdAt,
    this.creatorAvatar,
    this.topic,
    this.languageLevel = 'all',
    this.roomType = 'free_talk',
    this.maxSpeakers = 4,
    this.duration,
    this.livekitRoomName = '',
    this.status = 'active',
    this.speakerCount = 0,
    this.listenerCount = 0,
    this.participants = const [],
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
      roomType: (json['room_type'] ?? 'free_talk').toString(),
      maxSpeakers: (json['max_speakers'] ?? json['max_participants'] ?? 4) as int,
      duration: json['duration'] as int?,
      livekitRoomName: (json['livekit_room_name'] ?? '').toString(),
      status: (json['status'] ?? 'active').toString(),
      speakerCount: (json['speaker_count'] ?? json['participant_count'] ?? 0) as int,
      listenerCount: (json['listener_count'] ?? 0) as int,
      participants: participants,
      createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'creator_id': creatorId,
        'creator_name': creatorName,
        if (creatorAvatar != null) 'creator_avatar': creatorAvatar,
        'title': title,
        if (topic != null) 'topic': topic,
        'language_level': languageLevel,
        'room_type': roomType,
        'max_speakers': maxSpeakers,
        if (duration != null) 'duration': duration,
        'livekit_room_name': livekitRoomName,
        'status': status,
        'speaker_count': speakerCount,
        'listener_count': listenerCount,
        'created_at': createdAt.toIso8601String(),
      };

  bool get isActive => status == 'active';
  bool get isStageFull => speakerCount >= maxSpeakers;
  int get totalParticipants => speakerCount + listenerCount;

  /// Human-readable display name for the room type (fallback, no l10n)
  String get roomTypeDisplay {
    switch (roomType) {
      case RoomTypes.freeTalk:
        return 'Free Talk';
      case RoomTypes.pronunciation:
        return 'Pronunciation';
      case RoomTypes.roleplay:
        return 'Role Play';
      case RoomTypes.qna:
        return 'Q&A';
      case RoomTypes.listening:
        return 'Listening';
      case RoomTypes.debate:
        return 'Debate';
      default:
        return 'Free Talk';
    }
  }

  /// Localized display name for a room type string
  static String localizedRoomType(String roomType, AppLocalizations? l10n) {
    switch (roomType) {
      case RoomTypes.freeTalk:
        return l10n?.voiceRoomTypeFreeTalk ?? 'Free Talk';
      case RoomTypes.pronunciation:
        return l10n?.voiceRoomTypePronunciation ?? 'Pronunciation';
      case RoomTypes.roleplay:
        return l10n?.voiceRoomTypeRolePlay ?? 'Role Play';
      case RoomTypes.qna:
        return l10n?.voiceRoomTypeQnA ?? 'Q&A';
      case RoomTypes.listening:
        return l10n?.voiceRoomTypeListening ?? 'Listening';
      case RoomTypes.debate:
        return l10n?.voiceRoomTypeDebate ?? 'Debate';
      default:
        return l10n?.voiceRoomTypeFreeTalk ?? 'Free Talk';
    }
  }

  /// Icon for the room type
  IconData get roomTypeIcon {
    switch (roomType) {
      case RoomTypes.freeTalk:
        return Icons.chat_bubble_outline;
      case RoomTypes.pronunciation:
        return Icons.record_voice_over;
      case RoomTypes.roleplay:
        return Icons.theater_comedy;
      case RoomTypes.qna:
        return Icons.help_outline;
      case RoomTypes.listening:
        return Icons.headphones;
      case RoomTypes.debate:
        return Icons.forum;
      default:
        return Icons.chat_bubble_outline;
    }
  }

  /// Background tint color for the room type
  Color get roomTypeColor {
    switch (roomType) {
      case RoomTypes.freeTalk:
        return const Color(0x00000000); // transparent - default
      case RoomTypes.pronunciation:
        return const Color(0x152196F3); // light blue
      case RoomTypes.roleplay:
        return const Color(0x159C27B0); // light purple
      case RoomTypes.qna:
        return const Color(0x154CAF50); // light green
      case RoomTypes.listening:
        return const Color(0x15FF9800); // light orange
      case RoomTypes.debate:
        return const Color(0x15F44336); // light red
      default:
        return const Color(0x00000000);
    }
  }

  /// Accent color (solid) for room type badge
  Color get roomTypeAccentColor {
    switch (roomType) {
      case RoomTypes.freeTalk:
        return const Color(0xFF757575); // grey
      case RoomTypes.pronunciation:
        return const Color(0xFF2196F3); // blue
      case RoomTypes.roleplay:
        return const Color(0xFF9C27B0); // purple
      case RoomTypes.qna:
        return const Color(0xFF4CAF50); // green
      case RoomTypes.listening:
        return const Color(0xFFFF9800); // orange
      case RoomTypes.debate:
        return const Color(0xFFF44336); // red
      default:
        return const Color(0xFF757575);
    }
  }
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
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
    this.id,
    this.userAvatar,
    this.messageType = 'text',
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
    required this.createdAt,
    this.avatar,
    this.status = 'pending',
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
