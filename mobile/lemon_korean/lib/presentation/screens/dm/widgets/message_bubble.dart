import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/dm_message_model.dart';

/// Chat message bubble widget
class MessageBubble extends StatelessWidget {
  final DmMessageModel message;
  final bool isMe;
  final VoidCallback? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
      return _buildDeletedBubble(context);
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onDelete != null
            ? () => _showDeleteDialog(context)
            : null,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: message.isImage
              ? const EdgeInsets.all(3)
              : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe
                ? AppConstants.primaryColor.withValues(alpha: 0.85)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildContent(context),
              const SizedBox(height: 2),
              _buildTimeAndStatus(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (message.isImage) {
      return _buildImageContent(context);
    }
    if (message.isVoice) {
      return _buildVoiceContent(context);
    }
    return _buildTextContent(context);
  }

  Widget _buildTextContent(BuildContext context) {
    return Text(
      message.content ?? '',
      style: TextStyle(
        fontSize: AppConstants.fontSizeNormal,
        color: isMe ? Colors.black87 : AppConstants.textPrimary,
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    final url = message.mediaUrl;
    if (url == null) return const SizedBox.shrink();

    final fullUrl = url.startsWith('http')
        ? url
        : '${AppConstants.baseUrl}$url';

    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: CachedNetworkImage(
        imageUrl: fullUrl,
        width: 200,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          width: 200,
          height: 150,
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          width: 200,
          height: 100,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildVoiceContent(BuildContext context) {
    final durationMs = message.mediaMetadata['duration_ms'] as int? ?? 0;
    final seconds = (durationMs / 1000).ceil();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_arrow,
          color: isMe ? Colors.black87 : AppConstants.primaryColor,
          size: 28,
        ),
        const SizedBox(width: 8),
        // Waveform placeholder
        Container(
          width: 100,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: (isMe ? Colors.black : AppConstants.primaryColor)
                .withValues(alpha: 0.15),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${seconds}s',
          style: TextStyle(
            fontSize: 12,
            color: isMe ? Colors.black54 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeAndStatus(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.createdAt),
          style: TextStyle(
            fontSize: 10,
            color: isMe ? Colors.black45 : Colors.grey.shade500,
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 4),
          _buildStatusIcon(),
        ],
      ],
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case DmMessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black38),
          ),
        );
      case DmMessageStatus.sent:
        return const Icon(Icons.done, size: 14, color: Colors.black45);
      case DmMessageStatus.failed:
        return const Icon(Icons.error_outline, size: 14, color: Colors.red);
    }
  }

  Widget _buildDeletedBubble(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Text(
          'Message deleted',
          style: TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('This message will be deleted for everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
