import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/voice_room_provider.dart';
import 'create_voice_room_screen.dart';
import 'voice_room_screen.dart';
import 'widgets/room_card.dart';

/// Voice rooms list screen showing active rooms
class VoiceRoomsListScreen extends StatefulWidget {
  const VoiceRoomsListScreen({super.key});

  @override
  State<VoiceRoomsListScreen> createState() => _VoiceRoomsListScreenState();
}

class _VoiceRoomsListScreenState extends State<VoiceRoomsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoiceRoomProvider>(context, listen: false).loadRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.voiceRooms ?? 'Voice Rooms',
          style: const TextStyle(
            fontSize: AppConstants.fontSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<VoiceRoomProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.rooms.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
              ),
            );
          }

          if (provider.rooms.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingXLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic_off_outlined,
                        size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      l10n?.noVoiceRooms ?? 'No active voice rooms',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeNormal,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      l10n?.createVoiceRoomHint ??
                          'Create a room to practice Korean with others!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms);
          }

          return RefreshIndicator(
            color: AppConstants.primaryColor,
            onRefresh: () => provider.loadRooms(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: provider.rooms.length,
              itemBuilder: (context, index) {
                final room = provider.rooms[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                  child: RoomCard(
                    room: room,
                    onTap: () async {
                      // Request microphone permission on mobile
                      if (!kIsWeb) {
                        final status = await Permission.microphone.request();
                        if (!status.isGranted && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Microphone permission is required for voice rooms'),
                            ),
                          );
                          return;
                        }
                      }

                      final success = await provider.joinRoom(room.id);
                      if (success && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VoiceRoomScreen(),
                          ),
                        );
                      } else if (provider.error != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.error!)),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateVoiceRoomScreen(),
            ),
          );
          if (created == true && mounted) {
            final provider =
                Provider.of<VoiceRoomProvider>(context, listen: false);
            if (provider.activeRoom != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VoiceRoomScreen(),
                ),
              );
            }
          }
        },
        backgroundColor: AppConstants.primaryColor,
        icon: const Icon(Icons.add, color: Colors.black87),
        label: Text(
          l10n?.createRoom ?? 'Create Room',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).animate().scale(
            delay: 300.ms,
            duration: 300.ms,
            curve: Curves.elasticOut,
          ),
    );
  }
}
