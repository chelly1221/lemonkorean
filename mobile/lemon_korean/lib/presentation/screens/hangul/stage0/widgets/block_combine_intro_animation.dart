import 'dart:math';
import 'package:flutter/material.dart';

/// Intro animation: two puzzle-like blocks (consonant + vowel) slide together,
/// snap with a bounce, then transform into the combined syllable with a glow burst.
class BlockCombineIntroAnimation extends StatefulWidget {
  final String consonant;
  final String vowel;
  final String result;

  const BlockCombineIntroAnimation({
    required this.consonant,
    required this.vowel,
    required this.result,
    super.key,
  });

  @override
  State<BlockCombineIntroAnimation> createState() =>
      _BlockCombineIntroAnimationState();
}

class _BlockCombineIntroAnimationState extends State<BlockCombineIntroAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _loopController;

  // Phase 1 (0.0–0.15): blocks appear with bounce
  late final Animation<double> _appearScale;
  // Phase 2 (0.15–0.50): blocks float with gentle bob
  late final Animation<double> _floatPhase;
  // Phase 3 (0.50–0.70): blocks slide together
  late final Animation<double> _slideProgress;
  // Phase 4 (0.70–0.80): impact shake + flash
  late final Animation<double> _impactProgress;
  // Phase 5 (0.80–1.0): result reveal + glow
  late final Animation<double> _revealProgress;

  final List<_Particle> _particles = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _appearScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOutBack),
      ),
    );

    _floatPhase = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.50, curve: Curves.linear),
      ),
    );

    _slideProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.50, 0.70, curve: Curves.easeInCubic),
      ),
    );

    _impactProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.70, 0.80, curve: Curves.easeOut),
      ),
    );

    _revealProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loopController.repeat(reverse: true);
      }
    });

    _mainController.addListener(() {
      // Generate particles at impact moment
      if (_mainController.value >= 0.70 && _mainController.value <= 0.72 && _particles.isEmpty) {
        _generateParticles();
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _mainController.forward();
    });
  }

  void _generateParticles() {
    for (int i = 0; i < 12; i++) {
      _particles.add(_Particle(
        angle: _random.nextDouble() * 2 * pi,
        speed: 40 + _random.nextDouble() * 60,
        size: 4 + _random.nextDouble() * 6,
        color: [
          const Color(0xFF42A5F5),
          const Color(0xFFEF5350),
          const Color(0xFFFFD54F),
          const Color(0xFF66BB6A),
        ][_random.nextInt(4)],
      ));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _loopController]),
      builder: (context, child) {
        final appear = _appearScale.value;
        final floatT = _floatPhase.value;
        final slide = _slideProgress.value;
        final impact = _impactProgress.value;
        final reveal = _revealProgress.value;

        // Float bob offset (gentle up-down while waiting)
        final bobOffset = sin(floatT * pi * 4) * 6 * (1 - slide);

        // Slide distance: blocks start 110px apart, end at 0
        final slideOffset = 110.0 * (1 - slide);

        // Impact shake
        final shakeX = impact < 1 ? sin(impact * pi * 6) * 4 * (1 - impact) : 0.0;
        final shakeY = impact < 1 ? sin(impact * pi * 4) * 3 * (1 - impact) : 0.0;

        // After reveal, gentle float for the result
        final resultBob = _loopController.value * 6 - 3;

        final showBlocks = reveal < 0.5;
        final resultScale = reveal > 0 ? 0.5 + reveal * 0.5 : 0.0;

        return SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Particles
              if (_particles.isNotEmpty && impact > 0)
                ..._particles.map((p) {
                  final progress = (impact + reveal * 0.3).clamp(0.0, 1.0);
                  final dx = cos(p.angle) * p.speed * progress;
                  final dy = sin(p.angle) * p.speed * progress;
                  final opacity = (1 - progress).clamp(0.0, 1.0);
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(dx, dy),
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: p.size,
                            height: p.size,
                            decoration: BoxDecoration(
                              color: p.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

              // Glow behind result
              if (reveal > 0.2)
                Opacity(
                  opacity: ((reveal - 0.2) * 1.25).clamp(0.0, 0.6),
                  child: Transform.translate(
                    offset: Offset(0, resultBob),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Left block (consonant)
              if (showBlocks)
                Transform.translate(
                  offset: Offset(
                    -slideOffset + shakeX,
                    bobOffset + shakeY,
                  ),
                  child: Transform.scale(
                    scale: appear,
                    child: _PuzzleBlock(
                      char: widget.consonant,
                      color: const Color(0xFF42A5F5),
                      notchSide: _NotchSide.right,
                      opacity: 1 - reveal * 2,
                    ),
                  ),
                ),

              // Right block (vowel)
              if (showBlocks)
                Transform.translate(
                  offset: Offset(
                    slideOffset + shakeX,
                    -bobOffset + shakeY,
                  ),
                  child: Transform.scale(
                    scale: appear,
                    child: _PuzzleBlock(
                      char: widget.vowel,
                      color: const Color(0xFFEF5350),
                      notchSide: _NotchSide.left,
                      opacity: 1 - reveal * 2,
                    ),
                  ),
                ),

              // "+" label between blocks during float phase
              if (showBlocks && slide < 0.3)
                Opacity(
                  opacity: ((1 - slide * 3) * appear).clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, bobOffset * 0.5),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Result block
              if (reveal > 0)
                Transform.translate(
                  offset: Offset(0, resultBob),
                  child: Transform.scale(
                    scale: resultScale,
                    child: Opacity(
                      opacity: reveal.clamp(0.0, 1.0),
                      child: _ResultBlock(
                        char: widget.result,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

enum _NotchSide { left, right }

/// A single puzzle-like block with a 3D shadow and notch connector.
class _PuzzleBlock extends StatelessWidget {
  final String char;
  final Color color;
  final _NotchSide notchSide;
  final double opacity;

  const _PuzzleBlock({
    required this.char,
    required this.color,
    required this.notchSide,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: SizedBox(
        width: 90,
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 3D shadow layer
            Positioned(
              left: 3,
              top: 5,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            // Main block
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color, width: 2.5),
                ),
                child: Center(
                  child: Text(
                    char,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: color.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ),
            ),
            // Puzzle notch (connector tab)
            Positioned(
              left: notchSide == _NotchSide.right ? 70 : -10,
              top: 30,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The combined result block with golden glow.
class _ResultBlock extends StatelessWidget {
  final String char;

  const _ResultBlock({required this.char});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF9C4),
            Color(0xFFFFD54F),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFC107), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFFFFC107).withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          char,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });
}
