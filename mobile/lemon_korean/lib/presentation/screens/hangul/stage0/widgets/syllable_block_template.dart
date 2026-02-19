import 'package:flutter/material.dart';

/// Visualizes a consonant + vowel syllable block with two labeled slots.
/// Used as the "target" area for drag-drop and syllable-build steps.
class SyllableBlockTemplate extends StatelessWidget {
  final String? consonant;
  final String? vowel;
  final bool consonantFilled;
  final bool vowelFilled;
  final bool showResult;
  final String? resultChar;

  const SyllableBlockTemplate({
    this.consonant,
    this.vowel,
    this.consonantFilled = false,
    this.vowelFilled = false,
    this.showResult = false,
    this.resultChar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (showResult && resultChar != null) {
      return _buildResult();
    }
    return _buildSlots();
  }

  Widget _buildResult() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD54F), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          resultChar!,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildSlots() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Consonant slot
          _Slot(
            label: '자음',
            char: consonant,
            isFilled: consonantFilled,
            color: const Color(0xFF42A5F5),
          ),
          const SizedBox(width: 8),
          const Text('+', style: TextStyle(fontSize: 20, color: Colors.grey)),
          const SizedBox(width: 8),
          // Vowel slot
          _Slot(
            label: '모음',
            char: vowel,
            isFilled: vowelFilled,
            color: const Color(0xFFEF5350),
          ),
        ],
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  final String label;
  final String? char;
  final bool isFilled;
  final Color color;

  const _Slot({
    required this.label,
    this.char,
    required this.isFilled,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 72,
      decoration: BoxDecoration(
        color: isFilled ? color.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFilled ? color : Colors.grey.shade300,
          width: isFilled ? 2.5 : 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isFilled && char != null)
            Text(
              char!,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            )
          else ...[
            Icon(Icons.add, size: 20, color: Colors.grey.shade400),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ],
      ),
    );
  }
}
