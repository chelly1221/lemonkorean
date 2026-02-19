import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/utils/korean_tts_helper.dart';
import '../stage0_lesson_content.dart';

/// Sound match quiz: play a sound, pick the correct character from 2 choices.
class StepSoundMatch extends StatefulWidget {
  final LessonStep step;
  final void Function(int correct, int total) onCompleted;

  const StepSoundMatch({
    required this.step,
    required this.onCompleted,
    super.key,
  });

  @override
  State<StepSoundMatch> createState() => _StepSoundMatchState();
}

class _StepSoundMatchState extends State<StepSoundMatch> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final List<Map<String, dynamic>> _questions;
  int _currentIndex = 0;
  int _correctCount = 0;
  String? _selectedAnswer;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _questions = (widget.step.data['questions'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    // Auto-play first question sound
    if (_questions.isNotEmpty) {
      Future.delayed(500.ms, () => _playCurrentSound());
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _current => _questions[_currentIndex];

  Future<void> _playCurrentSound() async {
    final answer = _current['answer'] as String;
    await KoreanTtsHelper.playKoreanText(answer, _audioPlayer);
  }

  void _selectAnswer(String choice) {
    if (_showFeedback) return;
    final correct = _current['answer'] as String;
    final isCorrect = choice == correct;
    if (isCorrect) _correctCount++;

    setState(() {
      _selectedAnswer = choice;
      _showFeedback = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _showFeedback = false;
        });
        Future.delayed(300.ms, () => _playCurrentSound());
      } else {
        widget.onCompleted(_correctCount, _questions.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(child: Text('No questions'));
    }

    final choices = (_current['choices'] as List).cast<String>();
    final answer = _current['answer'] as String;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            widget.step.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentIndex + 1} / ${_questions.length}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const Spacer(flex: 2),
          // Play sound button
          GestureDetector(
            onTap: _playCurrentSound,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF42A5F5), width: 2.5),
              ),
              child: const Icon(
                Icons.volume_up,
                size: 40,
                color: Color(0xFF42A5F5),
              ),
            ),
          ).animate().scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
              ),
          const SizedBox(height: 12),
          Text(
            '소리를 듣고 맞는 글자를 고르세요',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const Spacer(),
          // Choice buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: choices.map((choice) {
              final isSelected = _selectedAnswer == choice;
              final isCorrect = choice == answer;
              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade300;

              if (_showFeedback && isSelected) {
                bgColor = isCorrect
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE);
                borderColor = isCorrect
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFF44336);
              } else if (_showFeedback && isCorrect) {
                bgColor = const Color(0xFFE8F5E9);
                borderColor = const Color(0xFF4CAF50);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  onTap: () => _selectAnswer(choice),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 2.5),
                    ),
                    child: Center(
                      child: Text(
                        choice,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
