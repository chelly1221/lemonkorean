import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/voice_room_provider.dart';

/// Create voice room screen
class CreateVoiceRoomScreen extends StatefulWidget {
  const CreateVoiceRoomScreen({super.key});

  @override
  State<CreateVoiceRoomScreen> createState() => _CreateVoiceRoomScreenState();
}

class _CreateVoiceRoomScreenState extends State<CreateVoiceRoomScreen> {
  final _titleController = TextEditingController();
  final _topicController = TextEditingController();
  String _selectedLevel = 'all';
  int _maxSpeakers = 4;
  bool _isCreating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a room title'),
        ),
      );
      return;
    }

    // Request microphone permission on mobile
    if (!kIsWeb) {
      final status = await Permission.microphone.request();
      if (!status.isGranted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Microphone permission is required for voice rooms'),
          ),
        );
        return;
      }
    }

    setState(() => _isCreating = true);

    final provider = Provider.of<VoiceRoomProvider>(context, listen: false);
    final success = await provider.createRoom(
      title: title,
      topic: _topicController.text.trim().isNotEmpty
          ? _topicController.text.trim()
          : null,
      languageLevel: _selectedLevel,
      maxSpeakers: _maxSpeakers,
    );

    if (mounted) {
      setState(() => _isCreating = false);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(provider.error ?? 'Failed to create room')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.createVoiceRoom ?? 'Create Voice Room'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              l10n?.roomTitle ?? 'Room Title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: l10n?.roomTitleHint ?? 'e.g., Korean Conversation Practice',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppConstants.primaryColor, width: 2),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Topic (optional)
            Text(
              l10n?.topic ?? 'Topic (optional)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _topicController,
              maxLength: 200,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: l10n?.topicHint ?? 'What will you talk about?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppConstants.primaryColor, width: 2),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Language Level
            Text(
              l10n?.languageLevel ?? 'Language Level',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildLevelChip('all', l10n?.allLevels ?? 'All'),
                _buildLevelChip('beginner', l10n?.beginner ?? 'Beginner'),
                _buildLevelChip(
                    'intermediate', l10n?.intermediate ?? 'Intermediate'),
                _buildLevelChip('advanced', l10n?.advanced ?? 'Advanced'),
              ],
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Stage slots (max speakers)
            Text(
              l10n?.stageSlots ?? 'Stage Slots',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n?.anyoneCanListen ?? 'Anyone can join to listen',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [2, 3, 4].map((count) {
                final isSelected = _maxSpeakers == count;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$count'),
                    selected: isSelected,
                    selectedColor: AppConstants.primaryColor,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _maxSpeakers = count);
                      }
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppConstants.paddingXLarge),

            // Create button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _handleCreate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black54,
                        ),
                      )
                    : Text(
                        l10n?.createAndJoin ?? 'Create & Join',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppConstants.fontSizeMedium,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelChip(String value, String label) {
    final isSelected = _selectedLevel == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppConstants.primaryColor,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedLevel = value);
        }
      },
    );
  }
}
