import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/platform/platform_factory.dart';
import '../../core/platform/secure_storage_interface.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';
import '../../core/utils/app_logger.dart';
import '../models/user_model.dart';

/// Auth Repository
/// Handles authentication with API and local storage
class AuthRepository {
  static const String _tag = 'AuthRepository';
  final _apiClient = ApiClient.instance;
  final ISecureStorage _secureStorage = PlatformFactory.createSecureStorage();

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
          message: '회원가입 성공',
        );
      }

      return AuthResult(
        success: false,
        message: response.data['message'] ?? '회원가입 실패',
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
      AppLogger.d('Attempting login for: $email', tag: _tag);

      final response = await _apiClient.login(
        email: email,
        password: password,
      );

      AppLogger.d('Login response status: ${response.statusCode}', tag: _tag);

      if (response.statusCode == 200) {
        final data = response.data;

        // Validate response structure
        if (data == null || data['user'] == null) {
          AppLogger.e('Error: Invalid response structure', tag: _tag);
          AppLogger.e('Response data: $data', tag: _tag);
          return AuthResult(
            success: false,
            message: '서버 응답 데이터 형식 오류 (no user object)',
          );
        }

        final userJson = data['user'];

        // Log the user data for debugging
        AppLogger.d('User data received: $userJson', tag: _tag);

        // Validate required fields with detailed logging
        if (userJson['id'] == null) {
          AppLogger.e('Error: Missing user ID', tag: _tag);
          return AuthResult(
            success: false,
            message: '사용자 데이터에 ID가 없습니다',
          );
        }

        if (userJson['email'] == null || userJson['email'].toString().isEmpty) {
          AppLogger.e('Error: Missing or empty email', tag: _tag);
          return AuthResult(
            success: false,
            message: '사용자 데이터에 이메일이 없습니다',
          );
        }

        // Try to parse user with try-catch for better error reporting
        UserModel user;
        try {
          user = UserModel.fromJson(data['user']);
          AppLogger.d('User parsed successfully: ${user.email}', tag: _tag);
        } catch (e, stackTrace) {
          AppLogger.e('Failed to parse user model: $e', tag: _tag, error: e);
          AppLogger.e('Stack trace: $stackTrace', tag: _tag);
          AppLogger.e('User JSON: ${data['user']}', tag: _tag);
          return AuthResult(
            success: false,
            message: '사용자 데이터 파싱 실패: ${e.toString()}',
          );
        }

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
          message: '로그인 성공',
        );
      }

      return AuthResult(
        success: false,
        message: response.data['message'] ?? '로그인 실패',
      );
    } catch (e) {
      // Add debug context for troubleshooting
      AppLogger.e('Login failed: $e', tag: _tag, error: e);
      if (e is DioException) {
        AppLogger.e('Request URL: ${e.requestOptions.uri}', tag: _tag);
        AppLogger.e('Request method: ${e.requestOptions.method}', tag: _tag);
        AppLogger.e('Response status: ${e.response?.statusCode}', tag: _tag);
        AppLogger.e('Response data: ${e.response?.data}', tag: _tag);
        AppLogger.e('Error type: ${e.type}', tag: _tag);
      }

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
      return '네트워크 연결 실패. 네트워크 설정을 확인하세요';
    } else if (errorString.contains('401')) {
      return '이메일 또는 비밀번호가 잘못되었습니다';
    } else if (errorString.contains('409')) {
      return '이미 등록된 이메일입니다';
    } else if (errorString.contains('timeout')) {
      return '요청 시간 초과. 다시 시도하세요';
    }

    return '작업 실패. 나중에 다시 시도하세요';
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
