import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'utils/onboarding_colors.dart';
import 'utils/onboarding_text_styles.dart';
import 'widgets/lemon_character.dart';
import 'widgets/onboarding_button.dart';
import 'widgets/level_selection_card.dart';
import 'weekly_goal_screen.dart';

/// Screen 3: Korean Level Selection
/// User selects their current Korean proficiency level
class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  String? _selectedLevel;

  final List<Map<String, String>> _levels = [
    {'id': 'beginner', 'emoji': '🌱', 'topik': '1'},
    {'id': 'elementary', 'emoji': '🌿', 'topik': '2'},
    {'id': 'intermediate', 'emoji': '🌳', 'topik': '3-4'},
    {'id': 'advanced', 'emoji': '🎓', 'topik': '5-6'},
  ];

  String _getLevelTitle(AppLocalizations l10n, String levelId) {
    switch (levelId) {
      case 'beginner':
        return l10n.levelBeginner;
      case 'elementary':
        return l10n.levelElementary;
      case 'intermediate':
        return l10n.levelIntermediate;
      case 'advanced':
        return l10n.levelAdvanced;
      default:
        return '';
    }
  }

  String _getLevelDesc(AppLocalizations l10n, String levelId) {
    switch (levelId) {
      case 'beginner':
        return l10n.levelBeginnerDesc;
      case 'elementary':
        return l10n.levelElementaryDesc;
      case 'intermediate':
        return l10n.levelIntermediateDesc;
      case 'advanced':
        return l10n.levelAdvancedDesc;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: OnboardingColors.backgroundYellow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: OnboardingColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: OnboardingSpacing.lg,
            vertical: OnboardingSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lemon character (thinking)
              const LemonCharacter(
                expression: LemonExpression.thinking,
                size: 100,
              )
                  .animate()
                  .scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fade(duration: 400.ms),

              const SizedBox(height: OnboardingSpacing.xl),

              // Title
              Text(
                l10n.onboardingLevelTitle,
                style: OnboardingTextStyles.headline2,
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
                l10n.onboardingLevelSubtitle,
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

              const SizedBox(height: OnboardingSpacing.xl),

              // Level cards
              ..._levels.asMap().entries.map((entry) {
                final index = entry.key;
                final level = entry.value;
                final levelId = level['id']!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: OnboardingSpacing.md),
                  child: LevelSelectionCard(
                    emoji: level['emoji']!,
                    title: _getLevelTitle(l10n, levelId),
                    description: _getLevelDesc(l10n, levelId),
                    topikLevel: l10n.levelTopik(level['topik']!),
                    isSelected: _selectedLevel == levelId,
                    onTap: () {
                      setState(() {
                        _selectedLevel = levelId;
                      });
                    },
                  )
                      .animate()
                      .fadeIn(
                        delay: (400 + index * 100).ms,
                        duration: 400.ms,
                      )
                      .slideX(
                        begin: -0.3,
                        end: 0,
                        delay: (400 + index * 100).ms,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      ),
                );
              }),

              const SizedBox(height: OnboardingSpacing.lg),

              // Next button
              OnboardingButton(
                text: l10n.onboardingNext,
                isEnabled: _selectedLevel != null,
                onPressed: _selectedLevel == null
                    ? null
                    : () async {
                        // Save level to settings
                        final settingsProvider =
                            context.read<SettingsProvider>();
                        final navigator = Navigator.of(context);

                        await settingsProvider.setUserLevel(_selectedLevel!);

                        if (!mounted) return;

                        // Navigate to next screen
                        navigator.push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const WeeklyGoalScreen(),
                            transitionDuration:
                                const Duration(milliseconds: 400),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                  .fadeIn(delay: 800.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 800.ms,
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
