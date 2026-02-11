import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/korean_tts_helper.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/pronunciation_player.dart';

/// Korean syllable structure helper
class KoreanSyllable {
  /// Combine initial, medial, and optional final to form a syllable
  static String combine(String initial, String medial, [String? finalConsonant]) {
    final initialIndex = initialConsonants.indexOf(initial);
    final medialIndex = medialVowels.indexOf(medial);
    final finalIndex = finalConsonant != null
        ? finalConsonants.indexOf(finalConsonant)
        : 0;

    if (initialIndex == -1 || medialIndex == -1) return '';
    if (finalConsonant != null && finalIndex == -1) return '';

    // Korean syllable Unicode formula
    // Syllable = 0xAC00 + (initial * 588) + (medial * 28) + final
    final code = 0xAC00 + (initialIndex * 588) + (medialIndex * 28) + finalIndex;
    return String.fromCharCode(code);
  }

  /// Decompose a syllable into its components
  static Map<String, String?> decompose(String syllable) {
    if (syllable.isEmpty) return {'initial': null, 'medial': null, 'final': null};

    final code = syllable.codeUnitAt(0);
    if (code < 0xAC00 || code > 0xD7A3) {
      return {'initial': null, 'medial': null, 'final': null};
    }

    final base = code - 0xAC00;
    final initialIndex = base ~/ 588;
    final medialIndex = (base % 588) ~/ 28;
    final finalIndex = base % 28;

    return {
      'initial': initialConsonants[initialIndex],
      'medial': medialVowels[medialIndex],
      'final': finalIndex > 0 ? finalConsonants[finalIndex] : null,
    };
  }

  static const List<String> initialConsonants = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
  ];

  static const List<String> medialVowels = [
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
    'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'
  ];

  static const List<String> finalConsonants = [
    '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ',
    'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
  ];
}

/// Syllable combination screen
class HangulSyllableScreen extends StatefulWidget {
  const HangulSyllableScreen({super.key});

  @override
  State<HangulSyllableScreen> createState() => _HangulSyllableScreenState();
}

class _HangulSyllableScreenState extends State<HangulSyllableScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedInitial;
  String? _selectedMedial;
  String? _selectedFinal;
  late TabController _tabController;
  late AudioPlayer _audioPlayer;
  PlaybackSpeed _playbackSpeed = PlaybackSpeed.normal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  String get _combinedSyllable {
    if (_selectedInitial == null || _selectedMedial == null) return '';
    return KoreanSyllable.combine(
      _selectedInitial!,
      _selectedMedial!,
      _selectedFinal,
    );
  }

  Future<void> _playSyllable() async {
    final syllable = _combinedSyllable;
    if (syllable.isEmpty) return;

    try {
      await KoreanTtsHelper.playKoreanText(
        syllable,
        _audioPlayer,
        speed: _playbackSpeed.value,
      );
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.audioLoadError)),
        );
      }
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedInitial = null;
      _selectedMedial = null;
      _selectedFinal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.syllableCombination),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.syllableCombination),
            Tab(text: l10n.decomposeSyllable),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCombinationTab(),
          _buildDecompositionTab(),
        ],
      ),
    );
  }

  Widget _buildCombinationTab() {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combined syllable display
          _buildSyllableDisplay(),

          const SizedBox(height: 24),

          // Initial consonant selector
          Text(
            l10n.selectConsonant,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildCharacterGrid(
            KoreanSyllable.initialConsonants,
            _selectedInitial,
            (char) => setState(() => _selectedInitial = char),
            Colors.blue,
          ),

          const SizedBox(height: 16),

          // Medial vowel selector
          Text(
            l10n.selectVowel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildCharacterGrid(
            KoreanSyllable.medialVowels,
            _selectedMedial,
            (char) => setState(() => _selectedMedial = char),
            Colors.green,
          ),

          const SizedBox(height: 16),

          // Final consonant selector (optional)
          Row(
            children: [
              Text(
                l10n.selectFinalConsonant,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              if (_selectedFinal != null)
                TextButton(
                  onPressed: () => setState(() => _selectedFinal = null),
                  child: Text(l10n.noFinalConsonant),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _buildCharacterGrid(
            KoreanSyllable.finalConsonants.where((c) => c.isNotEmpty).toList(),
            _selectedFinal,
            (char) => setState(() => _selectedFinal = char),
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSyllableDisplay() {
    final l10n = AppLocalizations.of(context)!;
    final syllable = _combinedSyllable;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withValues(alpha: 0.2),
            AppConstants.primaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Formula display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFormulaBox(_selectedInitial, l10n.selectConsonant, Colors.blue),
              const Text(' + ', style: TextStyle(fontSize: 24)),
              _buildFormulaBox(_selectedMedial, l10n.selectVowel, Colors.green),
              const Text(' + ', style: TextStyle(fontSize: 24)),
              _buildFormulaBox(
                _selectedFinal ?? '()',
                l10n.selectFinalConsonant.split(' ').first,
                Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Result display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(' = ', style: TextStyle(fontSize: 24)),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    syllable.isEmpty ? '?' : syllable,
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: syllable.isEmpty
                          ? Colors.grey.shade400
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Speed control
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: PlaybackSpeed.values.map((speed) {
                    final isSelected = _playbackSpeed == speed;
                    return InkWell(
                      onTap: () => setState(() => _playbackSpeed = speed),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppConstants.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          speed.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              // Play button
              ElevatedButton.icon(
                onPressed: syllable.isEmpty ? null : _playSyllable,
                icon: const Icon(Icons.volume_up),
                label: Text(l10n.playSyllable),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              // Clear button
              IconButton(
                onPressed: _clearSelection,
                icon: const Icon(Icons.refresh),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaBox(String? value, String placeholder, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: value != null
            ? color.withValues(alpha: 0.2)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value != null ? color : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          value ?? '?',
          style: TextStyle(
            fontSize: value != null ? 28 : 20,
            fontWeight: FontWeight.bold,
            color: value != null ? color : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterGrid(
    List<String> characters,
    String? selected,
    Function(String) onSelect,
    Color color,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: characters.map((char) {
        final isSelected = char == selected;
        return InkWell(
          onTap: () => onSelect(char),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                char,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDecompositionTab() {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          // Input field
          TextField(
            decoration: InputDecoration(
              labelText: l10n.syllableInputLabel,
              hintText: l10n.syllableInputHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLength: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32),
            onChanged: (value) {
              if (value.isNotEmpty) {
                final parts = KoreanSyllable.decompose(value);
                setState(() {
                  _selectedInitial = parts['initial'];
                  _selectedMedial = parts['medial'];
                  _selectedFinal = parts['final'];
                });
              }
            },
          ),

          const SizedBox(height: 24),

          // Decomposition result
          if (_selectedInitial != null || _selectedMedial != null)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.decomposeSyllable,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDecomposedPart(
                        '초성',
                        _selectedInitial ?? '-',
                        Colors.blue,
                      ),
                      _buildDecomposedPart(
                        '중성',
                        _selectedMedial ?? '-',
                        Colors.green,
                      ),
                      _buildDecomposedPart(
                        '종성',
                        _selectedFinal ?? '-',
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDecomposedPart(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: value != '-' ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value != '-' ? color : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: value != '-' ? color : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
