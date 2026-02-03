import 'package:hive/hive.dart';

part 'hangul_progress_model.g.dart';

/// Hangul character learning progress with SRS data
@HiveType(typeId: 12)
class HangulProgressModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final int characterId;

  @HiveField(3)
  final String? character;

  @HiveField(4)
  final String? characterType;

  @HiveField(5)
  final int masteryLevel;

  @HiveField(6)
  final int correctCount;

  @HiveField(7)
  final int wrongCount;

  @HiveField(8)
  final int streakCount;

  @HiveField(9)
  final DateTime? lastPracticed;

  @HiveField(10)
  final DateTime? nextReview;

  @HiveField(11)
  final double easeFactor;

  @HiveField(12)
  final int intervalDays;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  HangulProgressModel({
    required this.id,
    required this.userId,
    required this.characterId,
    required this.createdAt,
    required this.updatedAt,
    this.character,
    this.characterType,
    this.masteryLevel = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.streakCount = 0,
    this.lastPracticed,
    this.nextReview,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
  });

  factory HangulProgressModel.fromJson(Map<String, dynamic> json) {
    return HangulProgressModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      characterId: json['character_id'] as int,
      character: json['character'] as String?,
      characterType: json['character_type'] as String?,
      masteryLevel: json['mastery_level'] as int? ?? 0,
      correctCount: json['correct_count'] as int? ?? 0,
      wrongCount: json['wrong_count'] as int? ?? 0,
      streakCount: json['streak_count'] as int? ?? 0,
      lastPracticed: json['last_practiced'] != null
          ? DateTime.parse(json['last_practiced'] as String)
          : null,
      nextReview: json['next_review'] != null
          ? DateTime.parse(json['next_review'] as String)
          : null,
      easeFactor: (json['easiness_factor'] ?? json['ease_factor'] ?? 2.5) is num
          ? (json['easiness_factor'] ?? json['ease_factor'] ?? 2.5).toDouble()
          : 2.5,
      intervalDays: json['interval_days'] as int? ?? 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'character_id': characterId,
      'character': character,
      'character_type': characterType,
      'mastery_level': masteryLevel,
      'correct_count': correctCount,
      'wrong_count': wrongCount,
      'streak_count': streakCount,
      'last_practiced': lastPracticed?.toIso8601String(),
      'next_review': nextReview?.toIso8601String(),
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  HangulProgressModel copyWith({
    int? id,
    int? userId,
    int? characterId,
    String? character,
    String? characterType,
    int? masteryLevel,
    int? correctCount,
    int? wrongCount,
    int? streakCount,
    DateTime? lastPracticed,
    DateTime? nextReview,
    double? easeFactor,
    int? intervalDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HangulProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      characterId: characterId ?? this.characterId,
      character: character ?? this.character,
      characterType: characterType ?? this.characterType,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      streakCount: streakCount ?? this.streakCount,
      lastPracticed: lastPracticed ?? this.lastPracticed,
      nextReview: nextReview ?? this.nextReview,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helpers
  int get totalAttempts => correctCount + wrongCount;
  double get accuracy =>
      totalAttempts > 0 ? correctCount / totalAttempts : 0.0;
  bool get isDueForReview =>
      nextReview == null || nextReview!.isBefore(DateTime.now());
  bool get isNew => masteryLevel == 0 && totalAttempts == 0;
  bool get isMastered => masteryLevel >= 3;
  bool get isPerfected => masteryLevel >= 5;

  String get masteryLevelName {
    switch (masteryLevel) {
      case 0:
        return '新';
      case 1:
        return '学习中';
      case 2:
        return '熟悉';
      case 3:
        return '掌握';
      case 4:
        return '精通';
      case 5:
        return '完美';
      default:
        return '未知';
    }
  }

  String get masteryLevelNameKo {
    switch (masteryLevel) {
      case 0:
        return '새로운';
      case 1:
        return '학습 중';
      case 2:
        return '익숙함';
      case 3:
        return '숙달';
      case 4:
        return '정통';
      case 5:
        return '완벽';
      default:
        return '알 수 없음';
    }
  }

  @override
  String toString() {
    return 'HangulProgressModel(id: $id, characterId: $characterId, mastery: $masteryLevel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HangulProgressModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Hangul learning statistics
class HangulStats {
  final int totalCharacters;
  final int charactersLearned;
  final int charactersMastered;
  final int charactersPerfected;
  final int totalCorrect;
  final int totalWrong;
  final double accuracyPercent;
  final int dueForReview;

  HangulStats({
    this.totalCharacters = 40,
    this.charactersLearned = 0,
    this.charactersMastered = 0,
    this.charactersPerfected = 0,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.accuracyPercent = 0.0,
    this.dueForReview = 0,
  });

  factory HangulStats.fromJson(Map<String, dynamic> json) {
    return HangulStats(
      totalCharacters: json['total_characters'] as int? ?? 40,
      charactersLearned: json['characters_learned'] as int? ?? 0,
      charactersMastered: json['characters_mastered'] as int? ?? 0,
      charactersPerfected: json['characters_perfected'] as int? ?? 0,
      totalCorrect: json['total_correct'] as int? ?? 0,
      totalWrong: json['total_wrong'] as int? ?? 0,
      accuracyPercent: (json['accuracy_percent'] as num?)?.toDouble() ?? 0.0,
      dueForReview: json['due_for_review'] as int? ?? 0,
    );
  }

  double get progressPercent =>
      totalCharacters > 0 ? charactersLearned / totalCharacters : 0.0;
  double get masteryPercent =>
      totalCharacters > 0 ? charactersMastered / totalCharacters : 0.0;
}
