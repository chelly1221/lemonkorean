/// Lemon reward data for each lesson completion.
/// Stores how many lemons (1-3) a user earned for a lesson based on quiz score.
class LemonRewardModel {
  final int lessonId;
  final int lemonsEarned; // 1-3
  final int bestQuizScore; // 0-100
  final DateTime earnedAt;

  LemonRewardModel({
    required this.lessonId,
    required this.lemonsEarned,
    required this.bestQuizScore,
    required this.earnedAt,
  });

  /// Calculate lemons from quiz score percentage.
  /// [t3] and [t2] are configurable thresholds (from server settings).
  static int calculateLemons(int quizScorePercent, {int t3 = 95, int t2 = 80}) {
    if (quizScorePercent >= t3) return 3;
    if (quizScorePercent >= t2) return 2;
    return 1; // lesson completed = at least 1 lemon
  }

  factory LemonRewardModel.fromJson(Map<String, dynamic> json) {
    return LemonRewardModel(
      lessonId: json['lesson_id'] as int,
      lemonsEarned: json['lemons_earned'] as int? ?? 1,
      bestQuizScore: json['best_quiz_score'] as int? ?? 0,
      earnedAt: json['earned_at'] != null
          ? DateTime.parse(json['earned_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'lemons_earned': lemonsEarned,
      'best_quiz_score': bestQuizScore,
      'earned_at': earnedAt.toIso8601String(),
    };
  }

  LemonRewardModel copyWith({
    int? lessonId,
    int? lemonsEarned,
    int? bestQuizScore,
    DateTime? earnedAt,
  }) {
    return LemonRewardModel(
      lessonId: lessonId ?? this.lessonId,
      lemonsEarned: lemonsEarned ?? this.lemonsEarned,
      bestQuizScore: bestQuizScore ?? this.bestQuizScore,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }
}
