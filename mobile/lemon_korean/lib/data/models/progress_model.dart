import 'package:hive/hive.dart';

part 'progress_model.g.dart';

@HiveType(typeId: 3)
class ProgressModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final int lessonId;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final int? quizScore;

  @HiveField(5)
  final int timeSpent;

  @HiveField(6)
  final DateTime? startedAt;

  @HiveField(7)
  final DateTime? completedAt;

  @HiveField(8)
  final Map<String, dynamic>? stageProgress;

  @HiveField(9)
  final int attempts;

  @HiveField(10)
  final bool isSynced;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  ProgressModel({
    required this.id,
    required this.userId,
    required this.lessonId,
    this.status = 'not_started',
    this.quizScore,
    this.timeSpent = 0,
    this.startedAt,
    this.completedAt,
    this.stageProgress,
    this.attempts = 0,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int,
      lessonId: json['lesson_id'] as int,
      status: json['status'] as String? ?? 'not_started',
      quizScore: json['quiz_score'] as int?,
      timeSpent: json['time_spent'] as int? ?? 0,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      stageProgress: json['stage_progress'] as Map<String, dynamic>?,
      attempts: json['attempts'] as int? ?? 0,
      isSynced: json['is_synced'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lesson_id': lessonId,
      'status': status,
      'quiz_score': quizScore,
      'time_spent': timeSpent,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'stage_progress': stageProgress,
      'attempts': attempts,
      'is_synced': isSynced,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Copy with
  ProgressModel copyWith({
    int? id,
    int? userId,
    int? lessonId,
    String? status,
    int? quizScore,
    int? timeSpent,
    DateTime? startedAt,
    DateTime? completedAt,
    Map<String, dynamic>? stageProgress,
    int? attempts,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      quizScore: quizScore ?? this.quizScore,
      timeSpent: timeSpent ?? this.timeSpent,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      stageProgress: stageProgress ?? this.stageProgress,
      attempts: attempts ?? this.attempts,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Status helpers
  bool get isNotStarted => status == 'not_started';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isPassed => quizScore != null && quizScore! >= 80;

  // Progress percentage (0-100)
  int get progressPercentage {
    if (isCompleted) return 100;
    if (isNotStarted) return 0;

    // Calculate based on stage progress
    if (stageProgress != null && stageProgress!.isNotEmpty) {
      final totalStages = 7; // 7 stages
      final completedStages = stageProgress!.values
          .where((value) => value == true || value == 'completed')
          .length;
      return ((completedStages / totalStages) * 100).round();
    }

    return isInProgress ? 50 : 0;
  }

  // Time spent formatted
  String get timeSpentFormatted {
    final hours = timeSpent ~/ 3600;
    final minutes = (timeSpent % 3600) ~/ 60;
    final seconds = timeSpent % 60;

    if (hours > 0) {
      return '$hours时${minutes}分${seconds}秒';
    } else if (minutes > 0) {
      return '$minutes分${seconds}秒';
    } else {
      return '$seconds秒';
    }
  }

  // Status display
  String get statusDisplay {
    switch (status) {
      case 'not_started':
        return '未开始';
      case 'in_progress':
        return '进行中';
      case 'completed':
        return '已完成';
      case 'failed':
        return '未通过';
      default:
        return status;
    }
  }

  // Quiz score grade
  String get scoreGrade {
    if (quizScore == null) return '';
    if (quizScore! >= 90) return 'A';
    if (quizScore! >= 80) return 'B';
    if (quizScore! >= 70) return 'C';
    if (quizScore! >= 60) return 'D';
    return 'F';
  }

  @override
  String toString() {
    return 'ProgressModel(id: $id, lessonId: $lessonId, status: $status, score: $quizScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProgressModel &&
        other.id == id &&
        other.lessonId == lessonId;
  }

  @override
  int get hashCode => id.hashCode ^ lessonId.hashCode;
}

// ================================================================
// REVIEW MODEL (for SRS)
// ================================================================

@HiveType(typeId: 4)
class ReviewModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final int vocabularyId;

  @HiveField(3)
  final DateTime nextReview;

  @HiveField(4)
  final int interval;

  @HiveField(5)
  final double easeFactor;

  @HiveField(6)
  final int repetitions;

  @HiveField(7)
  final DateTime? lastReviewedAt;

  @HiveField(8)
  final int? lastQuality;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.vocabularyId,
    required this.nextReview,
    this.interval = 1,
    this.easeFactor = 2.5,
    this.repetitions = 0,
    this.lastReviewedAt,
    this.lastQuality,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int,
      vocabularyId: json['vocabulary_id'] as int,
      nextReview: DateTime.parse(json['next_review'] as String),
      interval: json['interval'] as int? ?? 1,
      easeFactor:
          (json['ease_factor'] as num?)?.toDouble() ?? 2.5,
      repetitions: json['repetitions'] as int? ?? 0,
      lastReviewedAt: json['last_reviewed_at'] != null
          ? DateTime.parse(json['last_reviewed_at'] as String)
          : null,
      lastQuality: json['last_quality'] as int?,
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
      'vocabulary_id': vocabularyId,
      'next_review': nextReview.toIso8601String(),
      'interval': interval,
      'ease_factor': easeFactor,
      'repetitions': repetitions,
      'last_reviewed_at': lastReviewedAt?.toIso8601String(),
      'last_quality': lastQuality,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    int? id,
    int? userId,
    int? vocabularyId,
    DateTime? nextReview,
    int? interval,
    double? easeFactor,
    int? repetitions,
    DateTime? lastReviewedAt,
    int? lastQuality,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      nextReview: nextReview ?? this.nextReview,
      interval: interval ?? this.interval,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      lastQuality: lastQuality ?? this.lastQuality,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isDue => DateTime.now().isAfter(nextReview);

  int get daysUntilReview =>
      nextReview.difference(DateTime.now()).inDays;

  String get dueStatus {
    if (isDue) return '该复习了';
    final days = daysUntilReview;
    if (days == 0) return '今天';
    if (days == 1) return '明天';
    return '$days天后';
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, vocabularyId: $vocabularyId, nextReview: $nextReview)';
  }
}
