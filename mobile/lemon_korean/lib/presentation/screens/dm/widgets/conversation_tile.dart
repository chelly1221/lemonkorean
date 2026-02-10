import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/conversation_model.dart';

/// Conversation list item tile
class ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: 12,
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: conversation.otherUserAvatar != null
                  ? NetworkImage(conversation.otherUserAvatar!)
                  : null,
              child: conversation.otherUserAvatar == null
                  ? Icon(Icons.person, size: 28, color: Colors.grey.shade400)
                  : null,
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.otherUserName,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: conversation.hasUnread
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: AppConstants.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.lastMessageAt != null)
                        Text(
                          _formatTime(conversation.lastMessageAt!),
                          style: TextStyle(
                            fontSize: 12,
                            color: conversation.hasUnread
                                ? AppConstants.primaryColor
                                : Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Preview + unread badge
                  Row(
                    children: [
                      // Message type icon
                      if (conversation.lastMessageType == 'image')
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.image_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      if (conversation.lastMessageType == 'voice')
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.mic_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),

                      Expanded(
                        child: Text(
                          conversation.lastMessagePreview ?? '',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: conversation.hasUnread
                                ? AppConstants.textPrimary
                                : Colors.grey.shade500,
                            fontWeight: conversation.hasUnread
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Unread badge
                      if (conversation.hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            conversation.unreadCount > 99
                                ? '99+'
                                : '${conversation.unreadCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[time.weekday - 1];
    } else {
      return '${time.month}/${time.day}';
    }
  }
}
