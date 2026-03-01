import 'dart:async';
import 'dart:math';
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
  final bool isHost;
  final int maxSpeakers;
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

  // Stage spot markers
  final List<_StageSpotMarker> _spotMarkers = [];

  // Effects
  late ParticleManager _particles;
  late GestureEffects _gestureEffects;

  // Bridge event subscription
  StreamSubscription? _bridgeSub;

  VoiceStageGame({
    required this.bridge,
    required this.isSpeaker,
    required this.myEquippedItems,
    required this.mySkinColor,
    required this.myName,
    this.myUserId,
    this.isHost = false,
    this.maxSpeakers = 4,
  });

  /// Calculate dynamic display scale based on stage area size.
  double calcDisplayScale() {
    final stageHeight = size.y * (GameConstants.stageMaxY - GameConstants.stageMinY);
    final idealCharHeight = stageHeight * 0.35;
    return (idealCharHeight / GameConstants.frameHeight).clamp(2.0, 4.0);
  }

  @override
  Color backgroundColor() => const ui.Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    // Stage floor line
    add(_StageFloorLine());

    // Stage label
    add(_StageLabel());

    // Stage spot markers
    _addStageSpots();

    // Particles
    _particles = ParticleManager();
    add(_particles);
    _particles.spawnAmbientSparkles(8);
    _gestureEffects = GestureEffects(particles: _particles);

    // My character (if speaker)
    if (isSpeaker && myUserId != null) {
      _setupMyCharacter();
    }

    // Listen for bridge events
    _bridgeSub = bridge.gameEvents.listen(_handleGameEvent);
  }

  @override
  void onRemove() {
    _bridgeSub?.cancel();
    _bridgeSub = null;
    super.onRemove();
  }

  void _addStageSpots() {
    final List<double> xPositions;
    switch (maxSpeakers) {
      case 2:
        xPositions = [0.35, 0.65];
        break;
      case 3:
        xPositions = [0.25, 0.50, 0.75];
        break;
      case 4:
      default:
        xPositions = [0.20, 0.40, 0.60, 0.80];
        break;
    }

    const spotY = 0.65;
    for (final spotX in xPositions) {
      final marker = _StageSpotMarker(normX: spotX, normY: spotY);
      _spotMarkers.add(marker);
      add(marker);
    }
  }

  void _setupMyCharacter() {
    final items = myEquippedItems.where((i) => i.isCharacterPart).toList();
    final scale = calcDisplayScale();

    _myCharacter = PixelCharacter(
      equippedItems: items,
      skinColor: mySkinColor,
      position: Vector2(size.x * 0.5, size.y * 0.75),
      displayScale: scale,
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

    final charW = GameConstants.frameWidth * scale;
    final charH = GameConstants.frameHeight * scale;

    _myAura = SpeakingAura(isMuted: _myMuted, isHost: isHost);
    _myAura!.position = Vector2(size.x * 0.5, size.y * 0.75 - charH / 2);
    add(_myAura!);

    _myNameLabel = NameLabel(name: myName, isLocalPlayer: true, isHost: isHost);
    _myNameLabel!.position = Vector2(size.x * 0.5, size.y * 0.75 - charH - 4);
    add(_myNameLabel!);

    _myMuteBadge = MuteBadge(isMuted: _myMuted);
    _myMuteBadge!.position = Vector2(
      size.x * 0.5 + charW / 2 - 5,
      size.y * 0.75 - 5,
    );
    add(_myMuteBadge!);

    _myQualityBadge = ConnectionQualityBadge();
    _myQualityBadge!.position = Vector2(
      size.x * 0.5 + charW / 2 - 5,
      size.y * 0.75 - charH - 12,
    );
    add(_myQualityBadge!);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Recalculate dynamic scale for characters on resize
    if (_myCharacter != null) {
      final scale = calcDisplayScale();
      _myCharacter!.displayScale = scale;
    }
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

      case RemoteCharacterAdded(:final userId, :final name, :final equippedItems, :final skinColor, :final isMuted, :final isHost):
        if (userId == myUserId) return;
        _addRemoteCharacter(userId, name, equippedItems, skinColor, isMuted, isHost);

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
    bool isHost,
  ) {
    if (_remoteCharacters.containsKey(userId)) return;

    final remote = RemoteCharacter(
      userId: userId,
      name: name,
      equippedItems: equippedItems,
      skinColor: skinColor,
      isHost: isHost,
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
    position = Vector2(0, 12);
    size = Vector2(game.size.x, 20);

    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontSize: 12,
    ))
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0x26FFFFFF),
        fontSize: 12,
        fontWeight: ui.FontWeight.w500,
        letterSpacing: 6,
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

/// Subtle spot marker showing where speakers can stand on the stage.
///
/// Renders a dotted ring at a normalized position. Fades out when
/// a character is close by (within 0.1 normalized distance).
class _StageSpotMarker extends PositionComponent with HasGameReference<VoiceStageGame> {
  final double normX;
  final double normY;

  static const double _radius = 20.0;
  static const double _fadeDistance = 0.1; // normalized distance threshold

  _StageSpotMarker({required this.normX, required this.normY})
      : super(
          size: Vector2(_radius * 2 + 4, _radius * 2 + 4),
          anchor: Anchor.center,
          priority: 5,
        );

  @override
  Future<void> onLoad() async {
    _updatePosition();
  }

  void _updatePosition() {
    position = Vector2(
      game.size.x * normX,
      game.size.y * normY,
    );
  }

  @override
  void render(ui.Canvas canvas) {
    // Compute proximity fade based on all characters on stage
    final fade = _computeFade();
    if (fade < 0.01) return;

    final center = ui.Offset(size.x / 2, size.y / 2);

    // Filled circle background (very subtle)
    canvas.drawCircle(
      center,
      _radius,
      ui.Paint()..color = ui.Color.fromRGBO(255, 255, 255, 0.08 * fade),
    );

    // Dashed ring
    final ringPaint = ui.Paint()
      ..color = ui.Color.fromRGBO(255, 255, 255, 0.15 * fade)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const dashCount = 16;
    const dashAngle = (2 * pi) / dashCount;
    const gapFraction = 0.4;
    const dashSweep = dashAngle * (1 - gapFraction);

    for (var i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      canvas.drawArc(
        ui.Rect.fromCircle(center: center, radius: _radius),
        startAngle,
        dashSweep,
        false,
        ringPaint,
      );
    }
  }

  /// Returns 0.0 (fully hidden) to 1.0 (fully visible) based on how
  /// close any character is to this spot.
  double _computeFade() {
    double minDist = double.infinity;

    // Check local character
    final local = game._myCharacter;
    if (local != null) {
      final charNormX = local.position.x / game.size.x;
      final charNormY = local.position.y / game.size.y;
      final dx = charNormX - normX;
      final dy = charNormY - normY;
      minDist = min(minDist, sqrt(dx * dx + dy * dy));
    }

    // Check remote characters
    for (final remote in game._remoteCharacters.values) {
      final charNormX = remote.position.x / game.size.x;
      final charNormY = remote.position.y / game.size.y;
      final dx = charNormX - normX;
      final dy = charNormY - normY;
      minDist = min(minDist, sqrt(dx * dx + dy * dy));
    }

    if (minDist >= _fadeDistance) return 1.0;
    return (minDist / _fadeDistance).clamp(0.0, 1.0);
  }
}
