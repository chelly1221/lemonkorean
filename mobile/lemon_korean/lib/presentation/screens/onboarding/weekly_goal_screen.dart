import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'utils/onboarding_colors.dart';
import 'utils/onboarding_text_styles.dart';
import 'widgets/goal_selection_card.dart';
import 'widgets/lemon_character.dart';
import 'widgets/onboarding_button.dart';
import 'personalization_complete_screen.dart';

/// Screen 4: Weekly Goal Selection
/// User sets their weekly learning commitment
class WeeklyGoalScreen extends StatefulWidget {
  const WeeklyGoalScreen({super.key});

  @override
  State<WeeklyGoalScreen> createState() => _WeeklyGoalScreenState();
}

class _WeeklyGoalScreenState extends State<WeeklyGoalScreen> {
  String? _selectedGoal;

  final List<Map<String, dynamic>> _goals = [
    {
      'id': 'casual',
      'emoji': '🍃',
      'target': 2,
      'color': OnboardingColors.blueAccent,
    },
    {
      'id': 'regular',
      'emoji': '🍋',
      'target': 4,
      'color': OnboardingColors.primaryYellow,
    },
    {
      'id': 'serious',
      'emoji': '🔥',
      'target': 6,
      'color': OnboardingColors.accentOrange,
    },
    {
      'id': 'intensive',
      'emoji': '⚡',
      'target': 7,
      'color': OnboardingColors.redAccent,
    },
  ];

  String _getGoalTitle(AppLocalizations l10n, String goalId) {
    switch (goalId) {
      case 'casual':
        return l10n.goalCasual;
      case 'regular':
        return l10n.goalRegular;
      case 'serious':
        return l10n.goalSerious;
      case 'intensive':
        return l10n.goalIntensive;
      default:
        return '';
    }
  }

  String _getGoalDesc(AppLocalizations l10n, String goalId) {
    switch (goalId) {
      case 'casual':
        return l10n.goalCasualDesc;
      case 'regular':
        return l10n.goalRegularDesc;
      case 'serious':
        return l10n.goalSeriousDesc;
      case 'intensive':
        return l10n.goalIntensiveDesc;
      default:
        return '';
    }
  }

  String _getGoalTime(AppLocalizations l10n, String goalId) {
    switch (goalId) {
      case 'casual':
        return l10n.goalCasualTime;
      case 'regular':
        return l10n.goalRegularTime;
      case 'serious':
        return l10n.goalSeriousTime;
      case 'intensive':
        return l10n.goalIntensiveTime;
      default:
        return '';
    }
  }

  String _getGoalHelper(AppLocalizations l10n, String goalId) {
    switch (goalId) {
      case 'casual':
        return l10n.goalCasualHelper;
      case 'regular':
        return l10n.goalRegularHelper;
      case 'serious':
        return l10n.goalSeriousHelper;
      case 'intensive':
        return l10n.goalIntensiveHelper;
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
              // Lemon character (encouraging)
              const LemonCharacter(
                expression: LemonExpression.encouraging,
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
                l10n.onboardingGoalTitle,
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
                l10n.onboardingGoalSubtitle,
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

              // Goal cards
              ..._goals.asMap().entries.map((entry) {
                final index = entry.key;
                final goal = entry.value;
                final goalId = goal['id'] as String;

                return Padding(
                  padding: const EdgeInsets.only(bottom: OnboardingSpacing.md),
                  child: GoalSelectionCard(
                    emoji: goal['emoji'] as String,
                    title: _getGoalTitle(l10n, goalId),
                    description: _getGoalDesc(l10n, goalId),
                    timeText: _getGoalTime(l10n, goalId),
                    helperText: _getGoalHelper(l10n, goalId),
                    accentColor: goal['color'] as Color,
                    isSelected: _selectedGoal == goalId,
                    onTap: () {
                      setState(() {
                        _selectedGoal = goalId;
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
                isEnabled: _selectedGoal != null,
                onPressed: _selectedGoal == null
                    ? null
                    : () async {
                        // Save goal to settings
                        final settingsProvider =
                            context.read<SettingsProvider>();
                        final selectedGoalData = _goals.firstWhere(
                          (g) => g['id'] == _selectedGoal,
                        );
                        await settingsProvider.setWeeklyGoal(
                          _selectedGoal!,
                          selectedGoalData['target'] as int,
                        );

                        if (!mounted) return;

                        // Navigate to next screen
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const PersonalizationCompleteScreen(),
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
