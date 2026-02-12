import 'dart:ui' as ui;

import 'package:flame/components.dart';

/// Character name label rendered above a character.
class NameLabel extends PositionComponent {
  String name;
  final bool isLocalPlayer;

  ui.Paragraph? _paragraph;
  double _labelWidth = 0;

  NameLabel({
    required this.name,
    this.isLocalPlayer = false,
  }) : super(
    size: Vector2(100, 20),
    anchor: Anchor.bottomCenter,
  );

  @override
  void onLoad() {
    _buildParagraph();
  }

  void updateName(String newName) {
    if (name == newName) return;
    name = newName;
    _buildParagraph();
  }

  void _buildParagraph() {
    final displayName = isLocalPlayer ? '$name (You)' : name;

    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontSize: 10,
      maxLines: 1,
      ellipsis: '...',
    ))
      ..pushStyle(ui.TextStyle(
        color: isLocalPlayer
            ? const ui.Color(0xFF212121)
            : const ui.Color(0xFFFFFFFF),
        fontSize: 10,
        fontWeight: ui.FontWeight.w600,
      ))
      ..addText(displayName);

    _paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: 100));

    _labelWidth = _paragraph!.longestLine + 12;
  }

  @override
  void render(ui.Canvas canvas) {
    if (_paragraph == null) return;

    final bgColor = isLocalPlayer
        ? const ui.Color(0xCCFFC107) // amber
        : const ui.Color(0x88000000); // black54

    final bgRect = ui.RRect.fromRectAndRadius(
      ui.Rect.fromCenter(
        center: ui.Offset(size.x / 2, size.y / 2),
        width: _labelWidth,
        height: 16,
      ),
      const ui.Radius.circular(8),
    );

    canvas.drawRRect(bgRect, ui.Paint()..color = bgColor);
    canvas.drawParagraph(
      _paragraph!,
      ui.Offset(0, (size.y - _paragraph!.height) / 2),
    );
  }
}
