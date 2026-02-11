import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/voice_room_provider.dart';

/// Expandable gesture picker for speakers (3s cooldown)
class GestureTrayWidget extends StatelessWidget {
  final VoidCallback onClose;

  const GestureTrayWidget({super.key, required this.onClose});

  static const List<({String id, String label, IconData icon})> gestures = [
    (id: 'wave', label: 'Wave', icon: Icons.waving_hand),
    (id: 'bow', label: 'Bow', icon: Icons.accessibility_new),
    (id: 'dance', label: 'Dance', icon: Icons.music_note),
    (id: 'jump', label: 'Jump', icon: Icons.arrow_upward),
    (id: 'clap', label: 'Clap', icon: Icons.volunteer_activism),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        final canSend = provider.canSendGesture();

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
              ...gestures.map((g) {
                return GestureDetector(
                  onTap: canSend
                      ? () {
                          provider.sendGesture(g.id);
                          onClose();
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: canSend
                                ? Colors.purple.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            g.icon,
                            color: canSend
                                ? Colors.purple.shade200
                                : Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          g.label,
                          style: TextStyle(
                            color: canSend ? Colors.white60 : Colors.grey,
                            fontSize: 9,
                          ),
                        ),
                      ],
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
      },
    );
  }
}
