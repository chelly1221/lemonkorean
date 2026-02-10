import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Circular avatar for voice room participant with speaking/mute indicators
class ParticipantAvatar extends StatelessWidget {
  final String name;
  final String? avatar;
  final bool isMuted;
  final bool isCreator;
  final bool isSelf;

  const ParticipantAvatar({
    super.key,
    required this.name,
    this.avatar,
    this.isMuted = false,
    this.isCreator = false,
    this.isSelf = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar with border
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isMuted
                      ? Colors.grey
                      : AppConstants.primaryColor,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 37,
                backgroundColor: Colors.grey.shade800,
                backgroundImage:
                    avatar != null ? NetworkImage(avatar!) : null,
                child: avatar == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      )
                    : null,
              ),
            ),

            // Mute indicator
            if (isMuted)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A1A2E),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.mic_off,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),

            // Creator badge
            if (isCreator)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A1A2E),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.black87,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Name
        Text(
          isSelf ? '$name (You)' : name,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
            fontWeight: isSelf ? FontWeight.bold : FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
