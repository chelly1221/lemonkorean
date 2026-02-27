import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Native language comparison data for pronunciation
class NativeComparison {
  final String languageCode;
  final String languageName;
  final String comparison;
  final String? tip;

  const NativeComparison({
    required this.languageCode,
    required this.languageName,
    required this.comparison,
    this.tip,
  });
}

/// Parse native comparisons from API JSONB format
/// API format: {"zh": [{"comparison": "...", "tip": "..."}], "en": [...]}
class NativeComparisonParser {
  static Map<String, List<NativeComparison>> fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return {};
    }

    final result = <String, List<NativeComparison>>{};

    json.forEach((langCode, comparisons) {
      if (comparisons is List) {
        final langName = _getLanguageName(langCode);
        result[langCode] = comparisons.map<NativeComparison>((item) {
          final map = item as Map<String, dynamic>;
          return NativeComparison(
            languageCode: langCode,
            languageName: langName,
            comparison: map['comparison'] as String? ?? '',
            tip: map['tip'] as String?,
          );
        }).toList();
      }
    });

    return result;
  }

  static String _getLanguageName(String code) {
    switch (code) {
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'ko':
        return '한국어';
      default:
        return code;
    }
  }
}

/// Fallback comparisons for Korean characters by language
/// Used when API data is not available (offline mode)
class KoreanCharacterComparisons {
  static Map<String, List<NativeComparison>> getComparisons(String character) {
    return _comparisons[character] ?? {};
  }

  static const Map<String, Map<String, List<NativeComparison>>> _comparisons = {
    // Consonants
    'ㄱ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"哥"的声母g，但更轻',
          tip: '发音时声带不振动',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「か」行の子音に近い',
          tip: '語中では濁音化することがある',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Similar to "g" in "go" but unaspirated',
          tip: 'No puff of air like "k" in "key"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Similar a la "g" de "gato"',
          tip: 'Sin aspiración',
        ),
      ],
    },
    'ㄴ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '与"你"的声母n相同',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「な」行の子音と同じ',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Same as "n" in "no"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Igual que la "n" en "no"',
        ),
      ],
    },
    'ㄷ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"大"的声母d，但更轻',
          tip: '发音时声带不振动',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「た」行の子音に近い',
          tip: '語中では濁音化することがある',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Like "d" in "do" but unaspirated',
          tip: 'Less air than "t" in "top"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Similar a la "d" de "dar"',
        ),
      ],
    },
    'ㄹ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '词首类似l，词中类似卷舌r',
          tip: '舌尖轻触上颚',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「ら」行の子音に近い',
          tip: '舌先が上あごに軽く触れる',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Between "l" and "r"',
          tip: 'Flap sound, like "tt" in "butter" (American)',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Similar a la "r" simple de "pero"',
          tip: 'No es la "rr" fuerte',
        ),
      ],
    },
    'ㅁ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '与"妈"的声母m相同',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「ま」行の子音と同じ',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Same as "m" in "mom"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Igual que la "m" en "mamá"',
        ),
      ],
    },
    'ㅂ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"把"的声母b，但更轻',
          tip: '不送气',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「ば」行の子音に近い',
          tip: '語中では濁音化することがある',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Like "b" in "boy" but unaspirated',
          tip: 'Less air than "p" in "pie"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Similar a la "b" de "boca"',
        ),
      ],
    },
    'ㅅ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"四"的声母s',
          tip: '在ㅣ前面时接近"西"的声母x',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「さ」行の子音',
          tip: 'ㅣの前では「し」に近い',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Similar to "s" in "sun"',
          tip: 'Before ㅣ, more like "sh"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Similar a la "s" de "sol"',
        ),
      ],
    },
    // Vowels
    'ㅏ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"啊"，但口型更小',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「あ」とほぼ同じ',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Like "a" in "father"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Igual que la "a" española',
        ),
      ],
    },
    'ㅓ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"哦"但不圆唇',
          tip: '嘴唇不要圆起来',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「お」より口を縦に開く',
          tip: '唇を丸めない',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Like "u" in "up" or "uh"',
          tip: 'Keep lips unrounded',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Entre "o" y "a", sin redondear labios',
        ),
      ],
    },
    'ㅗ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"哦"，嘴唇圆起',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「お」とほぼ同じ',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Like "o" in "go"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Igual que la "o" española',
        ),
      ],
    },
    'ㅜ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"屋"，嘴唇圆起突出',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「う」とほぼ同じ',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Like "oo" in "food"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Igual que la "u" española',
        ),
      ],
    },
    'ㅡ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '类似"资"的韵母，嘴唇扁平',
          tip: '嘴唇向两边拉',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「う」と「い」の中間',
          tip: '唇を横に引く',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'No exact equivalent',
          tip: 'Say "oo" but spread your lips like "ee"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'No existe en español',
          tip: 'Di "u" con los labios estirados como "i"',
        ),
      ],
    },
    'ㅣ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '与"一"相同',
        ),
      ],
      'ja': [
        NativeComparison(
          languageCode: 'ja',
          languageName: '日本語',
          comparison: '「い」と同じ',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Like "ee" in "see"',
        ),
      ],
      'es': [
        NativeComparison(
          languageCode: 'es',
          languageName: 'Español',
          comparison: 'Igual que la "i" española',
        ),
      ],
    },
    // Double consonants
    'ㄲ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '比ㄱ更紧，喉咙紧张',
          tip: '没有类似的音，需要练习',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Tense "k" with no air',
          tip: 'Like "sk" in "sky" but tenser',
        ),
      ],
    },
    'ㅃ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '比ㅂ更紧，喉咙紧张',
          tip: '没有类似的音，需要练习',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Tense "p" with no air',
          tip: 'Like "sp" in "spy" but tenser',
        ),
      ],
    },
    'ㄸ': {
      'zh': [
        NativeComparison(
          languageCode: 'zh',
          languageName: '中文',
          comparison: '比ㄷ更紧，喉咙紧张',
          tip: '没有类似的音，需要练习',
        ),
      ],
      'en': [
        NativeComparison(
          languageCode: 'en',
          languageName: 'English',
          comparison: 'Tense "t" with no air',
          tip: 'Like "st" in "stop" but tenser',
        ),
      ],
    },
  };
}

/// Widget showing native language comparison for pronunciation
class NativeComparisonCard extends StatefulWidget {
  final String character;
  final String? userLanguage;
  final Map<String, List<NativeComparison>>? customComparisons;

  const NativeComparisonCard({
    required this.character,
    this.userLanguage,
    this.customComparisons,
    super.key,
  });

  @override
  State<NativeComparisonCard> createState() => _NativeComparisonCardState();
}

class _NativeComparisonCardState extends State<NativeComparisonCard> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = _resolveLanguage(widget.userLanguage ?? 'ko');
  }

  /// Resolve the user's language to one available in comparisons.
  /// zh_TW maps to zh (comparison data uses zh key).
  /// For ko users (or if no match), fall back to first available language.
  String _resolveLanguage(String lang) {
    // Map zh_TW to zh since comparison data uses zh key
    final mapped = lang == 'zh_TW' ? 'zh' : lang;
    final available = _comparisons.keys.toList();
    if (available.contains(mapped)) return mapped;
    // Fallback to first available language
    return available.isNotEmpty ? available.first : mapped;
  }

  Map<String, List<NativeComparison>> get _comparisons =>
      widget.customComparisons ??
      KoreanCharacterComparisons.getComparisons(widget.character);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_comparisons.isEmpty) {
      return const SizedBox.shrink();
    }

    final availableLanguages = _comparisons.keys.toList();
    var effectiveLanguage = _selectedLanguage;
    if (!availableLanguages.contains(effectiveLanguage) &&
        availableLanguages.isNotEmpty) {
      effectiveLanguage = availableLanguages.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedLanguage = effectiveLanguage);
      });
    }

    final currentComparisons = _comparisons[effectiveLanguage] ?? [];

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
          // Header
          Row(
            children: [
              Icon(
                Icons.translate,
                color: Colors.green.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.nativeComparison,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Comparison content
          ...currentComparisons.map((comparison) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildComparisonItem(comparison),
              )),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(NativeComparison comparison) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language name
          Row(
            children: [
              Text(
                _getLanguageFlag(comparison.languageCode),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                comparison.languageName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Comparison text
          Text(
            comparison.comparison,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),

          // Tip if available
          if (comparison.tip != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 14,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    comparison.tip!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getLanguageFlag(String code) {
    switch (code) {
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      case 'ko':
        return '🇰🇷';
      default:
        return '🌐';
    }
  }
}
