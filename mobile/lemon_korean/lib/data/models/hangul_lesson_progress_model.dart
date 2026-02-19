/// Progress model for hangul interactive lessons (Stage 0+).
/// Stored in Hive via LocalStorage.saveToBox (JSON map, no adapter needed).
class HangulLessonProgressModel {
  final String lessonId; // e.g. '0-1', '0-2', '0-3', '0-M'
  final int userId;
  final int completedSteps;
  final int totalSteps;
  final bool isCompleted;
  final int bestScore; // 0-100
  final int lemonsEarned; // 0-3
  final DateTime? completedAt;
  final DateTime lastAccessedAt;

  HangulLessonProgressModel({
    required this.lessonId,
    required this.userId,
    required this.completedSteps,
    required this.totalSteps,
    this.isCompleted = false,
    this.bestScore = 0,
    this.lemonsEarned = 0,
    this.completedAt,
    DateTime? lastAccessedAt,
  }) : lastAccessedAt = lastAccessedAt ?? DateTime.now();

  factory HangulLessonProgressModel.fromJson(Map<String, dynamic> json) {
    return HangulLessonProgressModel(
      lessonId: json['lesson_id'] as String,
      userId: json['user_id'] as int? ?? 0,
      completedSteps: json['completed_steps'] as int? ?? 0,
      totalSteps: json['total_steps'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      bestScore: json['best_score'] as int? ?? 0,
      lemonsEarned: json['lemons_earned'] as int? ?? 0,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.tryParse(json['last_accessed_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lesson_id': lessonId,
        'user_id': userId,
        'completed_steps': completedSteps,
        'total_steps': totalSteps,
        'is_completed': isCompleted,
        'best_score': bestScore,
        'lemons_earned': lemonsEarned,
        'completed_at': completedAt?.toIso8601String(),
        'last_accessed_at': lastAccessedAt.toIso8601String(),
      };

  HangulLessonProgressModel copyWith({
    String? lessonId,
    int? userId,
    int? completedSteps,
    int? totalSteps,
    bool? isCompleted,
    int? bestScore,
    int? lemonsEarned,
    DateTime? completedAt,
    DateTime? lastAccessedAt,
  }) {
    return HangulLessonProgressModel(
      lessonId: lessonId ?? this.lessonId,
      userId: userId ?? this.userId,
      completedSteps: completedSteps ?? this.completedSteps,
      totalSteps: totalSteps ?? this.totalSteps,
      isCompleted: isCompleted ?? this.isCompleted,
      bestScore: bestScore ?? this.bestScore,
      lemonsEarned: lemonsEarned ?? this.lemonsEarned,
      completedAt: completedAt ?? this.completedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }
}
