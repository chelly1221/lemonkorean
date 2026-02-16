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
  static const int _sliceCount = 9;
  static const double _gapAngle = 0.02;
  static const double _sliceAngle = 2 * pi / _sliceCount;
  static const double _sliceCenterOffset = (_sliceAngle - _gapAngle) / 2;

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

    // Initialize rotation to align slice center with viewport center line.
    _currentRotation = _targetRotationForStage(widget.initialStage);
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GiantLemonWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStage != widget.initialStage) {
      _animateToStage(widget.initialStage.clamp(0, 8));
    }
  }

  void _animateToStage(int stageIndex) {
    final targetRotation = _targetRotationForStage(stageIndex);

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

    setState(() {
      _centerSliceIndex = stageIndex;
    });
  }

  double _targetRotationForStage(int stageIndex) {
    return -((stageIndex * _sliceAngle) + _sliceCenterOffset);
  }

  /// Calculate which slice is currently at center (0 degrees / top)
  int _calculateCenterSliceIndex(double rotation) {
    final rawIndex = -(rotation + _sliceCenterOffset) / _sliceAngle;
    var index = rawIndex.round() % _sliceCount;

    // Ensure positive index
    if (index < 0) index += _sliceCount;

    return index;
  }

  /// Snap to the nearest stage after drag ends
  void _snapToNearestStage() {
    // Find nearest slice
    final nearestIndex = _calculateCenterSliceIndex(_currentRotation);
    final targetRotation = _targetRotationForStage(nearestIndex);

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final viewportHeight = constraints.maxHeight;

        // Make the wheel large enough to reach up close to the stage info bottom.
        final wheelDiameter = max(viewportHeight * 2.5, viewportWidth * 2.0);
        final radius = wheelDiameter / 2;

        // Position center below viewport while keeping upper arc visible near top.
        final centerX = viewportWidth / 2;
        final centerY = viewportHeight + (radius * 0.2);

        return GestureDetector(
          onHorizontalDragStart: (details) {
            _snapController.stop();
            _dragStartX = details.globalPosition.dx;
            _rotationAtDragStart = _currentRotation;
          },
          onHorizontalDragUpdate: (details) {
            final dragDelta = details.globalPosition.dx - _dragStartX;

            // Viewport width drag = 360 degrees rotation.
            final rotationDelta = (dragDelta / viewportWidth) * 2 * pi;

            setState(() {
              _currentRotation = _rotationAtDragStart + rotationDelta;
              _centerSliceIndex = _calculateCenterSliceIndex(_currentRotation);
            });
          },
          onHorizontalDragEnd: (details) {
            _snapToNearestStage();
          },
          child: ClipRect(
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Positioned(
                    left: centerX - radius,
                    top: centerY - radius,
                    child: Transform.rotate(
                      angle: _currentRotation,
                      alignment: Alignment.center,
                      child: CustomPaint(
                        size: Size(wheelDiameter, wheelDiameter),
                        painter: GiantLemonSlicePainter(
                          centerIndex: _centerSliceIndex,
                          stageProgress: widget.stageProgress,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
