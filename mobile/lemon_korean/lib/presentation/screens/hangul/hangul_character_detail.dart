import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/hangul_character_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/hangul_provider.dart';
import 'widgets/pronunciation_player.dart';
import 'widgets/stroke_order_animation.dart';

/// Hangul Character Detail Screen
/// Shows detailed information about a single hangul character
class HangulCharacterDetailScreen extends StatelessWidget {
  final HangulCharacterModel character;

  const HangulCharacterDetailScreen({
    required this.character,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(character.character),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
            tooltip: l10n.share,
          ),
        ],
      ),
      body: Consumer<HangulProvider>(
        builder: (context, provider, child) {
          final progress = provider.getProgressForCharacter(character.id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character Hero Section
                _buildHeroSection(context, progress),

                const SizedBox(height: 24),

                // Pronunciation Section
                PronunciationPlayer(character: character),

                const SizedBox(height: 16),

                // Stroke Order Section
                StrokeOrderAnimation(character: character),

                const SizedBox(height: 16),

                // Example Words Section
                if (character.hasExamples) _buildExampleWordsSection(),

                const SizedBox(height: 16),

                // Mnemonics Section
                if (character.hasMnemonics) _buildMnemonicsSection(),

                const SizedBox(height: 16),

                // Progress Section
                if (progress != null) _buildProgressSection(progress),

                const SizedBox(height: 32),

                // Practice Button
                _buildPracticeButton(context),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, dynamic progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingXLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getTypeColor().withValues(alpha: 0.1),
            _getTypeColor().withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: _getTypeColor().withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Character
          Text(
            character.character,
            style: const TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Romanization
          Text(
            character.romanization,
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 8),

          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getTypeColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getLocalizedTypeName(context),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          // Mastery badge if available
          if (progress != null && progress.masteryLevel > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getMasteryColor(progress.masteryLevel),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getLocalizedMasteryName(context, progress.masteryLevel),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExampleWordsSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.book,
                color: Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Builder(builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Text(
                  l10n.exampleWords,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          ...character.exampleWords!.map((word) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bullet
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        color: _getTypeColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word.korean,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            word.chinese,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (word.pinyin != null)
                            Text(
                              word.pinyin!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMnemonicsSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: Colors.purple.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Builder(builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Text(
                  l10n.mnemonics,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            character.mnemonicsZh!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.purple.shade900,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(dynamic progress) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.green.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Builder(builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Text(
                  l10n.learningProgress,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          Builder(builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Row(
              children: [
                _buildStatItem(
                  l10n.correct,
                  '${progress.correctCount}',
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  l10n.wrong,
                  '${progress.wrongCount}',
                  Colors.red,
                ),
                const SizedBox(width: 16),
                _buildStatItem(
                  l10n.accuracy,
                  '${(progress.accuracy * 100).toStringAsFixed(0)}%',
                  Colors.blue,
                ),
              ],
            );
          }),
          if (progress.nextReview != null) ...[
            const SizedBox(height: 12),
            Builder(builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              final formattedDate = _localizeNextReview(context, _formatNextReview(progress.nextReview));
              return Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.nextReviewLabel(formattedDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to practice mode for this character
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.practiceFunctionDeveloping),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.school),
        label: Text(l10n.startPractice),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (character.characterType) {
      case 'basic_consonant':
        return Colors.blue;
      case 'double_consonant':
        return Colors.indigo;
      case 'basic_vowel':
        return Colors.green;
      case 'compound_vowel':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getMasteryColor(int level) {
    if (level >= 5) return Colors.purple;
    if (level >= 4) return Colors.green;
    if (level >= 3) return Colors.blue;
    if (level >= 2) return Colors.orange;
    if (level >= 1) return Colors.amber;
    return Colors.grey;
  }

  String _getLocalizedTypeName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (character.characterType) {
      case 'basic_consonant':
        return l10n.typeBasicConsonant;
      case 'double_consonant':
        return l10n.typeDoubleConsonant;
      case 'basic_vowel':
        return l10n.typeBasicVowel;
      case 'compound_vowel':
        return l10n.typeCompoundVowel;
      case 'final_consonant':
        return l10n.typeFinalConsonant;
      default:
        return character.characterType;
    }
  }

  String _getLocalizedMasteryName(BuildContext context, int level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 0:
        return l10n.masteryNew;
      case 1:
        return l10n.masteryLearning;
      case 2:
        return l10n.masteryFamiliar;
      case 3:
        return l10n.masteryMastered;
      case 4:
        return l10n.masteryExpert;
      case 5:
        return l10n.masteryPerfect;
      default:
        return l10n.masteryUnknown;
    }
  }

  String _formatNextReview(DateTime date) {
    // Return a standardized format that will be processed by localization
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.isNegative) return 'EXPIRED';
    if (diff.inDays == 0) return 'TODAY';
    if (diff.inDays == 1) return 'TOMORROW';
    if (diff.inDays < 7) return 'DAYS:${diff.inDays}';
    return 'DATE:${date.month}/${date.day}';
  }

  String _localizeNextReview(BuildContext context, String formatted) {
    final l10n = AppLocalizations.of(context)!;
    if (formatted == 'EXPIRED') return l10n.expired;
    if (formatted == 'TODAY') return l10n.today;
    if (formatted == 'TOMORROW') return l10n.tomorrow;
    if (formatted.startsWith('DAYS:')) {
      final days = int.parse(formatted.substring(5));
      return l10n.daysLater(days);
    }
    if (formatted.startsWith('DATE:')) {
      final parts = formatted.substring(5).split('/');
      return l10n.dateFormat(int.parse(parts[0]), int.parse(parts[1]));
    }
    return formatted;
  }
}
