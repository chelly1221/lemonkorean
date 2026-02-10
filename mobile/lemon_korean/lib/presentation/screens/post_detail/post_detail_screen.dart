import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/sns_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../community/widgets/post_image_grid.dart';
import '../user_profile/user_profile_screen.dart';
import 'widgets/comment_input.dart';
import 'widgets/comment_item.dart';

/// Post detail screen showing full post content, images, and comments
class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final SnsRepository _snsRepository = SnsRepository();

  int? _replyToCommentId;
  String? _replyToName;
  bool _isLoadingComments = true;
  List<CommentModel> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoadingComments = true;
    });

    final comments = await _snsRepository.getComments(widget.post.id);

    if (mounted) {
      setState(() {
        _comments = comments;
        _isLoadingComments = false;
      });
    }
  }

  void _startReply(CommentModel comment) {
    setState(() {
      _replyToCommentId = comment.id;
      _replyToName = comment.author.name;
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyToCommentId = null;
      _replyToName = null;
    });
  }

  Future<void> _submitComment(String content) async {
    final comment = await _snsRepository.createComment(
      widget.post.id,
      content: content,
      parentId: _replyToCommentId,
    );

    if (comment != null && mounted) {
      setState(() {
        _comments.add(comment);
        _replyToCommentId = null;
        _replyToName = null;
      });

      // Update comment count in feed provider
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.updateCommentCount(widget.post.id, 1);

      // Scroll to bottom to show new comment
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: AppConstants.animationNormal,
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final success = await _snsRepository.deleteComment(commentId);

    if (success && mounted) {
      setState(() {
        _comments.removeWhere((c) => c.id == commentId);
      });

      // Update comment count in feed provider
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.updateCommentCount(widget.post.id, -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser?.id ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.postDetail ?? 'Post'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Post content + comments (scrollable)
          Expanded(
            child: RefreshIndicator(
              color: AppConstants.primaryColor,
              onRefresh: _loadComments,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post content
                    _buildPostContent(l10n),

                    // Divider
                    const Divider(height: 1),

                    // Action row
                    _buildActionRow(context, l10n),

                    // Divider
                    const Divider(height: 1),

                    // Comments section header
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Text(
                        l10n?.comments ?? 'Comments',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                    ),

                    // Comments list
                    _buildCommentsList(currentUserId, l10n),

                    // Bottom padding for scroll
                    const SizedBox(height: AppConstants.paddingLarge),
                  ],
                ),
              ),
            ),
          ),

          // Comment input bar (bottom-pinned)
          CommentInput(
            focusNode: _commentFocusNode,
            onSubmit: _submitComment,
            replyToName: _replyToName,
            onCancelReply: _cancelReply,
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          _buildAuthorRow(),

          const SizedBox(height: AppConstants.paddingMedium),

          // Full content (no truncation)
          Text(
            widget.post.content,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeNormal,
              color: AppConstants.textPrimary,
              height: 1.5,
            ),
          ),

          // Category tag
          if (widget.post.isLearningPost) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppConstants.infoColor.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
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
          ],

          // Tags
          if (widget.post.hasTags) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.post.tags.map((tag) {
                return Text(
                  '#$tag',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.infoColor,
                  ),
                );
              }).toList(),
            ),
          ],

          // Images
          if (widget.post.hasImages) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            PostImageGrid(imageUrls: widget.post.imageUrls),
          ],

          // Timestamp
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            _formatDateTime(widget.post.createdAt),
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildAuthorRow() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserProfileScreen(userId: widget.post.author.id),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
                AppConstants.primaryColor.withValues(alpha: 0.3),
            backgroundImage: widget.post.author.profileImageUrl != null
                ? NetworkImage(
                    '${AppConstants.mediaUrl}/images/${widget.post.author.profileImageUrl}',
                  )
                : null,
            child: widget.post.author.profileImageUrl == null
                ? Text(
                    widget.post.author.name.isNotEmpty
                        ? widget.post.author.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.author.name,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _timeAgo(widget.post.createdAt),
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

  Widget _buildActionRow(BuildContext context, AppLocalizations? l10n) {
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        // Find updated post in feed lists
        final feedIndex = feedProvider.feedPosts.indexWhere(
            (p) => p.id == widget.post.id);
        final discoverIndex = feedProvider.discoverPosts.indexWhere(
            (p) => p.id == widget.post.id);

        PostModel post = widget.post;
        if (feedIndex != -1) {
          post = feedProvider.feedPosts[feedIndex];
        } else if (discoverIndex != -1) {
          post = feedProvider.discoverPosts[discoverIndex];
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          child: Row(
            children: [
              // Like button
              InkWell(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
                onTap: () => feedProvider.toggleLike(post.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        post.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 22,
                        color: post.isLiked
                            ? Colors.red
                            : AppConstants.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        post.likeCount > 0
                            ? '${post.likeCount}'
                            : (l10n?.like ?? 'Like'),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: post.isLiked
                              ? Colors.red
                              : AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppConstants.paddingLarge),

              // Comment button
              InkWell(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
                onTap: () => _commentFocusNode.requestFocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 22,
                        color: AppConstants.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _comments.isNotEmpty
                            ? '${_comments.length}'
                            : (l10n?.comment ?? 'Comment'),
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppConstants.paddingLarge),

              // Share button
              InkWell(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSmall),
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
                    vertical: 6,
                  ),
                  child: Icon(
                    Icons.share_outlined,
                    size: 22,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsList(int currentUserId, AppLocalizations? l10n) {
    if (_isLoadingComments) {
      return const Padding(
        padding: EdgeInsets.all(AppConstants.paddingLarge),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
            ),
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (_comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                l10n?.noComments ?? 'No comments yet. Be the first!',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Group comments: top-level first, then replies grouped under parents
    final topLevel =
        _comments.where((c) => !c.isReply).toList();
    final replies = _comments.where((c) => c.isReply).toList();

    final orderedComments = <CommentModel>[];
    for (final comment in topLevel) {
      orderedComments.add(comment);
      // Add replies to this comment
      final commentReplies =
          replies.where((r) => r.parentId == comment.id).toList();
      orderedComments.addAll(commentReplies);
    }

    // Add any orphaned replies at the end
    final accountedReplyIds =
        orderedComments.where((c) => c.isReply).map((c) => c.id).toSet();
    final orphanedReplies =
        replies.where((r) => !accountedReplyIds.contains(r.id));
    orderedComments.addAll(orphanedReplies);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderedComments.length,
      itemBuilder: (context, index) {
        final comment = orderedComments[index];
        return CommentItem(
          comment: comment,
          currentUserId: currentUserId,
          onReply: comment.isReply ? null : () => _startReply(comment),
        ).animate().fadeIn(
              duration: 200.ms,
              delay: Duration(milliseconds: (index * 30).clamp(0, 200)),
            );
      },
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

/// Format a DateTime as a localized date string
String _formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final isToday = dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day;

  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final time = '$hour:$minute';

  if (isToday) {
    return time;
  }

  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '${dateTime.year}-$month-$day $time';
}
