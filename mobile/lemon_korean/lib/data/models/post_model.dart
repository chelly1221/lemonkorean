/// Post Author model
/// Represents the author of a post or comment
class PostAuthor {
  final int id;
  final String name;
  final String? profileImageUrl;

  PostAuthor({
    required this.id,
    required this.name,
    this.profileImageUrl,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      id: json['id'] ?? json['user_id'] ?? 0,
      name: json['name'] ?? json['author_name'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? json['author_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image_url': profileImageUrl,
    };
  }

  @override
  String toString() => 'PostAuthor(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostAuthor && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Post model
/// Represents a social post in the SNS feed
class PostModel {
  final int id;
  final PostAuthor author;
  final String content;
  final String category; // 'learning' or 'general'
  final List<String> tags;
  final String visibility; // 'public' or 'followers'
  final List<String> imageUrls;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.author,
    required this.content,
    required this.category,
    this.tags = const [],
    this.visibility = 'public',
    this.imageUrls = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      author: PostAuthor.fromJson(json),
      content: (json['content'] ?? '') as String,
      category: (json['category'] ?? 'general') as String,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : [],
      visibility: (json['visibility'] ?? 'public') as String,
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'] as List)
          : [],
      likeCount: (json['like_count'] ?? 0) as int,
      commentCount: (json['comment_count'] ?? 0) as int,
      isLiked: (json['is_liked'] ?? false) as bool,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': author.id,
      'name': author.name,
      'profile_image_url': author.profileImageUrl,
      'content': content,
      'category': category,
      'tags': tags,
      'visibility': visibility,
      'image_urls': imageUrls,
      'like_count': likeCount,
      'comment_count': commentCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PostModel copyWith({
    int? id,
    PostAuthor? author,
    String? content,
    String? category,
    List<String>? tags,
    String? visibility,
    List<String>? imageUrls,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      visibility: visibility ?? this.visibility,
      imageUrls: imageUrls ?? this.imageUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helpers
  bool get isLearningPost => category == 'learning';
  bool get isGeneralPost => category == 'general';
  bool get isPublic => visibility == 'public';
  bool get hasImages => imageUrls.isNotEmpty;
  bool get hasTags => tags.isNotEmpty;

  @override
  String toString() => 'PostModel(id: $id, author: ${author.name}, content: ${content.length > 30 ? '${content.substring(0, 30)}...' : content})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
