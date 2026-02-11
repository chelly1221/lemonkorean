import 'package:flutter/material.dart';

import '../../../../data/models/voice_room_model.dart';

/// Horizontal scroll bar showing listener avatars
class AudienceBarWidget extends StatelessWidget {
  final List<VoiceParticipantModel> listeners;

  const AudienceBarWidget({super.key, required this.listeners});

  @override
  Widget build(BuildContext context) {
    if (listeners.isEmpty) {
      return Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            'No listeners yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Audience icon + count
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Row(
              children: [
                Icon(Icons.visibility,
                    color: Colors.white.withValues(alpha: 0.5), size: 14),
                const SizedBox(width: 4),
                Text(
                  '${listeners.length}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable avatars
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listeners.length,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                final listener = listeners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade700,
                        backgroundImage: listener.avatar != null
                            ? NetworkImage(listener.avatar!)
                            : null,
                        child: listener.avatar == null
                            ? Text(
                                listener.name.isNotEmpty
                                    ? listener.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.white),
                              )
                            : null,
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 40,
                        child: Text(
                          listener.name,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
