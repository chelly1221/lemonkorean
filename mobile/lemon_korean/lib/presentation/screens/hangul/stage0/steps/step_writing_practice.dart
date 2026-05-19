import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../widgets/writing_canvas.dart';
import '../stage0_lesson_content.dart';

/// Writing practice step: cycle through characters with 3 phases
/// (animation -> trace -> freehand) per character.
class StepWritingPractice extends StatefulWidget {
  final LessonStep step;
  final VoidCallback onNext;

  const StepWritingPractice({
    required this.step,
    required this.onNext,
    super.key,
  });

  @override
  State<StepWritingPractice> createState() => _StepWritingPracticeState();
}

class _StepWritingPracticeState extends State<StepWritingPractice> {
  int _currentCharIndex = 0;
  WritingMode _currentMode = WritingMode.animation;
  double _accuracy = 0.0;
  bool _phaseCompleted = false;

  // Unique key to force WritingCanvas rebuild when character/mode changes
  int _canvasKey = 0;

  List<String> get _characters {
    final chars = widget.step.data['characters'] as List?;
    return chars?.cast<String>() ?? [];
  }

  WritingMode get _initialMode {
    final mode = widget.step.data['mode'] as String?;
    switch (mode) {
      case 'animation':
        return WritingMode.animation;
      case 'freehand':
        return WritingMode.freehand;
      case 'trace':
      default:
        return WritingMode.traceWithGuide;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentMode = _initialMode;
  }

  int get _phaseNumber {
    switch (_currentMode) {
      case WritingMode.animation:
        return 1;
      case WritingMode.traceWithGuide:
        return 2;
      case WritingMode.freehand:
        return 3;
    }
  }

  String get _phaseLabel {
    switch (_currentMode) {
      case WritingMode.animation:
        return '획순 보기';
      case WritingMode.traceWithGuide:
        return '따라 쓰기';
      case WritingMode.freehand:
        return '자유 쓰기';
    }
  }

  void _advancePhase() {
    setState(() {
      _accuracy = 0.0;
      _phaseCompleted = false;
      _canvasKey++;

      switch (_currentMode) {
        case WritingMode.animation:
          _currentMode = WritingMode.traceWithGuide;
          break;
        case WritingMode.traceWithGuide:
          _currentMode = WritingMode.freehand;
          break;
        case WritingMode.freehand:
          // Move to next character or finish
          if (_currentCharIndex < _characters.length - 1) {
            _currentCharIndex++;
            _currentMode = _initialMode;
          } else {
            // All characters done
            widget.onNext();
            return;
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chars = _characters;
    if (chars.isEmpty) {
      return const Center(child: Text('No characters defined'));
    }

    final currentChar = chars[_currentCharIndex];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Title
          Text(
            widget.step.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (widget.step.description != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.step.description!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 12),

          // Character tabs (if multiple)
          if (chars.length > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(chars.length, (i) {
                  final isActive = i == _currentCharIndex;
                  final isDone = i < _currentCharIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDone
                            ? Colors.green.shade100
                            : isActive
                                ? const Color(0xFFFFD54F)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: isActive
                            ? Border.all(
                                color: const Color(0xFFF9A825), width: 2)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDone)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.check_circle,
                                  size: 16, color: Colors.green),
                            ),
                          Text(
                            chars[i],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isActive || isDone
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

          const SizedBox(height: 12),

          // Phase indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPhaseIndicator(1, '획순 보기'),
              _buildPhaseConnector(1),
              _buildPhaseIndicator(2, '따라 쓰기'),
              _buildPhaseConnector(2),
              _buildPhaseIndicator(3, '자유 쓰기'),
            ],
          ),

          const SizedBox(height: 8),

          // Phase title
          Text(
            _phaseLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          // Writing canvas
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: WritingCanvas(
                key: ValueKey('canvas_${_canvasKey}_${currentChar}_$_currentMode'),
                character: currentChar,
                mode: _currentMode,
                onComplete: () {
                  setState(() => _phaseCompleted = true);
                },
                onAccuracyCalculated: (accuracy) {
                  setState(() {
                    _accuracy = accuracy;
                    _phaseCompleted = accuracy >= 0.4;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Accuracy display for non-animation modes
          if (_currentMode != WritingMode.animation && _accuracy > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _accuracy >= 0.8
                    ? Colors.green.shade100
                    : _accuracy >= 0.5
                        ? Colors.orange.shade100
                        : Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _accuracy >= 0.8
                        ? Icons.check_circle
                        : _accuracy >= 0.5
                            ? Icons.warning
                            : Icons.error,
                    size: 20,
                    color: _accuracy >= 0.8
                        ? Colors.green
                        : _accuracy >= 0.5
                            ? Colors.orange
                            : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '정확도: ${(_accuracy * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _accuracy >= 0.8
                          ? Colors.green.shade900
                          : _accuracy >= 0.5
                              ? Colors.orange.shade900
                              : Colors.red.shade900,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Next button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed:
                  (_currentMode == WritingMode.animation || _phaseCompleted)
                      ? _advancePhase
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: Text(
                (_currentMode == WritingMode.freehand &&
                        _currentCharIndex >= _characters.length - 1)
                    ? '완료'
                    : '다음',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator(int phase, String label) {
    final isActive = _phaseNumber == phase;
    final isCompleted = _phaseNumber > phase;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : isActive
                    ? AppConstants.primaryColor
                    : Colors.grey.shade300,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '$phase',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: 56,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: isActive ? Colors.black87 : Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseConnector(int afterPhase) {
    final isCompleted = _phaseNumber > afterPhase;
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isCompleted ? Colors.green : Colors.grey.shade300,
    );
  }
}
