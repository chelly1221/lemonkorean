import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/jwt_utils.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Auth Provider
/// Manages authentication state using Provider pattern
class AuthProvider extends ChangeNotifier {
  static const String _tag = 'AuthProvider';
  final AuthRepository _authRepository = AuthRepository();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final _apiClient = ApiClient.instance;

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
  /// OFFLINE-FIRST: Uses cached user data when network is unavailable
  /// Uses multi-source validation: JWT token > SecureStorage > Hive
  Future<void> loadUser() async {
    _setLoading(true);
    _clearError();

    try {
      // 1. Get token and validate
      final token = await _secureStorage.read(key: AppConstants.tokenKey);
      if (token == null) {
        AppLogger.d('No token found, user needs to login', tag: _tag);
        _currentUser = null;
        _setLoading(false);
        return;
      }

      // 2. Check token expiration and refresh if needed
      if (JwtUtils.isTokenExpired(token)) {
        AppLogger.d('Token is expired, attempting refresh...', tag: _tag);
        final refreshToken = await _secureStorage.read(key: AppConstants.refreshTokenKey);
        if (refreshToken == null) {
          AppLogger.w('No refresh token, clearing session', tag: _tag);
          await _forceLogout();
          return;
        }
        final refreshSuccess = await _authRepository.refreshToken(refreshToken);
        if (!refreshSuccess) {
          AppLogger.w('Token refresh failed, clearing session', tag: _tag);
          await _forceLogout();
          return;
        }
      }

      // 3. OFFLINE-FIRST: Try to load cached user first
      final cachedUser = _authRepository.getCachedUser();
      if (cachedUser != null) {
        _currentUser = cachedUser;
        AppLogger.i('Loaded cached user: ${cachedUser.username}', tag: _tag);
        _setLoading(false);

        // 4. Refresh profile in background (don't block startup)
        _refreshUserProfileInBackground();
        return;
      }

      // 5. No cached user - must fetch from API
      await _fetchAndCacheUserProfile();
    } catch (e) {
      AppLogger.e('Error loading user: $e', tag: _tag);
      _setError('加载用户信息失败');
      // Don't force logout on general errors if we have cached user
      if (_currentUser == null) {
        await _forceLogout();
      }
    }
    _setLoading(false);
  }

  /// Get valid user ID from multiple sources
  Future<int?> _getValidUserId() async {
    final hiveUserId = _authRepository.getCurrentUserId();
    final secureUserId = await _authRepository.getSecureUserId();
    final token = await _secureStorage.read(key: AppConstants.tokenKey);
    final tokenUserId = token != null ? JwtUtils.getUserIdFromToken(token) : null;

    AppLogger.d('User ID sources - Hive: $hiveUserId, SecureStorage: $secureUserId, JWT: $tokenUserId', tag: _tag);
    return _validateAndReconcileUserId(hiveUserId, secureUserId, tokenUserId);
  }

  /// Fetch user profile from API and cache it
  Future<void> _fetchAndCacheUserProfile() async {
    final userId = await _getValidUserId();
    if (userId == null) {
      AppLogger.w('No valid user ID found', tag: _tag);
      await _forceLogout();
      return;
    }

    try {
      final response = await _apiClient.getUserProfile(userId);
      if (response.statusCode == 200) {
        _currentUser = UserModel.fromJson(response.data['user']);
        await _authRepository.cacheUser(_currentUser!);
        AppLogger.i('User profile fetched and cached: ${_currentUser?.username}', tag: _tag);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Auth error - force logout
        AppLogger.w('Auth error ${response.statusCode}, logging out', tag: _tag);
        await _forceLogout();
      } else {
        // Other server errors (500, etc.) - don't logout, just log
        AppLogger.w('Failed to fetch user profile: ${response.statusCode}', tag: _tag);
      }
    } catch (e) {
      // Network error - don't force logout, user may be offline
      AppLogger.e('Network error fetching user profile: $e', tag: _tag);
      // If we have no user at all, force logout so they can try again
      if (_currentUser == null) {
        await _forceLogout();
      }
    }
  }

  /// Refresh user profile in background (non-blocking)
  Future<void> _refreshUserProfileInBackground() async {
    final userId = await _getValidUserId();
    if (userId == null) return;

    try {
      final response = await _apiClient.getUserProfile(userId);
      if (response.statusCode == 200) {
        final freshUser = UserModel.fromJson(response.data['user']);
        _currentUser = freshUser;
        await _authRepository.cacheUser(freshUser);
        notifyListeners();
        AppLogger.d('User profile refreshed in background', tag: _tag);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Token became invalid - logout
        AppLogger.w('Background refresh got auth error, logging out', tag: _tag);
        await _forceLogout();
        notifyListeners();
      }
    } catch (e) {
      // Network error in background - silently ignore, user has cached data
      AppLogger.d('Background refresh failed (offline?): $e', tag: _tag);
    }
  }

  /// Validate and reconcile user ID from multiple sources
  /// Priority: Token > SecureStorage > Hive
  int? _validateAndReconcileUserId(int? hiveId, int? secureId, int? tokenId) {
    // If we have a token user ID, it's the most authoritative
    if (tokenId != null) {
      // Sync other storages to match token
      if (secureId != tokenId || hiveId != tokenId) {
        AppLogger.d('Syncing storages to match token userId: $tokenId', tag: _tag);
        _authRepository.saveUserIdToAll(tokenId);
      }
      return tokenId;
    }

    // SecureStorage is more reliable than Hive
    if (secureId != null) {
      // Sync Hive if needed
      if (hiveId != secureId) {
        AppLogger.d('Syncing Hive to match SecureStorage userId: $secureId', tag: _tag);
        _authRepository.saveUserIdToAll(secureId);
      }
      return secureId;
    }

    // Fall back to Hive (least reliable after APK update)
    return hiveId;
  }

  /// Force logout - clears all session data including cached user
  Future<void> _forceLogout() async {
    try {
      // Clear cached user for offline-first auth
      await _authRepository.clearCachedUser();

      await _authRepository.logout();
      await _secureStorage.delete(key: AppConstants.tokenKey);
      await _secureStorage.delete(key: AppConstants.refreshTokenKey);
      await _secureStorage.delete(key: AppConstants.secureUserIdKey);
    } catch (e) {
      AppLogger.e('Error during force logout: $e', tag: _tag);
    }
    _currentUser = null;
    _setLoading(false);
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

        // Save user_id to SecureStorage for reliable persistence
        await _secureStorage.write(
          key: AppConstants.secureUserIdKey,
          value: result.user!.id.toString(),
        );

        // Cache user for offline-first auth
        await _authRepository.cacheUser(result.user!);

        AppLogger.i('Login successful: ${result.user!.username} (ID: ${result.user!.id})', tag: _tag);
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

        // Save user_id to SecureStorage for reliable persistence
        await _secureStorage.write(
          key: AppConstants.secureUserIdKey,
          value: result.user!.id.toString(),
        );

        // Cache user for offline-first auth
        await _authRepository.cacheUser(result.user!);

        AppLogger.i('Registration successful: ${result.user!.username} (ID: ${result.user!.id})', tag: _tag);
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
      // Clear cached user for offline-first auth
      await _authRepository.clearCachedUser();

      // Logout from repository (clears local storage and SecureStorage user_id)
      await _authRepository.logout();

      // Clear tokens and user_id from secure storage
      await _secureStorage.delete(key: AppConstants.tokenKey);
      await _secureStorage.delete(key: AppConstants.refreshTokenKey);
      await _secureStorage.delete(key: AppConstants.secureUserIdKey);

      // Clear current user
      _currentUser = null;

      AppLogger.i('Logout successful', tag: _tag);
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
