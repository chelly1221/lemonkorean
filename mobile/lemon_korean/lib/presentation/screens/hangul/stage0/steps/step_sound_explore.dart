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
  bool _isPlaying = false;
  // B3: track which characters have been listened to
  final Set<int> _listenedSet = {};
  static const Map<String, String> _consonantAReference = {
    'ㄱ': '가',
    'ㄴ': '나',
    'ㄷ': '다',
    'ㄹ': '라',
    'ㅁ': '마',
    'ㅂ': '바',
    'ㅅ': '사',
    'ㅇ': '아',
    'ㅈ': '자',
    'ㅊ': '차',
    'ㅋ': '카',
    'ㅌ': '타',
    'ㅍ': '파',
    'ㅎ': '하',
    'ㄲ': '까',
    'ㄸ': '따',
    'ㅃ': '빠',
    'ㅆ': '싸',
    'ㅉ': '짜',
  };

  List<String> get _characters {
    // Single character or multiple
    final single = widget.step.data['character'] as String?;
    if (single != null) return [single];
    return (widget.step.data['characters'] as List?)?.cast<String>() ?? [];
  }

  bool get _allListened {
    final chars = _characters;
    if (chars.length <= 1) return true;
    return _listenedSet.length >= chars.length;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String char, int index) async {
    setState(() {
      _listenedSet.add(index);
      _isPlaying = true;
    });
    await KoreanTtsHelper.playKoreanText(_spokenTextFor(char), _audioPlayer);
    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  String _spokenTextFor(String char) {
    final rawMap = widget.step.data['pronunciationMap'];
    if (rawMap is Map) {
      final mapped = rawMap[char];
      if (mapped is String && mapped.isNotEmpty) {
        return mapped;
      }
    }

    if (widget.step.data['type'] == 'consonant') {
      return _consonantAReference[char] ?? char;
    }
    return char;
  }

  void _nextChar() {
    if (_currentCharIndex < _characters.length - 1) {
      setState(() => _currentCharIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chars = _characters;
    if (chars.isEmpty) {
      return const Center(child: Text('No characters defined'));
    }

    final currentChar = chars[_currentCharIndex];
    final isSyllableType = widget.step.data['type'] == 'syllable';

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
                final hasListened = _listenedSet.contains(i);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _currentCharIndex = i),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        // B3: red dot badge for unlistened characters
                        if (!hasListened)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF44336),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
          const Spacer(),
          // Character display + play button
          GestureDetector(
            onTap: () => _playSound(currentChar, _currentCharIndex),
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
              ).animate(
                autoPlay: false,
                target: _isPlaying ? 1.0 : 0.0,
              ).scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 600.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 8),
          Text(
            '탭하여 소리 듣기',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          // Mouth animation (hidden for syllables and when showMouth is false)
          if (!isSyllableType && widget.step.data['showMouth'] != false)
            MouthAnimationWidget(character: currentChar),
          const Spacer(),
          // Next / advance button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              // B3: disable next until all characters listened
              onPressed: (chars.length > 1 && !_allListened)
                  ? null
                  : (chars.length > 1 && _currentCharIndex < chars.length - 1)
                      ? _nextChar
                      : widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: Colors.black87,
                disabledBackgroundColor: Colors.grey.shade200,
                disabledForegroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: Text(
                (chars.length > 1 && !_allListened)
                    ? '모든 소리를 들어보세요'
                    : (chars.length > 1 && _currentCharIndex < chars.length - 1)
                        ? '다음 글자'
                        : '다음',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
