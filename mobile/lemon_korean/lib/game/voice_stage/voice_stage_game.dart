import 'dart:ui' as ui;
import 'dart:ui' show Color;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

import '../../data/models/character_item_model.dart';
import '../components/character/pixel_character.dart';
import '../components/effects/floating_emoji.dart';
import '../components/effects/gesture_effects.dart';
import '../components/effects/particle_manager.dart';
import '../components/effects/speaking_aura.dart';
import '../components/ui/connection_quality_badge.dart';
import '../components/ui/mute_badge.dart';
import '../components/ui/name_label.dart';
import '../core/game_bridge.dart';
import '../core/game_constants.dart';
import 'remote_character.dart';

/// FlameGame for the Voice Room Stage.
///
/// Renders the dark stage background with characters (local + remote),
/// speaking auras, floating reactions, and gesture effects.
class VoiceStageGame extends FlameGame with TapCallbacks {
  final GameBridge bridge;
  final int? myUserId;
  final bool isSpeaker;
  final List<CharacterItemModel> myEquippedItems;
  final String mySkinColor;
  final String myName;

  // Local player
  PixelCharacter? _myCharacter;
  SpeakingAura? _myAura;
  NameLabel? _myNameLabel;
  MuteBadge? _myMuteBadge;
  ConnectionQualityBadge? _myQualityBadge;
  bool _myMuted = false;

  // Remote characters
  final Map<int, RemoteCharacter> _remoteCharacters = {};

  // Effects
  late ParticleManager _particles;
  late GestureEffects _gestureEffects;

  VoiceStageGame({
    required this.bridge,
    required this.isSpeaker,
    required this.myEquippedItems,
    required this.mySkinColor,
    required this.myName,
    this.myUserId,
  });

  @override
  Color backgroundColor() => const ui.Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    // Stage floor line
    add(_StageFloorLine());

    // Stage label
    add(_StageLabel());

    // Particles
    _particles = ParticleManager();
    add(_particles);
    _gestureEffects = GestureEffects(particles: _particles);

    // My character (if speaker)
    if (isSpeaker && myUserId != null) {
      _setupMyCharacter();
    }

    // Listen for bridge events
    bridge.gameEvents.listen(_handleGameEvent);
  }

  void _setupMyCharacter() {
    final items = myEquippedItems.where((i) => i.isCharacterPart).toList();

    _myCharacter = PixelCharacter(
      equippedItems: items,
      skinColor: mySkinColor,
      position: Vector2(size.x * 0.5, size.y * 0.75),
    );
    _myCharacter!.priority = 100;
    _myCharacter!.onPositionChanged = (x, y, dir) {
      bridge.sendToFlutter(LocalCharacterMoved(
        x: x / size.x,
        y: y / size.y,
        direction: dir,
      ));
    };
    add(_myCharacter!);

    _myAura = SpeakingAura(isMuted: _myMuted);
    _myAura!.position = Vector2(size.x * 0.5, size.y * 0.75 - GameConstants.displayHeight / 2);
    add(_myAura!);

    _myNameLabel = NameLabel(name: myName, isLocalPlayer: true);
    _myNameLabel!.position = Vector2(size.x * 0.5, size.y * 0.75 - GameConstants.displayHeight - 4);
    add(_myNameLabel!);

    _myMuteBadge = MuteBadge(isMuted: _myMuted);
    _myMuteBadge!.position = Vector2(
      size.x * 0.5 + GameConstants.displayWidth / 2 - 5,
      size.y * 0.75 - 5,
    );
    add(_myMuteBadge!);

    _myQualityBadge = ConnectionQualityBadge();
    _myQualityBadge!.position = Vector2(
      size.x * 0.5 + GameConstants.displayWidth / 2 - 5,
      size.y * 0.75 - GameConstants.displayHeight - 12,
    );
    add(_myQualityBadge!);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!isSpeaker || _myCharacter == null) return;

    final tapPos = event.canvasPosition;

    // Clamp to stage bounds
    final target = Vector2(
      tapPos.x.clamp(size.x * GameConstants.stageMinX, size.x * GameConstants.stageMaxX),
      tapPos.y.clamp(size.y * GameConstants.stageMinY, size.y * GameConstants.stageMaxY),
    );

    _myCharacter!.walkTo(target);
  }

  void _handleGameEvent(GameEvent event) {
    switch (event) {
      case RemoteCharacterMoved(:final userId, :final x, :final y, :final direction):
        _remoteCharacters[userId]?.updateTarget(x, y, direction);

      case RemoteGestureReceived(:final userId, :final gesture):
        final remote = _remoteCharacters[userId];
        if (remote != null) {
          remote.playGesture(gesture);
          _gestureEffects.play(gesture, remote.position);
        }
        // Also handle own gesture
        if (userId == myUserId && _myCharacter != null) {
          _myCharacter!.playGesture(gesture);
          _gestureEffects.play(gesture, _myCharacter!.position);
        }

      case ReactionReceived(:final emoji, :final startX, :final startY):
        add(FloatingEmoji(
          emoji: emoji,
          startPosition: Vector2(startX * size.x, startY * size.y),
        ));

      case MuteStateChanged(:final userId, :final isMuted):
        if (userId == myUserId) {
          _myMuted = isMuted;
          _myAura?.isMuted = isMuted;
          _myMuteBadge?.isMuted = isMuted;
        } else {
          _remoteCharacters[userId]?.updateMuteState(isMuted);
        }

      case ConnectionQualityChanged(:final userId, :final quality):
        if (userId == myUserId) {
          _myQualityBadge?.quality = quality;
        } else {
          _remoteCharacters[userId]?.updateConnectionQuality(quality);
        }

      case RemoteCharacterAdded(:final userId, :final name, :final equippedItems, :final skinColor, :final isMuted):
        if (userId == myUserId) return;
        _addRemoteCharacter(userId, name, equippedItems, skinColor, isMuted);

      case RemoteCharacterRemoved(:final userId):
        _removeRemoteCharacter(userId);

      case CharacterEquipmentChanged(:final equippedItems, :final skinColor):
        _myCharacter?.updateEquipment(equippedItems, skinColor);

      default:
        break;
    }
  }

  void _addRemoteCharacter(
    int userId,
    String name,
    Map<String, dynamic>? equippedItems,
    String? skinColor,
    bool isMuted,
  ) {
    if (_remoteCharacters.containsKey(userId)) return;

    final remote = RemoteCharacter(
      userId: userId,
      name: name,
      equippedItems: equippedItems,
      skinColor: skinColor,
      isMuted: isMuted,
    );
    _remoteCharacters[userId] = remote;
    add(remote);
  }

  void _removeRemoteCharacter(int userId) {
    final remote = _remoteCharacters.remove(userId);
    remote?.removeFromParent();
  }

  /// Called when my mute state changes.
  void setMyMuted(bool muted) {
    _myMuted = muted;
    _myAura?.isMuted = muted;
    _myMuteBadge?.isMuted = muted;
  }
}

/// Subtle floor line at the bottom of the stage.
class _StageFloorLine extends PositionComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    position = Vector2(0, game.size.y * 0.95);
    size = Vector2(game.size.x, 2);
  }

  @override
  void render(ui.Canvas canvas) {
    final paint = ui.Paint()
      ..shader = ui.Gradient.linear(
        ui.Offset.zero,
        ui.Offset(size.x, 0),
        [
          const ui.Color(0x00FFFFFF),
          const ui.Color(0x1AFFFFFF),
          const ui.Color(0x00FFFFFF),
        ],
        [0, 0.5, 1],
      );
    canvas.drawRect(size.toRect(), paint);
  }
}

/// "STAGE" text label at the top of the stage area.
class _StageLabel extends PositionComponent with HasGameReference {
  ui.Paragraph? _paragraph;

  @override
  Future<void> onLoad() async {
    position = Vector2(0, 8);
    size = Vector2(game.size.x, 20);

    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontSize: 14,
    ))
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0x26FFFFFF),
        fontSize: 14,
        fontWeight: ui.FontWeight.bold,
        letterSpacing: 4,
      ))
      ..addText('STAGE');

    _paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: game.size.x));
  }

  @override
  void render(ui.Canvas canvas) {
    if (_paragraph != null) {
      canvas.drawParagraph(_paragraph!, ui.Offset.zero);
    }
  }
}
