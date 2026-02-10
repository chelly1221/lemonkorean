import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Bottom-pinned comment input bar
/// Shows a text field with send button and optional reply indicator
class CommentInput extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final String? replyToName;
  final VoidCallback? onCancelReply;
  final FocusNode? focusNode;

  const CommentInput({
    super.key,
    required this.onSubmit,
    this.replyToName,
    this.onCancelReply,
    this.focusNode,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSubmit(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isReplying = widget.replyToName != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply indicator
            if (isReplying)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    const Icon(
                      Icons.reply,
                      size: 16,
                      color: AppConstants.textSecondary,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(
                        '${l10n?.replyingTo ?? 'Replying to'} @${widget.replyToName}',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCancelReply,
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            // Input row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: widget.focusNode,
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSubmit(),
                      decoration: InputDecoration(
                        hintText: l10n?.writeComment ?? 'Write a comment...',
                        hintStyle: const TextStyle(
                          color: AppConstants.textHint,
                          fontSize: AppConstants.fontSizeMedium,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusXLarge,
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusXLarge,
                          ),
                          borderSide: const BorderSide(
                            color: AppConstants.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusXLarge,
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingSmall,
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppConstants.paddingSmall),

                  // Send button
                  Material(
                    color: _controller.text.trim().isNotEmpty
                        ? AppConstants.primaryColor
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _controller.text.trim().isNotEmpty
                          ? _handleSubmit
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.send,
                          size: 20,
                          color: _controller.text.trim().isNotEmpty
                              ? Colors.black87
                              : AppConstants.textHint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
