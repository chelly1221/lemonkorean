import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';

/// Factory for creating various particle effects.
class ParticleManager extends Component with HasGameReference {
  final _random = Random();

  /// Spawn ambient sparkle particles in the room.
  void spawnAmbientSparkles(int count) {
    for (int i = 0; i < count; i++) {
      final x = _random.nextDouble() * game.size.x;
      final y = _random.nextDouble() * game.size.y * 0.6;
      final delay = _random.nextDouble() * 3.0;
      game.add(_SparkleParticle(
        position: Vector2(x, y),
        delay: delay,
      ));
    }
  }

  /// Spawn confetti burst at a position.
  void spawnConfetti(Vector2 position, {int count = 20}) {
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 50 + _random.nextDouble() * 150;
      final color = _confettiColors[_random.nextInt(_confettiColors.length)];
      game.add(_ConfettiParticle(
        position: position.clone(),
        velocity: Vector2(cos(angle) * speed, sin(angle) * speed - 100),
        color: color,
      ));
    }
  }

  /// Spawn puff effect (furniture interaction, landing).
  void spawnPuff(Vector2 position, {int count = 8}) {
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 20 + _random.nextDouble() * 40;
      game.add(_PuffParticle(
        position: position.clone(),
        velocity: Vector2(cos(angle) * speed, sin(angle) * speed - 20),
      ));
    }
  }

  /// Spawn impact particles (clap gesture).
  void spawnImpact(Vector2 position, {int count = 12}) {
    for (int i = 0; i < count; i++) {
      final angle = (i / 12) * 2 * pi;
      final speed = 60 + _random.nextDouble() * 60;
      game.add(_ImpactParticle(
        position: position.clone(),
        velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
      ));
    }
  }

  static const _confettiColors = [
    0xFFFF6B6B, 0xFF4ECDC4, 0xFFFFE66D, 0xFF95E1D3,
    0xFFF38181, 0xFF6C5CE7, 0xFFFF9FF3, 0xFF00D2D3,
  ];
}

/// Single sparkle particle with fade in/out.
class _SparkleParticle extends PositionComponent {
  double delay;
  double _life = 0;
  static const _duration = 2.0;

  _SparkleParticle({required super.position, required this.delay})
      : super(size: Vector2.all(4));

  @override
  void update(double dt) {
    super.update(dt);
    if (delay > 0) {
      delay -= dt;
      return;
    }
    _life += dt;
    if (_life >= _duration) removeFromParent();
  }

  @override
  void render(ui.Canvas canvas) {
    if (delay > 0) return;
    final t = _life / _duration;
    final alpha = t < 0.5 ? t * 2 : (1 - t) * 2;
    canvas.drawCircle(
      const ui.Offset(2, 2),
      2,
      ui.Paint()..color = ui.Color.fromRGBO(255, 255, 200, alpha.clamp(0, 1)),
    );
  }
}

/// Confetti particle with gravity and color.
class _ConfettiParticle extends PositionComponent {
  Vector2 velocity;
  final int color;
  double _life = 0;
  static const _duration = 1.5;
  static const _gravity = 200.0;

  _ConfettiParticle({
    required super.position,
    required this.velocity,
    required this.color,
  }) : super(size: Vector2(4, 6));

  @override
  void update(double dt) {
    super.update(dt);
    _life += dt;
    if (_life >= _duration) {
      removeFromParent();
      return;
    }
    velocity.y += _gravity * dt;
    position += velocity * dt;
  }

  @override
  void render(ui.Canvas canvas) {
    final alpha = (1.0 - _life / _duration).clamp(0.0, 1.0);
    canvas.drawRect(
      size.toRect(),
      ui.Paint()..color = ui.Color(color).withValues(alpha: alpha),
    );
  }
}

/// Soft puff particle.
class _PuffParticle extends PositionComponent {
  Vector2 velocity;
  double _life = 0;
  static const _duration = 0.6;

  _PuffParticle({required super.position, required this.velocity})
      : super(size: Vector2.all(6));

  @override
  void update(double dt) {
    super.update(dt);
    _life += dt;
    if (_life >= _duration) {
      removeFromParent();
      return;
    }
    position += velocity * dt;
    velocity *= 0.95; // friction
  }

  @override
  void render(ui.Canvas canvas) {
    final alpha = (1.0 - _life / _duration).clamp(0.0, 1.0);
    final radius = 3 + (_life / _duration) * 4;
    canvas.drawCircle(
      const ui.Offset(3, 3),
      radius,
      ui.Paint()..color = ui.Color.fromRGBO(200, 200, 200, alpha * 0.5),
    );
  }
}

/// Sharp impact line particle.
class _ImpactParticle extends PositionComponent {
  Vector2 velocity;
  double _life = 0;
  static const _duration = 0.4;

  _ImpactParticle({required super.position, required this.velocity})
      : super(size: Vector2.all(3));

  @override
  void update(double dt) {
    super.update(dt);
    _life += dt;
    if (_life >= _duration) {
      removeFromParent();
      return;
    }
    position += velocity * dt;
  }

  @override
  void render(ui.Canvas canvas) {
    final alpha = (1.0 - _life / _duration).clamp(0.0, 1.0);
    canvas.drawCircle(
      const ui.Offset(1.5, 1.5),
      1.5,
      ui.Paint()..color = ui.Color.fromRGBO(255, 255, 100, alpha),
    );
  }
}
