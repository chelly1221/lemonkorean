import 'package:flame/game.dart';

/// Base class for mini-games triggered from furniture interactions.
///
/// Mini-games run as overlay games within MyRoom and report results
/// back through a callback.
abstract class MiniGameBase extends FlameGame {
  /// Called when the mini-game is completed.
  /// [score] is the number of correct answers.
  /// [total] is the total number of questions/challenges.
  void Function(int score, int total)? onGameComplete;

  /// Called when the player exits the mini-game early.
  VoidCallback? onGameExit;

  /// Start the mini-game with the given data.
  Future<void> startGame(Map<String, dynamic> gameData);

  /// Clean up and end the mini-game.
  void endGame() {
    onGameComplete = null;
    onGameExit = null;
  }
}

typedef VoidCallback = void Function();
