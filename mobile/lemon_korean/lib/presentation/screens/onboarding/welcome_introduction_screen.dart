import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'utils/onboarding_colors.dart';
import 'utils/onboarding_text_styles.dart';
import 'widgets/feature_card.dart';
import 'widgets/lemon_character.dart';
import 'widgets/onboarding_button.dart';
import 'level_selection_screen.dart';

/// Screen 2: Welcome & App Introduction
/// Shows app features and value proposition
class WelcomeIntroductionScreen extends StatefulWidget {
  const WelcomeIntroductionScreen({super.key});

  @override
  State<WelcomeIntroductionScreen> createState() =>
      _WelcomeIntroductionScreenState();
}

class _WelcomeIntroductionScreenState extends State<WelcomeIntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: OnboardingColors.backgroundYellow,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: OnboardingSpacing.lg,
            vertical: OnboardingSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lemon character (waving)
              const LemonCharacter(
                expression: LemonExpression.waving,
                size: 120,
              )
                  .animate()
                  .scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fade(duration: 400.ms),

              const SizedBox(height: OnboardingSpacing.xl),

              // Welcome title
              Text(
                l10n.onboardingWelcomeTitle,
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
                l10n.onboardingWelcomeSubtitle,
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

              // Feature cards (staggered animation)
              FeatureCard(
                icon: Icons.download_rounded,
                title: l10n.onboardingFeature1Title,
                description: l10n.onboardingFeature1Desc,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideX(
                    begin: -0.3,
                    end: 0,
                    delay: 400.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: OnboardingSpacing.md),

              FeatureCard(
                icon: Icons.psychology_rounded,
                title: l10n.onboardingFeature2Title,
                description: l10n.onboardingFeature2Desc,
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms)
                  .slideX(
                    begin: -0.3,
                    end: 0,
                    delay: 500.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: OnboardingSpacing.md),

              FeatureCard(
                icon: Icons.stairs_rounded,
                title: l10n.onboardingFeature3Title,
                description: l10n.onboardingFeature3Desc,
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .slideX(
                    begin: -0.3,
                    end: 0,
                    delay: 600.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: OnboardingSpacing.xxl),

              // Next button
              OnboardingButton(
                text: l10n.onboardingNext,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LevelSelectionScreen(),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
