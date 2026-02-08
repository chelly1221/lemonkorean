import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/platform/storage_reset.dart'
    if (dart.library.html) 'core/platform/web/storage_reset_web.dart';
import 'core/network/api_client.dart';
import 'core/platform/platform_factory.dart';
import 'core/utils/app_logger.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/bookmark_provider.dart';
import 'presentation/providers/download_provider.dart';
import 'presentation/providers/hangul_provider.dart';
import 'presentation/providers/lesson_provider.dart';
import 'presentation/providers/progress_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/sync_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/vocabulary_browser_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/onboarding/language_selection_screen.dart';

// Mobile-only imports with web stubs
import 'package:hive_flutter/hive_flutter.dart'
    if (dart.library.html) 'core/platform/web/stubs/hive_stub.dart';
import 'core/storage/local_storage.dart'
    if (dart.library.html) 'core/platform/web/stubs/local_storage_stub.dart';
import 'core/services/notification_service.dart'
    if (dart.library.html) 'core/platform/web/stubs/notification_stub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Log configuration for debugging
  if (kDebugMode) {
    AppLogger.i('═══════════════════════════════════════', tag: 'Main');
    AppLogger.i('Initializing Lemon Korean App', tag: 'Main');
    AppLogger.i('Production URL: ${AppConstants.baseUrl}', tag: 'Main');
    AppLogger.i('═══════════════════════════════════════', tag: 'Main');
  }

  // Initialize ApiClient with production URL
  await ApiClient.instance.ensureInitialized();

  // Platform-specific initialization
  if (kIsWeb) {
    AppLogger.i('Running on WEB platform', tag: 'Main');

    // Web: Check and handle storage reset flag BEFORE initializing storage
    await checkAndHandleStorageReset();

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

  // Pre-initialize SettingsProvider BEFORE runApp to load saved language
  // This prevents language flicker on startup (showing English/Chinese before Korean)
  final settingsProvider = SettingsProvider();
  await settingsProvider.init();

  // Pre-initialize ThemeProvider to load theme from cache/API
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(LemonKoreanApp(
    settingsProvider: settingsProvider,
    themeProvider: themeProvider,
  ));
}

/// Convert AppLanguage to Locale
Locale _getLocaleFromLanguage(AppLanguage language) {
  switch (language) {
    case AppLanguage.zhCN:
      return const Locale('zh');
    case AppLanguage.zhTW:
      return const Locale('zh', 'TW');
    case AppLanguage.ko:
      return const Locale('ko');
    case AppLanguage.en:
      return const Locale('en');
    case AppLanguage.ja:
      return const Locale('ja');
    case AppLanguage.es:
      return const Locale('es');
  }
}

class LemonKoreanApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final ThemeProvider themeProvider;

  const LemonKoreanApp({
    required this.settingsProvider,
    required this.themeProvider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => VocabularyBrowserProvider()),
        ChangeNotifierProvider(create: (_) => HangulProvider()),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        // Download provider only on mobile (web doesn't support file downloads)
        if (!kIsWeb) ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ],
      child: Consumer2<SettingsProvider, ThemeProvider>(
        builder: (context, settings, theme, child) {
          // Determine locale based on app language setting
          final locale = _getLocaleFromLanguage(settings.appLanguage);

          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            // Localization configuration
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            // Use theme from ThemeProvider (loaded from admin API)
            theme: theme.lightTheme,
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

    // SettingsProvider is already initialized in main() before runApp()
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    // Check if onboarding is completed
    if (!settingsProvider.hasCompletedOnboarding) {
      // Navigate to onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LanguageSelectionScreen(),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

    // Check auth status
    final isLoggedIn = await authProvider.checkAuth();

    if (!mounted) return;

    if (isLoggedIn && authProvider.currentUser?.id != null) {
      final userId = authProvider.currentUser!.id;

      // Logged in: Sync lessons + progress (3 second timeout)
      await Future.wait([
        lessonProvider.fetchLessons(language: settingsProvider.contentLanguageCode),
        progressProvider.syncWithServer(userId).timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            debugPrint('[Splash] Sync timeout, using cached data');
          },
        ),
      ]);
    } else {
      // Not logged in: Prefetch lessons only
      await lessonProvider.fetchLessons(language: settingsProvider.contentLanguageCode);
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
        decoration: const BoxDecoration(
          color: AppConstants.primaryColor,
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
                      color: Colors.black.withValues(alpha: 0.1),
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
                    color: Color(0xFF001F3F), // 짙은 남색
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Text(
                    l10n?.appName ?? '레몬 한국어',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF003366), // 짙은 남색 (약간 밝게)
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
