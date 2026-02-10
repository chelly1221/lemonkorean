import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/post_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/feed_provider.dart';
import '../../post_detail/post_detail_screen.dart';
import '../../user_profile/user_profile_screen.dart';
import 'post_image_grid.dart';

/// Card widget displaying a single post in the feed
/// Shows author info, content, images, and action buttons
class PostCard extends StatelessWidget {
  final PostModel post;
  final int index;

  const PostCard({
    super.key,
    required this.post,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      elevation: 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author row
              _buildAuthorRow(context),

              const SizedBox(height: AppConstants.paddingSmall),

              // Content text
              _buildContentText(context, l10n),

              // Image grid
              if (post.hasImages) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                PostImageGrid(imageUrls: post.imageUrls),
              ],

              const SizedBox(height: AppConstants.paddingSmall),

              // Category tag
              if (post.isLearningPost)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppConstants.paddingSmall,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.infoColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSmall,
                      ),
                    ),
                    child: Text(
                      l10n?.learning ?? 'Learning',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.infoColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              // Action row
              _buildActionRow(context, l10n),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: (index * 50).clamp(0, 300)),
        );
  }

  Widget _buildAuthorRow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(userId: post.author.id),
          ),
        );
      },
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.3),
            backgroundImage: post.author.profileImageUrl != null
                ? NetworkImage(
                    '${AppConstants.mediaUrl}/images/${post.author.profileImageUrl}',
                  )
                : null,
            child: post.author.profileImageUrl == null
                ? Text(
                    post.author.name.isNotEmpty
                        ? post.author.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                : null,
          ),

          const SizedBox(width: AppConstants.paddingSmall),

          // Name + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author.name,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _timeAgo(post.createdAt),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentText(BuildContext context, AppLocalizations? l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: post.content,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeNormal,
            color: AppConstants.textPrimary,
            height: 1.4,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 5,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.content,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeNormal,
                color: AppConstants.textPrimary,
                height: 1.4,
              ),
            ),
            if (isOverflowing)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n?.seeMore ?? 'See more',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.infoColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildActionRow(BuildContext context, AppLocalizations? l10n) {
    return Row(
      children: [
        // Like button
        _LikeButton(post: post),

        const SizedBox(width: AppConstants.paddingLarge),

        // Comment button
        InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: post),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingSmall,
              vertical: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 20,
                  color: AppConstants.textSecondary,
                ),
                if (post.commentCount > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentCount}',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(width: AppConstants.paddingLarge),

        // Share button
        InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n?.linkCopied ?? 'Link copied'),
                duration: AppConstants.snackBarShort,
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.paddingSmall,
              vertical: 4,
            ),
            child: Icon(
              Icons.share_outlined,
              size: 20,
              color: AppConstants.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated like button with optimistic update
class _LikeButton extends StatelessWidget {
  final PostModel post;

  const _LikeButton({required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      onTap: () {
        final feedProvider = Provider.of<FeedProvider>(context, listen: false);
        feedProvider.toggleLike(post.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingSmall,
          vertical: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: post.isLiked ? Colors.red : AppConstants.textSecondary,
            ),
            if (post.likeCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '${post.likeCount}',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color:
                      post.isLiked ? Colors.red : AppConstants.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Helper to format a DateTime as a human-readable "time ago" string
String _timeAgo(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 365) return '${diff.inDays ~/ 365}y';
  if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo';
  if (diff.inDays > 0) return '${diff.inDays}d';
  if (diff.inHours > 0) return '${diff.inHours}h';
  if (diff.inMinutes > 0) return '${diff.inMinutes}m';
  return 'now';
}
