import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'presentation/providers/gamification_provider.dart';
import 'presentation/providers/hangul_provider.dart';
import 'presentation/providers/lesson_provider.dart';
import 'presentation/providers/progress_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/sync_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/vocabulary_browser_provider.dart';
import 'core/services/socket_service.dart';
import 'presentation/providers/dm_provider.dart';
import 'presentation/providers/feed_provider.dart';
import 'presentation/providers/social_provider.dart';
import 'presentation/providers/character_provider.dart';
import 'presentation/providers/voice_room_provider.dart';
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
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => VocabularyBrowserProvider()),
        ChangeNotifierProvider(create: (_) => HangulProvider()),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => SocialProvider()),
        ChangeNotifierProvider(create: (_) => DmProvider()),
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
        ChangeNotifierProvider(create: (_) => VoiceRoomProvider()),
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

      // Connect Socket.IO for DM
      SocketService.instance.connect();

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final mascotSize = screenHeight * 0.22;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFEFFF4),
        child: Stack(
          children: [
            // ── 방사형 그라데이션 오버레이 ──
            Center(
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Transform.scale(
                  scaleY: 0.65,
                  child: Container(
                    width: screenWidth * 1.2,
                    height: screenWidth * 1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFEF7E).withOpacity(0.5),
                          const Color(0xFFFFEF7E).withOpacity(0.0),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── 콘텐츠 ──
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 마스코트
                  SvgPicture.asset(
                    'assets/images/moni_mascot.svg',
                    width: mascotSize,
                    height: mascotSize,
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(duration: 500.ms),
                  SizedBox(height: screenHeight * 0.03),
                  // 제목
                  Semantics(
                    header: true,
                    child: Text(
                      '레몬 한국어',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF43240D),
                        letterSpacing: -0.8,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms)
                      .slideY(begin: 0.15, end: 0, duration: 500.ms, curve: Curves.easeOut),
                  SizedBox(height: screenHeight * 0.01),
                  // 부제목
                  Text(
                    '상큼한 학습습관',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: screenWidth * 0.045,
                      color: const Color(0xFF907866),
                      letterSpacing: -0.2,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 350.ms, duration: 500.ms)
                      .slideY(begin: 0.15, end: 0, duration: 500.ms, curve: Curves.easeOut),
                  SizedBox(height: screenHeight * 0.06),
                  // 스피너
                  Semantics(
                    label: 'Loading',
                    child: const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDEB887)),
                        strokeWidth: 3,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
