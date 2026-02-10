import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/feed_provider.dart';
import 'widgets/image_picker_grid.dart';

/// Post creation screen
/// Allows users to compose a new post with text content, category, and images
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  String _selectedCategory = 'general';
  final List<String> _imageUrls = [];
  bool _isPosting = false;

  static const int _maxContentLength = 500;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _contentController.text.trim().isNotEmpty && !_isPosting;

  int get _remainingChars =>
      _maxContentLength - _contentController.text.length;

  Future<void> _submitPost() async {
    if (!_canSubmit) return;

    setState(() {
      _isPosting = true;
    });

    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    final post = await feedProvider.createPost(
      content: _contentController.text.trim(),
      category: _selectedCategory,
      imageUrls: _imageUrls,
    );

    if (!mounted) return;

    setState(() {
      _isPosting = false;
    });

    if (post != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.postCreated ?? 'Post created'),
          backgroundColor: AppConstants.successColor,
          duration: AppConstants.snackBarShort,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedProvider.errorMessage ?? (l10n?.postFailed ?? 'Failed to create post')),
          backgroundColor: AppConstants.errorColor,
          duration: AppConstants.snackBarLong,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.newPost ?? 'New Post'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: _isPosting
                ? const Padding(
                    padding: EdgeInsets.all(AppConstants.paddingMedium),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.primaryColor,
                        ),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: _canSubmit ? _submitPost : null,
                    style: TextButton.styleFrom(
                      backgroundColor: _canSubmit
                          ? AppConstants.primaryColor
                          : Colors.grey.shade200,
                      foregroundColor:
                          _canSubmit ? Colors.black87 : AppConstants.textHint,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLarge),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                      ),
                    ),
                    child: Text(
                      l10n?.post ?? 'Post',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category selector
            _buildCategorySelector(l10n),

            const SizedBox(height: AppConstants.paddingMedium),

            // Content text field
            _buildContentField(l10n),

            const SizedBox(height: AppConstants.paddingMedium),

            // Character counter
            _buildCharacterCounter(),

            const SizedBox(height: AppConstants.paddingLarge),

            // Image picker
            ImagePickerGrid(
              imageUrls: _imageUrls,
              onImageAdded: (url) {
                setState(() {
                  _imageUrls.add(url);
                });
              },
              onImageRemoved: (index) {
                setState(() {
                  _imageUrls.removeAt(index);
                });
              },
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildCategorySelector(AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.category ?? 'Category',
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Row(
          children: [
            Expanded(
              child: _buildCategoryChip(
                label: l10n?.general ?? 'General',
                value: 'general',
                icon: Icons.chat_bubble_outline,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Expanded(
              child: _buildCategoryChip(
                label: l10n?.learning ?? 'Learning',
                value: 'learning',
                icon: Icons.school_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedCategory == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = value;
        });
      },
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor.withValues(alpha: 0.2)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isSelected
                ? AppConstants.primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.black87
                  : AppConstants.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.black87
                    : AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentField(AppLocalizations? l10n) {
    return TextField(
      controller: _contentController,
      focusNode: _contentFocusNode,
      maxLines: 8,
      minLines: 4,
      maxLength: _maxContentLength,
      buildCounter: (context,
          {required currentLength, required isFocused, required maxLength}) {
        return null; // Custom counter below
      },
      decoration: InputDecoration(
        hintText: l10n?.writeYourThoughts ?? 'Share your thoughts...',
        hintStyle: const TextStyle(
          color: AppConstants.textHint,
          fontSize: AppConstants.fontSizeNormal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
      ),
      style: const TextStyle(
        fontSize: AppConstants.fontSizeNormal,
        height: 1.5,
      ),
    );
  }

  Widget _buildCharacterCounter() {
    final isNearLimit = _remainingChars <= 50;
    final isOverLimit = _remainingChars < 0;

    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        '$_remainingChars',
        style: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          color: isOverLimit
              ? AppConstants.errorColor
              : isNearLimit
                  ? AppConstants.warningColor
                  : AppConstants.textSecondary,
          fontWeight: isNearLimit ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
