import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/comment_model.dart';
import '../../../../data/repositories/sns_repository.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../user_profile/user_profile_screen.dart';

/// Single comment widget displaying author info, content, and actions
class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final int currentUserId;
  final VoidCallback? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.currentUserId,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isOwnComment = comment.author.id == currentUserId;

    return Padding(
      padding: EdgeInsets.only(
        left: comment.isReply
            ? AppConstants.paddingLarge + AppConstants.paddingMedium
            : AppConstants.paddingMedium,
        right: AppConstants.paddingMedium,
        top: AppConstants.paddingSmall,
        bottom: AppConstants.paddingSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserProfileScreen(userId: comment.author.id),
                ),
              );
            },
            child: CircleAvatar(
              radius: comment.isReply ? 14 : 16,
              backgroundColor:
                  AppConstants.primaryColor.withValues(alpha: 0.3),
              backgroundImage: comment.author.profileImageUrl != null
                  ? NetworkImage(
                      '${AppConstants.mediaUrl}/images/${comment.author.profileImageUrl}',
                    )
                  : null,
              child: comment.author.profileImageUrl == null
                  ? Text(
                      comment.author.name.isNotEmpty
                          ? comment.author.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: comment.isReply
                            ? AppConstants.fontSizeSmall
                            : AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(width: AppConstants.paddingSmall),

          // Comment body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author name + time + menu
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserProfileScreen(userId: comment.author.id),
                          ),
                        );
                      },
                      child: Text(
                        comment.author.name,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Text(
                      _timeAgo(comment.createdAt),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (isOwnComment)
                      _buildPopupMenu(context, l10n),
                  ],
                ),

                const SizedBox(height: 2),

                // Comment content
                Text(
                  comment.content,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textPrimary,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 4),

                // Reply button
                if (!comment.isReply && onReply != null)
                  GestureDetector(
                    onTap: onReply,
                    child: Text(
                      l10n?.reply ?? 'Reply',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, AppLocalizations? l10n) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_horiz,
        size: 18,
        color: AppConstants.textSecondary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                l10n?.delete ?? 'Delete',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'delete') {
          _confirmDelete(context, l10n);
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, AppLocalizations? l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n?.deleteComment ?? 'Delete Comment'),
        content: Text(l10n?.deleteCommentConfirm ??
            'Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              SnsRepository().deleteComment(comment.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n?.delete ?? 'Delete'),
          ),
        ],
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
