import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/vocabulary_model.dart';
import '../providers/bookmark_provider.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/media_helper.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';

class VocabularyCard extends StatelessWidget {
  final VocabularyModel vocabulary;
  final VoidCallback? onTap;

  const VocabularyCard({
    required this.vocabulary,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Korean + Bookmark button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Korean word
                        Text(
                          vocabulary.korean,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        // Hanja (if available)
                        if (vocabulary.hanja != null && vocabulary.hanja!.isNotEmpty)
                          Text(
                            vocabulary.hanja!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Bookmark button
                  FutureBuilder<bool>(
                    future: bookmarkProvider.isBookmarked(vocabulary.id),
                    builder: (context, snapshot) {
                      final isBookmarked = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () async {
                          final result = await bookmarkProvider.toggleBookmark(vocabulary);
                          if (context.mounted) {
                            final l10n = AppLocalizations.of(context)!;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result ? l10n.addedToVocabularyBook : l10n.removedFromVocabularyBook,
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Chinese + Pinyin
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vocabulary.translation,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (vocabulary.pronunciation != null)
                          Text(
                            vocabulary.pronunciation!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Audio button
                  if (vocabulary.audioUrl != null)
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.blue),
                      onPressed: () => _playAudio(vocabulary.audioUrl!),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Metadata row
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(_getLocalizedPartOfSpeech(context, vocabulary.partOfSpeech), style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.blue[50],
                  ),
                  if (vocabulary.similarityScore != null)
                    Chip(
                      label: Text(AppLocalizations.of(context)!.similarityPercent((vocabulary.similarityScore! * 100).toInt()), style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.green[50],
                    ),
                  Chip(
                    label: Text('Level ${vocabulary.level}', style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.orange[50],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playAudio(String audioUrl) async {
    try {
      final audioPlayer = AudioPlayer();
      final mediaPath = await MediaHelper.getMediaUrl(audioUrl);
      await audioPlayer.play(UrlSource(mediaPath));
    } catch (e) {
      AppLogger.e('Audio playback error', error: e, tag: 'VocabularyCard');
    }
  }

  String _getLocalizedPartOfSpeech(BuildContext context, String partOfSpeech) {
    final l10n = AppLocalizations.of(context)!;
    switch (partOfSpeech) {
      case 'noun':
        return l10n.partOfSpeechNoun;
      case 'verb':
        return l10n.partOfSpeechVerb;
      case 'adjective':
        return l10n.partOfSpeechAdjective;
      case 'adverb':
        return l10n.partOfSpeechAdverb;
      case 'pronoun':
        return l10n.partOfSpeechPronoun;
      case 'particle':
        return l10n.partOfSpeechParticle;
      case 'conjunction':
        return l10n.partOfSpeechConjunction;
      case 'interjection':
        return l10n.partOfSpeechInterjection;
      default:
        return partOfSpeech;
    }
  }
}
