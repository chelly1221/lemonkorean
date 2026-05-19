import 'package:flutter/material.dart';
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

class _HangulSyllableScreenState extends State<HangulSyllableScreen> {
  String? _selectedInitial;
  String? _selectedMedial;
  String? _selectedFinal;
  PlaybackSpeed _playbackSpeed = PlaybackSpeed.normal;

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
        speed: _playbackSpeed.value,
      );
    } catch (e) {
      debugPrint('[SyllableScreen] Audio error for "$syllable": $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.audioLoadError)),
        );
      }
    }
  }

  Future<void> _playJamo(String text) async {
    try {
      await KoreanTtsHelper.playKoreanText(text, speed: _playbackSpeed.value);
    } catch (e) {
      debugPrint('[SyllableScreen] Audio error for "$text": $e');
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
      ),
      body: _buildCombinationTab(),
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
            (char) {
              setState(() => _selectedInitial = char);
              _playJamo(char);
            },
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
            (char) {
              setState(() => _selectedMedial = char);
              _playJamo(char);
            },
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
            (char) {
              setState(() => _selectedFinal = char);
              _playJamo(char);
            },
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

}
