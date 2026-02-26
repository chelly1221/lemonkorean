import 'package:flutter/material.dart';

import '../../../../data/models/voice_room_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Horizontal scroll bar showing listener avatars
class AudienceBarWidget extends StatelessWidget {
  final List<VoiceParticipantModel> listeners;
  final void Function(VoiceParticipantModel)? onListenerTap;

  const AudienceBarWidget({
    required this.listeners,
    super.key,
    this.onListenerTap,
  });

  @override
  Widget build(BuildContext context) {
    if (listeners.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Audience icon + count
          Semantics(
            label: l10n?.voiceRoomListenerCount(listeners.length) ?? '${listeners.length} listeners',
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Row(
                  children: [
                    Icon(Icons.visibility,
                        color: Colors.white.withValues(alpha: 0.7), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${listeners.length}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
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
                return Semantics(
                  button: onListenerTap != null,
                  label: onListenerTap != null
                      ? (l10n?.voiceRoomListenerTapToManage(listener.name) ?? 'Listener ${listener.name}, tap to manage')
                      : (l10n?.voiceRoomListenerName(listener.name) ?? 'Listener ${listener.name}'),
                  child: InkWell(
                    onTap: onListenerTap != null
                        ? () => onListenerTap!(listener)
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    child: ExcludeSemantics(
                      child: Padding(
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
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
