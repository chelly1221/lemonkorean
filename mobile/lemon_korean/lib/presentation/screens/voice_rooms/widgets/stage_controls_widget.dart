import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/voice_room_provider.dart';

/// Role-based control buttons for voice room
class StageControlsWidget extends StatelessWidget {
  final VoidCallback onLeaveRoom;
  final VoidCallback onCloseRoom;
  final VoidCallback onShowReactions;
  final VoidCallback onShowGestures;
  final VoidCallback onManageStage;

  const StageControlsWidget({
    super.key,
    required this.onLeaveRoom,
    required this.onCloseRoom,
    required this.onShowReactions,
    required this.onShowGestures,
    required this.onManageStage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reaction button (all users)
                    _buildButton(
                      icon: Icons.emoji_emotions_outlined,
                      label: l10n?.emojiReaction ?? 'React',
                      color: Colors.amber,
                      onTap: onShowReactions,
                    ),

                    // Gesture button (speakers only)
                    if (provider.isSpeaker)
                      _buildButton(
                        icon: Icons.waving_hand_outlined,
                        label: l10n?.gesture ?? 'Gesture',
                        color: Colors.purple.shade300,
                        onTap: onShowGestures,
                      ),

                    // Mute button (speakers only)
                    if (provider.isSpeaker)
                      _buildButton(
                        icon: provider.isMuted ? Icons.mic_off : Icons.mic,
                        label: provider.isMuted
                            ? (l10n?.unmute ?? 'Unmute')
                            : (l10n?.mute ?? 'Mute'),
                        color: provider.isMuted
                            ? Colors.red.shade400
                            : AppConstants.primaryColor,
                        onTap: () => provider.toggleMute(),
                      ),

                    // Raise hand / Cancel hand (listeners only)
                    if (provider.isListener)
                      _buildButton(
                        icon: provider.hasRaisedHand
                            ? Icons.back_hand
                            : Icons.back_hand_outlined,
                        label: provider.hasRaisedHand
                            ? (l10n?.cancelRequest ?? 'Cancel')
                            : (l10n?.raiseHand ?? 'Raise Hand'),
                        color: provider.hasRaisedHand
                            ? Colors.orange
                            : Colors.blue.shade300,
                        onTap: () {
                          if (provider.hasRaisedHand) {
                            provider.cancelStageRequest();
                          } else {
                            provider.requestStage();
                          }
                        },
                      ),

                    // Leave stage (speakers who are not creator)
                    if (provider.isSpeaker && !provider.isCreator)
                      _buildButton(
                        icon: Icons.arrow_downward,
                        label: l10n?.leaveStage ?? 'Leave Stage',
                        color: Colors.orange,
                        onTap: () => provider.leaveStage(),
                      ),

                    // Manage stage (creator only)
                    if (provider.isCreator &&
                        provider.stageRequests.isNotEmpty)
                      _buildButton(
                        icon: Icons.people_outline,
                        label: '${l10n?.pendingRequests ?? 'Requests'} (${provider.stageRequests.length})',
                        color: Colors.cyan,
                        onTap: onManageStage,
                      ),

                    // Leave room button
                    _buildButton(
                      icon: Icons.exit_to_app,
                      label: l10n?.leave ?? 'Leave',
                      color: Colors.red,
                      onTap: onLeaveRoom,
                    ),

                    // Close room (creator only)
                    if (provider.isCreator)
                      _buildButton(
                        icon: Icons.close,
                        label: l10n?.closeRoom ?? 'Close',
                        color: Colors.red.shade300,
                        onTap: onCloseRoom,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 9),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
