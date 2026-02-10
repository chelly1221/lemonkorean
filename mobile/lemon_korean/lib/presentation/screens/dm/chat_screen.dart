import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dm_provider.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';

/// 1:1 Chat screen
class ChatScreen extends StatefulWidget {
  final int conversationId;
  final String otherUserName;
  final String? otherUserAvatar;
  final int otherUserId;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DmProvider>(context, listen: false)
          .loadMessages(widget.conversationId, refresh: true);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    Provider.of<DmProvider>(context, listen: false)
        .leaveConversation(widget.conversationId);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when scrolled to top (oldest messages)
    if (_scrollController.position.pixels <=
            _scrollController.position.minScrollExtent + 100 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    final hasMore = await Provider.of<DmProvider>(context, listen: false)
        .loadMoreMessages(widget.conversationId);

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        _hasMore = hasMore;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _handleSendText(String text) async {
    final dmProvider = Provider.of<DmProvider>(context, listen: false);
    await dmProvider.sendTextMessage(widget.conversationId, text);
    _scrollToBottom();
  }

  Future<void> _handlePickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      final fileName = picked.name;
      final mimeType = _getMimeType(fileName);

      if (!mounted) return;

      final dmProvider = Provider.of<DmProvider>(context, listen: false);
      await dmProvider.sendMediaMessage(
        widget.conversationId,
        messageType: 'image',
        fileBytes: bytes,
        fileName: fileName,
        mimeType: mimeType,
      );
      _scrollToBottom();
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: widget.otherUserAvatar != null
                  ? NetworkImage(widget.otherUserAvatar!)
                  : null,
              child: widget.otherUserAvatar == null
                  ? Icon(Icons.person, size: 20, color: Colors.grey.shade400)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUserName,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Consumer<DmProvider>(
                    builder: (context, dm, _) {
                      if (dm.isUserTyping(widget.otherUserId)) {
                        return Text(
                          l10n?.typing ?? 'typing...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.primaryColor,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: Consumer<DmProvider>(
              builder: (context, dmProvider, child) {
                if (dmProvider.isLoadingMessages &&
                    dmProvider.getMessages(widget.conversationId).isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.primaryColor),
                    ),
                  );
                }

                final messages =
                    dmProvider.getMessages(widget.conversationId);

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      l10n?.noMessagesYet ?? 'No messages yet. Say hello!',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeNormal,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: AppConstants.paddingSmall,
                  ),
                  itemCount: messages.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isLoadingMore && index == 0) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppConstants.primaryColor),
                            ),
                          ),
                        ),
                      );
                    }

                    final msgIndex = _isLoadingMore ? index - 1 : index;
                    final message = messages[msgIndex];
                    final isMe = message.senderId == currentUserId ||
                        message.senderId == 0; // 0 = optimistic

                    // Show date separator
                    final showDate = msgIndex == 0 ||
                        !_isSameDay(
                          messages[msgIndex - 1].createdAt,
                          message.createdAt,
                        );

                    return Column(
                      children: [
                        if (showDate)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              _formatDate(context, message.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        MessageBubble(
                          message: message,
                          isMe: isMe,
                          onDelete: isMe && message.id != null
                              ? () => dmProvider.deleteMessage(
                                    widget.conversationId,
                                    message.id!,
                                  )
                              : null,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // Input bar
          ChatInputBar(
            conversationId: widget.conversationId,
            onSendText: _handleSendText,
            onPickImage: _handlePickImage,
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      final l10n = AppLocalizations.of(context);
      return l10n?.today ?? 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (_isSameDay(date, yesterday)) {
      final l10n = AppLocalizations.of(context);
      return l10n?.yesterday ?? 'Yesterday';
    }
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
