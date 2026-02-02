import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../auth/login_screen.dart';
import 'utils/onboarding_colors.dart';
import 'utils/onboarding_text_styles.dart';
import 'widgets/lemon_character.dart';
import 'widgets/onboarding_button.dart';
import 'widgets/summary_card.dart';

/// Screen 5: Personalization Complete
/// Shows summary of user's selections and completes onboarding
class PersonalizationCompleteScreen extends StatelessWidget {
  const PersonalizationCompleteScreen({super.key});

  String _getLevelEmoji(String? level) {
    switch (level) {
      case 'beginner':
        return '🌱';
      case 'elementary':
        return '🌿';
      case 'intermediate':
        return '🌳';
      case 'advanced':
        return '🎓';
      default:
        return '📚';
    }
  }

  String _getLevelText(AppLocalizations l10n, String? level) {
    switch (level) {
      case 'beginner':
        return l10n.levelBeginner;
      case 'elementary':
        return l10n.levelElementary;
      case 'intermediate':
        return l10n.levelIntermediate;
      case 'advanced':
        return l10n.levelAdvanced;
      default:
        return '-';
    }
  }

  String _getGoalEmoji(String goal) {
    switch (goal) {
      case 'casual':
        return '🍃';
      case 'regular':
        return '🍋';
      case 'serious':
        return '🔥';
      case 'intensive':
        return '⚡';
      default:
        return '🎯';
    }
  }

  String _getGoalText(AppLocalizations l10n, String goal) {
    switch (goal) {
      case 'casual':
        return l10n.goalCasual;
      case 'regular':
        return l10n.goalRegular;
      case 'serious':
        return l10n.goalSerious;
      case 'intensive':
        return l10n.goalIntensive;
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();

    // Get language display text
    final languageText = settingsProvider.appLanguage.nativeName;
    final languageEmoji = '🌐';

    return Scaffold(
      backgroundColor: OnboardingColors.backgroundYellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: OnboardingSpacing.lg,
            vertical: OnboardingSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Lemon character (excited with sparkles)
              const LemonCharacter(
                expression: LemonExpression.excited,
                size: 140,
              )
                  .animate()
                  .scale(
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fade(duration: 400.ms),

              const SizedBox(height: OnboardingSpacing.xl),

              // Title
              Text(
                l10n.onboardingCompleteTitle,
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

              const SizedBox(height: OnboardingSpacing.sm),

              // Subtitle
              Text(
                l10n.onboardingCompleteSubtitle,
                style: OnboardingTextStyles.body1,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 300.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: OnboardingSpacing.xxl),

              // Summary card
              SummaryCard(
                languageLabel: l10n.onboardingSummaryLanguage,
                languageEmoji: languageEmoji,
                languageValue: languageText,
                levelLabel: l10n.onboardingSummaryLevel,
                levelEmoji: _getLevelEmoji(settingsProvider.userLevel),
                levelValue: _getLevelText(l10n, settingsProvider.userLevel),
                goalLabel: l10n.onboardingSummaryGoal,
                goalEmoji: _getGoalEmoji(settingsProvider.weeklyGoal),
                goalValue: _getGoalText(l10n, settingsProvider.weeklyGoal),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.0, 1.0),
                    delay: 400.ms,
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

              const Spacer(),

              // Start learning button
              OnboardingButton(
                text: l10n.onboardingStartLearning,
                onPressed: () async {
                  // Mark onboarding as completed
                  await settingsProvider.completeOnboarding();

                  if (!context.mounted) return;

                  // Navigate to login screen (replace entire stack)
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LoginScreen(),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final fadeAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        ));

                        return FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        );
                      },
                    ),
                    (route) => false,
                  );
                },
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

              const SizedBox(height: OnboardingSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
