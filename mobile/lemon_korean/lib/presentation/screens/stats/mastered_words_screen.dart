import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/convertible_text.dart';

/// Screen showing all mastered vocabulary words
class MasteredWordsScreen extends StatefulWidget {
  const MasteredWordsScreen({super.key});

  @override
  State<MasteredWordsScreen> createState() => _MasteredWordsScreenState();
}

class _MasteredWordsScreenState extends State<MasteredWordsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _searchQuery = '';
  String _sortBy = 'lesson'; // 'lesson', 'korean', 'chinese'

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progressProvider = Provider.of<ProgressProvider>(context);
    var words = progressProvider.getMasteredWords();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      words = words.where((word) {
        final korean = (word['korean'] as String? ?? '').toLowerCase();
        final chinese = (word['chinese'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return korean.contains(query) || chinese.contains(query);
      }).toList();
    }

    // Sort words
    words = _sortWords(words);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.masteredWords,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: l10n.sort,
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'lesson',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'lesson' ? Icons.check : null,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByLesson),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'korean',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'korean' ? Icons.check : null,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByKorean),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'chinese',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'chinese' ? Icons.check : null,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByChinese),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchWords,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Word count
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.wordCount(words.length),
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.paddingSmall),

          // Word list
          Expanded(
            child: words.isEmpty
                ? _buildEmptyState(l10n)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                    ),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      return _buildWordCard(words[index], l10n);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _sortWords(List<Map<String, dynamic>> words) {
    switch (_sortBy) {
      case 'korean':
        words.sort((a, b) => (a['korean'] as String? ?? '')
            .compareTo(b['korean'] as String? ?? ''));
        break;
      case 'chinese':
        words.sort((a, b) => (a['chinese'] as String? ?? '')
            .compareTo(b['chinese'] as String? ?? ''));
        break;
      case 'lesson':
      default:
        words.sort((a, b) => (a['lesson_id'] as int? ?? 0)
            .compareTo(b['lesson_id'] as int? ?? 0));
        break;
    }
    return words;
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.translate,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            _searchQuery.isNotEmpty ? l10n.noWordsFound : l10n.noMasteredWords,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(Map<String, dynamic> word, AppLocalizations l10n) {
    final korean = word['korean'] as String? ?? '';
    final chinese = word['chinese'] as String? ?? '';
    final pinyin = word['pinyin'] as String? ?? '';
    final lessonId = word['lesson_id'] as int?;
    final audioUrl = word['audio_url'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: InkWell(
        onTap: () => _showWordDetail(word, l10n),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Korean word
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      korean,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (lessonId != null)
                      Text(
                        l10n.lessonId(lessonId),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),

              // Chinese meaning
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConvertibleText(
                      chinese,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                      ),
                    ),
                    if (pinyin.isNotEmpty)
                      Text(
                        pinyin,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),

              // Audio button
              if (audioUrl != null)
                IconButton(
                  icon: const Icon(Icons.volume_up_outlined),
                  color: AppConstants.primaryColor,
                  onPressed: () => _playAudio(audioUrl),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  void _showWordDetail(Map<String, dynamic> word, AppLocalizations l10n) {
    final korean = word['korean'] as String? ?? '';
    final chinese = word['chinese'] as String? ?? '';
    final pinyin = word['pinyin'] as String? ?? '';
    final hanja = word['hanja'] as String?;
    final example = word['example'] as String?;
    final exampleTranslation = word['example_translation'] as String?;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Korean word
              Center(
                child: Text(
                  korean,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Chinese meaning
              Center(
                child: ConvertibleText(
                  chinese,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                  ),
                ),
              ),

              if (pinyin.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Center(
                  child: Text(
                    pinyin,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],

              if (hanja != null && hanja.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingLarge),
                _buildDetailRow(l10n.hanja, hanja),
              ],

              if (example != null && example.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingLarge),
                _buildDetailRow(l10n.exampleSentence, example),
                if (exampleTranslation != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppConstants.paddingMedium,
                      top: AppConstants.paddingSmall,
                    ),
                    child: ConvertibleText(
                      exampleTranslation,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: AppConstants.paddingLarge),

              // Mastery indicator
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppConstants.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppConstants.successColor,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(
                        l10n.mastered,
                        style: const TextStyle(
                          color: AppConstants.successColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: AppConstants.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
          ),
        ),
      ],
    );
  }

  Future<void> _playAudio(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }
}
