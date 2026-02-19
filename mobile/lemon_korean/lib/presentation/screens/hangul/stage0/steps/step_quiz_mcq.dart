import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';

/// Multiple-choice quiz step.
class StepQuizMcq extends StatefulWidget {
  final LessonStep step;
  final void Function(int correct, int total) onCompleted;

  const StepQuizMcq({
    required this.step,
    required this.onCompleted,
    super.key,
  });

  @override
  State<StepQuizMcq> createState() => _StepQuizMcqState();
}

class _StepQuizMcqState extends State<StepQuizMcq> {
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
  }

  Map<String, dynamic> get _current => _questions[_currentIndex];

  void _selectAnswer(String choice) {
    if (_showFeedback) return;
    final correct = _current['answer'] as String;
    if (choice == correct) _correctCount++;

    setState(() {
      _selectedAnswer = choice;
      _showFeedback = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _showFeedback = false;
        });
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

    final question = _current['question'] as String;
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
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_questions.length, (i) {
              Color dotColor;
              if (i < _currentIndex) {
                dotColor = const Color(0xFF4CAF50);
              } else if (i == _currentIndex) {
                dotColor = const Color(0xFFFFD54F);
              } else {
                dotColor = Colors.grey.shade300;
              }
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              );
            }),
          ),
          const Spacer(flex: 2),
          // Question
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate().fadeIn(duration: 300.ms),
          const Spacer(),
          // Choice grid (2x2)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: choices.map((choice) {
              final isSelected = _selectedAnswer == choice;
              final isCorrect = choice == answer;
              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade300;
              Color textColor = Colors.black87;

              if (_showFeedback) {
                if (isSelected && isCorrect) {
                  bgColor = const Color(0xFFE8F5E9);
                  borderColor = const Color(0xFF4CAF50);
                  textColor = const Color(0xFF2E7D32);
                } else if (isSelected && !isCorrect) {
                  bgColor = const Color(0xFFFFEBEE);
                  borderColor = const Color(0xFFF44336);
                  textColor = const Color(0xFFC62828);
                } else if (isCorrect) {
                  bgColor = const Color(0xFFE8F5E9);
                  borderColor = const Color(0xFF4CAF50);
                }
              }

              return GestureDetector(
                onTap: () => _selectAnswer(choice),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 140,
                  height: 64,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      choice,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
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
