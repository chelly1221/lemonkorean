import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import 'utils/onboarding_colors.dart';
import 'utils/onboarding_text_styles.dart';
import 'widgets/lemon_character.dart';
import 'widgets/onboarding_button.dart';

/// Screen 6: Account Choice
/// Asks user to login or create a new account
class AccountChoiceScreen extends StatelessWidget {
  const AccountChoiceScreen({super.key});

  Future<void> _navigateToAuth(
    BuildContext context,
    SettingsProvider settingsProvider, {
    required bool toLogin,
  }) async {
    // Mark onboarding as completed
    await settingsProvider.completeOnboarding();

    if (!context.mounted) return;

    // Navigate to login or register screen (replace entire stack)
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            toLogin ? const LoginScreen() : const RegisterScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();

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
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: OnboardingColors.textPrimary,
                  ),
                ),
              ),

              const Spacer(),

              // Lemon character (waving/friendly)
              const LemonCharacter(
                expression: LemonExpression.waving,
                size: 160,
              )
                  .animate()
                  .scale(
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fade(duration: 400.ms),

              const SizedBox(height: OnboardingSpacing.xxl),

              // Title
              Text(
                l10n.onboardingAccountTitle,
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
                l10n.onboardingAccountSubtitle,
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

              const Spacer(),

              // "I have an account" button - navigates to Login
              OnboardingButton(
                text: l10n.login,
                onPressed: () => _navigateToAuth(context, settingsProvider, toLogin: true),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 500.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: OnboardingSpacing.sm),

              // "Create account" button - navigates to Register
              OnboardingButton(
                text: l10n.createAccount,
                variant: OnboardingButtonVariant.secondary,
                onPressed: () => _navigateToAuth(context, settingsProvider, toLogin: false),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 600.ms,
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
