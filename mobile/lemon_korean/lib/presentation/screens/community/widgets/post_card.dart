import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/post_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/feed_provider.dart';
import '../../post_detail/post_detail_screen.dart';
import '../../user_profile/user_profile_screen.dart';
import 'post_image_grid.dart';

/// Card widget displaying a single post in the feed.
class PostCard extends StatefulWidget {
  final PostModel post;
  final int index;
  final VoidCallback? onDelete;

  const PostCard({
    required this.post,
    this.index = 0,
    this.onDelete,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool _showHeartOverlay = false;
  Timer? _heartTimer;

  // Like button scale animation
  bool _likeAnimating = false;

  @override
  void dispose() {
    _heartTimer?.cancel();
    super.dispose();
  }

  void _triggerHeartOverlay() {
    setState(() => _showHeartOverlay = true);
    _heartTimer?.cancel();
    _heartTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showHeartOverlay = false);
      }
    });
  }

  void _onDoubleTap() {
    HapticFeedback.lightImpact();
    if (!widget.post.isLiked) {
      context.read<FeedProvider>().toggleLike(widget.post.id);
    }
    _triggerHeartOverlay();
  }

  void _onLikeTap() {
    HapticFeedback.lightImpact();
    context.read<FeedProvider>().toggleLike(widget.post.id);
    setState(() => _likeAnimating = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _likeAnimating = false);
      }
    });
  }

  void _onShareTap(AppLocalizations? l10n) {
    HapticFeedback.selectionClick();
    final text =
        'Post by ${widget.post.author.name}: ${widget.post.content.substring(0, widget.post.content.length.clamp(0, 100))}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.linkCopied ?? 'Link copied'),
        duration: AppConstants.snackBarShort,
      ),
    );
  }

  void _openPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(post: widget.post),
      ),
    );
  }

  Future<void> _confirmDelete(AppLocalizations? l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.delete ?? 'Delete'),
        content: Text(
          l10n?.deletePostConfirm ?? 'Are you sure you want to delete this post?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppConstants.errorColor),
            child: Text(l10n?.delete ?? 'Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.onDelete?.call();
      if (widget.onDelete == null) {
        // Fallback: use FeedProvider directly
        if (mounted) {
          context.read<FeedProvider>().deletePost(widget.post.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final post = widget.post;

    // Determine if the card needs a colored left border for learning posts
    final isLearning = post.isLearningPost;

    return Semantics(
      label: 'Post by ${post.author.name}',
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        elevation: 0.5,
        clipBehavior: Clip.antiAlias,
        color: isLearning ? const Color(0xFFF5F9FF) : null,
        child: Container(
          decoration: isLearning
              ? const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Color(0xFF42A5F5), // Colors.blue.shade400
                      width: 3,
                    ),
                  ),
                )
              : null,
          child: InkWell(
            onTap: () => _openPost(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAuthorRow(context, l10n),
                  const SizedBox(height: 10),
                  if (post.isLearningPost) ...[
                    _buildLearningTag(l10n),
                    const SizedBox(height: 8),
                  ],
                  // Wrap content + images with double-tap gesture and heart overlay
                  _buildContentWithDoubleTap(l10n),
                  const SizedBox(height: 8),
                  _buildActionRow(context, l10n),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(
            duration: 220.ms,
            delay: Duration(milliseconds: (widget.index * 24).clamp(0, 180)),
          ),
    );
  }

  Widget _buildContentWithDoubleTap(AppLocalizations? l10n) {
    final post = widget.post;

    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Content + images column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContentText(l10n),
              if (post.hasImages) ...[
                const SizedBox(height: 10),
                PostImageGrid(imageUrls: post.imageUrls),
              ],
            ],
          ),
          // Heart overlay animation
          if (_showHeartOverlay)
            AnimatedOpacity(
              opacity: _showHeartOverlay ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: AnimatedScale(
                scale: _showHeartOverlay ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: const Icon(
                  Icons.favorite,
                  size: 80,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLearningTag(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppConstants.infoColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Text(
        l10n?.learning ?? 'Learning',
        style: const TextStyle(
          fontSize: 11,
          color: AppConstants.infoColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAuthorRow(BuildContext context, AppLocalizations? l10n) {
    final post = widget.post;
    final currentUserId =
        context.read<AuthProvider>().currentUser?.id;
    final isOwnPost = currentUserId != null && currentUserId == post.author.id;

    return Row(
      children: [
        Semantics(
          label: 'View ${post.author.name} profile',
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(userId: post.author.id),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  AppConstants.primaryColor.withValues(alpha: 0.3),
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
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(userId: post.author.id),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w700,
                  ),
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
        ),
        if (isOwnPost)
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              size: 20,
              color: AppConstants.textSecondary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(l10n);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppConstants.errorColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n?.delete ?? 'Delete',
                      style: const TextStyle(color: AppConstants.errorColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildContentText(AppLocalizations? l10n) {
    final post = widget.post;
    final isLong = post.content.runes.length > 120;

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
            height: 1.45,
          ),
        ),
        if (isLong)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n?.seeMore ?? 'See more',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.infoColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context, AppLocalizations? l10n) {
    final post = widget.post;

    return Row(
      children: [
        Expanded(
          child: Semantics(
            label:
                'Like post, currently ${post.isLiked ? "liked" : "not liked"}, ${post.likeCount} likes',
            child: _PostActionButton(
              icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
              iconColor: post.isLiked ? Colors.red : AppConstants.textSecondary,
              label: l10n?.like ?? 'Like',
              count: post.likeCount,
              textColor:
                  post.isLiked ? Colors.red : AppConstants.textSecondary,
              onTap: _onLikeTap,
              animateIcon: _likeAnimating,
            ),
          ),
        ),
        Expanded(
          child: Semantics(
            label: '${post.commentCount} comments',
            child: _PostActionButton(
              icon: Icons.chat_bubble_outline,
              iconColor: AppConstants.textSecondary,
              label: l10n?.comment ?? 'Comment',
              count: post.commentCount,
              textColor: AppConstants.textSecondary,
              onTap: () => _openPost(context),
            ),
          ),
        ),
        Expanded(
          child: Semantics(
            label: 'Share post',
            child: _PostActionButton(
              icon: Icons.share_outlined,
              iconColor: AppConstants.textSecondary,
              label: l10n?.share ?? 'Share',
              textColor: AppConstants.textSecondary,
              onTap: () => _onShareTap(l10n),
            ),
          ),
        ),
      ],
    );
  }
}

class _PostActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final String label;
  final int? count;
  final VoidCallback onTap;
  final bool animateIcon;

  const _PostActionButton({
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.label,
    required this.onTap,
    this.count,
    this.animateIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasCount = count != null && count! > 0;

    return InkWell(
      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 1.0,
                end: animateIcon ? 1.3 : 1.0,
              ),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                hasCount ? '$label ${_formatCount(count!)}' : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatCount(int value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return '$value';
}

String _timeAgo(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 365) return '${diff.inDays ~/ 365}y';
  if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo';
  if (diff.inDays > 0) return '${diff.inDays}d';
  if (diff.inHours > 0) return '${diff.inHours}h';
  if (diff.inMinutes > 0) return '${diff.inMinutes}m';
  return 'now';
}
