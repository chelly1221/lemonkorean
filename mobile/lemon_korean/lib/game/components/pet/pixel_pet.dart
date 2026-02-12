import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../../core/game_constants.dart';

/// Pet states for the simple AI behavior.
enum PetState { idle, wandering, following }

/// Pixel art pet with wander/idle/follow AI.
class PixelPet extends SpriteComponent with HasGameReference {
  final String? assetKey;
  final PositionComponent? owner; // Character to follow

  PetState _state = PetState.idle;
  final _random = Random();
  double _stateTimer = 0;
  double _nextStateChange = 3.0;
  Vector2 _wanderTarget = Vector2.zero();

  PixelPet({
    this.assetKey,
    this.owner,
    Vector2? position,
  }) : super(
    position: position ?? Vector2.zero(),
    size: Vector2(32, 32),
    anchor: Anchor.bottomCenter,
  );

  @override
  Future<void> onLoad() async {
    if (assetKey != null) {
      try {
        final image = await Flame.images.load(assetKey!);
        sprite = Sprite(image);
      } catch (_) {
        // No sprite, render placeholder
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _stateTimer += dt;

    switch (_state) {
      case PetState.idle:
        _updateIdle(dt);
      case PetState.wandering:
        _updateWander(dt);
      case PetState.following:
        _updateFollow(dt);
    }
  }

  void _updateIdle(double dt) {
    if (_stateTimer >= _nextStateChange) {
      _stateTimer = 0;

      // Decide: wander or follow
      if (owner != null && _distanceToOwner() > GameConstants.petFollowDistance * 2) {
        _state = PetState.following;
      } else if (_random.nextDouble() > 0.4) {
        _startWander();
      }

      _nextStateChange = 2 + _random.nextDouble() * 4;
    }
  }

  void _startWander() {
    _state = PetState.wandering;
    final gameSize = game.size;

    // Random nearby position within floor area
    _wanderTarget = Vector2(
      (position.x + (_random.nextDouble() - 0.5) * 100)
          .clamp(20, gameSize.x - 20),
      (position.y + (_random.nextDouble() - 0.5) * 50)
          .clamp(
            gameSize.y * GameConstants.floorTopFraction,
            gameSize.y * GameConstants.floorBottomFraction,
          ),
    );
  }

  void _updateWander(double dt) {
    final diff = _wanderTarget - position;
    final dist = diff.length;

    if (dist < 2) {
      _state = PetState.idle;
      _stateTimer = 0;
      _nextStateChange = 1 + _random.nextDouble() * 3;
      return;
    }

    final step = GameConstants.petWanderSpeed * dt;
    position += diff.normalized() * min(step, dist);
  }

  void _updateFollow(double dt) {
    if (owner == null) {
      _state = PetState.idle;
      return;
    }

    final ownerPos = owner!.position;
    final targetPos = Vector2(ownerPos.x + 30, ownerPos.y);
    final diff = targetPos - position;
    final dist = diff.length;

    if (dist < GameConstants.petFollowDistance) {
      _state = PetState.idle;
      _stateTimer = 0;
      return;
    }

    final step = GameConstants.petFollowSpeed * dt;
    position += diff.normalized() * min(step, dist);
  }

  double _distanceToOwner() {
    if (owner == null) return 0;
    return position.distanceTo(owner!.position);
  }

  @override
  void render(ui.Canvas canvas) {
    if (sprite != null) {
      super.render(canvas);
    } else {
      // Placeholder: small colored circle
      canvas.drawCircle(
        ui.Offset(size.x / 2, size.y / 2),
        12,
        ui.Paint()..color = const ui.Color(0xFF8D6E63),
      );
      // Eyes
      canvas.drawCircle(
        ui.Offset(size.x / 2 - 4, size.y / 2 - 3),
        2,
        ui.Paint()..color = const ui.Color(0xFF000000),
      );
      canvas.drawCircle(
        ui.Offset(size.x / 2 + 4, size.y / 2 - 3),
        2,
        ui.Paint()..color = const ui.Color(0xFF000000),
      );
    }
  }
}
