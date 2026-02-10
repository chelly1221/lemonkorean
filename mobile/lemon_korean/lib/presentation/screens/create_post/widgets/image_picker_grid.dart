import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Grid widget for selecting/displaying images for a new post
/// Supports up to 4 image slots with add/remove functionality
/// Images are referenced by URL string (media service integration)
class ImagePickerGrid extends StatelessWidget {
  final List<String> imageUrls;
  final ValueChanged<String> onImageAdded;
  final ValueChanged<int> onImageRemoved;

  const ImagePickerGrid({
    super.key,
    required this.imageUrls,
    required this.onImageAdded,
    required this.onImageRemoved,
  });

  static const int maxImages = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canAddMore = imageUrls.length < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 20,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text(
              l10n?.photos ?? 'Photos',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text(
              '${imageUrls.length}/$maxImages',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length + (canAddMore ? 1 : 0),
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppConstants.paddingSmall),
            itemBuilder: (context, index) {
              if (index == imageUrls.length && canAddMore) {
                return _buildAddButton(context);
              }
              return _buildImageSlot(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => _showAddImageDialog(context),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 4),
            Text(
              l10n?.addPhoto ?? 'Add',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlot(BuildContext context, int index) {
    final url = imageUrls[index];
    final fullUrl = url.startsWith('http') ? url : '${AppConstants.mediaUrl}/images/$url';

    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            child: Image.network(
              fullUrl,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppConstants.primaryColor,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppConstants.textHint,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onImageRemoved(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddImageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n?.addPhoto ?? 'Add Photo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n?.imageUrlHint ?? 'Enter image URL or media key',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.link),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onImageAdded(value.trim());
              Navigator.pop(dialogContext);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                onImageAdded(value);
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.black87,
            ),
            child: Text(l10n?.add ?? 'Add'),
          ),
        ],
      ),
    );
  }
}
