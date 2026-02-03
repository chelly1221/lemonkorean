import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/hangul_character_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Stroke Order Animation Widget
/// Displays stroke order for hangul characters with animation
class StrokeOrderAnimation extends StatefulWidget {
  final HangulCharacterModel character;
  final bool showControls;

  const StrokeOrderAnimation({
    required this.character,
    this.showControls = true,
    super.key,
  });

  @override
  State<StrokeOrderAnimation> createState() => _StrokeOrderAnimationState();
}

class _StrokeOrderAnimationState extends State<StrokeOrderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.character.strokeCount * 500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isAnimating = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    setState(() => _isAnimating = true);
    _controller.forward(from: 0);
  }

  void _stopAnimation() {
    _controller.stop();
    setState(() => _isAnimating = false);
  }

  void _resetAnimation() {
    _controller.reset();
    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.edit,
                color: Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.strokeOrder,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                l10n.strokesCount(widget.character.strokeCount),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Character display area
          if (widget.character.hasStrokeOrder)
            _buildStrokeOrderImage()
          else
            _buildStaticCharacter(),

          // Controls
          if (widget.showControls && widget.character.hasStrokeOrder) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _resetAnimation,
                  icon: const Icon(Icons.replay),
                  tooltip: l10n.reset,
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _isAnimating ? _stopAnimation : _playAnimation,
                  icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
                  tooltip: _isAnimating ? l10n.pause : l10n.play,
                  style: IconButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStrokeOrderImage() {
    // If stroke order image/SVG is available, display it
    // For now, show placeholder with animated opacity
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background grid
              CustomPaint(
                size: const Size(150, 150),
                painter: _GridPainter(),
              ),
              // Character with animated opacity
              Opacity(
                opacity: _controller.value,
                child: Text(
                  widget.character.character,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStaticCharacter() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background grid
          CustomPaint(
            size: const Size(150, 150),
            painter: _GridPainter(),
          ),
          // Static character
          Text(
            widget.character.character,
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid painter for writing practice
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    // Vertical center line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Horizontal center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Diagonal lines (optional for practice)
    final dashedPaint = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 1;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      dashedPaint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      dashedPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
