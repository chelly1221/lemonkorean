import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';

/// Stage 5: Dialogue
/// Practice conversations with audio playback
class Stage5Dialogue extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Stage5Dialogue({
    super.key,
    required this.lesson,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Stage5Dialogue> createState() => _Stage5DialogueState();
}

class _Stage5DialogueState extends State<Stage5Dialogue> {
  int _currentDialogueIndex = 0;
  int? _playingLineIndex;

  final List<Map<String, dynamic>> _mockDialogues = [
    {
      'title': '初次见面',
      'titleZh': '第一次见面',
      'lines': [
        {
          'speaker': 'A',
          'speakerName': '小明',
          'korean': '안녕하세요',
          'chinese': '你好',
          'pinyin': 'nǐ hǎo',
        },
        {
          'speaker': 'B',
          'speakerName': '小红',
          'korean': '안녕하세요',
          'chinese': '你好',
          'pinyin': 'nǐ hǎo',
        },
        {
          'speaker': 'A',
          'speakerName': '小明',
          'korean': '저는 민호입니다',
          'chinese': '我叫民浩',
          'pinyin': 'wǒ jiào mín hào',
        },
        {
          'speaker': 'B',
          'speakerName': '小红',
          'korean': '저는 수연이에요',
          'chinese': '我是秀妍',
          'pinyin': 'wǒ shì xiù yán',
        },
        {
          'speaker': 'A',
          'speakerName': '小明',
          'korean': '반갑습니다',
          'chinese': '很高兴认识你',
          'pinyin': 'hěn gāo xìng rèn shi nǐ',
        },
        {
          'speaker': 'B',
          'speakerName': '小红',
          'korean': '반갑습니다',
          'chinese': '很高兴认识你',
          'pinyin': 'hěn gāo xìng rèn shi nǐ',
        },
      ],
    },
    {
      'title': '자기소개',
      'titleZh': '自我介绍',
      'lines': [
        {
          'speaker': 'A',
          'speakerName': '老师',
          'korean': '이름이 뭐예요?',
          'chinese': '你叫什么名字？',
          'pinyin': 'nǐ jiào shén me míng zi?',
        },
        {
          'speaker': 'B',
          'speakerName': '学生',
          'korean': '저는 민수예요',
          'chinese': '我叫民秀',
          'pinyin': 'wǒ jiào mín xiù',
        },
        {
          'speaker': 'A',
          'speakerName': '老师',
          'korean': '학생이에요?',
          'chinese': '你是学生吗？',
          'pinyin': 'nǐ shì xué shēng ma?',
        },
        {
          'speaker': 'B',
          'speakerName': '学生',
          'korean': '네, 학생이에요',
          'chinese': '是的，我是学生',
          'pinyin': 'shì de, wǒ shì xué shēng',
        },
      ],
    },
  ];

  void _nextDialogue() {
    if (_currentDialogueIndex < _mockDialogues.length - 1) {
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
    final lines = _mockDialogues[_currentDialogueIndex]['lines'] as List;
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

  @override
  Widget build(BuildContext context) {
    final dialogue = _mockDialogues[_currentDialogueIndex];
    final lines = dialogue['lines'] as List;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const Text(
            '对话练习',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Dialogue Counter
          Text(
            '${_currentDialogueIndex + 1} / ${_mockDialogues.length}',
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
              label: Text(_playingLineIndex != null ? '播放中...' : '播放全部'),
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
                        _buildSpeakerAvatar(line['speaker'], isLeft),
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
                                  line['speakerName'],
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
                        _buildSpeakerAvatar(line['speaker'], isLeft),
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
                    child: const Text('上一个'),
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
                    _currentDialogueIndex < _mockDialogues.length - 1
                        ? '下一个'
                        : '继续',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerAvatar(String speaker, bool isLeft) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isLeft
            ? Colors.blue.shade100
            : AppConstants.primaryColor.withOpacity(0.3),
      ),
      child: Center(
        child: Text(
          speaker,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isLeft ? Colors.blue.shade700 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
