import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/media_helper.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Stage 5: Dialogue
/// Practice conversations with audio playback
class Stage5Dialogue extends StatefulWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const Stage5Dialogue({
    required this.lesson,
    this.stageData,
    required this.onNext,
    this.onPrevious,
    super.key,
  });

  @override
  State<Stage5Dialogue> createState() => _Stage5DialogueState();
}

class _Stage5DialogueState extends State<Stage5Dialogue> {
  int _currentDialogueIndex = 0;
  int? _playingLineIndex;
  List<Map<String, dynamic>> _dialogues = [];
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _loadDialogues();
      _initialized = true;
    }
  }

  /// Load dialogues from stageData or lesson content
  /// Returns empty list if no data available - UI shows "no content" message
  void _loadDialogues() {
    if (widget.stageData != null && widget.stageData!.containsKey('dialogues')) {
      _dialogues = List<Map<String, dynamic>>.from(widget.stageData!['dialogues']);
    } else if (widget.lesson.content != null) {
      final dialogueData = widget.lesson.content!['stage5_dialogue'];
      _dialogues = dialogueData != null
          ? List<Map<String, dynamic>>.from(dialogueData['dialogues'] ?? [])
          : [];
    } else {
      // No data available - return empty list, UI will show appropriate message
      _dialogues = [];
    }
  }

  void _nextDialogue() {
    if (_currentDialogueIndex < _dialogues.length - 1) {
      setState(() {
        _currentDialogueIndex++;
        _playingLineIndex = null;
      });
    } else {
      widget.onNext();
    }
  }

  void _previousDialogue() {
    if (_currentDialogueIndex > 0) {
      setState(() {
        _currentDialogueIndex--;
        _playingLineIndex = null;
      });
    }
  }

  void _playLine(int index) {
    setState(() {
      _playingLineIndex = index;
    });

    // Simulate audio playback
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _playingLineIndex = null;
        });
      }
    });
  }

  void _playAll() {
    final lines = _dialogues[_currentDialogueIndex]['lines'] as List;
    _playSequence(lines, 0);
  }

  void _playSequence(List lines, int index) {
    if (index >= lines.length) {
      setState(() {
        _playingLineIndex = null;
      });
      return;
    }

    setState(() {
      _playingLineIndex = index;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _playSequence(lines, index + 1);
      }
    });
  }

  String _getSpeakerName(Map<String, dynamic> dialogue, String speaker) {
    if (speaker == 'A') {
      return dialogue['speakerA']['name'];
    } else {
      return dialogue['speakerB']['name'];
    }
  }

  String? _getSpeakerAvatarUrl(Map<String, dynamic> dialogue, String speaker) {
    if (speaker == 'A') {
      return dialogue['speakerA']['avatarUrl'];
    } else {
      return dialogue['speakerB']['avatarUrl'];
    }
  }

  /// Build empty state widget when no dialogue data is available
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppConstants.textHint,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noDialogue,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: AppConstants.paddingMedium,
              ),
            ),
            child: Text(l10n.continueBtn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Handle empty dialogues case
    if (_dialogues.isEmpty) {
      return _buildEmptyState(l10n);
    }

    final dialogue = _dialogues[_currentDialogueIndex];
    final lines = dialogue['lines'] as List;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          Text(
            l10n.dialogueTitle,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Dialogue Counter
          Text(
            '${_currentDialogueIndex + 1} / ${_dialogues.length}',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // Dialogue Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Column(
              children: [
                Text(
                  dialogue['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dialogue['titleZh'],
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Play All Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _playingLineIndex == null ? _playAll : null,
              icon: Icon(
                _playingLineIndex != null ? Icons.pause : Icons.play_arrow,
              ),
              label: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Text(_playingLineIndex != null ? l10n.playingAudio : l10n.playAll);
                },
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingMedium,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Dialogue Lines
          Expanded(
            child: ListView.builder(
              itemCount: lines.length,
              itemBuilder: (context, index) {
                final line = lines[index];
                final isPlaying = _playingLineIndex == index;
                final isLeft = line['speaker'] == 'A';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isLeft
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      // Speaker A (left)
                      if (isLeft) ...[
                        _buildSpeakerAvatar(
                          dialogue,
                          line['speaker'],
                          isLeft,
                        ),
                        const SizedBox(width: 12),
                      ],

                      // Dialogue Bubble
                      Flexible(
                        child: GestureDetector(
                          onTap: () => _playLine(index),
                          child: Container(
                            padding: const EdgeInsets.all(
                              AppConstants.paddingMedium,
                            ),
                            decoration: BoxDecoration(
                              color: isLeft
                                  ? Colors.grey.shade200
                                  : AppConstants.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isLeft ? 4 : 20),
                                bottomRight: Radius.circular(isLeft ? 20 : 4),
                              ),
                              border: isPlaying
                                  ? Border.all(
                                      color: AppConstants.primaryColor,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Speaker Name
                                Text(
                                  _getSpeakerName(dialogue, line['speaker']),
                                  style: const TextStyle(
                                    fontSize: AppConstants.fontSizeSmall,
                                    color: AppConstants.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // Korean Text
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        line['korean'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isPlaying
                                          ? Icons.volume_up
                                          : Icons.volume_up_outlined,
                                      size: 20,
                                      color: isPlaying
                                          ? AppConstants.primaryColor
                                          : AppConstants.textSecondary,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Chinese Translation
                                Text(
                                  line['chinese'],
                                  style: const TextStyle(
                                    fontSize: AppConstants.fontSizeMedium,
                                    color: AppConstants.textSecondary,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // Pinyin
                                Text(
                                  line['pinyin'],
                                  style: const TextStyle(
                                    fontSize: AppConstants.fontSizeSmall,
                                    color: AppConstants.textHint,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Speaker B (right)
                      if (!isLeft) ...[
                        const SizedBox(width: 12),
                        _buildSpeakerAvatar(
                          dialogue,
                          line['speaker'],
                          isLeft,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Navigation Buttons
          Row(
            children: [
              // Previous Button
              if (_currentDialogueIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousDialogue,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: Text(l10n.previousItem),
                  ),
                ),

              if (_currentDialogueIndex > 0) const SizedBox(width: 16),

              // Next Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _nextDialogue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                  child: Text(
                    _currentDialogueIndex < _dialogues.length - 1
                        ? l10n.nextItem
                        : l10n.continueBtn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerAvatar(
    Map<String, dynamic> dialogue,
    String speaker,
    bool isLeft,
  ) {
    final avatarUrl = _getSpeakerAvatarUrl(dialogue, speaker);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isLeft
            ? Colors.blue.shade100
            : AppConstants.primaryColor.withOpacity(0.3),
        border: Border.all(
          color: isLeft
              ? Colors.blue.shade300
              : AppConstants.primaryColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: avatarUrl != null
            ? MediaHelper.buildImage(
                avatarUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: _buildAvatarPlaceholder(speaker, isLeft),
                errorWidget: _buildAvatarPlaceholder(speaker, isLeft),
              )
            : _buildAvatarPlaceholder(speaker, isLeft),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String speaker, bool isLeft) {
    return Container(
      color: isLeft
          ? Colors.blue.shade50
          : AppConstants.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          speaker == 'A' ? Icons.person : Icons.person_outline,
          size: 28,
          color: isLeft ? Colors.blue.shade700 : Colors.black87,
        ),
      ),
    );
  }
}
