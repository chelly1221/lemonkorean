import 'package:flame/components.dart';

import '../../../data/models/character_item_model.dart';
import '../../../presentation/providers/character_provider.dart';
import '../../core/game_constants.dart';
import 'character_animation.dart';
import 'character_shadow.dart';
import 'equipment_layer.dart';

/// Composite character component that stacks equipment layers in render order.
///
/// Handles walking animation, direction changes, and gesture playback.
/// This mirrors the logic of [CharacterAvatarWidget] but in FLAME.
class PixelCharacter extends PositionComponent {
  /// Default body spritesheet used when no equipped items have spritesheet data.
  static final List<CharacterItemModel> _defaultSpritesheetItems = [
    CharacterItemModel(
      id: 0,
      category: 'body',
      name: 'Default',
      assetKey: 'assets/sprites/character/body/body_default.png',
      assetType: 'spritesheet',
      isBundled: true,
      renderOrder: 0,
      isDefault: true,
      metadata: {
        'spritesheet_key': 'assets/sprites/character/body/body_default.png',
      },
    ),
  ];

  List<CharacterItemModel> _equippedItems;
  String _skinColor;
  final CharacterAnimationState animState = CharacterAnimationState();

  // Walking
  Vector2? _walkTarget;
  Vector2 _walkStart = Vector2.zero();
  double _walkProgress = 0;
  double _walkDuration = 0;

  // Layers
  final List<EquipmentLayer> _layers = [];
  late CharacterShadow _shadow;

  // Callback when character finishes walking
  void Function(double x, double y, String direction)? onPositionChanged;

  PixelCharacter({
    required List<CharacterItemModel> equippedItems,
    required String skinColor,
    Vector2? position,
  })  : _equippedItems = equippedItems,
        _skinColor = skinColor,
        super(
          position: position ?? Vector2.zero(),
          size: Vector2(GameConstants.displayWidth, GameConstants.displayHeight),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    _shadow = CharacterShadow();
    _shadow.position = Vector2(size.x / 2, size.y);
    add(_shadow);

    await _buildLayers();
  }

  /// Rebuild all equipment layers from the current equipped items.
  Future<void> _buildLayers() async {
    // Remove old layers
    for (final layer in _layers) {
      layer.removeFromParent();
    }
    _layers.clear();

    // Prefer bundledDefaults for items with matching IDs
    // (ensures bundled sprites always use latest code-side paths/metadata)
    final bundledLookup = {
      for (final item in CharacterProvider.bundledDefaults) item.id: item,
    };

    var characterItems = _equippedItems
        .map((i) => bundledLookup[i.id] ?? i)
        .where((i) => i.isCharacterPart && i.hasSpritesheet)
        .toList()
      ..sort((a, b) => a.renderOrder.compareTo(b.renderOrder));

    // Fallback: use default body spritesheet if no items have spritesheet data
    if (characterItems.isEmpty) {
      characterItems = _defaultSpritesheetItems;
    }

    // Create layers
    for (final item in characterItems) {
      final layer = EquipmentLayer(item: item, animState: animState);
      _layers.add(layer);
      add(layer);
      // Load images async (non-blocking per layer)
      layer.loadImage(_skinColor);
    }
  }

  /// Update equipped items and rebuild layers.
  Future<void> updateEquipment(
    List<CharacterItemModel> items,
    String skinColor,
  ) async {
    _equippedItems = items;
    _skinColor = skinColor;
    await _buildLayers();
  }

  /// Start walking to a target position (in game world coordinates).
  void walkTo(Vector2 target) {
    _walkStart = position.clone();
    _walkTarget = target;
    _walkProgress = 0;

    // Calculate duration based on distance
    final dist = _walkStart.distanceTo(target);
    _walkDuration = (dist / GameConstants.walkSpeed).clamp(0.2, 3.0);

    // Determine direction
    final dx = target.x - position.x;
    final dy = target.y - position.y;
    CharacterDir dir;
    if (dx.abs() >= dy.abs()) {
      dir = dx < 0 ? CharacterDir.left : CharacterDir.right;
    } else {
      dir = dy < 0 ? CharacterDir.back : CharacterDir.front;
    }
    animState.startWalking(dir);
  }

  /// Play a gesture animation.
  void playGesture(String gesture) {
    animState.startGesture(gesture);

    // Auto-end after gesture duration
    final duration = _gestureDuration(gesture);
    Future.delayed(duration, () {
      if (animState.activeGesture == gesture) {
        animState.endGesture();
      }
    });
  }

  Duration _gestureDuration(String gesture) {
    switch (gesture) {
      case 'jump':
        return const Duration(milliseconds: 600);
      case 'wave':
        return const Duration(milliseconds: 800);
      case 'bow':
        return const Duration(milliseconds: 1000);
      case 'dance':
        return const Duration(milliseconds: 3000);
      case 'clap':
        return const Duration(milliseconds: 800);
      default:
        return const Duration(milliseconds: 1000);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Walk interpolation
    if (_walkTarget != null && animState.isWalking) {
      _walkProgress += dt / _walkDuration;

      if (_walkProgress >= 1.0) {
        // Arrived
        _walkProgress = 1.0;
        position.setFrom(_walkTarget!);
        _walkTarget = null;
        animState.stopWalking();

        onPositionChanged?.call(
          position.x,
          position.y,
          animState.direction.name,
        );
      } else {
        // Ease-in-out interpolation
        final t = _easeInOut(_walkProgress);
        position.x = _walkStart.x + (_walkTarget!.x - _walkStart.x) * t;
        position.y = _walkStart.y + (_walkTarget!.y - _walkStart.y) * t;

        // Notify periodically for network sync
        onPositionChanged?.call(
          position.x,
          position.y,
          animState.direction.name,
        );
      }
    }
  }

  double _easeInOut(double t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }

  /// Set position directly (for remote characters or initialization).
  void setPosition(double x, double y) {
    position.x = x;
    position.y = y;
  }

  /// Set direction without walking.
  void setDirection(CharacterDir dir) {
    animState.direction = dir;
  }

  /// Whether the character is currently walking.
  bool get isWalking => animState.isWalking;

  /// Current direction as string.
  String get directionString => animState.direction.name;
}
