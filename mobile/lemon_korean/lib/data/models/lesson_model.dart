import 'package:hive/hive.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 1)
class LessonModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int level;

  @HiveField(2)
  final String titleKo;

  @HiveField(3)
  final String title; // Localized title (was titleZh)

  @HiveField(4)
  final String? description; // Localized description

  @HiveField(5)
  final String? thumbnailUrl;

  @HiveField(6)
  final String version;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final Map<String, dynamic>? content;

  @HiveField(9)
  final Map<String, String>? mediaUrls;

  @HiveField(10)
  final int? estimatedMinutes;

  @HiveField(11)
  final int? vocabularyCount;

  @HiveField(12)
  final bool isDownloaded;

  @HiveField(13)
  final DateTime? downloadedAt;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  @HiveField(16)
  final String? contentLanguage; // Language code of the content

  @HiveField(17)
  final int? week; // Week/chapter grouping from DB

  @HiveField(18)
  final int? orderNum; // Order within level from DB

  LessonModel({
    required this.id,
    required this.level,
    required this.titleKo,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.thumbnailUrl,
    this.version = '1.0.0',
    this.status = 'published',
    this.content,
    this.mediaUrls,
    this.estimatedMinutes,
    this.vocabularyCount,
    this.isDownloaded = false,
    this.downloadedAt,
    this.contentLanguage,
    this.week,
    this.orderNum,
  });

  // From JSON
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      level: json['level'] as int,
      titleKo: json['title_ko'] as String,
      // Support both new 'title' field and legacy 'title_zh' for backwards compatibility
      title: json['title'] as String? ?? json['title_zh'] as String,
      description: json['description'] as String? ?? json['description_zh'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      version: json['version'] as String? ?? '1.0.0',
      status: json['status'] as String? ?? 'published',
      content: json['content'] as Map<String, dynamic>?,
      mediaUrls: json['media_urls'] != null
          ? Map<String, String>.from(json['media_urls'] as Map)
          : null,
      estimatedMinutes: json['estimated_minutes'] as int?,
      vocabularyCount: json['vocabulary_count'] as int?,
      isDownloaded: json['is_downloaded'] as bool? ?? false,
      downloadedAt: json['downloaded_at'] != null
          ? DateTime.parse(json['downloaded_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      contentLanguage: json['content_language'] as String?,
      week: json['week'] as int?,
      orderNum: json['order_num'] as int?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'title_ko': titleKo,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'version': version,
      'status': status,
      'content': content,
      'media_urls': mediaUrls,
      'estimated_minutes': estimatedMinutes,
      'vocabulary_count': vocabularyCount,
      'is_downloaded': isDownloaded,
      'downloaded_at': downloadedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'content_language': contentLanguage,
      'week': week,
      'order_num': orderNum,
    };
  }

  // Copy with
  LessonModel copyWith({
    int? id,
    int? level,
    String? titleKo,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? version,
    String? status,
    Map<String, dynamic>? content,
    Map<String, String>? mediaUrls,
    int? estimatedMinutes,
    int? vocabularyCount,
    bool? isDownloaded,
    DateTime? downloadedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contentLanguage,
    int? week,
    int? orderNum,
  }) {
    return LessonModel(
      id: id ?? this.id,
      level: level ?? this.level,
      titleKo: titleKo ?? this.titleKo,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      version: version ?? this.version,
      status: status ?? this.status,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      vocabularyCount: vocabularyCount ?? this.vocabularyCount,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentLanguage: contentLanguage ?? this.contentLanguage,
      week: week ?? this.week,
      orderNum: orderNum ?? this.orderNum,
    );
  }

  // Helpers
  bool get isPublished => status == 'published';
  bool get isDraft => status == 'draft';

  /// Display title - uses localized title with Korean as fallback
  String get displayTitle => '$titleKo ($title)';

  String get estimatedTime {
    if (estimatedMinutes == null) return '';
    if (estimatedMinutes! < 60) return '$estimatedMinutes분';
    final hours = estimatedMinutes! ~/ 60;
    final minutes = estimatedMinutes! % 60;
    return minutes > 0 ? '$hours시간 $minutes분' : '$hours시간';
  }

  @override
  String toString() {
    return 'LessonModel(id: $id, titleKo: $titleKo, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LessonModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
