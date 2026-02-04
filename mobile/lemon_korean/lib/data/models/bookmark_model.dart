import 'package:hive/hive.dart';
import 'vocabulary_model.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 5)
class BookmarkModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int vocabularyId;

  @HiveField(2)
  final String? notes;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final bool isSynced;

  // Not persisted in Hive - loaded separately from vocabulary box
  VocabularyModel? vocabulary;

  // Progress data from backend (not persisted, loaded from API)
  Map<String, dynamic>? progress;

  BookmarkModel({
    required this.id,
    required this.vocabularyId,
    required this.createdAt,
    this.notes,
    this.isSynced = false,
    this.vocabulary,
    this.progress,
  });

  /// Create from JSON (from backend API)
  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['bookmark_id'] as int? ?? json['id'] as int,
      vocabularyId: json['vocabulary_id'] as int? ??
                    (json['vocabulary'] != null ? json['vocabulary']['id'] as int : 0),
      notes: json['notes'] as String?,
      createdAt: json['bookmarked_at'] != null
          ? DateTime.parse(json['bookmarked_at'] as String)
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now()),
      isSynced: true, // Data from server is always synced
      vocabulary: json['vocabulary'] != null
          ? VocabularyModel.fromJson(json['vocabulary'] as Map<String, dynamic>)
          : null,
      progress: json['progress'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vocabulary_id': vocabularyId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  /// Convert to JSON for local storage (Hive compatible)
  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'vocabulary_id': vocabularyId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  /// Create from local storage JSON
  factory BookmarkModel.fromLocalJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] as int,
      vocabularyId: json['vocabulary_id'] as int,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isSynced: json['is_synced'] as bool? ?? false,
    );
  }

  /// Copy with modifications
  BookmarkModel copyWith({
    int? id,
    int? vocabularyId,
    String? notes,
    DateTime? createdAt,
    bool? isSynced,
    VocabularyModel? vocabulary,
    Map<String, dynamic>? progress,
  }) {
    return BookmarkModel(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      vocabulary: vocabulary ?? this.vocabulary,
      progress: progress ?? this.progress,
    );
  }

  /// Check if has notes
  bool get hasNotes => notes != null && notes!.isNotEmpty;

  /// Check if has vocabulary data loaded
  bool get hasVocabulary => vocabulary != null;

  /// Check if has progress data
  bool get hasProgress => progress != null;

  /// Get mastery level from progress
  int? get masteryLevel => progress?['mastery_level'] as int?;

  /// Get next review date from progress
  DateTime? get nextReview {
    final nextReviewStr = progress?['next_review'] as String?;
    return nextReviewStr != null ? DateTime.parse(nextReviewStr) : null;
  }

  /// Check if due for review
  bool get isDueForReview {
    final review = nextReview;
    return review != null && DateTime.now().isAfter(review);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookmarkModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BookmarkModel(id: $id, vocabularyId: $vocabularyId, notes: $notes, '
        'isSynced: $isSynced, hasVocabulary: $hasVocabulary)';
  }
}
