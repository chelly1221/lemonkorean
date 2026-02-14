import 'dart:math';

import 'package:flame/components.dart';

import '../../data/models/character_item_model.dart';
import '../components/character/character_animation.dart';
import '../components/character/pixel_character.dart';
import '../components/effects/speaking_aura.dart';
import '../components/ui/connection_quality_badge.dart';
import '../components/ui/mute_badge.dart';
import '../components/ui/name_label.dart';
import '../core/game_constants.dart';

/// A remote player's character on the voice stage.
///
/// Smoothly interpolates position toward the target received
/// from Socket.IO, rather than snapping directly.
class RemoteCharacter extends PositionComponent with HasGameReference {
  final int userId;
  final String name;
  final Map<String, dynamic>? equippedItems;
  final String? skinColor;
  bool isMuted;

  // Target position from network updates
  double targetX;
  double targetY;
  String targetDirection;

  late PixelCharacter _character;
  late SpeakingAura _aura;
  late NameLabel _nameLabel;
  late MuteBadge _muteBadge;
  late ConnectionQualityBadge _qualityBadge;

  RemoteCharacter({
    required this.userId,
    required this.name,
    this.equippedItems,
    this.skinColor,
    this.isMuted = false,
    this.targetX = 0.5,
    this.targetY = 0.75,
    this.targetDirection = 'front',
  }) : super(priority: 50);

  @override
  Future<void> onLoad() async {
    // Build equipped items list from map
    final items = _buildEquippedItems();

    _character = PixelCharacter(
      equippedItems: items,
      skinColor: skinColor ?? '#FFDBB4',
    );
    add(_character);

    _aura = SpeakingAura(isMuted: isMuted);
    _aura.position = Vector2(
      GameConstants.displayWidth / 2,
      GameConstants.displayHeight / 2,
    );
    add(_aura);

    _nameLabel = NameLabel(name: name);
    _nameLabel.position = Vector2(
      GameConstants.displayWidth / 2,
      -4,
    );
    add(_nameLabel);

    _muteBadge = MuteBadge(isMuted: isMuted);
    _muteBadge.position = Vector2(
      GameConstants.displayWidth - 5,
      GameConstants.displayHeight - 5,
    );
    add(_muteBadge);

    _qualityBadge = ConnectionQualityBadge();
    _qualityBadge.position = Vector2(
      GameConstants.displayWidth - 5,
      -12,
    );
    add(_qualityBadge);

    // Set initial position
    _updateWorldPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _interpolateToTarget(dt);
  }

  void _interpolateToTarget(double dt) {
    final currentNormX = position.x / game.size.x;
    final currentNormY = position.y / game.size.y;

    final dx = targetX - currentNormX;
    final dy = targetY - currentNormY;
    final dist = sqrt(dx * dx + dy * dy);

    if (dist > GameConstants.positionMinDelta) {
      final step = min(GameConstants.remoteInterpolationSpeed, dist);
      final newX = currentNormX + (dx / dist) * step;
      final newY = currentNormY + (dy / dist) * step;

      position.x = newX * game.size.x;
      position.y = newY * game.size.y;

      // Update character direction
      final dir = CharacterDir.fromString(targetDirection);
      if (!_character.isWalking) {
        _character.animState.startWalking(dir);
      }
    } else {
      if (_character.animState.isWalking) {
        _character.animState.stopWalking();
      }
    }
  }

  void _updateWorldPosition() {
    position.x = targetX * game.size.x;
    position.y = targetY * game.size.y;
  }

  /// Update target from network.
  void updateTarget(double x, double y, String direction) {
    targetX = x;
    targetY = y;
    targetDirection = direction;
  }

  /// Update mute state.
  void updateMuteState(bool muted) {
    isMuted = muted;
    _aura.isMuted = muted;
    _muteBadge.isMuted = muted;
  }

  /// Update connection quality badge.
  void updateConnectionQuality(String quality) {
    _qualityBadge.quality = quality;
  }

  /// Play a gesture animation.
  void playGesture(String gesture) {
    _character.playGesture(gesture);
  }

  List<CharacterItemModel> _buildEquippedItems() {
    if (equippedItems == null || equippedItems!.isEmpty) return [];
    final items = <CharacterItemModel>[];
    equippedItems!.forEach((category, itemData) {
      if (itemData is Map<String, dynamic>) {
        items.add(CharacterItemModel.fromJson(itemData));
      }
    });
    return items;
  }
}
