import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/hangul_character_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/hangul_provider.dart';
import '../../hangul/hangul_character_detail.dart';
import '../../hangul/hangul_level0_learning_screen.dart';
import '../../hangul/hangul_syllable_screen.dart';
import '../../hangul/hangul_batchim_screen.dart';
import '../../hangul/hangul_discrimination_screen.dart';
import 'lemon_clipper.dart';

/// Lemon orchard dashboard for Level 0 (Hangul).
/// Shows an adaptive guide card and a lemon-themed character grid.
class HangulDashboardView extends StatefulWidget {
  const HangulDashboardView({super.key});

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

        final table = hangul.alphabetTable;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Action buttons for learning modes
                _buildActionButtons(context),

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

  // ── Action buttons ──────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.school,
            label: '학습',
            color: const Color(0xFF4CAF50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulLevel0LearningScreen(),
                ),
              );
            },
          ),
          _buildActionButton(
            context: context,
            icon: Icons.extension,
            label: '음절조합',
            color: const Color(0xFF2196F3),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulSyllableScreen(),
                ),
              );
            },
          ),
          _buildActionButton(
            context: context,
            icon: Icons.abc,
            label: '받침연습',
            color: const Color(0xFF9C27B0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulBatchimScreen(),
                ),
              );
            },
          ),
          _buildActionButton(
            context: context,
            icon: Icons.hearing,
            label: '소리구분훈련',
            color: const Color(0xFFFF9800),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulDiscriminationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.12,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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

}
