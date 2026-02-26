import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/local/conversation_prompts.dart';
import '../../../data/models/voice_room_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/voice_room_provider.dart';

/// Room template for quick create
class _RoomTemplate {
  final String label;
  final IconData icon;
  final String roomType;
  final String level;
  final String? title;
  final String? Function()? topicGenerator;

  const _RoomTemplate({
    required this.label,
    required this.icon,
    required this.roomType,
    required this.level,
    this.title,
    this.topicGenerator,
  });
}

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
  String _selectedRoomType = RoomTypes.freeTalk;
  int _maxSpeakers = 4;
  int? _selectedDuration; // minutes, null = no limit
  bool _isCreating = false;

  // Room type definitions with icons and labels
  static List<({String value, String label, String labelKo, IconData icon})> _getRoomTypeOptions(AppLocalizations? l10n) => [
    (value: RoomTypes.freeTalk, label: l10n?.voiceRoomTypeFreeTalk ?? 'Free Talk', labelKo: '자유 대화', icon: Icons.chat_bubble_outline),
    (value: RoomTypes.pronunciation, label: l10n?.voiceRoomTypePronunciation ?? 'Pronunciation', labelKo: '발음 연습', icon: Icons.record_voice_over),
    (value: RoomTypes.roleplay, label: l10n?.voiceRoomTypeRolePlay ?? 'Role Play', labelKo: '역할극', icon: Icons.theater_comedy),
    (value: RoomTypes.qna, label: l10n?.voiceRoomTypeQnA ?? 'Q&A', labelKo: '질문 & 답변', icon: Icons.help_outline),
    (value: RoomTypes.listening, label: l10n?.voiceRoomTypeListening ?? 'Listening', labelKo: '듣기 연습', icon: Icons.headphones),
    (value: RoomTypes.debate, label: l10n?.voiceRoomTypeDebate ?? 'Debate', labelKo: '토론', icon: Icons.forum),
  ];

  // Quick create templates
  List<_RoomTemplate> _getTemplates(AppLocalizations? l10n) => [
    _RoomTemplate(
      label: l10n?.voiceRoomTemplateFreeTalk ?? 'Korean Free Talk',
      icon: Icons.chat_bubble_outline,
      roomType: RoomTypes.freeTalk,
      level: 'all',
      title: l10n?.voiceRoomTemplateFreeTalk ?? 'Korean Free Talk',
    ),
    _RoomTemplate(
      label: l10n?.voiceRoomTemplatePronunciation ?? 'Pronunciation Practice',
      icon: Icons.record_voice_over,
      roomType: RoomTypes.pronunciation,
      level: 'beginner',
      title: l10n?.voiceRoomTemplatePronunciation ?? 'Pronunciation Practice',
    ),
    _RoomTemplate(
      label: l10n?.voiceRoomTemplateDailyKorean ?? 'Daily Korean',
      icon: Icons.today,
      roomType: RoomTypes.freeTalk,
      level: 'all',
      title: l10n?.voiceRoomTemplateDailyKorean ?? 'Daily Korean',
      topicGenerator: () => ConversationPrompts.getDailyTopic().textKo,
    ),
    _RoomTemplate(
      label: l10n?.voiceRoomTemplateTopikSpeaking ?? 'TOPIK Speaking',
      icon: Icons.school,
      roomType: RoomTypes.qna,
      level: 'advanced',
      title: l10n?.voiceRoomTemplateTopikSpeaking ?? 'TOPIK Speaking Practice',
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  void _applyTemplate(_RoomTemplate template) {
    setState(() {
      if (template.title != null) {
        _titleController.text = template.title!;
      }
      _selectedRoomType = template.roomType;
      _selectedLevel = template.level;
      if (template.topicGenerator != null) {
        final topic = template.topicGenerator!();
        if (topic != null) {
          _topicController.text = topic;
        }
      }
    });
  }

  Future<void> _handleCreate() async {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.voiceRoomEnterTitle ?? 'Please enter a room title'),
        ),
      );
      return;
    }

    // Request microphone permission on mobile
    if (!kIsWeb) {
      final status = await Permission.microphone.request();
      if (status.isPermanentlyDenied && mounted) {
        final dialogL10n = AppLocalizations.of(context);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(dialogL10n?.voiceRoomMicPermissionTitle ?? 'Microphone Permission'),
            content: Text(
              dialogL10n?.voiceRoomMicPermissionDenied ?? 'Microphone access was denied. To use voice features, please enable it in your device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(dialogL10n?.cancel ?? 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  openAppSettings();
                },
                child: Text(dialogL10n?.voiceRoomOpenSettings ?? 'Open Settings'),
              ),
            ],
          ),
        );
        return;
      }
      if (!status.isGranted && mounted) {
        final snackL10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              snackL10n?.voiceRoomMicPermission ?? 'Microphone permission is required for voice rooms',
            ),
            action: SnackBarAction(
              label: snackL10n?.settings ?? 'Settings',
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    setState(() => _isCreating = true);

    final provider = Provider.of<VoiceRoomProvider>(context, listen: false);
    final success = await provider.createRoom(
      title: title,
      topic: _topicController.text.trim().isNotEmpty
          ? _topicController.text.trim()
          : null,
      languageLevel: _selectedLevel,
      roomType: _selectedRoomType,
      maxSpeakers: _maxSpeakers,
      duration: _selectedDuration,
    );

    if (mounted) {
      setState(() => _isCreating = false);
      if (success) {
        Navigator.pop(context, true);
      } else {
        final errorL10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(provider.error ?? errorL10n?.voiceRoomCreateFailed ?? 'Failed to create room')),
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
            // Quick Create Templates
            Text(
              l10n?.voiceRoomQuickCreate ?? 'Quick Create',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _getTemplates(l10n).length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final template = _getTemplates(l10n)[index];
                  return ActionChip(
                    avatar: Icon(template.icon, size: 16),
                    label: Text(
                      template.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => _applyTemplate(template),
                  );
                },
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMedium),

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

            // Room Type Selector
            Text(
              l10n?.voiceRoomRoomType ?? 'Room Type',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getRoomTypeOptions(l10n).map((opt) {
                return _buildRoomTypeChip(opt.value, opt.label, opt.icon);
              }).toList(),
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

            const SizedBox(height: AppConstants.paddingLarge),

            // Session Duration
            Text(
              l10n?.voiceRoomSessionDuration ?? 'Session Duration',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n?.voiceRoomOptionalTimer ?? 'Optional timer for the session',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildDurationChip(null, l10n?.voiceRoomDurationNone ?? 'None'),
                _buildDurationChip(15, l10n?.voiceRoomDuration15 ?? '15 min'),
                _buildDurationChip(30, l10n?.voiceRoomDuration30 ?? '30 min'),
                _buildDurationChip(45, l10n?.voiceRoomDuration45 ?? '45 min'),
                _buildDurationChip(60, l10n?.voiceRoomDuration60 ?? '60 min'),
              ],
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

  Widget _buildRoomTypeChip(String value, String label, IconData icon) {
    final isSelected = _selectedRoomType == value;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.black87 : Colors.grey.shade600,
      ),
      label: Text(label),
      selected: isSelected,
      selectedColor: AppConstants.primaryColor,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedRoomType = value);
        }
      },
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

  Widget _buildDurationChip(int? value, String label) {
    final isSelected = _selectedDuration == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppConstants.primaryColor,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedDuration = value);
        }
      },
    );
  }
}
