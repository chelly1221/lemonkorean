import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/utils/korean_tts_helper.dart';
import '../../widgets/mouth_animation_widget.dart';
import '../stage0_lesson_content.dart';

/// Sound exploration step: play character sounds and show mouth shape.
class StepSoundExplore extends StatefulWidget {
  final LessonStep step;
  final VoidCallback onNext;

  const StepSoundExplore({required this.step, required this.onNext, super.key});

  @override
  State<StepSoundExplore> createState() => _StepSoundExploreState();
}

class _StepSoundExploreState extends State<StepSoundExplore> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentCharIndex = 0;
  bool _hasListenedAll = false;

  List<String> get _characters {
    // Single character or multiple
    final single = widget.step.data['character'] as String?;
    if (single != null) return [single];
    return (widget.step.data['characters'] as List?)?.cast<String>() ?? [];
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String char) async {
    await KoreanTtsHelper.playKoreanText(char, _audioPlayer);
  }

  void _nextChar() {
    if (_currentCharIndex < _characters.length - 1) {
      setState(() => _currentCharIndex++);
    } else {
      setState(() => _hasListenedAll = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chars = _characters;
    if (chars.isEmpty) {
      return Center(child: Text('No characters defined'));
    }

    final currentChar = chars[_currentCharIndex];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            widget.step.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (widget.step.description != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.step.description!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
          // Character tabs (if multiple)
          if (chars.length > 1) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(chars.length, (i) {
                final isActive = i == _currentCharIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _currentCharIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFFFD54F)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: isActive
                            ? Border.all(color: const Color(0xFFF9A825), width: 2)
                            : null,
                      ),
                      child: Text(
                        chars[i],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
          const Spacer(),
          // Character display + play button
          GestureDetector(
            onTap: () => _playSound(currentChar),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD54F), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD54F).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    currentChar,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Positioned(
                    bottom: 8,
                    child: Icon(Icons.volume_up, size: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ).animate().scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 8),
          Text(
            '탭하여 소리 듣기',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          // Mouth animation
          MouthAnimationWidget(character: currentChar),
          const Spacer(),
          // Next / advance button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: (chars.length > 1 && !_hasListenedAll && _currentCharIndex < chars.length - 1)
                  ? _nextChar
                  : widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: Text(
                (chars.length > 1 && _currentCharIndex < chars.length - 1) ? '다음 글자' : '다음',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
