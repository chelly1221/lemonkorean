import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'widgets/goal_selection_card.dart';
import 'widgets/onboarding_button.dart';
import 'account_choice_screen.dart';

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
    {'id': 'casual',     'emoji': '🍃', 'target': 2},
    {'id': 'regular',    'emoji': '🍋', 'target': 4},
    {'id': 'serious',    'emoji': '🔥', 'target': 6},
    {'id': 'intensive',  'emoji': '⚡', 'target': 7},
  ];

  String _getGoalTitle(AppLocalizations l10n, String goalId) {
    switch (goalId) {
      case 'casual':     return l10n.goalCasual;
      case 'regular':    return l10n.goalRegular;
      case 'serious':    return l10n.goalSerious;
      case 'intensive':  return l10n.goalIntensive;
      default:           return '';
    }
  }

  String _getGoalTime(AppLocalizations l10n, String goalId) {
    switch (goalId) {
      case 'casual':     return l10n.goalCasualTime;
      case 'regular':    return l10n.goalRegularTime;
      case 'serious':    return l10n.goalSeriousTime;
      case 'intensive':  return l10n.goalIntensiveTime;
      default:           return '';
    }
  }

  String _getGoalHelper(AppLocalizations l10n, String goalId) {
    switch (goalId) {
      case 'casual':     return l10n.goalCasualHelper;
      case 'regular':    return l10n.goalRegularHelper;
      case 'serious':    return l10n.goalSeriousHelper;
      case 'intensive':  return l10n.goalIntensiveHelper;
      default:           return '';
    }
  }

  Future<void> _onNext() async {
    final settingsProvider = context.read<SettingsProvider>();
    final navigator = Navigator.of(context);

    final selectedGoalData = _goals.firstWhere((g) => g['id'] == _selectedGoal);
    await settingsProvider.setWeeklyGoal(
      _selectedGoal!,
      selectedGoalData['target'] as int,
    );

    if (!mounted) return;

    navigator.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AccountChoiceScreen(),
        transitionDuration: const Duration(milliseconds: 400),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final hMargin = screenWidth * 0.039;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ── Back button row ──────────────────────────────
            SizedBox(
              height: screenHeight * 0.047,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.only(left: hMargin),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: screenWidth * 0.051,
                    color: Colors.black87,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // ── Mascot ───────────────────────────────────────
            SvgPicture.asset(
              'assets/images/level_mascot.svg',
              height: screenHeight * 0.22,
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 400.ms),

            SizedBox(height: screenHeight * 0.013),

            // ── Title ────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hMargin),
              child: Text(
                l10n.onboardingGoalTitle,
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
            ),

            SizedBox(height: screenHeight * 0.006),

            // ── Subtitle ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hMargin),
              child: Text(
                l10n.onboardingGoalSubtitle,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: screenWidth * 0.037,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7B7B7B),
                ),
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
            ),

            SizedBox(height: screenHeight * 0.010),

            // ── Goal cards ───────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hMargin,
                vertical: screenHeight * 0.013,
              ),
              child: Column(
                children: List.generate(_goals.length, (index) {
                  final goal = _goals[index];
                  final goalId = goal['id'] as String;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < _goals.length - 1
                          ? screenHeight * 0.013
                          : 0,
                    ),
                    child: GoalSelectionCard(
                      emoji: goal['emoji'] as String,
                      title: _getGoalTitle(l10n, goalId),
                      timeText: _getGoalTime(l10n, goalId),
                      helperText: _getGoalHelper(l10n, goalId),
                      isSelected: _selectedGoal == goalId,
                      onTap: () => setState(() => _selectedGoal = goalId),
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
              ),
            ),

            // ── Next button ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hMargin,
                vertical: screenHeight * 0.019,
              ),
              child: OnboardingButton(
                text: l10n.onboardingNext,
                isEnabled: _selectedGoal != null,
                onPressed: _selectedGoal == null ? null : _onNext,
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
