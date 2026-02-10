import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/dm_provider.dart';

/// Chat input bar with text field, image picker, and voice recorder buttons
class ChatInputBar extends StatefulWidget {
  final int conversationId;
  final Future<void> Function(String text) onSendText;
  final VoidCallback onPickImage;

  const ChatInputBar({
    super.key,
    required this.conversationId,
    required this.onSendText,
    required this.onPickImage,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  bool _isSending = false;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _typingTimer?.cancel();
    if (_isTyping) {
      Provider.of<DmProvider>(context, listen: false)
          .sendTypingStop(widget.conversationId);
    }
    super.dispose();
  }

  void _onTextChanged(String text) {
    final dmProvider = Provider.of<DmProvider>(context, listen: false);

    if (text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      dmProvider.sendTypingStart(widget.conversationId);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping) {
        _isTyping = false;
        dmProvider.sendTypingStop(widget.conversationId);
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _textController.clear();

    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      Provider.of<DmProvider>(context, listen: false)
          .sendTypingStop(widget.conversationId);
    }

    await widget.onSendText(text);

    if (mounted) {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Image picker button
              IconButton(
                onPressed: widget.onPickImage,
                icon: Icon(
                  Icons.image_outlined,
                  color: Colors.grey.shade600,
                ),
                visualDensity: VisualDensity.compact,
              ),

              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _textController,
                    onChanged: _onTextChanged,
                    onSubmitted: (_) => _handleSend(),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l10n?.typeMessage ?? 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Send button
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _textController,
                builder: (context, value, child) {
                  final hasText = value.text.trim().isNotEmpty;
                  return IconButton(
                    onPressed: hasText ? _handleSend : null,
                    icon: Icon(
                      Icons.send_rounded,
                      color: hasText
                          ? AppConstants.primaryColor
                          : Colors.grey.shade400,
                    ),
                    visualDensity: VisualDensity.compact,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
