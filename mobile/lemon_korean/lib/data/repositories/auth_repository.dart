import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';
import '../models/user_model.dart';

/// Auth Repository
/// Handles authentication with API and local storage
class AuthRepository {
  final _apiClient = ApiClient.instance;

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

        // Save user ID locally
        await LocalStorage.saveUserId(user.id);

        return AuthResult(
          success: true,
          user: user,
          token: data['token'] as String?,
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

        // Save user ID locally
        await LocalStorage.saveUserId(user.id);

        return AuthResult(
          success: true,
          user: user,
          token: data['token'] as String?,
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

      // Clear local storage
      await LocalStorage.clearUserId();
      await LocalStorage.clearAll();
    } catch (e) {
      print('[AuthRepository] Logout error: $e');
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
      print('[AuthRepository] Token refresh error: $e');
      return false;
    }
  }

  // ================================================================
  // USER INFO
  // ================================================================

  /// Get current user ID from local storage
  int? getCurrentUserId() {
    return LocalStorage.getUserId();
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
  final String? message;

  AuthResult({
    required this.success,
    this.user,
    this.token,
    this.message,
  });

  @override
  String toString() {
    return 'AuthResult(success: $success, user: ${user?.username}, message: $message)';
  }
}
