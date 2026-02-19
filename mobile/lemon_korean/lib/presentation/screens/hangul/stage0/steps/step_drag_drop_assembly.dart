import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';
import '../widgets/draggable_character_tile.dart';
import '../widgets/syllable_block_template.dart';

/// Drag-drop assembly: user drags consonant and vowel into slots.
class StepDragDropAssembly extends StatefulWidget {
  final LessonStep step;
  final void Function(int correct, int total) onCompleted;

  const StepDragDropAssembly({
    required this.step,
    required this.onCompleted,
    super.key,
  });

  @override
  State<StepDragDropAssembly> createState() => _StepDragDropAssemblyState();
}

class _StepDragDropAssemblyState extends State<StepDragDropAssembly> {
  late final List<Map<String, String>> _items;
  int _currentIndex = 0;
  String? _droppedConsonant;
  String? _droppedVowel;
  bool _showResult = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    final rawItems = widget.step.data['items'] as List? ?? [];
    _items = rawItems.cast<Map<String, dynamic>>().map((e) {
      return {
        'consonant': e['consonant'] as String,
        'vowel': e['vowel'] as String,
        'result': e['result'] as String,
      };
    }).toList();
  }

  Map<String, String> get _current => _items[_currentIndex];
  bool get _isLastItem => _currentIndex >= _items.length - 1;

  void _onConsonantAccepted(String char) {
    if (char == _current['consonant']) {
      setState(() => _droppedConsonant = char);
      _checkComplete();
    }
  }

  void _onVowelAccepted(String char) {
    if (char == _current['vowel']) {
      setState(() => _droppedVowel = char);
      _checkComplete();
    }
  }

  void _checkComplete() {
    if (_droppedConsonant != null && _droppedVowel != null) {
      _correctCount++;
      setState(() => _showResult = true);
      // Auto-advance after showing result
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (_isLastItem) {
          widget.onCompleted(_correctCount, _items.length);
        } else {
          setState(() {
            _currentIndex++;
            _droppedConsonant = null;
            _droppedVowel = null;
            _showResult = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final consonant = _current['consonant']!;
    final vowel = _current['vowel']!;
    final result = _current['result']!;

    // Available draggable characters (pool)
    final allConsonants = ['ㄱ', 'ㄴ', 'ㄷ'];
    final allVowels = ['ㅏ', 'ㅗ'];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Title
          Text(
            widget.step.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (widget.step.description != null)
            Text(
              widget.step.description!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          // Progress indicator
          if (_items.length > 1)
            Text(
              '${_currentIndex + 1} / ${_items.length}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          const Spacer(flex: 2),
          // Target area (drop zones)
          _buildDropArea(consonant, vowel, result),
          const Spacer(),
          // Draggable characters pool
          _buildCharacterPool(allConsonants, allVowels),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildDropArea(String consonant, String vowel, String result) {
    if (_showResult) {
      return SyllableBlockTemplate(
        showResult: true,
        resultChar: result,
      ).animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: 400.ms,
            curve: Curves.easeOutBack,
          );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Consonant drop zone
        DragTarget<String>(
          onWillAcceptWithDetails: (details) =>
              details.data == consonant && _droppedConsonant == null,
          onAcceptWithDetails: (details) => _onConsonantAccepted(details.data),
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 80,
              decoration: BoxDecoration(
                color: _droppedConsonant != null
                    ? const Color(0xFF42A5F5).withValues(alpha: 0.15)
                    : isHovering
                        ? const Color(0xFF42A5F5).withValues(alpha: 0.08)
                        : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isHovering ? const Color(0xFF42A5F5) : Colors.grey.shade300,
                  width: isHovering ? 2.5 : 1.5,
                ),
              ),
              child: Center(
                child: _droppedConsonant != null
                    ? Text(
                        _droppedConsonant!,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF42A5F5),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.grey.shade400, size: 22),
                          Text('자음', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        ],
                      ),
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('+', style: TextStyle(fontSize: 24, color: Colors.grey)),
        ),
        // Vowel drop zone
        DragTarget<String>(
          onWillAcceptWithDetails: (details) =>
              details.data == vowel && _droppedVowel == null,
          onAcceptWithDetails: (details) => _onVowelAccepted(details.data),
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 80,
              decoration: BoxDecoration(
                color: _droppedVowel != null
                    ? const Color(0xFFEF5350).withValues(alpha: 0.15)
                    : isHovering
                        ? const Color(0xFFEF5350).withValues(alpha: 0.08)
                        : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isHovering ? const Color(0xFFEF5350) : Colors.grey.shade300,
                  width: isHovering ? 2.5 : 1.5,
                ),
              ),
              child: Center(
                child: _droppedVowel != null
                    ? Text(
                        _droppedVowel!,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF5350),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.grey.shade400, size: 22),
                          Text('모음', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCharacterPool(List<String> consonants, List<String> vowels) {
    return Column(
      children: [
        // Consonants row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: consonants.map((c) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: DraggableCharacterTile(
                character: c,
                color: const Color(0xFF42A5F5),
                isUsed: c == _droppedConsonant,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Vowels row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: vowels.map((v) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: DraggableCharacterTile(
                character: v,
                color: const Color(0xFFEF5350),
                isUsed: v == _droppedVowel,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
