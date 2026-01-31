import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String? avatar;

  @HiveField(4)
  final String subscriptionType;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.createdAt, this.avatar,
    this.subscriptionType = 'free',
    this.lastLoginAt,
  });

  // From JSON - Safe parsing with no unsafe casts
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Safe ID parsing - handles int, string, or null
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      // Safe email parsing - never null
      email: (json['email'] ?? json['user_email'] ?? '').toString(),

      // Safe username with full fallback chain
      username: (json['username'] ??
                 json['name'] ??
                 json['email']?.toString().split('@').first ??
                 'User').toString(),

      // Avatar is nullable - safe
      avatar: json['avatar']?.toString(),

      // Subscription type with default
      subscriptionType: (json['subscription_type'] ?? 'free').toString(),

      // Safe created_at parsing with helper
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),

      // Safe last_login parsing with helper
      lastLoginAt: _parseDateTime(json['last_login'] ?? json['last_login_at']),
    );
  }

  /// Helper method for safe DateTime parsing
  /// Returns null if parsing fails or input is null
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    try {
      final str = value.toString();
      if (str.isEmpty) return null;
      return DateTime.parse(str);
    } catch (e) {
      print('[UserModel] Failed to parse DateTime: $value');
      return null;
    }
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'subscription_type': subscriptionType,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  // Copy with
  UserModel copyWith({
    int? id,
    String? email,
    String? username,
    String? avatar,
    String? subscriptionType,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  bool get isPremium => subscriptionType == 'premium';
  bool get isFree => subscriptionType == 'free';

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
