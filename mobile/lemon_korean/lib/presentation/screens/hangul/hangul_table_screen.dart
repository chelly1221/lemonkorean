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
  _TableViewMode _viewMode = _TableViewMode.grouped;

  static const List<String> _matrixConsonants = [
    'ㄱ',
    'ㄴ',
    'ㄷ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅅ',
    'ㅇ',
    'ㅈ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ',
    'ㄲ',
    'ㄸ',
    'ㅃ',
    'ㅆ',
    'ㅉ',
  ];

  static const List<String> _matrixVowels = [
    'ㅏ',
    'ㅑ',
    'ㅓ',
    'ㅕ',
    'ㅗ',
    'ㅛ',
    'ㅜ',
    'ㅠ',
    'ㅡ',
    'ㅣ',
  ];

  static const Map<String, int> _choseongIndex = {
    'ㄱ': 0,
    'ㄲ': 1,
    'ㄴ': 2,
    'ㄷ': 3,
    'ㄸ': 4,
    'ㄹ': 5,
    'ㅁ': 6,
    'ㅂ': 7,
    'ㅃ': 8,
    'ㅅ': 9,
    'ㅆ': 10,
    'ㅇ': 11,
    'ㅈ': 12,
    'ㅉ': 13,
    'ㅊ': 14,
    'ㅋ': 15,
    'ㅌ': 16,
    'ㅍ': 17,
    'ㅎ': 18,
  };

  static const Map<String, int> _jungseongIndex = {
    'ㅏ': 0,
    'ㅑ': 2,
    'ㅓ': 4,
    'ㅕ': 6,
    'ㅗ': 8,
    'ㅛ': 12,
    'ㅜ': 13,
    'ㅠ': 17,
    'ㅡ': 18,
    'ㅣ': 20,
  };

  static const Map<String, String> _compatMap = {
    'ᄀ': 'ㄱ',
    'ᄁ': 'ㄲ',
    'ᄂ': 'ㄴ',
    'ᄃ': 'ㄷ',
    'ᄄ': 'ㄸ',
    'ᄅ': 'ㄹ',
    'ᄆ': 'ㅁ',
    'ᄇ': 'ㅂ',
    'ᄈ': 'ㅃ',
    'ᄉ': 'ㅅ',
    'ᄊ': 'ㅆ',
    'ᄋ': 'ㅇ',
    'ᄌ': 'ㅈ',
    'ᄍ': 'ㅉ',
    'ᄎ': 'ㅊ',
    'ᄏ': 'ㅋ',
    'ᄐ': 'ㅌ',
    'ᄑ': 'ㅍ',
    'ᄒ': 'ㅎ',
    'ᅡ': 'ㅏ',
    'ᅣ': 'ㅑ',
    'ᅥ': 'ㅓ',
    'ᅧ': 'ㅕ',
    'ᅩ': 'ㅗ',
    'ᅭ': 'ㅛ',
    'ᅮ': 'ㅜ',
    'ᅲ': 'ㅠ',
    'ᅳ': 'ㅡ',
    'ᅵ': 'ㅣ',
    'ᅴ': 'ㅢ',
  };

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
    final groupedSelected = _viewMode == _TableViewMode.grouped;

    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildModeAppBarButton(
            icon: Icons.grid_view_rounded,
            tooltip: l10n.groupedView,
            selected: groupedSelected,
            onTap: () => setState(() => _viewMode = _TableViewMode.grouped),
          ),
          _buildModeAppBarButton(
            icon: Icons.table_chart_rounded,
            tooltip: l10n.matrixView,
            selected: !groupedSelected,
            onTap: () => setState(() => _viewMode = _TableViewMode.matrix),
          ),
          const SizedBox(width: 6),
        ],
      ),
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
              padding: EdgeInsets.fromLTRB(
                AppConstants.paddingMedium,
                _viewMode == _TableViewMode.matrix
                    ? 6
                    : AppConstants.paddingMedium,
                AppConstants.paddingMedium,
                _viewMode == _TableViewMode.matrix
                    ? 12
                    : AppConstants.paddingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_viewMode == _TableViewMode.grouped) ...[
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
                  ] else
                    _buildConsonantVowelMatrix(provider),
                  SizedBox(
                      height: _viewMode == _TableViewMode.matrix ? 10 : 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeAppBarButton({
    required IconData icon,
    required String tooltip,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Colors.grey.shade300 : Colors.transparent,
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: selected ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildConsonantVowelMatrix(HangulProvider provider) {
    final media = MediaQuery.of(context);
    final viewportHeight = media.size.height;
    final topInset = media.padding.top;
    final bottomInset = media.padding.bottom;
    final matrixRows = _matrixConsonants.length + 1;
    final reservedHeight = topInset + kToolbarHeight + bottomInset + 56;
    final tableAvailableHeight = viewportHeight - reservedHeight;
    final rowHeight = (tableAvailableHeight / matrixRows).clamp(17.0, 28.0);

    final byChar = <String, HangulCharacterModel>{};
    for (final c in provider.characters) {
      byChar[_normalizeCharacter(c.character)] = c;
    }

    final rows = <TableRow>[];
    rows.add(
      TableRow(
        children: [
          _buildMatrixHeaderCell('', rowHeight),
          for (final v in _matrixVowels)
            _buildMatrixHeaderCell(
              v,
              rowHeight,
              onTap: byChar[v] == null
                  ? null
                  : () => _navigateToDetail(context, byChar[v]!),
            ),
        ],
      ),
    );

    for (final c in _matrixConsonants) {
      rows.add(
        TableRow(
          children: [
            _buildMatrixHeaderCell(
              c,
              rowHeight,
              onTap: byChar[c] == null
                  ? null
                  : () => _navigateToDetail(context, byChar[c]!),
            ),
            for (final v in _matrixVowels)
              _buildMatrixBodyCell(_composeSyllable(c, v), rowHeight),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalCols = _matrixVowels.length + 1;
        final colWidth = (constraints.maxWidth / totalCols).clamp(24.0, 64.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '세로: 자음 / 가로: 모음',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(colWidth),
                border: TableBorder.all(color: Colors.grey.shade200),
                children: rows,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMatrixHeaderCell(String text, double rowHeight,
      {VoidCallback? onTap}) {
    final child = Container(
      height: rowHeight,
      alignment: Alignment.center,
      color: Colors.grey.shade100,
      child: Text(
        text,
        style: TextStyle(
          fontSize: rowHeight < 24 ? 12 : 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    if (onTap == null || text.isEmpty) return child;
    return InkWell(onTap: onTap, child: child);
  }

  Widget _buildMatrixBodyCell(String text, double rowHeight) {
    return Container(
      height: rowHeight,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: rowHeight < 24 ? 12 : 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _normalizeCharacter(String value) {
    final trimmed = value.trim();
    return _compatMap[trimmed] ?? trimmed;
  }

  String _composeSyllable(String consonant, String vowel) {
    final l = _choseongIndex[consonant];
    final v = _jungseongIndex[vowel];
    if (l == null || v == null) return '';
    final code = 0xAC00 + ((l * 21) + v) * 28;
    return String.fromCharCode(code);
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

enum _TableViewMode {
  grouped,
  matrix,
}
