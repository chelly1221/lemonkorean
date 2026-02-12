import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui' show Color;

import 'package:flame/events.dart';
import 'package:flame/components.dart';

import '../mini_game_base.dart';

/// Hangul syllable construction word puzzle.
///
/// Displays scattered jamo (consonants/vowels) that the player
/// drags into slots to form a target Korean syllable.
class WordPuzzleGame extends MiniGameBase with TapCallbacks, DragCallbacks {
  List<_PuzzleRound> _rounds = [];
  int _currentRound = 0;
  int _correctCount = 0;
  _PuzzleState _state = _PuzzleState.loading;

  // Drag state
  int? _draggedJamoIndex;
  Vector2 _dragOffset = Vector2.zero();

  // Timer
  double _roundTimer = 0;
  static const double _roundTimeLimit = 15.0;

  // Jamo tiles
  final List<_JamoTile> _jamoTiles = [];
  final List<_SlotArea> _slots = [];

  @override
  Color backgroundColor() => const ui.Color(0xFF1A237E);

  @override
  Future<void> startGame(Map<String, dynamic> gameData) async {
    final roundList = gameData['rounds'] as List<dynamic>? ?? [];
    _rounds = roundList.map((r) {
      final rMap = r as Map<String, dynamic>;
      return _PuzzleRound(
        targetSyllable: rMap['syllable'] as String? ?? '',
        jamo: (rMap['jamo'] as List<dynamic>?)
                ?.map((j) => j.toString())
                .toList() ??
            [],
        distractors: (rMap['distractors'] as List<dynamic>?)
                ?.map((d) => d.toString())
                .toList() ??
            [],
      );
    }).toList();

    if (_rounds.isEmpty) {
      // Sample rounds for testing
      _rounds = [
        _PuzzleRound(targetSyllable: '한', jamo: ['ㅎ', 'ㅏ', 'ㄴ'], distractors: ['ㄱ', 'ㅓ']),
        _PuzzleRound(targetSyllable: '글', jamo: ['ㄱ', 'ㅡ', 'ㄹ'], distractors: ['ㅂ', 'ㅜ']),
        _PuzzleRound(targetSyllable: '학', jamo: ['ㅎ', 'ㅏ', 'ㄱ'], distractors: ['ㅈ', 'ㅣ']),
      ];
    }

    _state = _PuzzleState.playing;
    _setupRound();
  }

  void _setupRound() {
    if (_currentRound >= _rounds.length) {
      _state = _PuzzleState.complete;
      onGameComplete?.call(_correctCount, _rounds.length);
      return;
    }

    final round = _rounds[_currentRound];
    _roundTimer = 0;

    // Create jamo tiles (correct + distractors, shuffled)
    final allJamo = [...round.jamo, ...round.distractors];
    allJamo.shuffle(Random());

    _jamoTiles.clear();
    final startX = (size.x - allJamo.length * 50) / 2;
    for (int i = 0; i < allJamo.length; i++) {
      _jamoTiles.add(_JamoTile(
        text: allJamo[i],
        originalPosition: Vector2(startX + i * 50, size.y * 0.7),
        position: Vector2(startX + i * 50, size.y * 0.7),
      ));
    }

    // Create slots (one per correct jamo)
    _slots.clear();
    final slotStartX = (size.x - round.jamo.length * 55) / 2;
    for (int i = 0; i < round.jamo.length; i++) {
      _slots.add(_SlotArea(
        expectedJamo: round.jamo[i],
        position: Vector2(slotStartX + i * 55, size.y * 0.4),
        placedJamo: null,
      ));
    }

    _draggedJamoIndex = null;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state == _PuzzleState.playing) {
      _roundTimer += dt;
      if (_roundTimer >= _roundTimeLimit) {
        _nextRound(correct: false);
      }
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_state != _PuzzleState.playing) return;

    for (int i = 0; i < _jamoTiles.length; i++) {
      final tile = _jamoTiles[i];
      final rect = ui.Rect.fromLTWH(tile.position.x, tile.position.y, 40, 40);
      if (rect.contains(event.canvasPosition.toOffset())) {
        _draggedJamoIndex = i;
        _dragOffset = event.canvasPosition - tile.position;
        return;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_draggedJamoIndex == null) return;
    _jamoTiles[_draggedJamoIndex!].position =
        event.canvasStartPosition + event.localDelta - _dragOffset;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_draggedJamoIndex == null) return;

    final tile = _jamoTiles[_draggedJamoIndex!];

    // Check if dropped on a slot
    bool placed = false;
    for (final slot in _slots) {
      if (slot.placedJamo != null) continue;
      final slotRect = ui.Rect.fromLTWH(slot.position.x, slot.position.y, 45, 45);
      if (slotRect.contains(tile.position.toOffset())) {
        slot.placedJamo = tile.text;
        tile.position = Vector2(slot.position.x + 2.5, slot.position.y + 2.5);
        placed = true;
        break;
      }
    }

    if (!placed) {
      // Return to original position
      tile.position = tile.originalPosition.clone();
    }

    _draggedJamoIndex = null;

    // Check if all slots are filled
    if (_slots.every((s) => s.placedJamo != null)) {
      final correct = _slots.every((s) => s.placedJamo == s.expectedJamo);
      _nextRound(correct: correct);
    }
  }

  void _nextRound({required bool correct}) {
    if (correct) _correctCount++;
    _currentRound++;
    _setupRound();
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);

    switch (_state) {
      case _PuzzleState.loading:
        _renderCenteredText(canvas, 'Loading...');
      case _PuzzleState.playing:
        _renderPlaying(canvas);
      case _PuzzleState.complete:
        _renderComplete(canvas);
    }
  }

  void _renderPlaying(ui.Canvas canvas) {
    final round = _rounds[_currentRound];

    // Target syllable
    _renderText(canvas, 'Build this syllable:', size.x / 2, size.y * 0.1,
        fontSize: 14, color: const ui.Color(0x99FFFFFF));
    _renderText(canvas, round.targetSyllable, size.x / 2, size.y * 0.15,
        fontSize: 48, color: const ui.Color(0xFFFFFFFF));

    // Timer bar
    final timerWidth = size.x * 0.6;
    final timerProgress = 1.0 - (_roundTimer / _roundTimeLimit);
    final timerX = (size.x - timerWidth) / 2;
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(timerX, size.y * 0.3, timerWidth, 6),
        const ui.Radius.circular(3),
      ),
      ui.Paint()..color = const ui.Color(0x33FFFFFF),
    );
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(timerX, size.y * 0.3, timerWidth * timerProgress, 6),
        const ui.Radius.circular(3),
      ),
      ui.Paint()
        ..color = timerProgress > 0.3
            ? const ui.Color(0xFF4CAF50)
            : const ui.Color(0xFFE74C3C),
    );

    // Slots
    for (final slot in _slots) {
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(
          ui.Rect.fromLTWH(slot.position.x, slot.position.y, 45, 45),
          const ui.Radius.circular(8),
        ),
        ui.Paint()
          ..color = const ui.Color(0x33FFFFFF)
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      if (slot.placedJamo != null) {
        _renderText(
          canvas,
          slot.placedJamo!,
          slot.position.x + 22.5,
          slot.position.y + 8,
          fontSize: 24,
        );
      }
    }

    // Jamo tiles
    for (final tile in _jamoTiles) {
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(
          ui.Rect.fromLTWH(tile.position.x, tile.position.y, 40, 40),
          const ui.Radius.circular(8),
        ),
        ui.Paint()..color = const ui.Color(0xFF3F51B5),
      );
      _renderText(
        canvas,
        tile.text,
        tile.position.x + 20,
        tile.position.y + 6,
        fontSize: 22,
      );
    }

    // Progress
    _renderText(
      canvas,
      '${_currentRound + 1} / ${_rounds.length}',
      size.x / 2,
      size.y * 0.92,
      fontSize: 12,
      color: const ui.Color(0x66FFFFFF),
    );
  }

  void _renderComplete(ui.Canvas canvas) {
    _renderCenteredText(canvas, 'Score: $_correctCount / ${_rounds.length}', fontSize: 28);
  }

  void _renderCenteredText(ui.Canvas canvas, String text, {double fontSize = 20}) {
    _renderText(canvas, text, size.x / 2, size.y / 2, fontSize: fontSize);
  }

  void _renderText(
    ui.Canvas canvas,
    String text,
    double x,
    double y, {
    double fontSize = 16,
    ui.Color color = const ui.Color(0xFFFFFFFF),
  }) {
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontSize: fontSize,
    ))
      ..pushStyle(ui.TextStyle(color: color, fontSize: fontSize))
      ..addText(text);

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));
    canvas.drawParagraph(paragraph, ui.Offset(0, y));
  }

  @override
  void endGame() {
    _rounds.clear();
    _jamoTiles.clear();
    _slots.clear();
    super.endGame();
  }
}

class _PuzzleRound {
  final String targetSyllable;
  final List<String> jamo;
  final List<String> distractors;

  _PuzzleRound({
    required this.targetSyllable,
    required this.jamo,
    required this.distractors,
  });
}

class _JamoTile {
  final String text;
  final Vector2 originalPosition;
  Vector2 position;

  _JamoTile({
    required this.text,
    required this.originalPosition,
    required this.position,
  });
}

class _SlotArea {
  final String expectedJamo;
  final Vector2 position;
  String? placedJamo;

  _SlotArea({
    required this.expectedJamo,
    required this.position,
    this.placedJamo,
  });
}

enum _PuzzleState { loading, playing, complete }
