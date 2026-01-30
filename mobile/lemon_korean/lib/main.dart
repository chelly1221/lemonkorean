import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/config/environment_config.dart';
import 'core/constants/app_constants.dart';
import 'core/network/api_client.dart';
import 'core/services/notification_service.dart';
import 'core/storage/local_storage.dart';
import 'core/utils/app_logger.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/download_provider.dart';
import 'presentation/providers/lesson_provider.dart';
import 'presentation/providers/progress_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/sync_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration from .env files
  await EnvironmentConfig.init();
  EnvironmentConfig.printConfig();

  // Initialize AppConstants with environment URLs (as fallback)
  AppConstants.initFromEnvironment();

  // Initialize Hive
  await Hive.initFlutter();
  await LocalStorage.init();

  // Initialize Notification Service
  await NotificationService.instance.init();

  // Fetch network configuration from server (may override environment URLs)
  AppLogger.i('Fetching network configuration from server...', tag: 'Main');
  final apiClient = ApiClient.instance;
  final networkConfig = await apiClient.getNetworkConfig();

  // Update app constants with server configuration
  AppConstants.updateFromConfig(networkConfig);

  // Update ApiClient's base URL to use new config
  apiClient.updateBaseUrl();

  AppLogger.i('Network configuration loaded: ${networkConfig.mode} mode', tag: 'Main');

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const LemonKoreanApp());
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
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
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

    // Run auth check and lesson prefetch in parallel
    final results = await Future.wait([
      authProvider.checkAuth(),
      lessonProvider.fetchLessons(),
    ]);

    final isLoggedIn = results[0] as bool;

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
