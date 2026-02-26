import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/hangul_character_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'widgets/native_comparison_card.dart';
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
              final exampleText = character.hasExamples
                  ? '\n${l10n.exampleWords}: ${character.exampleWords!.first.korean} - ${character.exampleWords!.first.chinese}'
                  : '';
              final text = '''${character.character} [${character.romanization}]
${l10n.pronunciationLabel}${character.pronunciationZh}$exampleText

#LemonKorean #${l10n.appName}''';
              Share.share(text);
            },
            tooltip: l10n.share,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final userLanguage =
              Provider.of<SettingsProvider>(context, listen: false)
                  .contentLanguageCode;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character Hero Section
                _buildHeroSection(context),

                const SizedBox(height: 24),

                // Pronunciation Section
                PronunciationPlayer(
                  character: character,
                  userLanguage: userLanguage,
                ),

                const SizedBox(height: 16),

                // Native Language Comparison Section
                NativeComparisonCard(
                  character: character.character,
                  userLanguage: userLanguage,
                  customComparisons: character.nativeComparisons != null
                      ? NativeComparisonParser.fromJson(
                          character.nativeComparisons)
                      : null,
                ),

                const SizedBox(height: 16),

                // Example Words Section
                if (character.hasExamples) _buildExampleWordsSection(),

                const SizedBox(height: 16),

                // Mnemonics Section
                if (character.hasMnemonics) _buildMnemonicsSection(),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
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
          StrokeOrderAnimation(
            character: character,
            showCard: false,
            showHeader: false,
            showCanvasFrame: false,
            showGrid: true,
            showGuideCharacter: true,
            canvasSize: 180,
            strokeDurationMs: 1600,
            fallbackDurationMs: 2800,
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
}
