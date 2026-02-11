import 'post_model.dart';

/// Comment model
/// Represents a comment on a social post
class CommentModel {
  final int id;
  final int postId;
  final PostAuthor author;
  final int? parentId;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.author,
    this.parentId,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      author: PostAuthor.fromJson(json),
      parentId: json['parent_id'] as int?,
      content: (json['content'] ?? '') as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': author.id,
      'name': author.name,
      'profile_image_url': author.profileImageUrl,
      'parent_id': parentId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  CommentModel copyWith({
    int? id,
    int? postId,
    PostAuthor? author,
    int? parentId,
    String? content,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helpers
  bool get isReply => parentId != null;

  @override
  String toString() => 'CommentModel(id: $id, postId: $postId, author: ${author.name})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
