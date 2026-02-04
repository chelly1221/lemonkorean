import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Writing mode for the canvas
enum WritingMode {
  animation,
  traceWithGuide,
  freehand,
}

/// A single stroke point
class StrokePoint {
  final double x;
  final double y;
  final double pressure;

  StrokePoint(this.x, this.y, [this.pressure = 0.5]);

  PointVector toPointVector() => PointVector(x, y, pressure);
}

/// Writing canvas widget for Korean character practice
class WritingCanvas extends StatefulWidget {
  final String character;
  final WritingMode mode;
  final String? guideImageUrl;
  final VoidCallback? onComplete;
  final Function(double accuracy)? onAccuracyCalculated;
  final bool showGuide;
  final Color strokeColor;
  final double strokeWidth;

  const WritingCanvas({
    required this.character,
    this.mode = WritingMode.freehand,
    this.guideImageUrl,
    this.onComplete,
    this.onAccuracyCalculated,
    this.showGuide = true,
    this.strokeColor = Colors.black,
    this.strokeWidth = 8.0,
    super.key,
  });

  @override
  State<WritingCanvas> createState() => _WritingCanvasState();
}

class _WritingCanvasState extends State<WritingCanvas>
    with SingleTickerProviderStateMixin {
  final List<List<StrokePoint>> _strokes = [];
  List<StrokePoint> _currentStroke = [];
  late AnimationController _animationController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    if (widget.mode == WritingMode.animation) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    setState(() => _isAnimating = true);
    _animationController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() => _isAnimating = false);
        widget.onComplete?.call();
      }
    });
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.mode == WritingMode.animation || _isAnimating) return;

    setState(() {
      _currentStroke = [
        StrokePoint(
          details.localPosition.dx,
          details.localPosition.dy,
        ),
      ];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.mode == WritingMode.animation || _isAnimating) return;

    setState(() {
      _currentStroke.add(
        StrokePoint(
          details.localPosition.dx,
          details.localPosition.dy,
        ),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.mode == WritingMode.animation || _isAnimating) return;

    if (_currentStroke.isNotEmpty) {
      setState(() {
        _strokes.add(List.from(_currentStroke));
        _currentStroke.clear();
      });

      // Calculate accuracy if callback provided
      if (widget.onAccuracyCalculated != null && _strokes.isNotEmpty) {
        final accuracy = _calculateAccuracy();
        widget.onAccuracyCalculated!(accuracy);
      }
    }
  }

  double _calculateAccuracy() {
    // Simplified accuracy calculation
    // In a real implementation, this would compare with reference strokes
    if (_strokes.isEmpty) return 0.0;

    // For now, return a placeholder based on stroke count and coverage
    final totalPoints =
        _strokes.fold<int>(0, (sum, stroke) => sum + stroke.length);
    final minExpectedPoints = 50;

    if (totalPoints < minExpectedPoints) {
      return (totalPoints / minExpectedPoints).clamp(0.0, 1.0);
    }

    return 0.8 + (0.2 * (totalPoints / 200).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Grid background
            CustomPaint(
              size: Size.infinite,
              painter: _GridPainter(),
            ),

            // Guide character (semi-transparent)
            if (widget.showGuide &&
                widget.mode != WritingMode.animation)
              Center(
                child: Text(
                  widget.character,
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.w100,
                    color: widget.mode == WritingMode.traceWithGuide
                        ? Colors.grey.shade400
                        : Colors.grey.shade200,
                  ),
                ),
              ),

            // Stroke animation for animation mode
            if (widget.mode == WritingMode.animation)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _AnimatedCharacterPainter(
                      character: widget.character,
                      progress: _animationController.value,
                    ),
                  );
                },
              ),

            // User strokes
            if (widget.mode != WritingMode.animation)
              GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                behavior: HitTestBehavior.opaque,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _StrokePainter(
                    strokes: _strokes,
                    currentStroke: _currentStroke,
                    strokeColor: widget.strokeColor,
                    strokeWidth: widget.strokeWidth,
                  ),
                ),
              ),

            // Clear button
            if (widget.mode != WritingMode.animation && _strokes.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: _clearCanvas,
                  icon: const Icon(Icons.refresh),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey.shade700,
                  ),
                ),
              ),

            // Replay button for animation mode
            if (widget.mode == WritingMode.animation && !_isAnimating)
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  onPressed: _startAnimation,
                  icon: const Icon(Icons.replay),
                  style: IconButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Grid background painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    // Cross lines
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Diagonal lines (optional)
    final dashedPaint = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), dashedPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), dashedPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Stroke painter using perfect_freehand
class _StrokePainter extends CustomPainter {
  final List<List<StrokePoint>> strokes;
  final List<StrokePoint> currentStroke;
  final Color strokeColor;
  final double strokeWidth;

  _StrokePainter({
    required this.strokes,
    required this.currentStroke,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }

    // Draw current stroke
    if (currentStroke.isNotEmpty) {
      _drawStroke(canvas, currentStroke, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<StrokePoint> points, Paint paint) {
    if (points.isEmpty) return;

    final strokeOptions = StrokeOptions(
      size: strokeWidth,
      thinning: 0.5,
      smoothing: 0.5,
      streamline: 0.5,
      start: StrokeEndOptions.start(
        taperEnabled: true,
        customTaper: 0.0,
        cap: true,
      ),
      end: StrokeEndOptions.end(
        taperEnabled: true,
        customTaper: 0.0,
        cap: true,
      ),
    );

    final outlinePoints = getStroke(
      points.map((p) => p.toPointVector()).toList(),
      options: strokeOptions,
    );

    if (outlinePoints.isEmpty) return;

    final path = Path();
    if (outlinePoints.length == 1) {
      path.addOval(Rect.fromCircle(
        center: outlinePoints[0],
        radius: strokeWidth / 2,
      ));
    } else {
      path.moveTo(outlinePoints[0].dx, outlinePoints[0].dy);
      for (int i = 1; i < outlinePoints.length; i++) {
        path.lineTo(outlinePoints[i].dx, outlinePoints[i].dy);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) {
    return strokes != oldDelegate.strokes ||
        currentStroke != oldDelegate.currentStroke;
  }
}

/// Animated character painter for stroke order animation
class _AnimatedCharacterPainter extends CustomPainter {
  final String character;
  final double progress;

  _AnimatedCharacterPainter({
    required this.character,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw character with animation progress
    final textPainter = TextPainter(
      text: TextSpan(
        text: character,
        style: TextStyle(
          fontSize: 200,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Create clip rect based on progress
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
      0,
      0,
      size.width * progress,
      size.height,
    ));

    textPainter.paint(canvas, offset);
    canvas.restore();

    // Also draw fill with lower opacity
    final fillPainter = TextPainter(
      text: TextSpan(
        text: character,
        style: TextStyle(
          fontSize: 200,
          fontWeight: FontWeight.bold,
          color: Colors.black.withValues(alpha: progress * 0.8),
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    fillPainter.layout();
    fillPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _AnimatedCharacterPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        character != oldDelegate.character;
  }
}

/// Full writing practice screen with 3 steps
class HangulWritingScreen extends StatefulWidget {
  final String character;
  final String? guideImageUrl;
  final VoidCallback? onComplete;

  const HangulWritingScreen({
    required this.character,
    this.guideImageUrl,
    this.onComplete,
    super.key,
  });

  @override
  State<HangulWritingScreen> createState() => _HangulWritingScreenState();
}

class _HangulWritingScreenState extends State<HangulWritingScreen> {
  WritingMode _currentMode = WritingMode.animation;
  double _accuracy = 0.0;
  bool _stepCompleted = false;

  void _nextStep() {
    setState(() {
      _stepCompleted = false;
      _accuracy = 0.0;

      switch (_currentMode) {
        case WritingMode.animation:
          _currentMode = WritingMode.traceWithGuide;
          break;
        case WritingMode.traceWithGuide:
          _currentMode = WritingMode.freehand;
          break;
        case WritingMode.freehand:
          // Practice complete
          widget.onComplete?.call();
          Navigator.pop(context);
          return;
      }
    });
  }

  String _getModeTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_currentMode) {
      case WritingMode.animation:
        return l10n.watchAnimation;
      case WritingMode.traceWithGuide:
        return l10n.traceWithGuide;
      case WritingMode.freehand:
        return l10n.freehandWriting;
    }
  }

  int _getStepNumber() {
    switch (_currentMode) {
      case WritingMode.animation:
        return 1;
      case WritingMode.traceWithGuide:
        return 2;
      case WritingMode.freehand:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.writingPractice),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                l10n.strokeOrderStep(_getStepNumber(), 3),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            // Step indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(1, l10n.watchAnimation),
                _buildStepConnector(1),
                _buildStepIndicator(2, l10n.traceWithGuide),
                _buildStepConnector(2),
                _buildStepIndicator(3, l10n.freehandWriting),
              ],
            ),

            const SizedBox(height: 16),

            // Mode title
            Text(
              _getModeTitle(context),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Writing canvas
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: WritingCanvas(
                  character: widget.character,
                  mode: _currentMode,
                  guideImageUrl: widget.guideImageUrl,
                  onComplete: () {
                    setState(() => _stepCompleted = true);
                  },
                  onAccuracyCalculated: (accuracy) {
                    setState(() {
                      _accuracy = accuracy;
                      _stepCompleted = accuracy >= 0.5;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Accuracy display for non-animation modes
            if (_currentMode != WritingMode.animation && _accuracy > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _accuracy >= 0.8
                      ? Colors.green.shade100
                      : _accuracy >= 0.5
                          ? Colors.orange.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _accuracy >= 0.8
                          ? Icons.check_circle
                          : _accuracy >= 0.5
                              ? Icons.warning
                              : Icons.error,
                      size: 20,
                      color: _accuracy >= 0.8
                          ? Colors.green
                          : _accuracy >= 0.5
                              ? Colors.orange
                              : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.writingAccuracy}: ${(_accuracy * 100).toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _accuracy >= 0.8
                            ? Colors.green.shade900
                            : _accuracy >= 0.5
                                ? Colors.orange.shade900
                                : Colors.red.shade900,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _currentMode == WritingMode.animation ||
                        _stepCompleted
                    ? _nextStep
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  _currentMode == WritingMode.freehand
                      ? l10n.finish
                      : l10n.nextStep,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _getStepNumber() == step;
    final isCompleted = _getStepNumber() > step;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : isActive
                    ? AppConstants.primaryColor
                    : Colors.grey.shade300,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.black87 : Colors.grey.shade600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int afterStep) {
    final isCompleted = _getStepNumber() > afterStep;

    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? Colors.green : Colors.grey.shade300,
    );
  }
}
