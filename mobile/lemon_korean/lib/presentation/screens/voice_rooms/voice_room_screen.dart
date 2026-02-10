import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voice_room_provider.dart';
import 'widgets/participant_avatar.dart';

/// Active voice room screen showing participants and controls
class VoiceRoomScreen extends StatefulWidget {
  const VoiceRoomScreen({super.key});

  @override
  State<VoiceRoomScreen> createState() => _VoiceRoomScreenState();
}

class _VoiceRoomScreenState extends State<VoiceRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserId =
        Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? 0;

    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        final room = provider.activeRoom;
        if (room == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Voice Room')),
            body: const Center(child: Text('Room not available')),
          );
        }

        final isCreator = room.creatorId == currentUserId;

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
                // Participant count
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.people, color: Colors.white54, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${provider.participants.length}/${room.maxParticipants}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Connection status banner
                if (provider.isConnecting)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.orange.shade800,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Connecting...',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                else if (!provider.isConnected && provider.activeRoom != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.red.shade800,
                    child: const Text(
                      'Disconnected',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),

                // Level badge
                if (room.languageLevel != 'all')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildLevelBadge(room.languageLevel),
                  ),

                // Participants grid
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: provider.participants.map((p) {
                          return ParticipantAvatar(
                            name: p.name,
                            avatar: p.avatar,
                            isMuted: p.isMuted,
                            isCreator: p.userId == room.creatorId,
                            isSelf: p.userId == currentUserId,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Bottom controls
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16213E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mute button
                        _buildControlButton(
                          icon: provider.isMuted
                              ? Icons.mic_off
                              : Icons.mic,
                          label: provider.isMuted
                              ? (l10n?.unmute ?? 'Unmute')
                              : (l10n?.mute ?? 'Mute'),
                          color: provider.isMuted
                              ? Colors.red.shade400
                              : AppConstants.primaryColor,
                          onTap: () => provider.toggleMute(),
                        ),

                        // Leave button
                        _buildControlButton(
                          icon: Icons.call_end,
                          label: l10n?.leave ?? 'Leave',
                          color: Colors.red,
                          onTap: () => _handleLeave(context, provider),
                        ),

                        // Close room (creator only)
                        if (isCreator)
                          _buildControlButton(
                            icon: Icons.close,
                            label: l10n?.closeRoom ?? 'Close',
                            color: Colors.orange,
                            onTap: () => _handleClose(context, provider),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
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
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
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
