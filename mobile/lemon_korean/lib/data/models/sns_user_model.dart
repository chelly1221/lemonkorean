/// SNS User model
/// Represents a user profile in the social network feature
class SnsUserModel {
  final int id;
  final String name;
  final String? profileImageUrl;
  final String? bio;
  final String? languagePreference;
  final int followerCount;
  final int followingCount;
  final int postCount;
  final bool isFollowing;
  final bool isPublic;

  SnsUserModel({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.bio,
    this.languagePreference,
    this.followerCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
    this.isFollowing = false,
    this.isPublic = true,
  });

  factory SnsUserModel.fromJson(Map<String, dynamic> json) {
    return SnsUserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? json['username'] ?? '').toString(),
      profileImageUrl: json['profile_image_url']?.toString() ?? json['avatar']?.toString(),
      bio: json['bio']?.toString(),
      languagePreference: json['language_preference']?.toString(),
      followerCount: (json['follower_count'] ?? 0) as int,
      followingCount: (json['following_count'] ?? 0) as int,
      postCount: (json['post_count'] ?? 0) as int,
      isFollowing: (json['is_following'] ?? false) as bool,
      isPublic: (json['is_public'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'language_preference': languagePreference,
      'follower_count': followerCount,
      'following_count': followingCount,
      'post_count': postCount,
      'is_following': isFollowing,
      'is_public': isPublic,
    };
  }

  SnsUserModel copyWith({
    int? id,
    String? name,
    String? profileImageUrl,
    String? bio,
    String? languagePreference,
    int? followerCount,
    int? followingCount,
    int? postCount,
    bool? isFollowing,
    bool? isPublic,
  }) {
    return SnsUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      languagePreference: languagePreference ?? this.languagePreference,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      postCount: postCount ?? this.postCount,
      isFollowing: isFollowing ?? this.isFollowing,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  // Helpers
  bool get hasProfileImage => profileImageUrl != null && profileImageUrl!.isNotEmpty;
  bool get hasBio => bio != null && bio!.isNotEmpty;
  bool get isPrivate => !isPublic;

  @override
  String toString() => 'SnsUserModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SnsUserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
