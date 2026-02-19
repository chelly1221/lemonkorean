import 'package:flutter/material.dart';

/// A draggable tile for a Korean character (consonant or vowel).
class DraggableCharacterTile extends StatelessWidget {
  final String character;
  final Color color;
  final bool isUsed;

  const DraggableCharacterTile({
    required this.character,
    required this.color,
    this.isUsed = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isUsed) {
      return Opacity(
        opacity: 0.3,
        child: _buildTile(),
      );
    }

    return Draggable<String>(
      data: character,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.15,
          child: _buildTile(shadow: true),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildTile()),
      child: _buildTile(),
    );
  }

  Widget _buildTile({bool shadow = false}) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 2),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          character,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: color.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}
