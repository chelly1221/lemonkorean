import 'package:flutter/material.dart';

/// Animates consonant + vowel splitting apart then combining into a syllable.
class SyllableCombineAnimation extends StatefulWidget {
  final String consonant;
  final String vowel;
  final String result;
  final VoidCallback? onComplete;

  const SyllableCombineAnimation({
    required this.consonant,
    required this.vowel,
    required this.result,
    this.onComplete,
    super.key,
  });

  @override
  State<SyllableCombineAnimation> createState() =>
      _SyllableCombineAnimationState();
}

class _SyllableCombineAnimationState extends State<SyllableCombineAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _splitAnim;
  late final Animation<double> _mergeAnim;
  late final Animation<double> _resultOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Phase 1 (0.0–0.4): characters split apart
    _splitAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );

    // Phase 2 (0.4–0.75): characters come back together
    _mergeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.75, curve: Curves.easeInOut)),
    );

    // Phase 3 (0.75–1.0): result syllable fades in
    _resultOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0, curve: Curves.easeIn)),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    // Auto-start after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Split offset: how far apart the characters move
        final splitOffset = _splitAnim.value * 60;
        // Merge: bring them back
        final mergeOffset = splitOffset * (1 - _mergeAnim.value);
        // Final offset used for positioning
        final offset = splitOffset > 0 ? mergeOffset : 0.0;

        final resultAlpha = _resultOpacity.value;
        final showParts = resultAlpha < 0.5;

        return SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Consonant (left)
              if (showParts)
                Transform.translate(
                  offset: Offset(-offset - 30, 0),
                  child: Opacity(
                    opacity: 1 - resultAlpha * 2,
                    child: _CharTile(
                      char: widget.consonant,
                      color: const Color(0xFF42A5F5),
                    ),
                  ),
                ),
              // Plus sign
              if (showParts && offset > 10)
                Opacity(
                  opacity: (1 - _mergeAnim.value).clamp(0, 1),
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              // Vowel (right)
              if (showParts)
                Transform.translate(
                  offset: Offset(offset + 30, 0),
                  child: Opacity(
                    opacity: 1 - resultAlpha * 2,
                    child: _CharTile(
                      char: widget.vowel,
                      color: const Color(0xFFEF5350),
                    ),
                  ),
                ),
              // Result syllable
              if (resultAlpha > 0)
                Opacity(
                  opacity: resultAlpha,
                  child: Transform.scale(
                    scale: 0.8 + resultAlpha * 0.2,
                    child: _CharTile(
                      char: widget.result,
                      color: const Color(0xFFFFD54F),
                      size: 72,
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

class _CharTile extends StatelessWidget {
  final String char;
  final Color color;
  final double size;

  const _CharTile({
    required this.char,
    required this.color,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 20,
      height: size + 20,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2.5),
      ),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontSize: size * 0.7,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
