import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'utils/onboarding_colors.dart';
import 'utils/onboarding_text_styles.dart';
import 'widgets/language_selection_card.dart';
import 'widgets/onboarding_button.dart';
import 'level_selection_screen.dart';

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

  // Korean-first language order
  static const _orderedLanguages = [
    AppLanguage.ko,
    AppLanguage.en,
    AppLanguage.zhCN,
    AppLanguage.zhTW,
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

  // Flags that need a black border (light-colored backgrounds)
  static const Set<AppLanguage> _flagsWithBorder = {
    AppLanguage.ja,
    AppLanguage.ko,
  };

  // SVG flag assets (override emoji for these languages)
  static const Map<AppLanguage, String> _languageFlagAssets = {
    AppLanguage.ja: 'assets/images/japanflag.svg',
    AppLanguage.zhCN: 'assets/images/chinaflag.svg',
    AppLanguage.en: 'assets/images/ukflag.svg',
    AppLanguage.zhTW: 'assets/images/taiwanflag.svg',
    AppLanguage.es: 'assets/images/spainflag.svg',
    AppLanguage.ko: 'assets/images/krflag.svg',
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

    // Navigate to next screen (Level Selection)
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LevelSelectionScreen(),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF4),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed: mascot + title + prompt
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.048),

                  // Moni mascot (bundled SVG)
                  SvgPicture.asset(
                    'assets/images/moni_mascot.svg',
                    height: screenHeight * 0.22,
                  )
                      .animate()
                      .scale(duration: 400.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 400.ms),

                  SizedBox(height: screenHeight * 0.016),

                  // Title
                  Text(
                    l10n.onboardingLanguageTitle,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: screenWidth * 0.048,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: const Color(0xFF43240D),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

                  // Instruction text (tight two-line block)
                  Text(
                    l10n.onboardingLanguagePrompt,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: screenWidth * 0.048,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: const Color(0xFF43240D),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms),

                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            ),

            // Scrollable language list with top/bottom fade
            Expanded(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.06, 0.88, 1.0],
                ).createShader(bounds),
                blendMode: BlendMode.dstIn,
                child: ListView(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    top: screenHeight * 0.03,
                    bottom: screenHeight * 0.01,
                  ),
                  children: _orderedLanguages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final language = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.012),
                      child: LanguageSelectionCard(
                        flagEmoji: _languageFlags[language] ?? '🌐',
                        flagSvgAsset: _languageFlagAssets[language],
                        flagShowBorder: _flagsWithBorder.contains(language),
                        nativeName: language.nativeName,
                        isSelected: _selectedLanguage == language,
                        onTap: () async {
                          setState(() {
                            _selectedLanguage = language;
                          });
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
                  }).toList(),
                ),
              ),
            ),

            // Next button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.019,
              ),
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
