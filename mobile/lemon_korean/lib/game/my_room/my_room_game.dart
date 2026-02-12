import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../../data/models/character_item_model.dart';
import '../components/character/pixel_character.dart';
import '../components/effects/particle_manager.dart';
import '../components/pet/pixel_pet.dart';
import '../components/room/day_night_overlay.dart';
import '../components/room/floor_component.dart';
import '../components/room/furniture_component.dart';
import '../components/room/room_background.dart';
import '../core/game_bridge.dart';

/// FlameGame for the MyRoom screen.
///
/// Renders the room with background, floor, furniture, character,
/// and optional pet. Supports tap-to-walk and day/night overlay.
class MyRoomGame extends FlameGame with TapCallbacks {
  final GameBridge bridge;
  final List<CharacterItemModel> initialEquippedItems;
  final String initialSkinColor;
  final String? wallpaperAssetKey;
  final String? floorAssetKey;
  final List<Map<String, dynamic>> furnitureData;
  final String? petAssetKey;

  late PixelCharacter _character;
  late FloorComponent _floor;
  late ParticleManager _particles;
  PixelPet? _pet;

  MyRoomGame({
    required this.bridge,
    required this.initialEquippedItems,
    required this.initialSkinColor,
    this.wallpaperAssetKey,
    this.floorAssetKey,
    this.furnitureData = const [],
    this.petAssetKey,
  });

  @override
  Future<void> onLoad() async {
    // Background
    add(RoomBackground(assetKey: wallpaperAssetKey));

    // Floor
    _floor = FloorComponent(assetKey: floorAssetKey);
    add(_floor);

    // Furniture
    for (final f in furnitureData) {
      final posX = (f['position_x'] as double?) ?? 0.5;
      final posY = (f['position_y'] as double?) ?? 0.7;
      add(FurnitureComponent(
        furnitureId: f['id'] as int? ?? 0,
        assetKey: f['asset_key'] as String?,
        interactionType: f['interaction_type'] as String?,
        bridge: bridge,
        position: Vector2(posX * size.x, posY * size.y),
      ));
    }

    // Character (centered on floor)
    final spritesheetItems = initialEquippedItems
        .where((i) => i.isCharacterPart)
        .toList();

    _character = PixelCharacter(
      equippedItems: spritesheetItems,
      skinColor: initialSkinColor,
      position: Vector2(size.x * 0.5, size.y * 0.78),
    );
    _character.priority = 100;
    _character.onPositionChanged = (x, y, dir) {
      bridge.sendToFlutter(LocalCharacterMoved(
        x: x / size.x,
        y: y / size.y,
        direction: dir,
      ));
    };
    add(_character);

    // Pet
    if (petAssetKey != null) {
      _pet = PixelPet(
        assetKey: petAssetKey,
        owner: _character,
        position: Vector2(size.x * 0.6, size.y * 0.8),
      );
      _pet!.priority = 99;
      add(_pet!);
    }

    // Particle manager
    _particles = ParticleManager();
    add(_particles);

    // Ambient sparkles
    _particles.spawnAmbientSparkles(5);

    // Day/night overlay
    add(DayNightOverlay());

    // Listen for bridge events
    bridge.gameEvents.listen(_handleGameEvent);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final tapPos = event.canvasPosition;

    // Clamp to floor
    final target = _floor.clampToFloor(tapPos);
    _character.walkTo(target);
  }

  void _handleGameEvent(GameEvent event) {
    switch (event) {
      case CharacterEquipmentChanged(:final equippedItems, :final skinColor):
        _character.updateEquipment(equippedItems, skinColor);
      case VisitorJoined():
        // Phase 4: handle room visitors
        break;
      case VisitorLeft():
        break;
      default:
        break;
    }
  }

  /// Update equipped items (called from Provider).
  void updateEquipment(List<CharacterItemModel> items, String skinColor) {
    bridge.sendToGame(CharacterEquipmentChanged(
      equippedItems: items,
      skinColor: skinColor,
    ));
  }

  /// Update furniture layout.
  void updateFurniture(List<Map<String, dynamic>> furniture) {
    // Remove old furniture
    children.whereType<FurnitureComponent>().forEach((f) => f.removeFromParent());

    // Add new furniture
    for (final f in furniture) {
      final posX = (f['position_x'] as double?) ?? 0.5;
      final posY = (f['position_y'] as double?) ?? 0.7;
      add(FurnitureComponent(
        furnitureId: f['id'] as int? ?? 0,
        assetKey: f['asset_key'] as String?,
        interactionType: f['interaction_type'] as String?,
        bridge: bridge,
        position: Vector2(posX * size.x, posY * size.y),
      ));
    }
  }
}
