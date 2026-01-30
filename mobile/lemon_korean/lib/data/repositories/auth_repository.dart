import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/app_logger.dart';
import '../models/user_model.dart';

/// Auth Repository
/// Handles authentication with API and local storage
class AuthRepository {
  static const String _tag = 'AuthRepository';
  final _apiClient = ApiClient.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // ================================================================
  // REGISTER
  // ================================================================

  /// Register new user
  Future<AuthResult> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _apiClient.register(
        email: email,
        password: password,
        username: username,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Parse user
        final user = UserModel.fromJson(data['user']);

        // Save user ID to BOTH Hive AND SecureStorage for reliability
        await LocalStorage.saveUserId(user.id);
        await _secureStorage.write(
          key: AppConstants.secureUserIdKey,
          value: user.id.toString(),
        );

        return AuthResult(
          success: true,
          user: user,
          token: data['accessToken'] as String?,
          refreshToken: data['refreshToken'] as String?,
          message: '注册成功',
        );
      }

      return AuthResult(
        success: false,
        message: response.data['message'] ?? '注册失败',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: _handleError(e),
      );
    }
  }

  // ================================================================
  // LOGIN
  // ================================================================

  /// Login user
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse user
        final user = UserModel.fromJson(data['user']);

        // Save user ID to BOTH Hive AND SecureStorage for reliability
        await LocalStorage.saveUserId(user.id);
        await _secureStorage.write(
          key: AppConstants.secureUserIdKey,
          value: user.id.toString(),
        );

        return AuthResult(
          success: true,
          user: user,
          token: data['accessToken'] as String?,
          refreshToken: data['refreshToken'] as String?,
          message: '登录成功',
        );
      }

      return AuthResult(
        success: false,
        message: response.data['message'] ?? '登录失败',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: _handleError(e),
      );
    }
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  /// Logout user
  Future<void> logout() async {
    try {
      // Clear API tokens
      await _apiClient.logout();

      // Clear cached user for offline-first auth
      await clearCachedUser();

      // Clear local storage (Hive)
      await LocalStorage.clearUserId();
      await LocalStorage.clearAll();

      // Clear SecureStorage user_id
      await _secureStorage.delete(key: AppConstants.secureUserIdKey);
    } catch (e) {
      AppLogger.e('Logout error: $e', tag: _tag);
    }
  }

  // ================================================================
  // TOKEN REFRESH
  // ================================================================

  /// Refresh access token
  Future<bool> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.refreshToken(refreshToken);

      return response.statusCode == 200;
    } catch (e) {
      AppLogger.e('Token refresh error: $e', tag: _tag);
      return false;
    }
  }

  // ================================================================
  // USER CACHE (for offline-first auth)
  // ================================================================

  /// Save user to local cache for offline access
  Future<void> cacheUser(UserModel user) async {
    await LocalStorage.saveCachedUser(user.toJson());
    AppLogger.d('User cached: ${user.username}', tag: _tag);
  }

  /// Get cached user for offline-first auth
  UserModel? getCachedUser() {
    final data = LocalStorage.getCachedUser();
    if (data == null) return null;
    try {
      return UserModel.fromJson(data);
    } catch (e) {
      AppLogger.e('Error parsing cached user: $e', tag: _tag);
      return null;
    }
  }

  /// Clear cached user on logout
  Future<void> clearCachedUser() async {
    await LocalStorage.clearCachedUser();
    AppLogger.d('Cached user cleared', tag: _tag);
  }

  // ================================================================
  // USER INFO
  // ================================================================

  /// Get current user ID from Hive (local storage)
  int? getCurrentUserId() {
    return LocalStorage.getUserId();
  }

  /// Get current user ID from SecureStorage (more reliable)
  Future<int?> getSecureUserId() async {
    final userIdStr = await _secureStorage.read(key: AppConstants.secureUserIdKey);
    if (userIdStr == null) return null;
    return int.tryParse(userIdStr);
  }

  /// Save user ID to both storages (for recovery scenarios)
  Future<void> saveUserIdToAll(int userId) async {
    await LocalStorage.saveUserId(userId);
    await _secureStorage.write(
      key: AppConstants.secureUserIdKey,
      value: userId.toString(),
    );
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    final userId = getCurrentUserId();
    return userId != null;
  }

  // ================================================================
  // ERROR HANDLING
  // ================================================================

  String _handleError(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('network') ||
        errorString.contains('SocketException')) {
      return '网络连接失败，请检查网络设置';
    } else if (errorString.contains('401')) {
      return '邮箱或密码错误';
    } else if (errorString.contains('409')) {
      return '邮箱已被注册';
    } else if (errorString.contains('timeout')) {
      return '请求超时，请重试';
    }

    return '操作失败，请稍后重试';
  }
}

// ================================================================
// MODELS
// ================================================================

/// Auth result model
class AuthResult {
  final bool success;
  final UserModel? user;
  final String? token;
  final String? refreshToken;
  final String? message;

  AuthResult({
    required this.success,
    this.user,
    this.token,
    this.refreshToken,
    this.message,
  });

  @override
  String toString() {
    return 'AuthResult(success: $success, user: ${user?.username}, message: $message)';
  }
}
