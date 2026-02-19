import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';
import '../widgets/syllable_block_template.dart';

/// Syllable build step: tap consonant + vowel to create a syllable.
class StepSyllableBuild extends StatefulWidget {
  final LessonStep step;
  final void Function(int correct, int total) onCompleted;

  const StepSyllableBuild({
    required this.step,
    required this.onCompleted,
    super.key,
  });

  @override
  State<StepSyllableBuild> createState() => _StepSyllableBuildState();
}

class _StepSyllableBuildState extends State<StepSyllableBuild> {
  late final List<_BuildTarget> _targets;
  int _currentTargetIndex = 0;
  String? _selectedConsonant;
  String? _selectedVowel;
  bool _showResult = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _targets = _parseTargets();
  }

  List<_BuildTarget> _parseTargets() {
    // Check for multi-target format
    final targetsRaw = widget.step.data['targets'] as List?;
    if (targetsRaw != null) {
      return targetsRaw.cast<Map<String, dynamic>>().map((t) {
        return _BuildTarget(
          consonant: t['consonant'] as String,
          vowel: t['vowel'] as String,
          result: t['result'] as String,
        );
      }).toList();
    }
    // Single target
    return [
      _BuildTarget(
        consonant: widget.step.data['targetConsonant'] as String? ?? 'ㄱ',
        vowel: widget.step.data['targetVowel'] as String? ?? 'ㅏ',
        result: widget.step.data['result'] as String? ?? '가',
      ),
    ];
  }

  List<String> get _consonantChoices =>
      (widget.step.data['consonantChoices'] as List?)?.cast<String>() ??
      ['ㄱ', 'ㄴ', 'ㄷ'];
  List<String> get _vowelChoices =>
      (widget.step.data['vowelChoices'] as List?)?.cast<String>() ?? ['ㅏ', 'ㅗ'];

  _BuildTarget get _current => _targets[_currentTargetIndex];

  void _selectConsonant(String c) {
    if (_showResult) return;
    setState(() => _selectedConsonant = c);
    _checkMatch();
  }

  void _selectVowel(String v) {
    if (_showResult) return;
    setState(() => _selectedVowel = v);
    _checkMatch();
  }

  void _checkMatch() {
    if (_selectedConsonant == null || _selectedVowel == null) return;

    final isCorrect =
        _selectedConsonant == _current.consonant && _selectedVowel == _current.vowel;

    if (isCorrect) {
      _correctCount++;
      setState(() => _showResult = true);

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (_currentTargetIndex < _targets.length - 1) {
          setState(() {
            _currentTargetIndex++;
            _selectedConsonant = null;
            _selectedVowel = null;
            _showResult = false;
          });
        } else {
          widget.onCompleted(_correctCount, _targets.length);
        }
      });
    } else {
      // Wrong — shake and reset
      setState(() {
        _selectedConsonant = null;
        _selectedVowel = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (_targets.length > 1) ...[
            const SizedBox(height: 8),
            Text(
              '${_currentTargetIndex + 1} / ${_targets.length}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
          const Spacer(flex: 2),
          // Target display
          Text(
            '"${_current.result}" 만들기',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          SyllableBlockTemplate(
            consonant: _selectedConsonant,
            vowel: _selectedVowel,
            consonantFilled: _selectedConsonant != null,
            vowelFilled: _selectedVowel != null,
            showResult: _showResult,
            resultChar: _current.result,
          ).animate().fadeIn(duration: 300.ms),
          const Spacer(),
          // Consonant choices
          Text('자음 선택', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _consonantChoices.map((c) {
              final isSelected = _selectedConsonant == c;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => _selectConsonant(c),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF42A5F5).withValues(alpha: 0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF42A5F5)
                            : Colors.grey.shade300,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        c,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF42A5F5) : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Vowel choices
          Text('모음 선택', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _vowelChoices.map((v) {
              final isSelected = _selectedVowel == v;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => _selectVowel(v),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEF5350).withValues(alpha: 0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFEF5350)
                            : Colors.grey.shade300,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        v,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFFEF5350) : Colors.black87,
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

class _BuildTarget {
  final String consonant;
  final String vowel;
  final String result;

  const _BuildTarget({
    required this.consonant,
    required this.vowel,
    required this.result,
  });
}
