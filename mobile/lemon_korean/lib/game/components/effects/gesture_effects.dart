import 'package:flame/components.dart';

import 'particle_manager.dart';

/// Spawns appropriate particle effects for character gestures.
class GestureEffects {
  final ParticleManager particles;

  GestureEffects({required this.particles});

  /// Trigger visual effects for a gesture at the character's position.
  void play(String gesture, Vector2 characterPosition) {
    switch (gesture) {
      case 'dance':
        particles.spawnConfetti(characterPosition, count: 15);
      case 'clap':
        particles.spawnImpact(characterPosition);
      case 'jump':
        // Puff on landing (delayed slightly)
        final landingPos = characterPosition.clone()..y += 10;
        Future.delayed(const Duration(milliseconds: 500), () {
          particles.spawnPuff(landingPos, count: 6);
        });
      case 'wave':
        particles.spawnPuff(characterPosition, count: 4);
      case 'bow':
        // Subtle sparkle
        particles.spawnPuff(characterPosition, count: 3);
    }
  }
}
