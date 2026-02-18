import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'utils/onboarding_colors.dart';
import 'utils/onboarding_text_styles.dart';
import 'widgets/language_selection_card.dart';
import 'widgets/lemon_character.dart';
import 'widgets/onboarding_button.dart';
import 'welcome_introduction_screen.dart';

/// Language Selection Screen (Onboarding Step 1)
/// Allows user to select their preferred app language
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  AppLanguage _selectedLanguage = AppLanguage.ko;
  static const _lemonMascotImageKey =
      'images/288f0d0a4b5650591f7f4f7a85f0a339.webp';

  // English-first language order
  static const _orderedLanguages = [
    AppLanguage.en,
    AppLanguage.zhCN,
    AppLanguage.zhTW,
    AppLanguage.ko,
    AppLanguage.ja,
    AppLanguage.es,
  ];

  // Language flag emojis
  final Map<AppLanguage, String> _languageFlags = {
    AppLanguage.zhCN: '🇨🇳',
    AppLanguage.zhTW: '🇹🇼',
    AppLanguage.ko: '🇰🇷',
    AppLanguage.en: '🇺🇸',
    AppLanguage.ja: '🇯🇵',
    AppLanguage.es: '🇪🇸',
  };

  @override
  void initState() {
    super.initState();
    // Get current language from settings
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _selectedLanguage = settings.appLanguage;
  }

  void _onNext() async {
    // Save selected language
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.setAppLanguage(_selectedLanguage);

    if (!mounted) return;

    // Navigate to next screen (Welcome Introduction)
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WelcomeIntroductionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ));

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ));

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF4),
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: OnboardingSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: OnboardingSpacing.md),

                    // Lemon mascot with shadow ellipses
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Blue shadow ellipses beneath lemon
                          Positioned(
                            bottom: 10,
                            left: 25,
                            child: Container(
                              width: 57,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFFB1E7FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 5,
                            child: Container(
                              width: 47,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFFB1E7FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          // Actual lemon image from media server
                          CachedNetworkImage(
                            imageUrl:
                                '${AppConstants.mediaUrl}/$_lemonMascotImageKey',
                            width: 180,
                            height: 180,
                            fit: BoxFit.contain,
                            placeholder: (ctx, url) =>
                                const SizedBox(width: 180, height: 180),
                            errorWidget: (ctx, url, e) => const LemonCharacter(
                              expression: LemonExpression.welcome,
                              size: 160,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .scale(
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: 400.ms),

                    const SizedBox(height: OnboardingSpacing.xl),

                    // App name - Toss style: dark text
                    Text(
                      l10n.onboardingLanguageTitle,
                      style: OnboardingTextStyles.headline1,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          delay: 200.ms,
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),

                    const SizedBox(height: OnboardingSpacing.xl),

                    // Instruction text
                    Text(
                      l10n.onboardingLanguagePrompt,
                      style: OnboardingTextStyles.body1,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 400.ms),

                    const SizedBox(height: OnboardingSpacing.lg),

                    // Language cards in fixed order (English first)
                    ..._orderedLanguages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final language = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: OnboardingSpacing.sm,
                        ),
                        child: LanguageSelectionCard(
                          flagEmoji: _languageFlags[language] ?? '🌐',
                          nativeName: language.nativeName,
                          isSelected: _selectedLanguage == language,
                          onTap: () async {
                            setState(() {
                              _selectedLanguage = language;
                            });
                            // 즉시 언어 적용
                            final settings = Provider.of<SettingsProvider>(
                                context,
                                listen: false);
                            await settings.setAppLanguage(language);
                          },
                        )
                            .animate()
                            .fadeIn(
                              delay: (400 + index * 50).ms,
                              duration: 400.ms,
                            )
                            .slideX(
                              begin: -0.3,
                              end: 0,
                              delay: (400 + index * 50).ms,
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            ),
                      );
                    }),

                    const SizedBox(height: OnboardingSpacing.xl),
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(OnboardingSpacing.lg),
              child: OnboardingButton(
                text: l10n.onboardingNext,
                onPressed: _onNext,
                backgroundColor: const Color(0xFFFFEC6D),
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 700.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
