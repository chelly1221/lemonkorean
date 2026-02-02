import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../auth/login_screen.dart';
import 'utils/onboarding_colors.dart';
import 'widgets/lemon_character.dart';
import 'widgets/level_selection_card.dart';

/// Welcome and Level Selection Screen (Onboarding Step 2)
/// Welcome message with lemon character and Korean level selection
class WelcomeLevelScreen extends StatefulWidget {
  const WelcomeLevelScreen({super.key});

  @override
  State<WelcomeLevelScreen> createState() => _WelcomeLevelScreenState();
}

class _WelcomeLevelScreenState extends State<WelcomeLevelScreen> {
  String? _selectedLevel;

  List<Map<String, String>> _getLevels(AppLocalizations l10n) {
    return [
      {
        'id': 'beginner',
        'emoji': '🌱',
        'name': l10n.levelBeginner,
        'description': l10n.levelBeginnerDesc,
      },
      {
        'id': 'elementary',
        'emoji': '🍋',
        'name': l10n.levelElementary,
        'description': l10n.levelElementaryDesc,
      },
      {
        'id': 'intermediate',
        'emoji': '🚀',
        'name': l10n.levelIntermediate,
        'description': l10n.levelIntermediateDesc,
      },
      {
        'id': 'advanced',
        'emoji': '🏆',
        'name': l10n.levelAdvanced,
        'description': l10n.levelAdvancedDesc,
      },
    ];
  }

  void _onStart() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    // Save selected level if any
    if (_selectedLevel != null) {
      await settings.setUserLevel(_selectedLevel!);
    }

    // Mark onboarding as completed
    await settings.completeOnboarding();

    if (!mounted) return;

    // Navigate to login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onSkip() async {
    // Mark onboarding as completed without level selection
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.completeOnboarding();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final levels = _getLevels(l10n);

    return Scaffold(
      backgroundColor: OnboardingColors.backgroundYellow,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _onSkip,
                child: Text(
                  l10n.onboardingSkip,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Lemon character (waving)
                      const LemonCharacter(
                        expression: LemonExpression.waving,
                        size: 140,
                      )
                          .animate()
                          .scale(
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                            begin: const Offset(0.8, 0.8),
                          )
                          .fadeIn(duration: 300.ms),

                      const SizedBox(height: 30),

                      // Welcome message
                      Text(
                        l10n.onboardingWelcome,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 40),

                      // Question text
                      Text(
                        l10n.onboardingLevelQuestion,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 400.ms),

                      const SizedBox(height: 20),

                      // Level selection cards
                      ...levels.asMap().entries.map((entry) {
                        final index = entry.key;
                        final level = entry.value;

                        return LevelSelectionCard(
                          emoji: level['emoji']!,
                          title: level['name']!,
                          description: level['description']!,
                          topikLevel: '',  // Not used in this screen
                          isSelected: _selectedLevel == level['id'],
                          onTap: () {
                            setState(() {
                              _selectedLevel = level['id'];
                            });
                          },
                        )
                            .animate()
                            .fadeIn(
                              delay: (400 + (index * 100)).ms,
                              duration: 400.ms,
                            )
                            .slideX(
                              begin: 0.2,
                              end: 0,
                              delay: (400 + (index * 100)).ms,
                            );
                      }),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // Start button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black87,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedLevel == null ? l10n.onboardingStartWithoutLevel : l10n.onboardingStart,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
            ),
          ],
        ),
      ),
    );
  }
}
