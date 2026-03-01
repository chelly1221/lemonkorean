import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/voice_room_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/voice_room_provider.dart';

/// Chat widget for voice room (ephemeral messages)
class VoiceChatWidget extends StatefulWidget {
  const VoiceChatWidget({super.key});

  @override
  State<VoiceChatWidget> createState() => _VoiceChatWidgetState();
}

class _VoiceChatWidgetState extends State<VoiceChatWidget> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  VoiceRoomProvider? _provider;
  bool _hasNewMessages = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _provider = context.read<VoiceRoomProvider>();
    _provider!.onNewMessageReceived = _onNewMessage;
    _scrollController.addListener(_onScrollChanged);
  }

  @override
  void dispose() {
    _provider?.onNewMessageReceived = null;
    _provider = null;
    _scrollController.removeListener(_onScrollChanged);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return true;
    final position = _scrollController.position;
    return position.maxScrollExtent - position.pixels < 100;
  }

  void _onScrollChanged() {
    if (_isNearBottom && _hasNewMessages) {
      setState(() => _hasNewMessages = false);
    }
  }

  void _onNewMessage() {
    if (!mounted) return;
    if (_isNearBottom) {
      _scrollToBottom();
    } else {
      setState(() => _hasNewMessages = true);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    _isSending = true;
    setState(() {});
    _controller.clear();
    _focusNode.requestFocus();

    try {
      await context.read<VoiceRoomProvider>().sendMessage(text);
    } finally {
      if (mounted) {
        _isSending = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Message list
            Expanded(
              child: Stack(
                children: [
                  provider.messages.isEmpty
                      ? Center(
                          child: Text(
                            l10n?.voiceRoomNoMessagesYet ?? 'No messages yet',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            return _MessageBubble(
                                message: provider.messages[index]);
                          },
                        ),
                  // New messages indicator
                  if (_hasNewMessages)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            _scrollToBottom();
                            setState(() => _hasNewMessages = false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_downward,
                                    size: 14, color: Colors.black87),
                                const SizedBox(width: 4),
                                Text(
                                  l10n?.voiceRoomNewMessages ?? 'New messages',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Chat error display
            if (provider.chatError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Text(
                  _localizedChatError(provider.chatError!, l10n),
                  style: TextStyle(
                      color: Colors.red.shade300, fontSize: 11),
                ),
              ),

            // Input field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      textField: true,
                      label: l10n?.voiceRoomChatInput ?? 'Chat message input',
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: l10n?.voiceRoomTypeMessage ?? 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.08),
                        ),
                        maxLines: 1,
                        maxLength: 500,
                        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Semantics(
                    button: true,
                    label: l10n?.voiceRoomSendMessage ?? 'Send message',
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _isSending ? null : _handleSend,
                        customBorder: const CircleBorder(),
                        splashColor: Colors.amber.withValues(alpha: 0.3),
                        highlightColor: Colors.amber.withValues(alpha: 0.15),
                        child: ExcludeSemantics(
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.send, size: 18, color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _localizedChatError(String errorKey, AppLocalizations? l10n) {
    switch (errorKey) {
      case 'chatRateLimited':
        return l10n?.voiceRoomChatRateLimited ??
            'You are sending messages too fast. Please wait a moment.';
      case 'messageSendFailed':
        return l10n?.voiceRoomMessageSendFailed ??
            'Failed to send message. Please try again.';
      default:
        return l10n?.voiceRoomChatError ?? 'Chat error occurred.';
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final VoiceChatMessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'system') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Text(
            message.content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${message.userName}: ',
            style: TextStyle(
              color: Colors.amber.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
