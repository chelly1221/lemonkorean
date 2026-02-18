import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'widgets/level_selection_card.dart';
import 'widgets/onboarding_button.dart';
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
    {'id': 'beginner',     'topik': '1'},
    {'id': 'elementary',   'topik': '2'},
    {'id': 'intermediate', 'topik': '3-4'},
    {'id': 'advanced',     'topik': '5-6'},
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

  Future<void> _onNext() async {
    final settingsProvider = context.read<SettingsProvider>();
    final navigator = Navigator.of(context);

    await settingsProvider.setUserLevel(_selectedLevel!);

    if (!mounted) return;

    navigator.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WeeklyGoalScreen(),
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

            // ── Level mascot ─────────────────────────────────
            SvgPicture.asset(
              'assets/images/level_card_icon.svg',
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
                l10n.onboardingLevelTitle,
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
                l10n.onboardingLevelSubtitle,
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

            // ── Level cards ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hMargin,
                vertical: screenHeight * 0.013,
              ),
              child: Column(
                children: List.generate(_levels.length, (index) {
                  final level = _levels[index];
                  final levelId = level['id']!;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < _levels.length - 1
                          ? screenHeight * 0.013
                          : 0,
                    ),
                    child: LevelSelectionCard(
                      title: _getLevelTitle(l10n, levelId),
                      description: _getLevelDesc(l10n, levelId),
                      topikLevel: l10n.levelTopik(level['topik']!),
                      isSelected: _selectedLevel == levelId,
                      onTap: () => setState(() => _selectedLevel = levelId),
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
                isEnabled: _selectedLevel != null,
                onPressed: _selectedLevel == null ? null : _onNext,
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
