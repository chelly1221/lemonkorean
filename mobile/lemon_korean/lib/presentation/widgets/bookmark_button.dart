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
    required this.vocabulary,
    this.onBookmarked,
    this.onUnbookmarked,
    this.size = 24.0,
    this.color,
    this.showLabel = false,
    super.key,
  });

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
        final l10n = AppLocalizations.of(context)!;
        final messenger = ScaffoldMessenger.of(context);

        // Animate
        await _animationController.forward();
        await _animationController.reverse();

        if (!mounted) return;

        // Show success message
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(l10n.addedToVocabularyBook),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        widget.onBookmarked?.call();
      } else if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text(l10n.addFailed),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
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
        final l10n = AppLocalizations.of(context)!;
        final messenger = ScaffoldMessenger.of(context);

        // Animate
        await _animationController.forward();
        await _animationController.reverse();

        if (!mounted) return;

        // Show success message
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(l10n.removedFromVocabularyBook),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        widget.onUnbookmarked?.call();
      } else if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text(l10n.removeFailed),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
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
