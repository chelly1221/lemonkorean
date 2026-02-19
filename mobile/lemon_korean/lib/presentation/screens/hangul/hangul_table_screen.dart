import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/hangul_character_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/hangul_provider.dart';
import 'hangul_character_detail.dart';
import 'widgets/character_card.dart';

/// Hangul Table Screen
/// Displays the complete Korean alphabet in an organized grid
class HangulTableScreen extends StatefulWidget {
  const HangulTableScreen({super.key});

  @override
  State<HangulTableScreen> createState() => _HangulTableScreenState();
}

class _HangulTableScreenState extends State<HangulTableScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<HangulProvider>(context, listen: false);
    if (provider.characters.isEmpty) {
      await provider.loadAlphabetTable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('자모표')),
      body: Consumer<HangulProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.characters.isEmpty) {
            return _buildErrorState(context, provider);
          }

          if (provider.characters.isEmpty) {
            return _buildEmptyState(context, provider);
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadAlphabetTable(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats summary
                  _buildStatsSummary(context, provider),

                  const SizedBox(height: 24),

                  // Basic Consonants
                  if (provider.basicConsonants.isNotEmpty)
                    _buildCharacterSection(
                      '${l10n.basicConsonants} (${l10n.basicConsonantsKo})',
                      provider.basicConsonants,
                      Colors.blue,
                      provider,
                    ),

                  const SizedBox(height: 20),

                  // Double Consonants
                  if (provider.doubleConsonants.isNotEmpty)
                    _buildCharacterSection(
                      '${l10n.doubleConsonants} (${l10n.doubleConsonantsKo})',
                      provider.doubleConsonants,
                      Colors.indigo,
                      provider,
                    ),

                  const SizedBox(height: 20),

                  // Basic Vowels
                  if (provider.basicVowels.isNotEmpty)
                    _buildCharacterSection(
                      '${l10n.basicVowels} (${l10n.basicVowelsKo})',
                      provider.basicVowels,
                      Colors.green,
                      provider,
                    ),

                  const SizedBox(height: 20),

                  // Compound Vowels
                  if (provider.compoundVowels.isNotEmpty)
                    _buildCharacterSection(
                      '${l10n.compoundVowels} (${l10n.compoundVowelsKo})',
                      provider.compoundVowels,
                      Colors.teal,
                      provider,
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context, HangulProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final stats = provider.stats;
    final totalCharacters = provider.characters.length;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withValues(alpha: 0.3),
            AppConstants.primaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            l10n.totalCharacters,
            '$totalCharacters',
            Icons.text_fields,
            Colors.grey.shade700,
          ),
          _buildStatItem(
            l10n.learned,
            '${stats?.charactersLearned ?? 0}',
            Icons.school,
            Colors.blue,
          ),
          _buildStatItem(
            l10n.mastered,
            '${stats?.charactersMastered ?? 0}',
            Icons.star,
            Colors.orange,
          ),
          _buildStatItem(
            l10n.perfectCount,
            '${stats?.charactersPerfected ?? 0}',
            Icons.emoji_events,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
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
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterSection(
    String title,
    List<HangulCharacterModel> characters,
    Color color,
    HangulProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              l10n.countUnit(characters.length),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Character grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            final progress = provider.getProgressForCharacter(character.id);

            return CompactCharacterCard(
              character: character,
              progress: progress,
              onTap: () => _navigateToDetail(context, character),
            );
          },
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, HangulCharacterModel character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HangulCharacterDetailScreen(character: character),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, HangulProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            provider.errorMessage ?? l10n.loadFailed,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.loadAlphabetTable(),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, HangulProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.grid_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCharactersAvailable,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.loadAlphabetTable(),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
