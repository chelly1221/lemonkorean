import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/error_localizer.dart';
import '../../../data/models/character_item_model.dart';
import '../../../data/models/voice_room_model.dart';
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

  // Connection banner: track "just connected" green flash
  bool _showConnectedBanner = false;
  bool _wasDisconnected = false;
  Timer? _connectedBannerTimer;

  // Stage loading timeout
  Timer? _stageLoadingTimer;
  bool _stageLoadingTimedOut = false;

  // Room closed auto-navigation
  Timer? _roomClosedTimer;
  bool _roomClosedAutoNavScheduled = false;

  // Leave/close guard
  bool _isLeaving = false;

  // Tray toggle debounce
  DateTime? _lastTrayToggle;

  // Back button double-tap for listeners
  DateTime? _lastBackPressTime;

  // Periodic reaction cleanup
  Timer? _reactionCleanupTimer;

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

    // Start stage loading timeout
    _stageLoadingTimer = Timer(const Duration(seconds: 10), () {
      if (_game == null && mounted) {
        setState(() => _stageLoadingTimedOut = true);
      }
    });

    // Periodic reaction cleanup to prevent unbounded growth in long sessions
    _reactionCleanupTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (mounted) {
          context.read<VoiceRoomProvider>().cleanupReactions();
        }
      },
    );
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

    final room = provider.activeRoom;
    final creatorId = room?.creatorId;

    // Build initial remote speakers list to pass to game (avoids broadcast
    // stream race condition where events sent before onLoad() are lost).
    final initialRemoteSpeakers = <RemoteCharacterAdded>[];
    for (final entry in provider.stageCharacters.entries) {
      if (entry.key == userId) continue;
      final char = entry.value;
      initialRemoteSpeakers.add(RemoteCharacterAdded(
        userId: char.userId,
        name: char.name,
        equippedItems: char.equippedItems,
        skinColor: char.skinColor,
        isMuted: char.isMuted,
        isHost: char.userId == creatorId,
      ));
    }

    _game = VoiceStageGame(
      bridge: provider.gameBridge,
      isSpeaker: provider.isSpeaker,
      myEquippedItems: myEquippedItems,
      mySkinColor: mySkinColor,
      myName: myName,
      myUserId: userId,
      isHost: provider.isCreator,
      maxSpeakers: room?.maxSpeakers ?? 4,
      initialRemoteSpeakers: initialRemoteSpeakers,
    );

    // Cancel the loading timeout since game initialized successfully
    _stageLoadingTimer?.cancel();
    _stageLoadingTimer = null;
    _stageLoadingTimedOut = false;

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
    _connectedBannerTimer?.cancel();
    _stageLoadingTimer?.cancel();
    _roomClosedTimer?.cancel();
    _reactionCleanupTimer?.cancel();
    _game?.onRemove();
    _game = null;
    // Bridge cleanup is handled by provider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        final room = provider.activeRoom;
        if (room == null) {
          // Room was closed/kicked - auto-navigate
          if (!_roomClosedAutoNavScheduled) {
            _roomClosedAutoNavScheduled = true;
            final navigator = Navigator.of(context);
            // If kicked, navigate immediately; otherwise 3 seconds
            final isKicked = provider.error == 'removedFromRoomByHost';
            final delay = isKicked ? Duration.zero : const Duration(seconds: 3);
            _roomClosedTimer = Timer(delay, () {
              if (mounted) {
                provider.clearError();
                navigator.pop();
              }
            });
          }
          final error = provider.error;
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A2E),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A1A2E),
              title: Text(l10n?.voiceRooms ?? 'Voice Room',
                  style: const TextStyle(color: Colors.white)),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.meeting_room_outlined,
                      color: Colors.white70, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    error != null
                        ? ErrorLocalizer.localize(error, l10n)
                        : (l10n?.voiceRoomNotAvailable ?? 'Room not available'),
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.voiceRoomReturningToList ?? 'Returning to room list...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _roomClosedTimer?.cancel();
                        provider.clearError();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n?.voiceRoomGoBack ?? 'Go Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black87,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
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
              await _handleBackPress(context, provider);
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
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          room.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (room.languageLevel != 'all') ...[
                        const SizedBox(width: 8),
                        _buildLevelChip(room.languageLevel),
                      ],
                    ],
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
                  Builder(builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Semantics(
                    button: true,
                    label: l10n?.voiceRoomStageRequestsPending(provider.stageRequests.length) ?? 'Stage requests, ${provider.stageRequests.length} pending',
                    child: IconButton(
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
                              : Colors.white70,
                          size: 20,
                        ),
                      ),
                      onPressed: () =>
                          _showStageManagement(context, provider),
                    ),
                  );
                  }),
                // Speaker count + Listener count
                Builder(builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Semantics(
                  label: l10n?.voiceRoomSpeakerListenerCount(provider.speakers.length, room.maxSpeakers, provider.listeners.length) ?? '${provider.speakers.length} of ${room.maxSpeakers} speakers, ${provider.listeners.length} listeners',
                  child: ExcludeSemantics(
                    child: Padding(
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
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${provider.listeners.length}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                }),
              ],
            ),
            body: Column(
              children: [
                // Connection status banner (animated)
                _buildConnectionBanner(provider),

                // STAGE AREA (~30%) - Flame GameWidget
                Expanded(
                  flex: 3,
                  child: _game != null
                      ? Builder(builder: (context) {
                          final l10n = AppLocalizations.of(context);
                          return Semantics(
                            label: l10n?.voiceRoomStageWithSpeakers ?? 'Voice room stage with speakers',
                            child: GameWidget(game: _game!),
                          );
                        })
                      : _buildStageLoadingIndicator(provider),
                ),

                // Divider
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),

                // AUDIENCE BAR (hidden when empty)
                AudienceBarWidget(
                  listeners: provider.listeners,
                  onListenerTap: provider.isCreator
                      ? (listener) =>
                          _showInviteToStageDialog(context, provider, listener)
                      : null,
                ),

                // Divider (only shown when audience bar is visible)
                if (provider.listeners.isNotEmpty)
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),

                // CHAT (~40%)
                const Expanded(
                  flex: 4,
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
                    final now = DateTime.now();
                    if (_lastTrayToggle != null &&
                        now.difference(_lastTrayToggle!) < const Duration(milliseconds: 200)) {
                      return;
                    }
                    _lastTrayToggle = now;
                    setState(() {
                      _showReactionTray = !_showReactionTray;
                      _showGestureTray = false;
                    });
                  },
                  onShowGestures: () {
                    final now = DateTime.now();
                    if (_lastTrayToggle != null &&
                        now.difference(_lastTrayToggle!) < const Duration(milliseconds: 200)) {
                      return;
                    }
                    _lastTrayToggle = now;
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
    // Track disconnected state for "Connected!" green flash
    if (provider.isConnecting || provider.isReconnecting ||
        (!provider.isConnected && provider.activeRoom != null)) {
      _wasDisconnected = true;
    } else if (_wasDisconnected && provider.isConnected) {
      // Just reconnected - show green "Connected!" banner briefly
      _wasDisconnected = false;
      if (!_showConnectedBanner) {
        _showConnectedBanner = true;
        _connectedBannerTimer?.cancel();
        _connectedBannerTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _showConnectedBanner = false);
          }
        });
      }
    }

    Widget bannerChild;

    if (provider.isConnecting || provider.isReconnecting) {
      bannerChild = Container(
        key: const ValueKey('connecting'),
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
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Text(
                  provider.isReconnecting
                      ? l10n?.voiceRoomReconnecting(provider.reconnectAttempts, 3) ?? 'Reconnecting (${provider.reconnectAttempts}/3)...'
                      : l10n?.voiceRoomConnecting ?? 'Connecting...',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                );
              },
            ),
          ],
        ),
      );
    } else if (!provider.isConnected && provider.activeRoom != null) {
      bannerChild = GestureDetector(
        key: const ValueKey('disconnected'),
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
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Text(
                      provider.error != null
                          ? ErrorLocalizer.localize(provider.error, l10n)
                          : (l10n?.voiceRoomDisconnected ?? 'Disconnected'),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
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
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Text(
                      l10n?.voiceRoomRetry ?? 'Retry',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_showConnectedBanner) {
      bannerChild = Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return Container(
            key: const ValueKey('connected'),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.green.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  l10n?.voiceRoomConnected ?? 'Connected!',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          );
        },
      );
    } else {
      bannerChild = const SizedBox.shrink(key: ValueKey('none'));
    }

    return Semantics(
      liveRegion: true,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: bannerChild,
      ),
    );
  }

  Widget _buildStageLoadingIndicator(VoiceRoomProvider provider) {
    final l10n = AppLocalizations.of(context);
    if (_stageLoadingTimedOut) {
      return Container(
        color: const Color(0xFF1A1A2E),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.amber, size: 36),
              const SizedBox(height: 12),
              Text(
                l10n?.voiceRoomStageFailedToLoad ?? 'Stage failed to load',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _stageLoadingTimedOut = false;
                    _gameInitialized = false;
                  });
                  // Restart timeout
                  _stageLoadingTimer?.cancel();
                  _stageLoadingTimer =
                      Timer(const Duration(seconds: 10), () {
                    if (_game == null && mounted) {
                      setState(() => _stageLoadingTimedOut = true);
                    }
                  });
                  // Retry initialization
                  final userId = Provider.of<AuthProvider>(context,
                          listen: false)
                      .currentUser
                      ?.id;
                  if (userId != null) {
                    _initializeGame(provider, userId);
                  }
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n?.voiceRoomRetry ?? 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              l10n?.voiceRoomPreparingStage ?? 'Preparing stage...',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelChip(String level) {
    final l10n = AppLocalizations.of(context);
    Color color;
    String label;
    switch (level) {
      case 'beginner':
        color = Colors.green;
        label = l10n?.beginner ?? 'Beginner';
        break;
      case 'intermediate':
        color = Colors.orange;
        label = l10n?.intermediate ?? 'Intermediate';
        break;
      case 'advanced':
        color = Colors.red;
        label = l10n?.advanced ?? 'Advanced';
        break;
      default:
        color = Colors.grey;
        label = l10n?.allLevels ?? 'All Levels';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showStageManagement(
      BuildContext context, VoiceRoomProvider provider) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<VoiceRoomProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
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
                                l10n?.noPendingRequests ??
                                    'No pending requests',
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
                                    tooltip: l10n?.voiceRoomAcceptToStage(req.name) ?? 'Accept ${req.name} to stage',
                                    onPressed: () {
                                      provider.grantStage(req.userId);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel,
                                        color: Colors.red),
                                    tooltip: l10n?.voiceRoomRejectFromStage(req.name) ?? 'Reject ${req.name}',
                                    onPressed: () {
                                      provider.rejectStageRequest(req.userId);
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
                          final isHost =
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
                              '${speaker.name}${isHost ? ' ${l10n?.voiceRoomHostLabel ?? '(Host)'}' : ''}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: isHost
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_downward,
                                            color: Colors.orange),
                                        tooltip:
                                            l10n?.voiceRoomDemoteToListener ??
                                                'Demote to listener',
                                        onPressed: () => _confirmDemote(
                                            ctx, provider, speaker),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.logout,
                                            color: Colors.red, size: 20),
                                        tooltip:
                                            l10n?.voiceRoomKickFromRoom ??
                                                'Kick from room',
                                        onPressed: () => _confirmKick(
                                            ctx, provider, speaker),
                                      ),
                                    ],
                                  ),
                          );
                        }),

                        // Listeners section
                        if (provider.listeners.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            l10n?.voiceRoomListeners ?? 'Listeners',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...provider.listeners.map((listener) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: listener.avatar != null
                                    ? NetworkImage(listener.avatar!)
                                    : null,
                                child: listener.avatar == null
                                    ? Text(listener.name.isNotEmpty
                                        ? listener.name[0].toUpperCase()
                                        : '?')
                                    : null,
                              ),
                              title: Text(
                                listener.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_upward,
                                        color: Colors.green, size: 20),
                                    tooltip: l10n?.voiceRoomInviteToStage ??
                                        'Invite to stage',
                                    onPressed: () {
                                      provider.inviteToStage(listener.userId);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.logout,
                                        color: Colors.red, size: 20),
                                    tooltip: l10n?.voiceRoomKickFromRoom ??
                                        'Kick from room',
                                    onPressed: () => _confirmKick(
                                        ctx, provider, listener),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDemote(
    BuildContext sheetContext,
    VoiceRoomProvider provider,
    VoiceParticipantModel speaker,
  ) async {
    final l10n = AppLocalizations.of(sheetContext);
    final confirmed = await showDialog<bool>(
      context: sheetContext,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.voiceRoomRemoveFromStage ?? 'Remove from Stage?'),
        content: Text(
            l10n?.voiceRoomRemoveFromStageConfirm(speaker.name) ?? 'Remove ${speaker.name} from stage? They will become a listener.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n?.voiceRoomDemote ?? 'Demote'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      provider.removeFromStage(speaker.userId);
    }
  }

  Future<void> _confirmKick(
    BuildContext sheetContext,
    VoiceRoomProvider provider,
    VoiceParticipantModel participant,
  ) async {
    final l10n = AppLocalizations.of(sheetContext);
    final confirmed = await showDialog<bool>(
      context: sheetContext,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.voiceRoomRemoveFromRoom ?? 'Remove from Room?'),
        content: Text(
            l10n?.voiceRoomRemoveFromRoomConfirm(participant.name) ?? 'Remove ${participant.name} from the room? They will be disconnected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n?.voiceRoomRemove ?? 'Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      provider.kickParticipant(participant.userId);
    }
  }

  void _showInviteToStageDialog(
    BuildContext context,
    VoiceRoomProvider provider,
    VoiceParticipantModel listener,
  ) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.voiceRoomInviteToStage ?? 'Invite to Stage'),
        content: Text(l10n?.voiceRoomInviteConfirm(listener.name) ??
            'Invite ${listener.name} to speak on stage?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.inviteToStage(listener.userId);
            },
            child: Text(l10n?.voiceRoomInvite ?? 'Invite'),
          ),
        ],
      ),
    );
  }

  /// Handle back button press with double-tap pattern for listeners
  /// and confirmation dialog for speakers
  Future<void> _handleBackPress(
      BuildContext context, VoiceRoomProvider provider) async {
    // Speakers always get a confirmation dialog
    if (provider.isSpeaker) {
      await _handleLeave(context, provider);
      return;
    }

    // Listeners: double-tap back to leave
    final now = DateTime.now();
    if (_lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2)) {
      // Second press within 2 seconds - actually leave
      _lastBackPressTime = null;
      if (_isLeaving) return;
      _isLeaving = true;
      try {
        await provider.leaveRoom();
        if (mounted) {
          Navigator.pop(context);
        }
      } finally {
        _isLeaving = false;
      }
      return;
    }

    // First press - show snackbar
    _lastBackPressTime = now;
    if (context.mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.voiceRoomPressBackToLeave ?? 'Press back again to leave'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleLeave(
      BuildContext context, VoiceRoomProvider provider) async {
    if (_isLeaving) return;

    // Show confirmation dialog for speakers
    if (provider.isSpeaker) {
      final l10n = AppLocalizations.of(context);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n?.voiceRoomLeaveTitle ?? 'Leave Room?'),
          content: Text(
              l10n?.voiceRoomLeaveBody ?? 'You are currently on stage. Are you sure you want to leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n?.leave ?? 'Leave'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    _isLeaving = true;
    try {
      await provider.leaveRoom();
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      _isLeaving = false;
    }
  }

  Future<void> _handleClose(
      BuildContext context, VoiceRoomProvider provider) async {
    if (_isLeaving) return;

    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.voiceRoomCloseConfirmTitle ?? 'Close Room?'),
        content: Text(l10n?.voiceRoomCloseConfirmBody ??
            'This will end the call for everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n?.close ?? 'Close'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      _isLeaving = true;
      try {
        final success = await provider.closeRoom();
        if (mounted) {
          if (success) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n?.voiceRoomCloseRoomFailed ?? 'Failed to close room'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } finally {
        _isLeaving = false;
      }
    }
  }
}
