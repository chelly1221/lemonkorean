import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/character_item_model.dart';
import '../../../game/core/game_bridge.dart';
import '../../../game/voice_stage/voice_stage_game.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voice_room_provider.dart';
import 'widgets/audience_bar_widget.dart';
import 'widgets/gesture_tray_widget.dart';
import 'widgets/reaction_tray_widget.dart';
import 'widgets/stage_controls_widget.dart';
import 'widgets/voice_chat_widget.dart';

/// Active voice room screen with stage/audience layout
class VoiceRoomScreen extends StatefulWidget {
  const VoiceRoomScreen({super.key});

  @override
  State<VoiceRoomScreen> createState() => _VoiceRoomScreenState();
}

class _VoiceRoomScreenState extends State<VoiceRoomScreen> {
  bool _showReactionTray = false;
  bool _showGestureTray = false;
  VoiceStageGame? _game;
  bool _gameInitialized = false;

  @override
  void initState() {
    super.initState();
    // Set user ID on provider and initialize Flame game
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
          Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
      if (userId != null) {
        final provider = context.read<VoiceRoomProvider>();
        provider.setMyUserId(userId);
        _initializeGame(provider, userId);
      }
    });
  }

  void _initializeGame(VoiceRoomProvider provider, int userId) {
    if (_gameInitialized) return;
    _gameInitialized = true;

    // Attach bridge
    provider.attachGameBridge();

    // Build my equipped items from my stage character data
    final myChar = provider.stageCharacters[userId];
    final myEquippedItems = _convertEquippedItems(myChar?.equippedItems);
    final mySkinColor = myChar?.skinColor ?? '#FFDBB4';
    final myName = myChar?.name ?? '';

    _game = VoiceStageGame(
      bridge: provider.gameBridge,
      isSpeaker: provider.isSpeaker,
      myEquippedItems: myEquippedItems,
      mySkinColor: mySkinColor,
      myName: myName,
      myUserId: userId,
    );

    // Send existing remote speakers to Flame
    for (final entry in provider.stageCharacters.entries) {
      if (entry.key == userId) continue;
      final char = entry.value;
      provider.gameBridge.sendToGame(RemoteCharacterAdded(
        userId: char.userId,
        name: char.name,
        equippedItems: char.equippedItems,
        skinColor: char.skinColor,
        isMuted: char.isMuted,
      ));
    }

    setState(() {});
  }

  List<CharacterItemModel> _convertEquippedItems(
      Map<String, dynamic>? items) {
    if (items == null || items.isEmpty) return [];
    final result = <CharacterItemModel>[];
    items.forEach((category, itemData) {
      if (itemData is Map<String, dynamic>) {
        result.add(CharacterItemModel.fromJson(itemData));
      }
    });
    return result;
  }

  @override
  void dispose() {
    // Bridge cleanup is handled by provider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        final room = provider.activeRoom;
        if (room == null) {
          // Room was closed by host
          final error = provider.error;
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A2E),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A1A2E),
              title: const Text('Voice Room',
                  style: TextStyle(color: Colors.white)),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.meeting_room_outlined,
                      color: Colors.white54, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    error ?? 'Room not available',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              await _handleLeave(context, provider);
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFF1A1A2E),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A1A2E),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => _handleLeave(context, provider),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (room.topic != null)
                    Text(
                      room.topic!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              actions: [
                // Stage request badge (creator only)
                if (provider.isCreator)
                  IconButton(
                    icon: Badge(
                      isLabelVisible: provider.stageRequests.isNotEmpty,
                      label: Text(
                        '${provider.stageRequests.length}',
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: Colors.red,
                      child: Icon(
                        provider.stageRequests.isNotEmpty
                            ? Icons.back_hand
                            : Icons.back_hand_outlined,
                        color: provider.stageRequests.isNotEmpty
                            ? Colors.amber
                            : Colors.white54,
                        size: 20,
                      ),
                    ),
                    onPressed: () =>
                        _showStageManagement(context, provider),
                  ),
                // Speaker count + Listener count
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.mic, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${provider.speakers.length}/${room.maxSpeakers}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.visibility,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${provider.listeners.length}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Connection status banner
                _buildConnectionBanner(provider),

                // Level badge
                if (room.languageLevel != 'all')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _buildLevelBadge(room.languageLevel),
                  ),

                // STAGE AREA (~40%) - Flame GameWidget
                Expanded(
                  flex: 4,
                  child: _game != null
                      ? GameWidget(game: _game!)
                      : Container(
                          color: const Color(0xFF1A1A2E),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white24,
                            ),
                          ),
                        ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),

                // AUDIENCE BAR
                AudienceBarWidget(listeners: provider.listeners),

                // Divider
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),

                // CHAT (~30%)
                const Expanded(
                  flex: 3,
                  child: VoiceChatWidget(),
                ),

                // Reaction or Gesture tray (expandable)
                if (_showReactionTray)
                  ReactionTrayWidget(
                    onClose: () => setState(() => _showReactionTray = false),
                  ),
                if (_showGestureTray)
                  GestureTrayWidget(
                    onClose: () => setState(() => _showGestureTray = false),
                  ),

                // Controls
                StageControlsWidget(
                  onLeaveRoom: () => _handleLeave(context, provider),
                  onCloseRoom: () => _handleClose(context, provider),
                  onShowReactions: () {
                    setState(() {
                      _showReactionTray = !_showReactionTray;
                      _showGestureTray = false;
                    });
                  },
                  onShowGestures: () {
                    setState(() {
                      _showGestureTray = !_showGestureTray;
                      _showReactionTray = false;
                    });
                  },
                  onManageStage: () => _showStageManagement(context, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionBanner(VoiceRoomProvider provider) {
    if (provider.isConnecting || provider.isReconnecting) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: Colors.orange.shade800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              provider.isReconnecting
                  ? 'Reconnecting (${provider.reconnectAttempts}/3)...'
                  : 'Connecting...',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (!provider.isConnected && provider.activeRoom != null) {
      return GestureDetector(
        onTap: () => provider.reconnect(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.red.shade800,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  provider.error ?? 'Disconnected',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLevelBadge(String level) {
    Color color;
    String label;
    switch (level) {
      case 'beginner':
        color = Colors.green;
        label = 'Beginner';
        break;
      case 'intermediate':
        color = Colors.orange;
        label = 'Intermediate';
        break;
      case 'advanced':
        color = Colors.red;
        label = 'Advanced';
        break;
      default:
        color = Colors.grey;
        label = 'All Levels';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showStageManagement(
      BuildContext context, VoiceRoomProvider provider) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Consumer<VoiceRoomProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.stageRequests ?? 'Stage Requests',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (provider.stageRequests.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          l10n?.noPendingRequests ?? 'No pending requests',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    )
                  else
                    ...provider.stageRequests.map((req) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: req.avatar != null
                              ? NetworkImage(req.avatar!)
                              : null,
                          child: req.avatar == null
                              ? Text(req.name.isNotEmpty
                                  ? req.name[0].toUpperCase()
                                  : '?')
                              : null,
                        ),
                        title: Text(
                          req.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                              onPressed: () {
                                provider.grantStage(req.userId);
                                Navigator.pop(ctx);
                              },
                            ),
                          ],
                        ),
                      );
                    }),

                  // Current speakers on stage
                  const SizedBox(height: 16),
                  Text(
                    l10n?.onStage ?? 'On Stage',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...provider.speakers.map((speaker) {
                    final isCreator =
                        speaker.userId == provider.activeRoom?.creatorId;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: speaker.avatar != null
                            ? NetworkImage(speaker.avatar!)
                            : null,
                        child: speaker.avatar == null
                            ? Text(speaker.name.isNotEmpty
                                ? speaker.name[0].toUpperCase()
                                : '?')
                            : null,
                      ),
                      title: Text(
                        '${speaker.name}${isCreator ? ' (Host)' : ''}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: isCreator
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.arrow_downward,
                                  color: Colors.orange),
                              onPressed: () {
                                provider.removeFromStage(speaker.userId);
                                Navigator.pop(ctx);
                              },
                            ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleLeave(
      BuildContext context, VoiceRoomProvider provider) async {
    await provider.leaveRoom();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _handleClose(
      BuildContext context, VoiceRoomProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close Room?'),
        content: const Text('This will end the call for everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Close'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await provider.closeRoom();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
