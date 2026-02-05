import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/app_logger.dart';
import '../../data/models/app_theme_model.dart';

/// Theme Provider
///
/// Manages app theme state by loading configuration from the admin API.
/// Caches theme locally in Hive for offline access.
class ThemeProvider extends ChangeNotifier {
  // ================================================================
  // DEPENDENCIES
  // ================================================================

  final _apiClient = ApiClient.instance;
  static const String _themeBoxName = 'app_theme';
  static const String _themeKey = 'current_theme';

  // ================================================================
  // STATE
  // ================================================================

  AppThemeModel? _currentTheme;
  bool _isLoading = false;
  String? _error;

  // ================================================================
  // GETTERS
  // ================================================================

  /// Current theme model (or default if not loaded)
  AppThemeModel get currentTheme => _currentTheme ?? AppThemeModel.defaultTheme();

  /// Whether theme is currently loading
  bool get isLoading => _isLoading;

  /// Error message if theme loading failed
  String? get error => _error;

  /// Theme version for cache invalidation
  int get version => currentTheme.version;

  // ================================================================
  // INITIALIZATION
  // ================================================================

  /// Initialize theme provider
  ///
  /// Loads theme from cache first, then fetches from API if online.
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load from cache first
      await _loadFromCache();

      // Then try to fetch from API (will update cache if successful)
      await refreshTheme(silent: true);

      _error = null;
    } catch (e) {
      AppLogger.e('Theme initialization failed', error: e);
      _error = e.toString();
      // Fall back to default theme if cache and API both fail
      _currentTheme ??= AppThemeModel.defaultTheme();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load theme from local cache
  Future<void> _loadFromCache() async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      final cachedData = box.get(_themeKey) as Map<dynamic, dynamic>?;

      if (cachedData != null) {
        final themeMap = Map<String, dynamic>.from(cachedData);
        _currentTheme = AppThemeModel.fromJson(themeMap);
        AppLogger.d('Theme loaded from cache (version: ${_currentTheme!.version})');
      } else {
        AppLogger.d('No cached theme found, using defaults');
      }
    } catch (e) {
      AppLogger.e('Failed to load theme from cache', error: e);
    }
  }

  /// Save theme to local cache
  Future<void> _saveToCache(AppThemeModel theme) async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      await box.put(_themeKey, theme.toJson());
      AppLogger.d('Theme saved to cache (version: ${theme.version})');
    } catch (e) {
      AppLogger.e('Failed to save theme to cache', error: e);
    }
  }

  // ================================================================
  // THEME LOADING
  // ================================================================

  /// Refresh theme from API
  ///
  /// Fetches the latest theme configuration from the admin API.
  /// If [silent] is true, won't show loading state or notify listeners during fetch.
  Future<void> refreshTheme({bool silent = false}) async {
    try {
      if (!silent) {
        _isLoading = true;
        _error = null;
        notifyListeners();
      }

      // Fetch theme from API (public endpoint, no auth required)
      final response = await _apiClient.getAppTheme();

      if (response.statusCode == 200 && response.data != null) {
        final newTheme = AppThemeModel.fromJson(response.data);

        // Check if version changed
        final versionChanged = _currentTheme == null || newTheme.version != _currentTheme!.version;

        if (versionChanged) {
          _currentTheme = newTheme;
          await _saveToCache(newTheme);

          // Initialize AppConstants with new theme
          AppConstants.initializeTheme(newTheme);

          AppLogger.i('Theme updated from API (version: ${newTheme.version})');
          if (!silent) {
            notifyListeners();
          }
        } else {
          AppLogger.d('Theme version unchanged, skipping update');
        }

        _error = null;
      } else {
        throw Exception('Failed to fetch theme: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.e('Failed to refresh theme from API', error: e);
      _error = e.toString();

      // If this is first load and we have no cached theme, use default
      _currentTheme ??= AppThemeModel.defaultTheme();
    } finally {
      if (!silent) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Clear theme cache
  ///
  /// Removes cached theme and resets to default.
  /// Useful for testing or troubleshooting.
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      await box.delete(_themeKey);
      _currentTheme = AppThemeModel.defaultTheme();
      AppLogger.i('Theme cache cleared');
      notifyListeners();
    } catch (e) {
      AppLogger.e('Failed to clear theme cache', error: e);
    }
  }

  // ================================================================
  // THEME DATA
  // ================================================================

  /// Generate Flutter ThemeData from current theme
  ThemeData get lightTheme {
    final theme = currentTheme;

    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: theme.primary,
        secondary: theme.secondary,
        tertiary: theme.accent,
        error: theme.error,
        surface: theme.cardBackgroundCol,
        surfaceContainerHighest: theme.backgroundLightCol,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: theme.backgroundLightCol,

      // Card Theme
      cardTheme: CardThemeData(
        color: theme.cardBackgroundCol,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: theme.textPrimaryCol,
          fontSize: AppConstants.fontSizeXXLarge,
          fontWeight: FontWeight.bold,
          fontFamily: theme.fontFamily,
        ),
        displayMedium: TextStyle(
          color: theme.textPrimaryCol,
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.bold,
          fontFamily: theme.fontFamily,
        ),
        displaySmall: TextStyle(
          color: theme.textPrimaryCol,
          fontSize: AppConstants.fontSizeLarge,
          fontWeight: FontWeight.bold,
          fontFamily: theme.fontFamily,
        ),
        bodyLarge: TextStyle(
          color: theme.textPrimaryCol,
          fontSize: AppConstants.fontSizeNormal,
          fontFamily: theme.fontFamily,
        ),
        bodyMedium: TextStyle(
          color: theme.textSecondaryCol,
          fontSize: AppConstants.fontSizeMedium,
          fontFamily: theme.fontFamily,
        ),
        bodySmall: TextStyle(
          color: theme.textHintCol,
          fontSize: AppConstants.fontSizeSmall,
          fontFamily: theme.fontFamily,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: theme.cardBackgroundCol,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: theme.textHintCol),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: theme.textHintCol),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: theme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: theme.error),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: theme.primary,
      ),

      // Font Family (applied globally)
      fontFamily: theme.fontFamily,
    );
  }

  /// Generate dark theme (if needed in future)
  ThemeData get darkTheme {
    final theme = currentTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.dark(
        primary: theme.primary,
        secondary: theme.secondary,
        tertiary: theme.accent,
        error: theme.error,
        surface: theme.backgroundDarkCol,
        surfaceContainerHighest: const Color(0xFF1E1E1E),
      ),

      scaffoldBackgroundColor: theme.backgroundDarkCol,
      fontFamily: theme.fontFamily,
    );
  }
}
