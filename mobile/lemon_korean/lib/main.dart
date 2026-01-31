import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/config/environment_config.dart';
import 'core/constants/app_constants.dart';
import 'core/network/api_client.dart';
import 'core/platform/platform_factory.dart';
import 'core/utils/app_logger.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/bookmark_provider.dart';
import 'presentation/providers/download_provider.dart';
import 'presentation/providers/lesson_provider.dart';
import 'presentation/providers/progress_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/sync_provider.dart';
import 'presentation/providers/vocabulary_browser_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';

// Mobile-only imports with web stubs
import 'package:hive_flutter/hive_flutter.dart'
    if (dart.library.html) 'core/platform/web/stubs/hive_stub.dart';
import 'core/storage/local_storage.dart'
    if (dart.library.html) 'core/platform/web/stubs/local_storage_stub.dart';
import 'core/services/notification_service.dart'
    if (dart.library.html) 'core/platform/web/stubs/notification_stub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // STEP 1: Fetch network mode from server (quick HTTP call)
  // This determines which .env file to load
  print('[Main] ═══════════════════════════════════════');
  print('[Main] Fetching network mode from server...');
  final networkMode = await _fetchNetworkMode();
  print('[Main] Network mode from server: ${networkMode ?? "not available (using build mode)"}');
  print('[Main] ═══════════════════════════════════════');

  // STEP 2: Initialize environment configuration with network mode override
  // If server returned a mode, use it; otherwise fall back to build mode
  await EnvironmentConfig.init(mode: networkMode);
  EnvironmentConfig.printConfig();

  // STEP 3: Initialize AppConstants with environment URLs (as fallback)
  AppConstants.initFromEnvironment();

  // STEP 3.5: Ensure ApiClient is initialized with base URL
  await ApiClient.instance.ensureInitialized();

  // Log configuration for debugging
  if (kDebugMode) {
    print('[Main] Environment initialized:');
    print('  BASE_URL: ${EnvironmentConfig.baseUrl}');
    print('  API_URL: ${AppConstants.apiUrl}');
  }

  // STEP 4: Platform-specific initialization
  if (kIsWeb) {
    AppLogger.i('Running on WEB platform', tag: 'Main');

    // Web: Initialize IndexedDB storage
    final storage = PlatformFactory.createLocalStorage();
    await storage.init();

    // Web: Also initialize static stub for backward compatibility
    await LocalStorage.init();

    // Web: Initialize notification service (limited functionality)
    final notification = PlatformFactory.createNotificationService();
    await notification.init();
  } else {
    AppLogger.i('Running on MOBILE platform', tag: 'Main');

    // Mobile: Initialize Hive
    await Hive.initFlutter();
    await LocalStorage.init();

    // Mobile: Initialize notification service
    await NotificationService.instance.init();

    // Mobile: Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Mobile: Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // STEP 5: Wait for network connection (max 5 seconds)
  await _waitForNetwork();

  // STEP 6: Fetch full network configuration from server
  AppLogger.i('Fetching network configuration from server...', tag: 'Main');
  final apiClient = ApiClient.instance;
  final networkConfig = await apiClient.getNetworkConfig();

  // Update app constants with server configuration
  AppConstants.updateFromConfig(networkConfig);

  // Update ApiClient's base URL to use new config
  apiClient.updateBaseUrl();

  // STEP 7: Log final configuration (both environment and network modes)
  AppLogger.i('═══════════════════════════════════════', tag: 'Main');
  AppLogger.i('Environment Mode: ${EnvironmentConfig.envMode}', tag: 'Main');
  AppLogger.i('Network Mode: ${networkConfig.mode}', tag: 'Main');
  AppLogger.i('Loaded from: ${EnvironmentConfig.loadedEnvFile}', tag: 'Main');
  AppLogger.i('Base URL: ${networkConfig.baseUrl}', tag: 'Main');
  AppLogger.i('Use Gateway: ${networkConfig.useGateway}', tag: 'Main');
  AppLogger.i('═══════════════════════════════════════', tag: 'Main');

  runApp(const LemonKoreanApp());
}

/// Fetch network mode from server before initializing environment
/// Returns null if server is unreachable (will fall back to build mode)
Future<String?> _fetchNetworkMode() async {
  try {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    // Try multiple URLs to find the server
    // Priority: production with port (works externally), local dev, then generic endpoints
    final urls = [
      'http://3chan.kr:3006',      // Production domain with explicit port (works externally)
      'http://localhost:3006',     // Local development (works locally)
      'http://localhost',          // Local Nginx gateway
      'http://3chan.kr',           // Production Nginx gateway
    ];

    for (final baseUrl in urls) {
      try {
        print('[Main] Trying to fetch network mode from: $baseUrl');
        final response = await dio.get('$baseUrl/api/admin/network/config');

        if (response.statusCode == 200 && response.data != null) {
          final mode = response.data['config']?['mode'];
          if (mode != null) {
            print('[Main] ═══════════════════════════════════════');
            print('[Main] ✓ Network mode fetch SUCCEEDED');
            print('[Main]   URL: $baseUrl/api/admin/network/config');
            print('[Main]   Mode: $mode');
            print('[Main] ═══════════════════════════════════════');
            return mode;
          }
        }
      } catch (e) {
        // Try next URL
        print('[Main] ✗ Failed to fetch from $baseUrl: ${e.toString().split('\n')[0]}');
      }
    }

    print('[Main] ═══════════════════════════════════════');
    print('[Main] ⚠ Network mode fetch FAILED');
    print('[Main]   Tried ${urls.length} URLs without success');
    print('[Main]   Falling back to build mode (.env file)');
    print('[Main] ═══════════════════════════════════════');
    return null;  // Fall back to build mode
  } catch (e) {
    print('[Main] ⚠ Error fetching network mode: $e');
    return null;  // Fall back to build mode
  }
}

/// Wait for network connection (max 5 seconds)
Future<void> _waitForNetwork() async {
  final connectivity = Connectivity();

  for (int i = 0; i < 10; i++) {
    final result = await connectivity.checkConnectivity();
    // Check if connection is available (not none)
    if (result != ConnectivityResult.none) {
      AppLogger.i('Network connected: $result', tag: 'Main');
      return;
    }
    AppLogger.i('Waiting for network... ($i/10)', tag: 'Main');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  AppLogger.w('Network not available after 5 seconds', tag: 'Main');
}

class LemonKoreanApp extends StatelessWidget {
  const LemonKoreanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => VocabularyBrowserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        // Download provider only on mobile (web doesn't support file downloads)
        if (!kIsWeb) ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          // Determine locale based on Chinese variant setting
          final locale = settings.chineseVariant == ChineseVariant.traditional
              ? const Locale('zh', 'TW')
              : const Locale('zh');

          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            // Localization configuration
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppConstants.primaryColor,
                brightness: Brightness.light,
              ),
              fontFamily: 'NotoSansKR',
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(AppConstants.splashDelay);

    if (!mounted) return;

    // Initialize SettingsProvider
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    await settingsProvider.init();

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

    // 먼저 인증 상태 확인
    final isLoggedIn = await authProvider.checkAuth();

    if (!mounted) return;

    if (isLoggedIn && authProvider.currentUser?.id != null) {
      final userId = authProvider.currentUser!.id;

      // 로그인 상태: 레슨 + 진도/통계 동기화 (3초 타임아웃)
      await Future.wait([
        lessonProvider.fetchLessons(),
        progressProvider.syncWithServer(userId).timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            debugPrint('[Splash] Sync timeout, using cached data');
          },
        ),
      ]);
    } else {
      // 비로그인: 레슨만 프리페치
      await lessonProvider.fetchLessons();
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryColor,
              AppConstants.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🍋',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Semantics(
                header: true,
                child: const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Text(
                    l10n?.appName ?? '柠檬韩语',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              Semantics(
                label: 'Loading',
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
