import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/lesson_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/gamification_provider.dart';
import '../../lesson/boss_quiz_screen.dart';
import 'boss_quiz_node.dart';
import 'lesson_path_node.dart';

/// A chapter group: header + lessons + boss quiz node.
class _ChapterGroup {
  final int week;
  final List<LessonModel> lessons;

  _ChapterGroup({required this.week, required this.lessons});
}

/// Represents an item in the path: either a lesson node, chapter header, or boss node.
enum _PathItemType { chapterHeader, lessonNode, bossNode }

class _PathItem {
  final _PathItemType type;
  final LessonModel? lesson;
  final int? chapterNumber;
  final int? week;
  final List<LessonModel>? chapterLessons;

  _PathItem.lesson(this.lesson) : type = _PathItemType.lessonNode, chapterNumber = null, week = null, chapterLessons = null;
  _PathItem.chapterHeader(this.chapterNumber) : type = _PathItemType.chapterHeader, lesson = null, week = null, chapterLessons = null;
  _PathItem.bossNode({required this.week, required this.chapterLessons, required this.chapterNumber}) : type = _PathItemType.bossNode, lesson = null;
}

/// Displays lessons as a zigzag vertical learning path with lemon-shaped nodes
/// connected by S-curve lines. Groups lessons into chapters by week.
class LessonPathView extends StatelessWidget {
  final List<LessonModel> lessons;
  final Map<int, double> lessonProgress; // lesson_id -> 0.0-1.0
  final Map<int, int> lessonLemons; // lesson_id -> 0-3 lemons earned
  final Color levelColor;
  final void Function(LessonModel lesson) onLessonTap;

  /// Vertical spacing between node centers
  static const double _verticalSpacing = 130.0;

  /// Spacing for chapter headers
  static const double _headerHeight = 60.0;

  /// Max content width (for web)
  static const double _maxWidth = 420.0;

  /// Zigzag alignment pattern: left, center, right, center, ...
  static const List<double> _alignments = [-0.5, 0.0, 0.5, 0.0];

  const LessonPathView({
    required this.lessons,
    required this.lessonProgress,
    required this.levelColor,
    required this.onLessonTap,
    this.lessonLemons = const {},
    super.key,
  });

  /// Group lessons into chapters by week field
  List<_ChapterGroup> _buildChapters() {
    // Check if any lesson has week data
    final hasWeekData = lessons.any((l) => l.week != null);

    if (!hasWeekData) {
      // No week data: treat all lessons as a single chapter
      return [_ChapterGroup(week: 1, lessons: lessons)];
    }

    // Group by week
    final weekMap = <int, List<LessonModel>>{};
    for (final lesson in lessons) {
      final week = lesson.week ?? 1;
      weekMap.putIfAbsent(week, () => []).add(lesson);
    }

    // Sort by week number
    final sortedWeeks = weekMap.keys.toList()..sort();
    return sortedWeeks.map((w) => _ChapterGroup(week: w, lessons: weekMap[w]!)).toList();
  }

  /// Build flat list of path items from chapters
  List<_PathItem> _buildPathItems(List<_ChapterGroup> chapters) {
    final items = <_PathItem>[];

    for (int ci = 0; ci < chapters.length; ci++) {
      final chapter = chapters[ci];
      final chapterNum = ci + 1;

      // Chapter header (skip for single-chapter case)
      if (chapters.length > 1) {
        items.add(_PathItem.chapterHeader(chapterNum));
      }

      // Lesson nodes
      for (final lesson in chapter.lessons) {
        items.add(_PathItem.lesson(lesson));
      }

      // Boss node at end of chapter (skip for single-chapter if no week data)
      if (chapters.length > 1) {
        items.add(_PathItem.bossNode(
          week: chapter.week,
          chapterLessons: chapter.lessons,
          chapterNumber: chapterNum,
        ));
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) return const SizedBox.shrink();

    final chapters = _buildChapters();
    final pathItems = _buildPathItems(chapters);
    final level = lessons.first.level;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;

            // Calculate positions for each item
            int nodeIndex = 0; // only incremented for nodes (not headers)
            final itemPositions = <Offset>[];
            final itemTypes = <_PathItemType>[];
            double currentY = 0;

            for (final item in pathItems) {
              if (item.type == _PathItemType.chapterHeader) {
                itemPositions.add(Offset(availableWidth / 2, currentY + _headerHeight / 2));
                itemTypes.add(item.type);
                currentY += _headerHeight;
              } else {
                // Lesson or boss node
                final align = _alignments[nodeIndex % _alignments.length];
                final cx = availableWidth / 2 +
                    align * (availableWidth / 2 - LessonPathNode.nodeWidth / 2 - 16);
                final cy = currentY + LessonPathNode.nodeHeight / 2;
                itemPositions.add(Offset(cx, cy));
                itemTypes.add(item.type);
                currentY += _verticalSpacing;
                nodeIndex++;
              }
            }

            final totalHeight = currentY + 60; // padding

            return SizedBox(
              height: totalHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background path lines (only between nodes, not headers)
                  CustomPaint(
                    size: Size(availableWidth, totalHeight),
                    painter: _PathRoutePainter(
                      items: pathItems,
                      itemPositions: itemPositions,
                      itemTypes: itemTypes,
                      lessonProgress: lessonProgress,
                      levelColor: levelColor,
                    ),
                  ),

                  // Items
                  for (int i = 0; i < pathItems.length; i++)
                    _buildPathItemWidget(
                      context, pathItems[i], itemPositions[i], i, level,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPathItemWidget(
    BuildContext context,
    _PathItem item,
    Offset position,
    int index,
    int level,
  ) {
    switch (item.type) {
      case _PathItemType.chapterHeader:
        final l10n = AppLocalizations.of(context)!;
        return Positioned(
          left: 0,
          right: 0,
          top: position.dy - _headerHeight / 2,
          child: _buildChapterHeader(
            l10n.chapter,
            item.chapterNumber ?? 1,
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (60 * index).ms),
        );

      case _PathItemType.lessonNode:
        return Positioned(
          left: position.dx - LessonPathNode.nodeWidth / 2,
          top: position.dy - LessonPathNode.nodeHeight / 2,
          child: LessonPathNode(
            lesson: item.lesson!,
            progress: lessonProgress[item.lesson!.id],
            levelColor: levelColor,
            index: index,
            lemonsEarned: lessonLemons[item.lesson!.id] ?? 0,
            onTap: () => onLessonTap(item.lesson!),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (80 * index).ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: (80 * index).ms, curve: Curves.easeOut),
        );

      case _PathItemType.bossNode:
        final chapterLessons = item.chapterLessons ?? [];
        final allCompleted = chapterLessons.every(
          (l) => (lessonProgress[l.id] ?? 0) >= 1.0,
        );
        final gamification = Provider.of<GamificationProvider>(context, listen: false);
        final isCompleted = gamification.isBossQuizCompleted(level, item.week ?? 1);

        return Positioned(
          left: position.dx - BossQuizNode.nodeWidth / 2,
          top: position.dy - BossQuizNode.nodeHeight / 2,
          child: BossQuizNode(
            chapterNumber: item.chapterNumber ?? 1,
            isUnlocked: allCompleted,
            isCompleted: isCompleted,
            levelColor: levelColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BossQuizScreen(
                    chapterLessons: chapterLessons,
                    level: level,
                    week: item.week ?? 1,
                    levelColor: levelColor,
                  ),
                ),
              );
            },
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (80 * index).ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: (80 * index).ms, curve: Curves.easeOut),
        );
    }
  }

  Widget _buildChapterHeader(String label, int number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$label $number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }
}

/// Paints S-curve connection lines between consecutive nodes (skipping headers).
class _PathRoutePainter extends CustomPainter {
  final List<_PathItem> items;
  final List<Offset> itemPositions;
  final List<_PathItemType> itemTypes;
  final Map<int, double> lessonProgress;
  final Color levelColor;

  _PathRoutePainter({
    required this.items,
    required this.itemPositions,
    required this.itemTypes,
    required this.lessonProgress,
    required this.levelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Collect node positions and their lesson progress (skip headers)
    final nodePositions = <Offset>[];
    final nodeItems = <_PathItem>[];

    for (int i = 0; i < items.length; i++) {
      if (itemTypes[i] != _PathItemType.chapterHeader) {
        nodePositions.add(itemPositions[i]);
        nodeItems.add(items[i]);
      }
    }

    for (int i = 0; i < nodePositions.length - 1; i++) {
      final from = nodePositions[i];
      final to = nodePositions[i + 1];

      // Determine if segment is "completed"
      bool isCompleted = false;
      final fromItem = nodeItems[i];
      if (fromItem.type == _PathItemType.lessonNode && fromItem.lesson != null) {
        final fromProgress = lessonProgress[fromItem.lesson!.id];
        isCompleted = fromProgress != null && fromProgress >= 1.0;
      } else if (fromItem.type == _PathItemType.bossNode) {
        // Boss node segment is completed if boss is completed (check all chapter lessons)
        final chapterLessons = fromItem.chapterLessons ?? [];
        isCompleted = chapterLessons.every(
          (l) => (lessonProgress[l.id] ?? 0) >= 1.0,
        );
      }

      final paint = Paint()
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (isCompleted) {
        paint.color = levelColor;
      } else {
        paint.color = Colors.grey.shade300;
      }

      // Build S-curve path
      final midY = (from.dy + to.dy) / 2;
      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..cubicTo(
          from.dx, midY,
          to.dx, midY,
          to.dx, to.dy,
        );

      if (isCompleted) {
        canvas.drawPath(path, paint);
      } else {
        _drawDashedPath(canvas, path, paint, dashWidth: 8, gapWidth: 4);
      }
    }
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    double dashWidth = 8,
    double gapWidth = 4,
  }) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0, metric.length).toDouble();
        final extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PathRoutePainter oldDelegate) => true;
}
