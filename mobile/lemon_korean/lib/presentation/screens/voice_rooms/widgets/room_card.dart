import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/voice_room_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Card widget for voice room in the rooms list
class RoomCard extends StatelessWidget {
  final VoiceRoomModel room;
  final VoidCallback? onTap;

  const RoomCard({
    required this.room,
    this.onTap,
    super.key,
  });

  String _buildSemanticSummary(AppLocalizations? l10n) {
    final speakerListenerLabel = l10n?.voiceRoomSpeakerListenerCount(
          room.speakerCount, room.maxSpeakers, room.listenerCount) ??
        '${room.speakerCount} of ${room.maxSpeakers} speakers, ${room.listenerCount} listeners';
    final levelLabel = room.languageLevel == 'all'
        ? (l10n?.allLevels ?? 'All Levels')
        : room.languageLevel;
    final parts = <String>[
      room.title,
      VoiceRoomModel.localizedRoomType(room.roomType, l10n),
      room.creatorName.isNotEmpty ? room.creatorName : '?',
      speakerListenerLabel,
      levelLabel,
    ];
    if (room.topic != null && room.topic!.isNotEmpty) {
      parts.insert(2, room.topic!);
    }
    if (room.isStageFull) {
      parts.add(l10n?.voiceRoomStageFull ?? 'Stage Full');
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasTypeTint = room.roomType != RoomTypes.freeTalk;

    return Semantics(
      button: true,
      label: _buildSemanticSummary(l10n),
      child: ExcludeSemantics(
        child: Card(
          elevation: 1,
          color: hasTypeTint ? null : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: hasTypeTint
                ? BoxDecoration(
                    color: room.roomTypeColor,
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + participant count
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        room.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Speaker count + Listener count
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: room.isStageFull
                                ? Colors.red.shade100
                                : AppConstants.primaryColor
                                    .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mic,
                                  size: 13,
                                  color: room.isStageFull
                                      ? Colors.red
                                      : Colors.black87),
                              const SizedBox(width: 3),
                              Text(
                                '${room.speakerCount}/${room.maxSpeakers}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: room.isStageFull
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.visibility,
                                  size: 13, color: Colors.grey),
                              const SizedBox(width: 3),
                              Text(
                                '${room.listenerCount}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Topic
                if (room.topic != null && room.topic!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    room.topic!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Bottom row: room type badge + level badge + creator + participants avatars
                Row(
                  children: [
                    // Room type badge
                    _buildRoomTypeBadge(room),
                    const SizedBox(width: 6),

                    // Level badge
                    _buildLevelBadge(context, room.languageLevel),
                    const SizedBox(width: 8),

                    // Creator
                    Icon(Icons.person, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        room.creatorName.isNotEmpty ? room.creatorName : '?',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Participant avatars (overlapping)
                    SizedBox(
                      height: 28,
                      child: _buildParticipantAvatars(),
                    ),
                  ],
                ),

                // Stage full indicator
                if (room.isStageFull) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      l10n?.voiceRoomStageFull ?? 'Stage Full',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomTypeBadge(VoiceRoomModel room) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: room.roomTypeAccentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            room.roomTypeIcon,
            size: 11,
            color: room.roomTypeAccentColor,
          ),
          const SizedBox(width: 3),
          Text(
            room.roomTypeDisplay,
            style: TextStyle(
              fontSize: 11,
              color: room.roomTypeAccentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(BuildContext context, String level) {
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
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildParticipantAvatars() {
    final participants = room.participants.take(4).toList();
    if (participants.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: List.generate(participants.length, (index) {
        return Positioned(
          left: index * 20.0,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: participants[index].avatar != null
                ? NetworkImage(participants[index].avatar!)
                : null,
            child: participants[index].avatar == null
                ? Text(
                    participants[index].name.isNotEmpty
                        ? participants[index].name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  )
                : null,
          ),
        );
      }),
    );
  }
}
