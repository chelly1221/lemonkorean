import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/character_item_model.dart';
import '../../../providers/voice_room_provider.dart';
import '../../../widgets/character_avatar_widget.dart';

/// Stage area showing walkable characters for speakers
class StageAreaWidget extends StatefulWidget {
  final int? myUserId;

  const StageAreaWidget({super.key, this.myUserId});

  @override
  State<StageAreaWidget> createState() => _StageAreaWidgetState();
}

class _StageAreaWidgetState extends State<StageAreaWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  // Walking animation
  Offset? _walkTarget;
  static const double _bobAmplitude = 3.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final provider = context.read<VoiceRoomProvider>();
    final chars = provider.stageCharacters;
    bool needsUpdate = false;

    // Interpolate remote characters toward their targets
    for (final entry in chars.entries) {
      if (entry.key == widget.myUserId) continue;
      final char = entry.value;
      final dx = char.targetX - char.x;
      final dy = char.targetY - char.y;
      final dist = sqrt(dx * dx + dy * dy);
      if (dist > 0.002) {
        final step = min(0.02, dist); // smooth interpolation
        char.x += (dx / dist) * step;
        char.y += (dy / dist) * step;
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      setState(() {});
    }
  }

  void _handleTapOnStage(TapUpDetails details, BoxConstraints constraints) {
    final provider = context.read<VoiceRoomProvider>();
    if (!provider.isSpeaker) return;

    final size = constraints.biggest;
    final tapX = details.localPosition.dx / size.width;
    final tapY = details.localPosition.dy / size.height;

    // Clamp to walkable area
    final clampedX = tapX.clamp(0.05, 0.95);
    final clampedY = tapY.clamp(0.3, 0.9);

    _walkTarget = Offset(clampedX, clampedY);
    _animateWalk(provider);
  }

  void _animateWalk(VoiceRoomProvider provider) {
    if (_walkTarget == null) return;

    final target = _walkTarget!;
    final currentX = provider.myStageX;
    final currentY = provider.myStageY;
    final dx = target.dx - currentX;
    final dy = target.dy - currentY;
    final dist = sqrt(dx * dx + dy * dy);

    if (dist < 0.01) {
      _walkTarget = null;
      provider.updateMyStagePosition(target.dx, target.dy, 'front');
      return;
    }

    // Determine direction
    String direction;
    if (dx.abs() > dy.abs()) {
      direction = dx > 0 ? 'right' : 'left';
    } else {
      direction = dy > 0 ? 'front' : 'back';
    }

    final step = min(0.015, dist);
    final newX = currentX + (dx / dist) * step;
    final newY = currentY + (dy / dist) * step;

    provider.updateMyStagePosition(newX, newY, direction);

    // Continue animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _walkTarget != null) {
        _animateWalk(provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapUp: (details) =>
                  _handleTapOnStage(details, constraints),
              child: Container(
                width: double.infinity,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1A1A2E),
                      const Color(0xFF16213E).withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Floor line
                    Positioned(
                      bottom: constraints.maxHeight * 0.05,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Stage label
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'STAGE',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.15),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),

                    // Characters
                    ...provider.stageCharacters.entries.map((entry) {
                      final char = entry.value;
                      final isMe = entry.key == widget.myUserId;
                      final charSize = 120.0;

                      // Apply bob animation for walking
                      final bobOffset = isMe && _walkTarget != null
                          ? sin(DateTime.now().millisecondsSinceEpoch * 0.01) *
                              _bobAmplitude
                          : 0.0;

                      // Gesture animation offset
                      double gestureYOffset = 0;
                      double gestureRotation = 0;
                      double gestureScaleY = 1.0;
                      if (char.activeGesture != null &&
                          char.gestureStartTime != null) {
                        final elapsed = DateTime.now()
                            .difference(char.gestureStartTime!)
                            .inMilliseconds;
                        gestureYOffset =
                            _getGestureYOffset(char.activeGesture!, elapsed);
                        gestureRotation =
                            _getGestureRotation(char.activeGesture!, elapsed);
                        gestureScaleY =
                            _getGestureScaleY(char.activeGesture!, elapsed);
                      }

                      return Positioned(
                        left: char.x * constraints.maxWidth - charSize / 2,
                        top: char.y * constraints.maxHeight -
                            charSize +
                            bobOffset +
                            gestureYOffset,
                        child: Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()
                            ..rotateZ(gestureRotation)
                            // ignore: deprecated_member_use
                            ..scale(1.0, gestureScaleY),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Name label
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.amber.withValues(alpha: 0.8)
                                      : Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isMe ? '${char.name} (You)' : char.name,
                                  style: TextStyle(
                                    color:
                                        isMe ? Colors.black87 : Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 2),

                              // Speaking indicator + character
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Speaking glow (when not muted)
                                  if (!char.isMuted)
                                    Container(
                                      width: charSize + 8,
                                      height: charSize + 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green
                                                .withValues(alpha: 0.2),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Character
                                  RepaintBoundary(
                                    child: SizedBox(
                                      width: charSize,
                                      height: charSize * 1.33,
                                      child: CharacterAvatarWidget(
                                        equippedItems:
                                            _convertEquippedItems(
                                                char.equippedItems),
                                        skinColor:
                                            char.skinColor ?? '#FFDBB4',
                                        direction: _charDirection(
                                            char.direction),
                                        size: charSize,
                                      ),
                                    ),
                                  ),

                                  // Mute indicator
                                  if (char.isMuted)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 1.5),
                                        ),
                                        child: const Icon(
                                          Icons.mic_off,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Floating reactions
                    ...provider.reactions.map((reaction) {
                      final age = DateTime.now()
                          .difference(reaction.createdAt)
                          .inMilliseconds;
                      final progress = (age / 2000.0).clamp(0.0, 1.0);
                      final opacity = 1.0 - progress;
                      final yOffset = -60.0 * progress;

                      return Positioned(
                        left: reaction.startX * constraints.maxWidth - 15,
                        top: reaction.startY * constraints.maxHeight +
                            yOffset -
                            30,
                        child: Opacity(
                          opacity: opacity,
                          child: Text(
                            reaction.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<CharacterItemModel> _convertEquippedItems(
      Map<String, dynamic>? items) {
    if (items == null || items.isEmpty) return [];
    final result = <CharacterItemModel>[];
    items.forEach((category, itemData) {
      if (itemData is Map<String, dynamic>) {
        result.add(CharacterItemModel.fromJson(itemData));
      }
    });
    return result;
  }

  CharacterDirection _charDirection(String dir) {
    switch (dir) {
      case 'left':
        return CharacterDirection.left;
      case 'right':
        return CharacterDirection.right;
      case 'back':
        return CharacterDirection.back;
      default:
        return CharacterDirection.front;
    }
  }

  double _getGestureYOffset(String gesture, int elapsedMs) {
    if (gesture == 'jump') {
      final t = (elapsedMs / 600.0).clamp(0.0, 1.0);
      return -40.0 * sin(t * pi); // parabolic jump
    }
    return 0;
  }

  double _getGestureRotation(String gesture, int elapsedMs) {
    if (gesture == 'wave') {
      final t = (elapsedMs / 800.0).clamp(0.0, 1.0);
      return sin(t * pi * 4) * 0.1;
    }
    if (gesture == 'dance') {
      final t = (elapsedMs / 3000.0).clamp(0.0, 1.0);
      return sin(t * pi * 8) * 0.15;
    }
    return 0;
  }

  double _getGestureScaleY(String gesture, int elapsedMs) {
    if (gesture == 'bow') {
      final t = (elapsedMs / 1000.0).clamp(0.0, 1.0);
      return 1.0 - 0.15 * sin(t * pi);
    }
    return 1.0;
  }
}
