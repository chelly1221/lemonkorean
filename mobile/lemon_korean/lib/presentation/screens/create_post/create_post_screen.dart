import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/feed_provider.dart';
import 'widgets/image_picker_grid.dart';

/// Post creation screen
/// Allows users to compose a new post with text content, category, images,
/// learning templates, and tags
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();
  String _selectedCategory = 'general';
  String? _selectedTemplate;
  final List<String> _imageUrls = [];
  final List<String> _tags = [];
  bool _isPosting = false;
  bool _isAddingTag = false;

  static const int _maxContentLength = 500;
  static const int _maxTags = 5;

  // Learning templates
  static const Map<String, String> _learningTemplates = {
    'Today I Learned': '\u{1f4dd} Today I learned:\n\n\u{1f1f0}\u{1f1f7} Korean: \n\u{1f310} Meaning: \n\u{270f}\u{fe0f} Example: \n\n',
    'Practice Writing': '\u{270d}\u{fe0f} Practice writing:\n\n',
    'Question': '\u{2753} Question:\n\n',
  };

  // Suggested tags by category
  static const Map<String, List<String>> _suggestedTags = {
    'learning': ['hangul', 'grammar', 'vocabulary', 'pronunciation', 'practice'],
    'general': ['culture', 'kdrama', 'kpop', 'food', 'travel'],
  };

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
    _tagController.dispose();
    _contentFocusNode.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _contentController.text.trim().isNotEmpty && !_isPosting;

  int get _remainingChars =>
      _maxContentLength - _contentController.text.length;

  void _applyTemplate(String templateName) {
    final template = _learningTemplates[templateName];
    if (template == null) return;

    setState(() {
      _selectedTemplate = templateName;
    });

    _contentController.text = template;

    // Place cursor at a useful position (after the first placeholder)
    // Find the first colon-space pattern where user should type
    final colonIndex = template.indexOf(': \n');
    if (colonIndex != -1) {
      _contentController.selection = TextSelection.collapsed(
        offset: colonIndex + 2,
      );
    } else {
      // Place cursor at end
      _contentController.selection = TextSelection.collapsed(
        offset: template.length,
      );
    }

    _contentFocusNode.requestFocus();
  }

  void _addTag(String tag) {
    // Strip # prefix and lowercase
    tag = tag.replaceAll('#', '').trim().toLowerCase();
    if (tag.isEmpty) return;
    if (_tags.length >= _maxTags) return;
    if (_tags.contains(tag)) return;

    setState(() {
      _tags.add(tag);
      _tagController.clear();
      _isAddingTag = false;
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

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
      tags: _tags,
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

            // Learning templates (only when learning category selected)
            if (_selectedCategory == 'learning') ...[
              _buildTemplateSelector(),
              const SizedBox(height: AppConstants.paddingMedium),
            ],

            // Content text field
            _buildContentField(l10n),

            const SizedBox(height: AppConstants.paddingSmall),

            // Character counter
            _buildCharacterCounter(),

            const SizedBox(height: AppConstants.paddingMedium),

            // Tags section
            _buildTagsSection(),

            const SizedBox(height: AppConstants.paddingLarge),

            // Post preview
            if (_contentController.text.trim().isNotEmpty)
              _buildPostPreview(),

            if (_contentController.text.trim().isNotEmpty)
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
          final previousCategory = _selectedCategory;
          _selectedCategory = value;
          // Clear template selection when switching away from learning
          if (previousCategory == 'learning' && value != 'learning') {
            _selectedTemplate = null;
          }
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

  Widget _buildTemplateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Templates',
          style: TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _learningTemplates.keys.map((name) {
              final isSelected = _selectedTemplate == name;
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
                child: GestureDetector(
                  onTap: () => _applyTemplate(name),
                  child: AnimatedContainer(
                    duration: AppConstants.animationFast,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.infoColor.withValues(alpha: 0.15)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                      border: Border.all(
                        color: isSelected
                            ? AppConstants.infoColor
                            : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _templateIcon(name),
                          size: 16,
                          color: isSelected
                              ? AppConstants.infoColor
                              : AppConstants.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppConstants.infoColor
                                : AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0);
  }

  IconData _templateIcon(String templateName) {
    switch (templateName) {
      case 'Today I Learned':
        return Icons.lightbulb_outline;
      case 'Practice Writing':
        return Icons.edit_outlined;
      case 'Question':
        return Icons.help_outline;
      default:
        return Icons.article_outlined;
    }
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
    final isOverLimit = _remainingChars < 0;
    final isDanger = _remainingChars < 20;
    final isWarning = _remainingChars < 50;

    Color counterColor;
    if (isOverLimit || isDanger) {
      counterColor = AppConstants.errorColor;
    } else if (isWarning) {
      counterColor = AppConstants.warningColor;
    } else {
      counterColor = AppConstants.textSecondary;
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        '$_remainingChars',
        style: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          color: counterColor,
          fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // ================================================================
  // TAGS SECTION
  // ================================================================

  Widget _buildTagsSection() {
    final suggestions = _suggestedTags[_selectedCategory] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.tag,
              size: 20,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text(
              '${_tags.length}/$_maxTags',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingSmall),

        // Added tags
        if (_tags.isNotEmpty)
          Wrap(
            spacing: AppConstants.paddingSmall,
            runSpacing: AppConstants.paddingSmall,
            children: _tags.map((tag) {
              return Chip(
                label: Text(
                  '#$tag',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textPrimary,
                  ),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                deleteIconColor: AppConstants.textSecondary,
                onDeleted: () => _removeTag(tag),
                backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.15),
                side: BorderSide(
                  color: AppConstants.primaryColor.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),

        // Suggested tags (show when no tags added yet)
        if (_tags.isEmpty && suggestions.isNotEmpty) ...[
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Suggested',
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: AppConstants.paddingSmall,
            runSpacing: AppConstants.paddingSmall,
            children: suggestions.map((tag) {
              return GestureDetector(
                onTap: () => _addTag(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: AppConstants.paddingSmall),

        // Add tag input or button
        if (_tags.length < _maxTags)
          _isAddingTag
              ? _buildTagInput()
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAddingTag = true;
                    });
                    // Focus on next frame after build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _tagFocusNode.requestFocus();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add tag',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ],
    );
  }

  Widget _buildTagInput() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _tagController,
              focusNode: _tagFocusNode,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
              decoration: InputDecoration(
                hintText: 'Type a tag...',
                hintStyle: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.grey.shade400,
                ),
                prefixText: '# ',
                prefixStyle: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.grey.shade500,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  borderSide: const BorderSide(
                    color: AppConstants.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _addTag(value);
                } else {
                  setState(() {
                    _isAddingTag = false;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(width: AppConstants.paddingSmall),
        GestureDetector(
          onTap: () {
            setState(() {
              _tagController.clear();
              _isAddingTag = false;
            });
          },
          child: Icon(
            Icons.close,
            size: 20,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // POST PREVIEW
  // ================================================================

  Widget _buildPostPreview() {
    final content = _contentController.text.trim();
    // Show first 2 lines of content
    final lines = content.split('\n');
    final previewLines = lines.take(2).join('\n');
    final hasMore = lines.length > 2;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview header
          Row(
            children: [
              Icon(
                Icons.preview_outlined,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                'Preview',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _selectedCategory == 'learning'
                  ? AppConstants.infoColor.withValues(alpha: 0.1)
                  : AppConstants.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Text(
              _selectedCategory == 'learning' ? 'Learning' : 'General',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _selectedCategory == 'learning'
                    ? AppConstants.infoColor
                    : AppConstants.secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Content preview (first 2 lines)
          Text(
            hasMore ? '$previewLines...' : previewLines,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textPrimary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Tags preview
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              children: _tags.map((tag) {
                return Text(
                  '#$tag',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppConstants.infoColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
