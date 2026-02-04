import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_storage.dart'
    if (dart.library.html) '../../../core/platform/web/stubs/local_storage_stub.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/vocabulary_model.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';

/// Review Screen
/// Spaced Repetition System (SRS) for vocabulary review
class ReviewScreen extends StatefulWidget {
  final List<VocabularyModel>? vocabularyList;

  const ReviewScreen({
    this.vocabularyList,
    super.key,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ContentRepository _contentRepository = ContentRepository();

  List<VocabularyModel> _reviewItems = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviewItems();
  }

  Future<void> _loadReviewItems() async {
    setState(() => _isLoading = true);

    try {
      if (widget.vocabularyList != null) {
        _reviewItems = widget.vocabularyList!;
      } else {
        // Load vocabulary items due for review using SRS algorithm
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.currentUser != null) {
          try {
            // Fetch review schedule from API
            _reviewItems = await _contentRepository.getReviewSchedule(
              authProvider.currentUser!.id,
              limit: 20,
            );

            // If no items due for review, fallback to loading vocabulary by level
            if (_reviewItems.isEmpty) {
              AppLogger.d('No items due for review, loading by level', tag: 'ReviewScreen');
              _reviewItems = await _contentRepository.getVocabularyByLevel(1);
            }
          } catch (e) {
            AppLogger.e('Error fetching review schedule', error: e, tag: 'ReviewScreen');
            // Fallback: load vocabulary by level
            _reviewItems = await _contentRepository.getVocabularyByLevel(1);
          }
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n?.loadFailed ?? "Load failed"}: $e')),
        );
      }
    }
  }

  void _handleReview(ReviewRating rating) async {
    // Calculate next review date using SM-2 algorithm
    final currentItem = _reviewItems[_currentIndex];

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
          'vocabulary_id': currentItem.id,
          'quality': quality,
          'is_correct': quality >= 3,
          'response_time': 0, // Could track actual response time if needed
        };

        // Try to save to server
        final success = await _contentRepository.markReviewDone(reviewData);

        if (!success) {
          // If server save fails, add to sync queue for offline support
          AppLogger.w('Server save failed, adding to sync queue', tag: 'ReviewScreen');
          await LocalStorage.addToSyncQueue({
            'type': 'review_complete',
            'data': reviewData,
            'timestamp': DateTime.now().toIso8601String(),
          });
        }
      }
    } catch (e) {
      AppLogger.e('Error saving review', error: e, tag: 'ReviewScreen');
      // Continue even if save fails (will sync later or we'd add to queue)
    }

    // Move to next item
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
              l10n.reviewCompleteCount(_reviewItems.length),
              style: const TextStyle(fontSize: 16),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.review),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_reviewItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.review),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noWordsToReview,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentItem = _reviewItems[_currentIndex];
    final progress = (_currentIndex + 1) / _reviewItems.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.review} ${_currentIndex + 1}/${_reviewItems.length}'),
        actions: [
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
                              currentItem.korean,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            if (currentItem.hanja != null && currentItem.hanja!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  currentItem.hanja!,
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
                                  Text(
                                    currentItem.translation,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.successColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  if (currentItem.pronunciation != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        currentItem.pronunciation!,
                                        style: TextStyle(
                                          fontSize: 16,
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
            backgroundColor: color.withValues(alpha: 0.1),
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
}

/// Review rating for SM-2 algorithm
enum ReviewRating {
  forgot,  // 0 - Complete blackout
  hard,    // 3 - Correct response recalled with serious difficulty
  good,    // 4 - Correct response after a hesitation
  easy,    // 5 - Perfect response
}
