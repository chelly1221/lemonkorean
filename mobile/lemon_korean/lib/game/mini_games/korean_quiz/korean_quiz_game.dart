import 'dart:ui' as ui;
import 'dart:ui' show Color;

import 'package:flame/events.dart';

import '../mini_game_base.dart';

/// Korean word quiz mini-game.
///
/// Shows a Korean word and 4 answer options. Player taps the correct meaning.
/// Questions sourced from the user's SRS review queue.
class KoreanQuizGame extends MiniGameBase with TapCallbacks {
  List<_QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  _QuizState _state = _QuizState.loading;

  // UI layout constants
  static const double _questionY = 0.2;
  static const double _optionStartY = 0.45;
  static const double _optionHeight = 50.0;
  static const double _optionSpacing = 12.0;
  static const double _optionPadding = 24.0;

  // State
  int? _selectedOption;
  double _feedbackTimer = 0;

  @override
  Color backgroundColor() => const ui.Color(0xFF2C3E50);

  @override
  Future<void> startGame(Map<String, dynamic> gameData) async {
    // Parse questions from game data
    final questionList = gameData['questions'] as List<dynamic>? ?? [];
    _questions = questionList.map((q) {
      final qMap = q as Map<String, dynamic>;
      return _QuizQuestion(
        word: qMap['word'] as String? ?? '',
        options: (qMap['options'] as List<dynamic>?)
                ?.map((o) => o.toString())
                .toList() ??
            [],
        correctIndex: qMap['correct_index'] as int? ?? 0,
      );
    }).toList();

    if (_questions.isEmpty) {
      // Provide sample questions for testing
      _questions = [
        _QuizQuestion(word: '사과', options: ['Apple', 'Banana', 'Orange', 'Grape'], correctIndex: 0),
        _QuizQuestion(word: '학교', options: ['Hospital', 'School', 'Library', 'Store'], correctIndex: 1),
        _QuizQuestion(word: '감사합니다', options: ['Hello', 'Goodbye', 'Thank you', 'Sorry'], correctIndex: 2),
      ];
    }

    _state = _QuizState.questioning;
    _currentIndex = 0;
    _correctCount = 0;
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_state != _QuizState.questioning) return;

    final tapY = event.canvasPosition.y;
    final startY = size.y * _optionStartY;

    // Check which option was tapped
    for (int i = 0; i < _currentQuestion.options.length; i++) {
      final optionY = startY + i * (_optionHeight + _optionSpacing);
      if (tapY >= optionY && tapY <= optionY + _optionHeight) {
        _selectOption(i);
        return;
      }
    }
  }

  void _selectOption(int index) {
    _selectedOption = index;
    final correct = index == _currentQuestion.correctIndex;

    if (correct) {
      _correctCount++;
    }

    _state = _QuizState.feedback;
    _feedbackTimer = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state == _QuizState.feedback) {
      _feedbackTimer += dt;
      if (_feedbackTimer >= 1.5) {
        _nextQuestion();
      }
    }
  }

  void _nextQuestion() {
    _currentIndex++;
    _selectedOption = null;

    if (_currentIndex >= _questions.length) {
      _state = _QuizState.complete;
      onGameComplete?.call(_correctCount, _questions.length);
    } else {
      _state = _QuizState.questioning;
    }
  }

  _QuizQuestion get _currentQuestion => _questions[_currentIndex];

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);

    switch (_state) {
      case _QuizState.loading:
        _renderCenteredText(canvas, 'Loading...');
      case _QuizState.questioning:
      case _QuizState.feedback:
        _renderQuestion(canvas);
      case _QuizState.complete:
        _renderComplete(canvas);
    }
  }

  void _renderQuestion(ui.Canvas canvas) {
    final question = _currentQuestion;

    // Progress indicator
    _renderText(
      canvas,
      '${_currentIndex + 1} / ${_questions.length}',
      size.x / 2,
      24,
      fontSize: 14,
      color: const ui.Color(0x99FFFFFF),
    );

    // Korean word
    _renderText(
      canvas,
      question.word,
      size.x / 2,
      size.y * _questionY,
      fontSize: 36,
      color: const ui.Color(0xFFFFFFFF),
    );

    // Instruction
    _renderText(
      canvas,
      'What does this mean?',
      size.x / 2,
      size.y * _questionY + 50,
      fontSize: 14,
      color: const ui.Color(0x99FFFFFF),
    );

    // Options
    final startY = size.y * _optionStartY;
    for (int i = 0; i < question.options.length; i++) {
      final optionY = startY + i * (_optionHeight + _optionSpacing);
      _renderOption(canvas, question.options[i], i, optionY);
    }
  }

  void _renderOption(ui.Canvas canvas, String text, int index, double y) {
    final isSelected = _selectedOption == index;
    final isCorrect = index == _currentQuestion.correctIndex;
    final showFeedback = _state == _QuizState.feedback;

    // Background color
    ui.Color bgColor;
    if (showFeedback && isCorrect) {
      bgColor = const ui.Color(0xFF27AE60); // Green
    } else if (showFeedback && isSelected && !isCorrect) {
      bgColor = const ui.Color(0xFFE74C3C); // Red
    } else {
      bgColor = const ui.Color(0xFF34495E);
    }

    final rect = ui.RRect.fromRectAndRadius(
      ui.Rect.fromLTWH(_optionPadding, y, size.x - _optionPadding * 2, _optionHeight),
      const ui.Radius.circular(12),
    );

    canvas.drawRRect(rect, ui.Paint()..color = bgColor);

    _renderText(
      canvas,
      text,
      size.x / 2,
      y + _optionHeight / 2 - 8,
      fontSize: 16,
      color: const ui.Color(0xFFFFFFFF),
    );
  }

  void _renderComplete(ui.Canvas canvas) {
    _renderCenteredText(
      canvas,
      'Score: $_correctCount / ${_questions.length}',
      fontSize: 28,
    );
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
    _questions.clear();
    super.endGame();
  }
}

class _QuizQuestion {
  final String word;
  final List<String> options;
  final int correctIndex;

  _QuizQuestion({
    required this.word,
    required this.options,
    required this.correctIndex,
  });
}

enum _QuizState { loading, questioning, feedback, complete }
