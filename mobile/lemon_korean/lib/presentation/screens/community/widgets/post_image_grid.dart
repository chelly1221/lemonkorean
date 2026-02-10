import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Displays 1-4 images in a responsive grid layout
/// - 1 image: full width, max height 300
/// - 2 images: side by side
/// - 3 images: one large left, two stacked right
/// - 4 images: 2x2 grid
class PostImageGrid extends StatelessWidget {
  final List<String> imageUrls;

  const PostImageGrid({
    super.key,
    required this.imageUrls,
  });

  String _buildImageUrl(String key) {
    if (key.startsWith('http://') || key.startsWith('https://')) {
      return key;
    }
    return '${AppConstants.mediaUrl}/images/$key';
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    final count = imageUrls.length.clamp(1, 4);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      child: _buildGrid(context, count),
    );
  }

  Widget _buildGrid(BuildContext context, int count) {
    switch (count) {
      case 1:
        return _buildSingleImage(context, imageUrls[0]);
      case 2:
        return _buildTwoImages(context);
      case 3:
        return _buildThreeImages(context);
      default:
        return _buildFourImages(context);
    }
  }

  Widget _buildSingleImage(BuildContext context, String url) {
    return GestureDetector(
      onTap: () => _openFullscreen(context, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: _buildNetworkImage(url, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  Widget _buildTwoImages(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openFullscreen(context, 0),
              child: _buildNetworkImage(imageUrls[0], fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: GestureDetector(
              onTap: () => _openFullscreen(context, 1),
              child: _buildNetworkImage(imageUrls[1], fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeImages(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _openFullscreen(context, 0),
              child: _buildNetworkImage(imageUrls[0], fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openFullscreen(context, 1),
                    child: _buildNetworkImage(imageUrls[1], fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openFullscreen(context, 2),
                    child: _buildNetworkImage(imageUrls[2], fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourImages(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openFullscreen(context, 0),
                    child: _buildNetworkImage(imageUrls[0], fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openFullscreen(context, 1),
                    child: _buildNetworkImage(imageUrls[1], fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openFullscreen(context, 2),
                    child: _buildNetworkImage(imageUrls[2], fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openFullscreen(context, 3),
                    child: _buildNetworkImage(imageUrls[3], fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage(
    String key, {
    BoxFit fit = BoxFit.cover,
    double? width,
  }) {
    final url = _buildImageUrl(key);
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(
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
              size: 40,
            ),
          ),
        );
      },
    );
  }

  void _openFullscreen(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullscreenImageViewer(
          imageUrls: imageUrls.map((key) => _buildImageUrl(key)).toList(),
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

/// Fullscreen image viewer with PageView for swiping between images
class _FullscreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _FullscreenImageViewer({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<_FullscreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: widget.imageUrls.length > 1
            ? Text(
                '${_currentIndex + 1} / ${widget.imageUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppConstants.fontSizeMedium,
                ),
              )
            : null,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(
                widget.imageUrls[index],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppConstants.primaryColor,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 64,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
