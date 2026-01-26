import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Auth Provider
/// Manages authentication state using Provider pattern
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // ================================================================
  // STATE
  // ================================================================

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // ================================================================
  // INITIALIZATION
  // ================================================================

  /// Load user from saved token (auto-login)
  Future<void> loadUser() async {
    _setLoading(true);
    _clearError();

    try {
      // Check if user is logged in from repository
      if (_authRepository.isLoggedIn()) {
        final userId = _authRepository.getCurrentUserId();

        if (userId != null) {
          try {
            // Fetch user details from API
            final response = await _apiClient.getUserProfile(userId);

            if (response.statusCode == 200) {
              _currentUser = UserModel.fromJson(response.data['user']);
              _setLoading(false);
              return;
            } else {
              print('[AuthProvider] Failed to fetch user profile: ${response.statusCode}');
            }
          } catch (e) {
            print('[AuthProvider] Error fetching user details: $e');
          }

          // Fallback: create minimal user object from stored ID
          _currentUser = UserModel(
            id: userId,
            email: '',
            username: 'User $userId',
            createdAt: DateTime.now(),
          );

          _setLoading(false);
          return;
        }
      }

      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _setError('加载用户信息失败: $e');
      _currentUser = null;
      _setLoading(false);
    }
  }

  /// Check if user is authenticated
  Future<bool> checkAuth() async {
    await loadUser();
    return isLoggedIn;
  }

  // ================================================================
  // LOGIN
  // ================================================================

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      if (result.success && result.user != null) {
        _currentUser = result.user;

        // Save tokens to secure storage
        if (result.token != null) {
          await _secureStorage.write(
            key: AppConstants.tokenKey,
            value: result.token,
          );
        }
        if (result.refreshToken != null) {
          await _secureStorage.write(
            key: AppConstants.refreshTokenKey,
            value: result.refreshToken,
          );
        }

        _setLoading(false);
        return true;
      } else {
        _setError(result.message ?? '登录失败');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('登录时发生错误: $e');
      _setLoading(false);
      return false;
    }
  }

  // ================================================================
  // REGISTER
  // ================================================================

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String username,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        username: username,
      );

      if (result.success && result.user != null) {
        _currentUser = result.user;

        // Save tokens to secure storage
        if (result.token != null) {
          await _secureStorage.write(
            key: AppConstants.tokenKey,
            value: result.token,
          );
        }
        if (result.refreshToken != null) {
          await _secureStorage.write(
            key: AppConstants.refreshTokenKey,
            value: result.refreshToken,
          );
        }

        _setLoading(false);
        return true;
      } else {
        _setError(result.message ?? '注册失败');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('注册时发生错误: $e');
      _setLoading(false);
      return false;
    }
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  /// Logout current user
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      // Logout from repository (clears local storage)
      await _authRepository.logout();

      // Clear token from secure storage
      await _secureStorage.delete(key: AppConstants.tokenKey);
      await _secureStorage.delete(key: AppConstants.refreshTokenKey);

      // Clear current user
      _currentUser = null;

      _setLoading(false);
    } catch (e) {
      _setError('登出时发生错误: $e');
      _setLoading(false);
    }
  }

  // ================================================================
  // HELPERS
  // ================================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear error message manually
  void clearError() {
    _clearError();
  }

  /// Get saved token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.tokenKey);
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
