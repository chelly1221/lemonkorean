import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/hangul_character_model.dart';
import '../../../../data/models/hangul_progress_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/hangul_provider.dart';
import '../../hangul/hangul_character_detail.dart';
import '../../hangul/hangul_main_screen.dart';
import '../../hangul/hangul_level0_learning_screen.dart';
import 'lemon_clipper.dart';

/// Learning stage for the adaptive guide card.
enum _HangulStage { beginner, learning, reviewNeeded, practice, master }

/// Lemon orchard dashboard for Level 0 (Hangul).
/// Shows an adaptive guide card and a lemon-themed character grid.
class HangulDashboardView extends StatefulWidget {
  final ValueChanged<int>? onLevelSelected;

  const HangulDashboardView({this.onLevelSelected, super.key});

  @override
  State<HangulDashboardView> createState() => _HangulDashboardViewState();
}

class _HangulDashboardViewState extends State<HangulDashboardView> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final hangul = context.read<HangulProvider>();
    final auth = context.read<AuthProvider>();

    await hangul.loadAlphabetTable();
    if (auth.currentUser != null) {
      await hangul.loadProgress(auth.currentUser!.id);
    }
    if (mounted) setState(() => _loaded = true);
  }

  // ── Stage determination ──────────────────────────────────────────

  _HangulStage _determineStage(HangulStats stats) {
    final total = stats.totalCharacters;
    final learned = stats.charactersLearned;
    final mastered = stats.charactersMastered;
    final due = stats.dueForReview;

    // Priority: master > beginner > reviewNeeded > practice > learning
    if (total > 0 && mastered >= total * 0.85) return _HangulStage.master;
    if (learned == 0) return _HangulStage.beginner;
    if (due > 0) return _HangulStage.reviewNeeded;
    if (total > 0 && learned >= total * 0.85) return _HangulStage.practice;
    return _HangulStage.learning;
  }

  // ── Mastery → lemon colour ───────────────────────────────────────

  static Color _lemonColor(int masteryLevel) {
    switch (masteryLevel) {
      case 0:
        return Colors.grey.shade300;
      case 1:
        return const Color(0xFFC5E1A5); // light green
      case 2:
        return const Color(0xFF81C784); // green
      case 3:
        return const Color(0xFFCDDC39); // yellow-green
      case 4:
        return const Color(0xFFFFEE58); // yellow
      case 5:
        return const Color(0xFFFFD54F); // gold
      default:
        return Colors.grey.shade300;
    }
  }

  static bool _lemonFilled(int masteryLevel) => masteryLevel > 0;

  static double _lemonGlow(int masteryLevel) => masteryLevel >= 5 ? 0.5 : 0.0;

  // ── Progress lemon colour (interpolated) ─────────────────────────

  Color _progressLemonColor(double percent) {
    if (percent <= 0) return Colors.grey.shade400;
    if (percent <= 0.5) {
      return Color.lerp(
        const Color(0xFF81C784),
        const Color(0xFFCDDC39),
        percent * 2,
      )!;
    }
    return Color.lerp(
      const Color(0xFFCDDC39),
      const Color(0xFFFFEE58),
      (percent - 0.5) * 2,
    )!;
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<HangulProvider>(
      builder: (context, hangul, _) {
        if (!_loaded || hangul.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final stats = hangul.stats ?? HangulStats();
        final stage = _determineStage(stats);
        final table = hangul.alphabetTable;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildTopLearningButton(context),

                const SizedBox(height: 8),

                // Adaptive guide card
                _buildGuideCard(context, stats, stage),

                const SizedBox(height: 16),

                // Character sections
                if (table['basic_consonants']?.isNotEmpty == true)
                  _buildCharacterSection(
                    context,
                    hangul,
                    icon: '🌿',
                    characters: table['basic_consonants']!,
                    isConsonant: true,
                    animDelay: 0,
                  ),

                if (table['double_consonants']?.isNotEmpty == true)
                  _buildCharacterSection(
                    context,
                    hangul,
                    icon: '🌿',
                    characters: table['double_consonants']!,
                    isConsonant: true,
                    animDelay: 100,
                  ),

                if (table['basic_vowels']?.isNotEmpty == true)
                  _buildCharacterSection(
                    context,
                    hangul,
                    icon: '🌸',
                    characters: table['basic_vowels']!,
                    isConsonant: false,
                    animDelay: 200,
                  ),

                if (table['compound_vowels']?.isNotEmpty == true)
                  _buildCharacterSection(
                    context,
                    hangul,
                    icon: '🌸',
                    characters: table['compound_vowels']!,
                    isConsonant: false,
                    animDelay: 300,
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Guide card ──────────────────────────────────────────────────

  Widget _buildTopLearningButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HangulLevel0LearningScreen(),
              ),
            );
          },
          icon: const Icon(Icons.school),
          label: const Text('학습'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5BA3EC),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.12,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildGuideCard(
    BuildContext context,
    HangulStats stats,
    _HangulStage stage,
  ) {
    final l10n = AppLocalizations.of(context);
    final total = stats.totalCharacters;
    final learned = stats.charactersLearned;
    final percent = total > 0 ? learned / total : 0.0;

    // Stage-dependent text + action
    String message;
    String ctaLabel;
    VoidCallback ctaAction;

    switch (stage) {
      case _HangulStage.beginner:
        message = l10n?.hangulWelcomeDesc ??
            'Learn 40 Korean alphabet letters one by one';
        ctaLabel = '🌱  ${l10n?.hangulStartLearning ?? 'Start Learning'}';
        ctaAction = () => _goHangul(1);
        break;
      case _HangulStage.learning:
        message =
            l10n?.hangulLearnedCount(learned) ?? '$learned/40 letters learned!';
        ctaLabel = '🌱  ${l10n?.hangulLearnNext ?? 'Learn Next'}';
        ctaAction = () => _goHangul(1);
        break;
      case _HangulStage.reviewNeeded:
        message = l10n?.hangulReviewNeeded(stats.dueForReview) ??
            '${stats.dueForReview} letters due for review today!';
        ctaLabel = '🍋  ${l10n?.hangulReviewNow ?? 'Review Now'}';
        ctaAction = () => _goHangul(2);
        break;
      case _HangulStage.practice:
        message = l10n?.hangulPracticeSuggestion ??
            'Almost there! Strengthen skills with activities';
        ctaLabel = '🎮  ${l10n?.hangulStartActivities ?? 'Start Activities'}';
        ctaAction = () => _goHangul(3);
        break;
      case _HangulStage.master:
        message =
            l10n?.hangulMastered ?? "Congratulations! You've mastered Hangul!";
        ctaLabel = '▶  ${l10n?.hangulGoToLevel1 ?? 'Go to Level 1'}';
        ctaAction = () => widget.onLevelSelected?.call(1);
        break;
    }

    final lemonColor = _progressLemonColor(percent);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE8F5E9).withValues(alpha: 0.8),
              const Color(0xFFFFF9C4).withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Big progress lemon
            SizedBox(
              width: 80,
              height: 90,
              child: CustomPaint(
                painter: LemonShapePainter(
                  color: percent > 0 ? lemonColor : Colors.grey.shade300,
                  isFilled: percent > 0,
                  glowIntensity: percent >= 1.0 ? 0.5 : 0.0,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '${(percent * 100).round()}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: percent > 0.5
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Message + CTA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stage == _HangulStage.beginner)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        l10n?.hangulWelcome ?? 'Welcome to Hangul!',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ctaAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        ctaLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  // Secondary action row (when not master stage)
                  if (stage != _HangulStage.master) ...[
                    const SizedBox(height: 6),
                    _buildSecondaryActions(context, stage),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: 0.15,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildSecondaryActions(BuildContext context, _HangulStage stage) {
    final l10n = AppLocalizations.of(context);

    // Show actions that are NOT the primary CTA
    final buttons = <Widget>[];

    if (stage != _HangulStage.beginner && stage != _HangulStage.learning) {
      buttons.add(_secondaryBtn(
        l10n?.learn ?? 'Learn',
        Icons.school,
        () => _goHangul(1),
      ));
    }
    if (stage != _HangulStage.reviewNeeded) {
      buttons.add(_secondaryBtn(
        l10n?.practice ?? 'Practice',
        Icons.quiz,
        () => _goHangul(2),
      ));
    }
    if (stage != _HangulStage.practice) {
      buttons.add(_secondaryBtn(
        l10n?.activities ?? 'Activities',
        Icons.sports_esports,
        () => _goHangul(3),
      ));
    }

    return Wrap(spacing: 6, runSpacing: 4, children: buttons);
  }

  Widget _secondaryBtn(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // ── Character section ───────────────────────────────────────────

  Widget _buildCharacterSection(
    BuildContext context,
    HangulProvider hangul, {
    required String icon,
    required List<HangulCharacterModel> characters,
    required bool isConsonant,
    required int animDelay,
  }) {
    final l10n = AppLocalizations.of(context);
    final type = characters.first.characterType;

    String sectionTitle;
    switch (type) {
      case 'basic_consonant':
        sectionTitle = l10n?.basicConsonants ?? 'Basic Consonants';
        break;
      case 'double_consonant':
        sectionTitle = l10n?.doubleConsonants ?? 'Double Consonants';
        break;
      case 'basic_vowel':
        sectionTitle = l10n?.basicVowels ?? 'Basic Vowels';
        break;
      case 'compound_vowel':
        sectionTitle = l10n?.compoundVowels ?? 'Compound Vowels';
        break;
      default:
        sectionTitle = type;
    }

    final accentColor =
        isConsonant ? const Color(0xFF4CAF50) : const Color(0xFFE91E63);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          // Section header
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${characters.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 1,
                  color: accentColor.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Character grid (7 columns)
          Wrap(
            spacing: 6,
            runSpacing: 8,
            children: characters
                .map((ch) => _buildLemonCell(context, hangul, ch))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: 350.ms,
          delay: animDelay.ms,
        );
  }

  // ── Individual lemon cell ───────────────────────────────────────

  Widget _buildLemonCell(
    BuildContext context,
    HangulProvider hangul,
    HangulCharacterModel character,
  ) {
    final progress = hangul.getProgressForCharacter(character.id);
    final mastery = progress?.masteryLevel ?? 0;
    final color = _lemonColor(mastery);
    final filled = _lemonFilled(mastery);
    final glow = _lemonGlow(mastery);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HangulCharacterDetailScreen(character: character),
          ),
        );
      },
      child: SizedBox(
        width: 46,
        height: 56,
        child: CustomPaint(
          painter: LemonShapePainter(
            color: color,
            isFilled: filled,
            glowIntensity: glow,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                character.character,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: filled ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Navigation helpers ──────────────────────────────────────────

  void _goHangul(int tabIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HangulMainScreen(initialTabIndex: tabIndex),
      ),
    );
  }
}
