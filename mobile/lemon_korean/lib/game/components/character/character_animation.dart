/// State machine for character animation.
///
/// Tracks current state (idle/walk/gesture) and direction, providing
/// the correct row and frame range for spritesheet rendering.
enum CharacterAnimState {
  idle,
  walking,
  gesture,
}

enum CharacterDir {
  front,
  back,
  left,
  right;

  factory CharacterDir.fromString(String s) {
    switch (s) {
      case 'front':
        return CharacterDir.front;
      case 'back':
        return CharacterDir.back;
      case 'left':
        return CharacterDir.left;
      case 'right':
        return CharacterDir.right;
      default:
        return CharacterDir.front;
    }
  }

  @override
  String toString() => name;

  /// Whether the sprite should be flipped horizontally.
  bool get isFlipped => this == CharacterDir.left;

  /// Whether face layers should be hidden (back view).
  bool get hideFace => this == CharacterDir.back;
}

class CharacterAnimationState {
  CharacterAnimState state;
  CharacterDir direction;
  String? activeGesture;
  DateTime? gestureStartTime;

  CharacterAnimationState({
    this.state = CharacterAnimState.idle,
    this.direction = CharacterDir.front,
    this.activeGesture,
    this.gestureStartTime,
  });

  void startWalking(CharacterDir dir) {
    state = CharacterAnimState.walking;
    direction = dir;
    activeGesture = null;
    gestureStartTime = null;
  }

  void stopWalking() {
    if (state == CharacterAnimState.walking) {
      state = CharacterAnimState.idle;
    }
  }

  void startGesture(String gesture) {
    state = CharacterAnimState.gesture;
    activeGesture = gesture;
    gestureStartTime = DateTime.now();
  }

  void endGesture() {
    if (state == CharacterAnimState.gesture) {
      state = CharacterAnimState.idle;
      activeGesture = null;
      gestureStartTime = null;
    }
  }

  bool get isWalking => state == CharacterAnimState.walking;
  bool get isGesturing => state == CharacterAnimState.gesture;
  bool get isIdle => state == CharacterAnimState.idle;
}
