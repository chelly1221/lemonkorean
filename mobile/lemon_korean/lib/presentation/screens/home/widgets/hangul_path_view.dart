import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'lemon_clipper.dart';
import '../../hangul/hangul_main_screen.dart';

/// Hangul section data for level 0 inline path view.
class _HangulSection {
  final IconData icon;
  final String titleKo;
  final String title;
  final int tabIndex;

  const _HangulSection({
    required this.icon,
    required this.titleKo,
    required this.title,
    required this.tabIndex,
  });
}

/// Displays hangul sections as a zigzag vertical path matching LessonPathView style.
class HangulPathView extends StatelessWidget {
  static const _levelColor = Color(0xFF5BA3EC); // Level 0 blue

  static const double _verticalSpacing = 130.0;
  static const double _maxWidth = 420.0;
  static const double _nodeWidth = 80.0;
  static const double _nodeHeight = 90.0;
  static const List<double> _alignments = [-0.5, 0.0, 0.5, 0.0];

  static const _sections = [
    _HangulSection(icon: Icons.grid_view, titleKo: '자모표', title: 'Alphabet Table', tabIndex: 0),
    _HangulSection(icon: Icons.school, titleKo: '학습', title: 'Learn', tabIndex: 1),
    _HangulSection(icon: Icons.quiz, titleKo: '연습', title: 'Practice', tabIndex: 2),
    _HangulSection(icon: Icons.sports_esports, titleKo: '활동', title: 'Activities', tabIndex: 3),
  ];

  const HangulPathView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final totalHeight =
                _verticalSpacing * (_sections.length - 1) +
                _nodeHeight +
                60;

            final nodePositions = <Offset>[];
            for (int i = 0; i < _sections.length; i++) {
              final align = _alignments[i % _alignments.length];
              final cx = availableWidth / 2 +
                  align * (availableWidth / 2 - _nodeWidth / 2 - 16);
              final cy = _verticalSpacing * i + _nodeHeight / 2;
              nodePositions.add(Offset(cx, cy));
            }

            return SizedBox(
              height: totalHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background path lines
                  CustomPaint(
                    size: Size(availableWidth, totalHeight),
                    painter: _HangulPathPainter(
                      nodePositions: nodePositions,
                      color: _levelColor,
                    ),
                  ),

                  // Section nodes
                  for (int i = 0; i < _sections.length; i++)
                    Positioned(
                      left: nodePositions[i].dx - _nodeWidth / 2,
                      top: nodePositions[i].dy - _nodeHeight / 2,
                      child: _HangulPathNode(
                        section: _sections[i],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HangulMainScreen(
                                initialTabIndex: _sections[i].tabIndex,
                              ),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: (80 * i).ms,
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 400.ms,
                            delay: (80 * i).ms,
                            curve: Curves.easeOut,
                          ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A single lemon-shaped node for a hangul section.
class _HangulPathNode extends StatelessWidget {
  final _HangulSection section;
  final VoidCallback onTap;

  static const double nodeWidth = 80;
  static const double nodeHeight = 90;
  static const _levelColor = Color(0xFF5BA3EC);

  const _HangulPathNode({
    required this.section,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: nodeWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: nodeWidth,
              height: nodeHeight,
              child: CustomPaint(
                painter: LemonShapePainter(
                  color: _levelColor,
                  isFilled: false,
                  strokeWidth: 3.0,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(
                      section.icon,
                      color: _levelColor,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              section.titleKo,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              section.title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints S-curve connection lines between consecutive hangul nodes.
class _HangulPathPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final Color color;

  _HangulPathPainter({
    required this.nodePositions,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.4);

    for (int i = 0; i < nodePositions.length - 1; i++) {
      final from = nodePositions[i];
      final to = nodePositions[i + 1];

      final midY = (from.dy + to.dy) / 2;
      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..cubicTo(
          from.dx, midY,
          to.dx, midY,
          to.dx, to.dy,
        );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HangulPathPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.nodePositions != nodePositions;
  }
}
