import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';
import '../widgets/countdown_timer_widget.dart';

/// Timed mission: build N random syllables within a time limit.
class StepTimedMission extends StatefulWidget {
  final LessonStep step;
  final void Function(int timeSeconds, int completed) onCompleted;

  const StepTimedMission({
    required this.step,
    required this.onCompleted,
    super.key,
  });

  @override
  State<StepTimedMission> createState() => _StepTimedMissionState();
}

class _StepTimedMissionState extends State<StepTimedMission> {
  final _random = Random();
  final _timerKey = GlobalKey<CountdownTimerWidgetState>();

  late final int _timeLimit;
  late final int _targetCount;
  late final List<String> _consonants;
  late final List<String> _vowels;

  int _completedCount = 0;
  bool _isDone = false;

  // Current puzzle
  late String _targetConsonant;
  late String _targetVowel;
  late String _targetResult;
  String? _selectedConsonant;
  String? _selectedVowel;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _timeLimit = widget.step.data['timeLimitSeconds'] as int? ?? 180;
    _targetCount = widget.step.data['targetCount'] as int? ?? 5;
    _consonants = (widget.step.data['consonants'] as List?)?.cast<String>() ?? ['ㄱ', 'ㄴ', 'ㄷ'];
    _vowels = (widget.step.data['vowels'] as List?)?.cast<String>() ?? ['ㅏ', 'ㅗ'];
    _generatePuzzle();
  }

  void _generatePuzzle() {
    _targetConsonant = _consonants[_random.nextInt(_consonants.length)];
    _targetVowel = _vowels[_random.nextInt(_vowels.length)];
    _targetResult = _combineSyllable(_targetConsonant, _targetVowel);
    _selectedConsonant = null;
    _selectedVowel = null;
    _showResult = false;
  }

  /// Simple syllable combination for ㄱㄴㄷ + ㅏㅗ.
  String _combineSyllable(String consonant, String vowel) {
    const consonantMap = {'ㄱ': 0, 'ㄴ': 2, 'ㄷ': 3};
    const vowelMap = {'ㅏ': 0, 'ㅗ': 8};
    final cIndex = consonantMap[consonant] ?? 0;
    final vIndex = vowelMap[vowel] ?? 0;
    final code = 0xAC00 + (cIndex * 21 + vIndex) * 28;
    return String.fromCharCode(code);
  }

  void _selectConsonant(String c) {
    if (_showResult || _isDone) return;
    setState(() => _selectedConsonant = c);
    _checkMatch();
  }

  void _selectVowel(String v) {
    if (_showResult || _isDone) return;
    setState(() => _selectedVowel = v);
    _checkMatch();
  }

  void _checkMatch() {
    if (_selectedConsonant == null || _selectedVowel == null) return;

    if (_selectedConsonant == _targetConsonant && _selectedVowel == _targetVowel) {
      setState(() {
        _showResult = true;
        _completedCount++;
      });

      if (_completedCount >= _targetCount) {
        _finish();
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted && !_isDone) {
            setState(() => _generatePuzzle());
          }
        });
      }
    } else {
      // Wrong — reset selection
      setState(() {
        _selectedConsonant = null;
        _selectedVowel = null;
      });
    }
  }

  void _finish() {
    if (_isDone) return;
    _isDone = true;
    final elapsed = _timerKey.currentState?.elapsed ?? 0;
    _timerKey.currentState?.stop();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        widget.onCompleted(elapsed, _completedCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Timer + progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CountdownTimerWidget(
                key: _timerKey,
                totalSeconds: _timeLimit,
                onTimeUp: _finish,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_completedCount / $_targetCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
          // Target display
          Text(
            '"$_targetResult" 만들기',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Result or slots
          if (_showResult)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF4CAF50), width: 3),
              ),
              child: Center(
                child: Text(
                  _targetResult,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ).animate().scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 300.ms,
                  curve: Curves.easeOutBack,
                )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSlot(_selectedConsonant, '자음', const Color(0xFF42A5F5)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('+', style: TextStyle(fontSize: 24, color: Colors.grey)),
                ),
                _buildSlot(_selectedVowel, '모음', const Color(0xFFEF5350)),
              ],
            ),
          const Spacer(),
          // Consonant choices
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _consonants.map((c) {
              final isSelected = _selectedConsonant == c;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => _selectConsonant(c),
                  child: _buildChoiceTile(c, isSelected, const Color(0xFF42A5F5)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Vowel choices
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _vowels.map((v) {
              final isSelected = _selectedVowel == v;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => _selectVowel(v),
                  child: _buildChoiceTile(v, isSelected, const Color(0xFFEF5350)),
                ),
              );
            }).toList(),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildSlot(String? char, String label, Color color) {
    return Container(
      width: 72,
      height: 80,
      decoration: BoxDecoration(
        color: char != null ? color.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: char != null ? color : Colors.grey.shade300,
          width: char != null ? 2.5 : 1.5,
        ),
      ),
      child: Center(
        child: char != null
            ? Text(
                char,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
              )
            : Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ),
    );
  }

  Widget _buildChoiceTile(String char, bool isSelected, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.2) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2.5 : 1.5,
        ),
      ),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isSelected ? color : Colors.black87,
          ),
        ),
      ),
    );
  }
}
