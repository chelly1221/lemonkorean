import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/vocabulary_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/bookmark_provider.dart';

/// Reusable Bookmark Button Widget
/// Shows filled/outlined star icon based on bookmark state
/// Handles bookmark toggle with notes dialog
class BookmarkButton extends StatefulWidget {
  final VocabularyModel vocabulary;
  final VoidCallback? onBookmarked;
  final VoidCallback? onUnbookmarked;
  final double size;
  final Color? color;
  final bool showLabel;

  const BookmarkButton({
    Key? key,
    required this.vocabulary,
    this.onBookmarked,
    this.onUnbookmarked,
    this.size = 24.0,
    this.color,
    this.showLabel = false,
  }) : super(key: key);

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleToggle() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final bookmarkProvider = context.read<BookmarkProvider>();
    final isCurrentlyBookmarked = await bookmarkProvider.isBookmarked(widget.vocabulary.id);

    if (!isCurrentlyBookmarked) {
      // Show notes dialog before bookmarking
      final notes = await _showNotesDialog();
      if (notes == null && !mounted) {
        setState(() => _isProcessing = false);
        return; // User cancelled
      }

      // Create bookmark
      final success = await bookmarkProvider.toggleBookmark(
        widget.vocabulary,
        notes: notes,
      );

      if (success && mounted) {
        // Animate
        await _animationController.forward();
        await _animationController.reverse();

        // Show success message
        _showSnackBar(AppLocalizations.of(context)!.addedToVocabularyBook, isSuccess: true);
        widget.onBookmarked?.call();
      } else if (mounted) {
        _showSnackBar(AppLocalizations.of(context)!.addFailed, isSuccess: false);
      }
    } else {
      // Remove bookmark (with confirmation)
      final confirm = await _showRemoveConfirmation();
      if (confirm != true) {
        setState(() => _isProcessing = false);
        return;
      }

      final success = await bookmarkProvider.toggleBookmark(widget.vocabulary);

      if (!success && mounted) {
        // Animate
        await _animationController.forward();
        await _animationController.reverse();

        // Show success message
        _showSnackBar(AppLocalizations.of(context)!.removedFromVocabularyBook, isSuccess: true);
        widget.onUnbookmarked?.call();
      } else if (mounted) {
        _showSnackBar(AppLocalizations.of(context)!.removeFailed, isSuccess: false);
      }
    }

    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<String?> _showNotesDialog() async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addToVocabularyBook),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.vocabulary.korean} (${widget.vocabulary.translation})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.notesOptional,
                hintText: l10n.notesHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRemoveConfirmation() async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmRemove),
        content: Text(l10n.confirmRemoveWord(widget.vocabulary.korean)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        return FutureBuilder<bool>(
          future: bookmarkProvider.isBookmarked(widget.vocabulary.id),
          builder: (context, snapshot) {
            final isBookmarked = snapshot.data ?? false;
            final effectiveColor = widget.color ?? Theme.of(context).primaryColor;

            if (widget.showLabel) {
              return InkWell(
                onTap: _isProcessing ? null : _handleToggle,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: widget.size,
                          color: effectiveColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isBookmarked ? AppLocalizations.of(context)!.bookmarked : AppLocalizations.of(context)!.bookmark,
                        style: TextStyle(
                          color: effectiveColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return IconButton(
              onPressed: _isProcessing ? null : _handleToggle,
              icon: ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: widget.size,
                  color: _isProcessing ? Colors.grey : effectiveColor,
                ),
              ),
              tooltip: isBookmarked ? AppLocalizations.of(context)!.removeFromVocabularyBook : AppLocalizations.of(context)!.addToVocabularyBook,
            );
          },
        );
      },
    );
  }
}
