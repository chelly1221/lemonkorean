import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../../../data/models/character_item_model.dart';
import '../../core/game_constants.dart';
import '../../core/sprite_loader.dart';
import 'character_animation.dart';

/// A single equipment layer (e.g. body, hair, top) rendered as a sprite
/// animation from its spritesheet.
///
/// Multiple EquipmentLayer components are stacked in a PixelCharacter,
/// sorted by renderOrder, to form the composite character.
class EquipmentLayer extends PositionComponent {
  final CharacterItemModel item;
  final CharacterAnimationState animState;
  ui.Image? _image;
  SpritesheetMeta? _meta;

  // Current animation
  SpriteAnimation? _currentAnimation;
  double _animTimer = 0;
  int _currentFrame = 0;

  // Cached direction to detect changes
  CharacterDir? _lastDirection;
  CharacterAnimState? _lastState;
  String? _lastGesture;

  EquipmentLayer({
    required this.item,
    required this.animState,
  }) : super(
    size: Vector2(GameConstants.displayWidth, GameConstants.displayHeight),
    priority: item.renderOrder,
  );

  /// Load the spritesheet image (with palette swap for body).
  Future<void> loadImage(String skinColor) async {
    _image = await SpriteLoader.loadWithPaletteSwap(item, skinColor);
    _meta = SpriteLoader.getMeta(item);
    _updateAnimation();
  }

  /// Whether this layer has a loaded image ready to render.
  @override
  bool get isLoaded => _image != null;

  @override
  void update(double dt) {
    super.update(dt);

    // Check if animation needs to change
    if (animState.direction != _lastDirection ||
        animState.state != _lastState ||
        animState.activeGesture != _lastGesture) {
      _updateAnimation();
    }

    // Advance animation
    if (_currentAnimation != null && _currentAnimation!.frames.length > 1) {
      _animTimer += dt;
      final frame = _currentAnimation!.frames[_currentFrame];
      if (_animTimer >= frame.stepTime) {
        _animTimer -= frame.stepTime;
        _currentFrame = (_currentFrame + 1) % _currentAnimation!.frames.length;

        // For non-looping gestures, stop at last frame
        if (animState.isGesturing &&
            _currentFrame == 0) {
          _currentFrame = _currentAnimation!.frames.length - 1;
        }
      }
    }

    // Hide face categories when facing back
    if (GameConstants.faceCategories.contains(item.category)) {
      if (animState.direction.hideFace) {
        // Don't render
        return;
      }
    }
  }

  void _updateAnimation() {
    _lastDirection = animState.direction;
    _lastState = animState.state;
    _lastGesture = animState.activeGesture;

    if (_image == null || _meta == null) return;

    if (animState.isGesturing && animState.activeGesture != null) {
      _currentAnimation = SpriteLoader.createGestureAnimation(
        image: _image!,
        meta: _meta!,
        gesture: animState.activeGesture!,
      );
    } else {
      final row = SpriteLoader.rowForDirection(animState.direction.name);
      _currentAnimation = SpriteLoader.createDirectionAnimation(
        image: _image!,
        meta: _meta!,
        row: row,
        isWalking: animState.isWalking,
      );
    }

    _currentFrame = 0;
    _animTimer = 0;
  }

  @override
  void render(ui.Canvas canvas) {
    // Hide face categories when back is facing
    if (GameConstants.faceCategories.contains(item.category) &&
        animState.direction.hideFace) {
      return;
    }

    if (_currentAnimation == null || _currentAnimation!.frames.isEmpty) return;

    final frame = _currentAnimation!.frames[
        _currentFrame.clamp(0, _currentAnimation!.frames.length - 1)];

    // Apply horizontal flip for left direction
    if (animState.direction.isFlipped) {
      canvas.save();
      canvas.scale(-1, 1);
      canvas.translate(-size.x, 0);
      frame.sprite.render(canvas, size: size);
      canvas.restore();
    } else {
      frame.sprite.render(canvas, size: size);
    }
  }

  /// Force reload of image (e.g. after skin color change).
  Future<void> reload(String skinColor) async {
    _image = null;
    await loadImage(skinColor);
  }
}
