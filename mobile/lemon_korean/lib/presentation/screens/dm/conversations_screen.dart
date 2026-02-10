import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/dm_provider.dart';
import 'chat_screen.dart';
import 'widgets/conversation_tile.dart';

/// DM Conversations list screen
class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DmProvider>(context, listen: false)
          .loadConversations(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.messages ?? 'Messages',
          style: const TextStyle(
            fontSize: AppConstants.fontSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<DmProvider>(
        builder: (context, dmProvider, child) {
          if (dmProvider.isLoadingConversations &&
              dmProvider.conversations.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
              ),
            );
          }

          if (dmProvider.conversations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingXLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      l10n?.noMessages ?? 'No messages yet',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeNormal,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      l10n?.startConversation ??
                          'Start a conversation from a user profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms);
          }

          return RefreshIndicator(
            color: AppConstants.primaryColor,
            onRefresh: () => dmProvider.loadConversations(refresh: true),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingSmall),
              itemCount: dmProvider.conversations.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 76,
              ),
              itemBuilder: (context, index) {
                final conversation = dmProvider.conversations[index];
                return ConversationTile(
                  conversation: conversation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          conversationId: conversation.id,
                          otherUserName: conversation.otherUserName,
                          otherUserAvatar: conversation.otherUserAvatar,
                          otherUserId: conversation.otherUserId,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
