import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_storage.dart'
    if (dart.library.html) '../../../core/platform/web/stubs/local_storage_stub.dart';
import '../../../data/models/bookmark_model.dart';
import '../../../data/models/vocabulary_model.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/convertible_text.dart';

/// Vocabulary Book Review Screen
/// SRS-based review for bookmarked vocabulary words
class VocabularyBookReviewScreen extends StatefulWidget {
  const VocabularyBookReviewScreen({super.key});

  @override
  State<VocabularyBookReviewScreen> createState() => _VocabularyBookReviewScreenState();
}

class _VocabularyBookReviewScreenState extends State<VocabularyBookReviewScreen> {
  final ContentRepository _contentRepository = ContentRepository();

  List<BookmarkModel> _reviewItems = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isLoading = true;

  // Statistics
  int _correctCount = 0;
  int _wrongCount = 0;
  Map<int, ReviewRating> _results = {}; // vocabulary_id -> rating

  @override
  void initState() {
    super.initState();
    _loadReviewItems();
  }

  Future<void> _loadReviewItems() async {
    setState(() => _isLoading = true);

    try {
      final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

      // Get bookmarks that are due for review
      final dueBookmarks = bookmarkProvider.getDueForReview();

      // If no items due, get bookmarks with low mastery (< 4)
      if (dueBookmarks.isEmpty) {
        _reviewItems = bookmarkProvider.bookmarks
            .where((b) => (b.masteryLevel ?? 0) < 4)
            .toList();
      } else {
        _reviewItems = dueBookmarks;
      }

      // If still empty, get all bookmarks
      if (_reviewItems.isEmpty) {
        _reviewItems = bookmarkProvider.bookmarks;
      }

      // Shuffle for variety
      _reviewItems.shuffle();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loadingFailed(e.toString()))),
        );
      }
    }
  }

  void _handleReview(ReviewRating rating) async {
    final currentItem = _reviewItems[_currentIndex];
    final vocabulary = currentItem.vocabulary;

    if (vocabulary == null) {
      _moveToNextItem();
      return;
    }

    // Track statistics
    if (rating == ReviewRating.forgot) {
      _wrongCount++;
    } else {
      _correctCount++;
    }

    _results[vocabulary.id] = rating;

    // Convert rating to quality score for SM-2 algorithm
    int quality;
    switch (rating) {
      case ReviewRating.forgot:
        quality = 0;
        break;
      case ReviewRating.hard:
        quality = 3;
        break;
      case ReviewRating.good:
        quality = 4;
        break;
      case ReviewRating.easy:
        quality = 5;
        break;
    }

    try {
      // Save review result to server
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        final reviewData = {
          'user_id': authProvider.currentUser!.id,
          'vocabulary_id': vocabulary.id,
          'quality': quality,
          'is_correct': quality >= 3,
          'response_time': 0,
        };

        // Try to save to server
        final success = await _contentRepository.markReviewDone(reviewData);

        if (!success) {
          // If server save fails, add to sync queue for offline support
          await LocalStorage.addToSyncQueue({
            'type': 'review_complete',
            'data': reviewData,
            'timestamp': DateTime.now().toIso8601String(),
          });
        }
      }
    } catch (e) {
      // Continue even if save fails (will sync later)
    }

    // Move to next item
    _moveToNextItem();
  }

  void _moveToNextItem() {
    if (_currentIndex < _reviewItems.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      // Review session completed
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final l10n = AppLocalizations.of(context)!;
    final totalReviewed = _reviewItems.length;
    final accuracy = totalReviewed > 0
        ? ((_correctCount / totalReviewed) * 100).round()
        : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.reviewComplete,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.celebration,
              size: 64,
              color: AppConstants.successColor,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.reviewCompleteCount(totalReviewed),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBadge(
                  l10n.correct,
                  '$_correctCount',
                  AppConstants.successColor,
                ),
                _buildStatBadge(
                  l10n.wrong,
                  '$_wrongCount',
                  AppConstants.errorColor,
                ),
                _buildStatBadge(
                  l10n.accuracy,
                  '$accuracy%',
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close review screen
            },
            child: Text(l10n.finish),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.vocabularyBookReview,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_reviewItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.vocabularyBookReview,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noWordsToReview,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppConstants.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bookmarkWordsToReview,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textHint,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.returnToVocabularyBook),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentItem = _reviewItems[_currentIndex];
    final vocabulary = currentItem.vocabulary;
    final progress = (_currentIndex + 1) / _reviewItems.length;

    if (vocabulary == null) {
      // Skip items without vocabulary data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveToNextItem();
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${l10n.vocabularyBookReview} ${_currentIndex + 1}/${_reviewItems.length}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Mastery level indicator
          if (currentItem.masteryLevel != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getMasteryColor(currentItem.masteryLevel!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Lv${currentItem.masteryLevel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.exit),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
            ),
          ),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Personal notes (if any)
                    if (currentItem.hasNotes) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.note,
                              size: 16,
                              color: Colors.amber[800],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ConvertibleText(
                                currentItem.notes!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.amber[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Question Card
                    Card(
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppConstants.paddingXLarge),
                        child: Column(
                          children: [
                            // Korean Word
                            Text(
                              vocabulary.korean,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            if (vocabulary.hanja != null && vocabulary.hanja!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  vocabulary.hanja!,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 32),

                            // Divider
                            Divider(color: Colors.grey.shade300),

                            const SizedBox(height: 32),

                            // Answer (hidden until tapped)
                            if (!_showAnswer)
                              ElevatedButton(
                                onPressed: () => setState(() => _showAnswer = true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 48,
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(
                                  l10n.showAnswer,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: [
                                  // Translation
                                  ConvertibleText(
                                    vocabulary.translation,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.successColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  if (vocabulary.pronunciation != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        vocabulary.pronunciation!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Rating Buttons (shown after answer is revealed)
                    if (_showAnswer) ...[
                      const SizedBox(height: 32),
                      Text(
                        l10n.didYouRemember,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildRatingButton(
                            l10n.forgot,
                            Icons.close,
                            AppConstants.errorColor,
                            ReviewRating.forgot,
                          ),
                          _buildRatingButton(
                            l10n.hard,
                            Icons.sentiment_dissatisfied,
                            Colors.orange,
                            ReviewRating.hard,
                          ),
                          _buildRatingButton(
                            l10n.remembered,
                            Icons.sentiment_satisfied,
                            Colors.blue,
                            ReviewRating.good,
                          ),
                          _buildRatingButton(
                            l10n.easy,
                            Icons.sentiment_very_satisfied,
                            AppConstants.successColor,
                            ReviewRating.easy,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingButton(
    String label,
    IconData icon,
    Color color,
    ReviewRating rating,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () => _handleReview(rating),
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: color),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMasteryColor(int level) {
    if (level >= 4) return Colors.green;
    if (level >= 2) return Colors.blue;
    if (level >= 1) return Colors.orange;
    return Colors.grey;
  }
}

/// Review rating for SM-2 algorithm
enum ReviewRating {
  forgot,  // 0 - Complete blackout
  hard,    // 3 - Correct response recalled with serious difficulty
  good,    // 4 - Correct response after a hesitation
  easy,    // 5 - Perfect response
}
