import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/voice_room_provider.dart';

/// Role-based control buttons for voice room.
///
/// Two-tier layout inspired by Twitter Spaces / Clubhouse:
///   Top tier  - primary actions (react, mute/raise-hand, leave)
///   Bottom tier - secondary actions (gesture, stage mgmt, overflow menu)
class StageControlsWidget extends StatelessWidget {
  final VoidCallback onLeaveRoom;
  final VoidCallback onCloseRoom;
  final VoidCallback onShowReactions;
  final VoidCallback onShowGestures;
  final VoidCallback onManageStage;

  const StageControlsWidget({
    required this.onLeaveRoom,
    required this.onCloseRoom,
    required this.onShowReactions,
    required this.onShowGestures,
    required this.onManageStage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        final bool showSecondaryRow =
            provider.isSpeaker || provider.isCreator;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Primary action row
                _buildPrimaryRow(context, provider, l10n),

                // Secondary action row (speakers / creator only)
                if (showSecondaryRow) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  _buildSecondaryRow(context, provider, l10n),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------
  //  PRIMARY ROW - React | Mute/RaiseHand (large) | Leave (red)
  // ---------------------------------------------------------------
  Widget _buildPrimaryRow(
    BuildContext context,
    VoiceRoomProvider provider,
    AppLocalizations? l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left - Emoji reaction
        Expanded(
          child: Center(
            child: _buildControlButton(
              icon: Icons.emoji_emotions_outlined,
              label: l10n?.emojiReaction ?? 'React',
              color: Colors.amber,
              tooltip: l10n?.emojiReaction ?? 'React',
              semanticLabel: l10n?.voiceRoomSendReaction ?? 'Send reaction',
              onTap: onShowReactions,
            ),
          ),
        ),

        // Center - Primary action (mute/unmute OR raise hand)
        if (provider.isSpeaker)
          _buildPrimaryMuteButton(provider, l10n)
        else
          _buildPrimaryRaiseHandButton(context, provider, l10n),

        // Right - Leave room
        Expanded(
          child: Center(
            child: _buildControlButton(
              icon: Icons.exit_to_app,
              label: l10n?.leave ?? 'Leave',
              color: Colors.red,
              tooltip: l10n?.leave ?? 'Leave',
              semanticLabel: l10n?.voiceRoomLeaveRoom ?? 'Leave room',
              onTap: onLeaveRoom,
            ),
          ),
        ),
      ],
    );
  }

  /// Large mute / unmute button (56x56) for speakers.
  Widget _buildPrimaryMuteButton(
    VoiceRoomProvider provider,
    AppLocalizations? l10n,
  ) {
    final bool muted = provider.isMuted;
    final Color color =
        muted ? Colors.red.shade400 : AppConstants.primaryColor;
    final String label =
        muted ? (l10n?.unmute ?? 'Unmute') : (l10n?.mute ?? 'Mute');

    return _buildControlButton(
      icon: muted ? Icons.mic_off : Icons.mic,
      label: label,
      color: color,
      tooltip: label,
      semanticLabel: muted
          ? (l10n?.voiceRoomUnmuteMic ?? 'Unmute microphone')
          : (l10n?.voiceRoomMuteMic ?? 'Mute microphone'),
      size: 56,
      iconSize: 28,
      onTap: () {
        HapticFeedback.mediumImpact();
        provider.toggleMute();
      },
    );
  }

  /// Large raise-hand / cancel button (56x56) for listeners.
  Widget _buildPrimaryRaiseHandButton(
    BuildContext context,
    VoiceRoomProvider provider,
    AppLocalizations? l10n,
  ) {
    final bool raised = provider.hasRaisedHand;
    final Color color = raised ? Colors.orange : Colors.blue.shade300;
    final String label = raised
        ? (l10n?.cancelRequest ?? 'Cancel')
        : (l10n?.raiseHand ?? 'Raise Hand');

    return _buildControlButton(
      icon: raised ? Icons.back_hand : Icons.back_hand_outlined,
      label: label,
      color: color,
      tooltip: label,
      semanticLabel: raised
          ? (l10n?.voiceRoomCancelHandRaise ?? 'Cancel hand raise')
          : (l10n?.voiceRoomRaiseHandSemantic ?? 'Raise hand'),
      size: 56,
      iconSize: 28,
      onTap: () async {
        if (raised) {
          provider.cancelStageRequest();
        } else {
          // Request mic permission before raising hand (mobile only)
          if (!kIsWeb) {
            final status = await Permission.microphone.request();
            if (status.isPermanentlyDenied) {
              if (!context.mounted) return;
              final dialogL10n = AppLocalizations.of(context);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(dialogL10n?.voiceRoomMicPermissionTitle ?? 'Microphone Permission'),
                  content: Text(
                    dialogL10n?.voiceRoomMicPermissionDenied ?? 'Microphone access was denied. To use voice features, please enable it in your device settings.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(dialogL10n?.cancel ?? 'Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        openAppSettings();
                      },
                      child: Text(dialogL10n?.voiceRoomOpenSettings ?? 'Open Settings'),
                    ),
                  ],
                ),
              );
              return;
            }
            if (!status.isGranted) {
              if (!context.mounted) return;
              final snackL10n = AppLocalizations.of(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    snackL10n?.voiceRoomMicNeededForStage ?? 'Microphone permission is needed to speak on stage',
                  ),
                  action: SnackBarAction(
                    label: snackL10n?.voiceRoomOpenSettings ?? 'Settings',
                    onPressed: () => openAppSettings(),
                  ),
                ),
              );
              return;
            }
          }
          provider.requestStage();
        }
      },
    );
  }

  // ---------------------------------------------------------------
  //  SECONDARY ROW - Gesture | Leave Stage | Stage mgmt | Overflow
  // ---------------------------------------------------------------
  Widget _buildSecondaryRow(
    BuildContext context,
    VoiceRoomProvider provider,
    AppLocalizations? l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gesture (speakers)
        if (provider.isSpeaker)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildControlButton(
              icon: Icons.waving_hand_outlined,
              label: l10n?.gesture ?? 'Gesture',
              color: Colors.purple.shade300,
              tooltip: l10n?.gesture ?? 'Gesture',
              semanticLabel: l10n?.voiceRoomSendGesture ?? 'Send gesture',
              onTap: onShowGestures,
            ),
          ),

        // Leave stage (speakers who are not creator)
        if (provider.isSpeaker && !provider.isCreator)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildControlButton(
              icon: Icons.arrow_downward,
              label: l10n?.leaveStage ?? 'Leave Stage',
              color: Colors.orange,
              tooltip: l10n?.leaveStage ?? 'Leave Stage',
              semanticLabel: l10n?.voiceRoomLeaveStageAction ?? 'Leave stage',
              onTap: () => provider.leaveStage(),
            ),
          ),

        // Stage management (creator only, with badge)
        if (provider.isCreator)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildBadgeButton(
              icon: Icons.people_outline,
              label: l10n?.pendingRequests ?? 'Stage',
              color: Colors.cyan,
              tooltip: l10n?.pendingRequests ?? 'Manage Stage',
              semanticLabel: l10n?.voiceRoomManageStage ?? 'Manage stage',
              badgeCount: provider.stageRequests.length,
              onTap: onManageStage,
            ),
          ),

        // Overflow menu (creator only - contains Close Room)
        if (provider.isCreator)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildOverflowMenu(context, l10n),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------
  //  OVERFLOW MENU - "Close Room" moved here to prevent accidents
  // ---------------------------------------------------------------
  Widget _buildOverflowMenu(BuildContext context, AppLocalizations? l10n) {
    final String closeLabel = l10n?.closeRoom ?? 'Close Room';

    return Semantics(
      button: true,
      label: l10n?.voiceRoomMoreOptions ?? 'More options',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: PopupMenuButton<String>(
              tooltip: l10n?.voiceRoomMoreOptions ?? 'More options',
              icon: ExcludeSemantics(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
              ),
              color: const Color(0xFF1A2744),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              offset: const Offset(0, -60),
              onSelected: (value) {
                if (value == 'close_room') {
                  onCloseRoom();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'close_room',
                  child: Row(
                    children: [
                      Icon(Icons.close, color: Colors.red.shade300, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        closeLabel,
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ExcludeSemantics(
            child: Text(
              l10n?.voiceRoomMore ?? 'More',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  //  SHARED BUTTON BUILDERS
  // ---------------------------------------------------------------

  /// Standard control button with InkWell ripple, tooltip, and semantics.
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
    String? semanticLabel,
    double size = 48,
    double iconSize = 22,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: Tooltip(
        message: tooltip,
        child: ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  customBorder: const CircleBorder(),
                  splashColor: color.withValues(alpha: 0.25),
                  highlightColor: color.withValues(alpha: 0.12),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Badge button (with notification count) using InkWell, tooltip, and semantics.
  Widget _buildBadgeButton({
    required IconData icon,
    required String label,
    required Color color,
    required String tooltip,
    required int badgeCount,
    required VoidCallback onTap,
    String? semanticLabel,
    double size = 48,
    double iconSize = 22,
  }) {
    final String resolvedSemantic = semanticLabel ??
        (badgeCount > 0
            ? '$label ($badgeCount)'
            : label);

    return Semantics(
      button: true,
      label: resolvedSemantic,
      child: Tooltip(
        message: badgeCount > 0
            ? '$tooltip ($badgeCount)'
            : tooltip,
        child: ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: badgeCount > 0,
                label: Text(
                  '$badgeCount',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
                backgroundColor: Colors.red,
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    customBorder: const CircleBorder(),
                    splashColor: color.withValues(alpha: 0.25),
                    highlightColor: color.withValues(alpha: 0.12),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: iconSize),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
