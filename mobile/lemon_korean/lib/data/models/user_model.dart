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
    this.avatar,
    this.subscriptionType = 'free',
    required this.createdAt,
    this.lastLoginAt,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
      subscriptionType: json['subscription_type'] as String? ?? 'free',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
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
