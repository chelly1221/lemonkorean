import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/voice_room_provider.dart';

/// Expandable emoji reaction picker
class ReactionTrayWidget extends StatelessWidget {
  final VoidCallback onClose;

  const ReactionTrayWidget({super.key, required this.onClose});

  static const List<String> reactions = [
    '\u{1F44B}', // wave
    '\u{2764}',  // heart
    '\u{1F44F}', // clap
    '\u{1F602}', // laugh
    '\u{1F44D}', // thumbs up
    '\u{1F525}', // fire
    '\u{1F60D}', // heart eyes
    '\u{1F389}', // party
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          ...reactions.map((emoji) {
            return GestureDetector(
              onTap: () {
                context.read<VoiceRoomProvider>().sendReaction(emoji);
                onClose();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            );
          }),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close,
                color: Colors.white.withValues(alpha: 0.5), size: 20),
            onPressed: onClose,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
