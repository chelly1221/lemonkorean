import 'dart:math';
import 'package:flutter/material.dart';
import 'lemon_slice_painter.dart';

/// Giant interactive lemon wheel that displays 9 learning stages.
/// Users can drag horizontally to rotate and select different stages.
/// Only the center portion is visible, with the selected slice highlighted.
class GiantLemonWheel extends StatefulWidget {
  final List<({int stage, String title, String subtitle})> stages;
  final List<double> stageProgress; // Progress for each stage (0-5)
  final int initialStage; // Initial selected stage
  final ValueChanged<int>? onStageSelected; // Callback when stage is selected

  const GiantLemonWheel({
    required this.stages,
    required this.stageProgress,
    super.key,
    this.initialStage = 0,
    this.onStageSelected,
  })  : assert(stages.length == 9, 'Must have exactly 9 stages'),
        assert(
            stageProgress.length == 9, 'Must have exactly 9 progress values');

  @override
  State<GiantLemonWheel> createState() => _GiantLemonWheelState();
}

class _GiantLemonWheelState extends State<GiantLemonWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _snapController;
  late Animation<double> _snapAnimation;

  double _currentRotation = 0.0;
  int _centerSliceIndex = 0;
  double _dragStartX = 0.0;
  double _rotationAtDragStart = 0.0;

  @override
  void initState() {
    super.initState();
    _centerSliceIndex = widget.initialStage;

    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _snapAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _snapController,
      curve: Curves.easeOut,
    ));

    _snapAnimation.addListener(() {
      setState(() {
        _currentRotation = _snapAnimation.value;
      });
    });

    // Initialize rotation to show selected stage at center
    _currentRotation = -widget.initialStage * (2 * pi / 9);
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GiantLemonWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // External updates can be handled here if needed
  }

  /// Calculate which slice is currently at center (0 degrees / top)
  int _calculateCenterSliceIndex(double rotation) {
    const sliceAngle = 2 * pi / 9;
    final normalizedRotation = rotation % (2 * pi);

    // Calculate index based on rotation
    // We add a small offset to ensure proper rounding
    final rawIndex = -normalizedRotation / sliceAngle;
    var index = rawIndex.round() % 9;

    // Ensure positive index
    if (index < 0) index += 9;

    return index;
  }

  /// Snap to the nearest stage after drag ends
  void _snapToNearestStage() {
    const sliceAngle = 2 * pi / 9;

    // Find nearest slice
    final nearestIndex = _calculateCenterSliceIndex(_currentRotation);
    final targetRotation = -nearestIndex * sliceAngle;

    _snapAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _snapController,
      curve: Curves.easeOut,
    ));

    _snapController
      ..reset()
      ..forward();

    // Update center slice index
    setState(() {
      _centerSliceIndex = nearestIndex;
    });

    // Notify parent
    widget.onStageSelected?.call(nearestIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Giant wheel diameter (3.5x screen height)
    final wheelDiameter = screenHeight * 3.5;

    // Viewport height (40% of screen)
    final viewportHeight = screenHeight * 0.4;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        _snapController.stop();
        _dragStartX = details.globalPosition.dx;
        _rotationAtDragStart = _currentRotation;
      },
      onHorizontalDragUpdate: (details) {
        final dragDelta = details.globalPosition.dx - _dragStartX;

        // Convert drag distance to rotation angle
        // Screen width drag = 360 degrees rotation
        final rotationDelta = (dragDelta / screenWidth) * 2 * pi;

        setState(() {
          _currentRotation = _rotationAtDragStart + rotationDelta;
          _centerSliceIndex = _calculateCenterSliceIndex(_currentRotation);
        });
      },
      onHorizontalDragEnd: (details) {
        _snapToNearestStage();
      },
      child: ClipRect(
        child: SizedBox(
          height: viewportHeight,
          width: screenWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Giant lemon wheel
              Transform.rotate(
                angle: _currentRotation,
                child: CustomPaint(
                  size: Size(wheelDiameter, wheelDiameter),
                  painter: GiantLemonSlicePainter(
                    centerIndex: _centerSliceIndex,
                    stageProgress: widget.stageProgress,
                  ),
                ),
              ),

              // Center indicator (selection area guide)
              Positioned(
                top: viewportHeight / 2 - 60,
                child: _buildCenterIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build center indicator to show selection area
  Widget _buildCenterIndicator() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFFF6F00).withValues(alpha: 0.3),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.arrow_downward,
          size: 32,
          color: const Color(0xFFFF6F00).withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
