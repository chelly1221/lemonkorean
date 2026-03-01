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
import 'voice_stage_game.dart';

/// A remote player's character on the voice stage.
///
/// Smoothly interpolates position toward the target received
/// from Socket.IO, rather than snapping directly.
class RemoteCharacter extends PositionComponent with HasGameReference<VoiceStageGame> {
  final int userId;
  final String name;
  final Map<String, dynamic>? equippedItems;
  final String? skinColor;
  final bool isHost;
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
    this.isHost = false,
    this.isMuted = false,
    this.targetX = 0.5,
    this.targetY = 0.75,
    this.targetDirection = 'front',
  }) : super(priority: 50);

  @override
  Future<void> onLoad() async {
    // Build equipped items list from map
    final items = _buildEquippedItems();
    final scale = game.calcDisplayScale();
    final charW = GameConstants.frameWidth * scale;
    final charH = GameConstants.frameHeight * scale;

    _character = PixelCharacter(
      equippedItems: items,
      skinColor: skinColor ?? '#FFDBB4',
      displayScale: scale,
    );
    add(_character);

    _aura = SpeakingAura(isMuted: isMuted, isHost: isHost);
    _aura.position = Vector2(charW / 2, charH / 2);
    add(_aura);

    _nameLabel = NameLabel(name: name, isHost: isHost);
    _nameLabel.position = Vector2(charW / 2, -4);
    add(_nameLabel);

    _muteBadge = MuteBadge(isMuted: isMuted);
    _muteBadge.position = Vector2(charW - 5, charH - 5);
    add(_muteBadge);

    _qualityBadge = ConnectionQualityBadge();
    _qualityBadge.position = Vector2(charW - 5, -12);
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
      // Frame-rate independent exponential interpolation
      final lerpFactor = 1.0 - pow(0.001, dt).clamp(0.0, 1.0);
      final newX = currentNormX + dx * lerpFactor;
      final newY = currentNormY + dy * lerpFactor;

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

  /// Update display scale and reposition UI badges after game resize.
  void updateDisplayScale(double scale) {
    _character.displayScale = scale;
    final charW = GameConstants.frameWidth * scale;
    final charH = GameConstants.frameHeight * scale;

    _aura.position = Vector2(charW / 2, charH / 2);
    _nameLabel.position = Vector2(charW / 2, -4);
    _muteBadge.position = Vector2(charW - 5, charH - 5);
    _qualityBadge.position = Vector2(charW - 5, -12);
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
