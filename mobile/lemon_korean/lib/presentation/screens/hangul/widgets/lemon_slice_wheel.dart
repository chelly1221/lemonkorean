import 'dart:math';
import 'package:flutter/material.dart';
import 'lemon_slice_painter.dart';

/// Interactive lemon cross-section wheel that displays 9 learning stages.
/// Users can drag to rotate and select different stages.
class LemonSliceWheel extends StatefulWidget {
  final double size; // Diameter of the wheel
  final List<({int stage, String title, String subtitle})> stages;
  final List<double> stageProgress; // Progress for each stage (0-5)
  final int selectedStage; // Initial selected stage
  final ValueChanged<int>? onStageSelected; // Callback when stage is selected

  const LemonSliceWheel({
    required this.size,
    required this.stages,
    required this.stageProgress,
    super.key,
    this.selectedStage = 0,
    this.onStageSelected,
  })  : assert(stages.length == 9, 'Must have exactly 9 stages'),
        assert(
            stageProgress.length == 9, 'Must have exactly 9 progress values');

  @override
  State<LemonSliceWheel> createState() => _LemonSliceWheelState();
}

class _LemonSliceWheelState extends State<LemonSliceWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  double _currentRotation = 0.0;
  int _selectedStageIndex = 0;
  double _startAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedStageIndex = widget.selectedStage;

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutCubic,
    ));

    _rotationAnimation.addListener(() {
      setState(() {
        _currentRotation = _rotationAnimation.value;
      });
    });

    // Initialize rotation to show selected stage at top
    _currentRotation = _calculateTargetRotation(_selectedStageIndex);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LemonSliceWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedStage != widget.selectedStage) {
      _selectedStageIndex = widget.selectedStage;
      _rotateToStage(widget.selectedStage);
    }
  }

  /// Calculate the target rotation angle for a given stage index
  double _calculateTargetRotation(int stageIndex) {
    const sliceAngle = 2 * pi / 9;
    return -stageIndex * sliceAngle;
  }

  /// Calculate which stage is currently at the top (0 degrees)
  int _calculateTopStageIndex(double rotation) {
    const sliceAngle = 2 * pi / 9;
    final normalized = rotation % (2 * pi);

    // Normalize to positive angle
    final positiveAngle = normalized < 0 ? normalized + 2 * pi : normalized;

    // Calculate which slice is at top
    final index = ((-positiveAngle / sliceAngle).round()) % 9;
    return index < 0 ? index + 9 : index;
  }

  /// Calculate tapped stage index from local position.
  int _calculateTappedStageIndex(Offset localPosition) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final radius = sqrt(dx * dx + dy * dy);
    final maxRadius = widget.size / 2;

    // Ignore taps outside wheel.
    if (radius > maxRadius) return _selectedStageIndex;

    const sliceAngle = 2 * pi / 9;
    final angle = atan2(dy, dx);

    // Convert to wheel-local angle with top as 0 and current rotation applied.
    double normalized = angle - _currentRotation - (-pi / 2);
    normalized %= (2 * pi);
    if (normalized < 0) normalized += 2 * pi;

    return (normalized / sliceAngle).floor().clamp(0, 8);
  }

  /// Animate rotation to a specific stage
  void _rotateToStage(int stageIndex) {
    final targetRotation = _calculateTargetRotation(stageIndex);

    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    ));

    _rotationController
      ..reset()
      ..forward();

    setState(() {
      _selectedStageIndex = stageIndex;
    });
  }

  /// Snap to the nearest stage after drag ends
  void _snapToNearestStage() {
    // Find nearest stage
    final nearestIndex = (_calculateTopStageIndex(_currentRotation));
    final targetRotation = _calculateTargetRotation(nearestIndex);

    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOut,
    ));

    _rotationController
      ..reset()
      ..forward();

    setState(() {
      _selectedStageIndex = nearestIndex;
    });

    // Notify parent
    widget.onStageSelected?.call(nearestIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final tappedIndex = _calculateTappedStageIndex(details.localPosition);
        _rotateToStage(tappedIndex);
        widget.onStageSelected?.call(tappedIndex);
      },
      onPanStart: (details) {
        _rotationController.stop();

        final center = Offset(widget.size / 2, widget.size / 2);
        final localPosition = details.localPosition;

        _startAngle = atan2(
              localPosition.dy - center.dy,
              localPosition.dx - center.dx,
            ) -
            _currentRotation;
      },
      onPanUpdate: (details) {
        final center = Offset(widget.size / 2, widget.size / 2);
        final localPosition = details.localPosition;

        final angle = atan2(
          localPosition.dy - center.dy,
          localPosition.dx - center.dx,
        );

        setState(() {
          _currentRotation = angle - _startAngle;
        });
      },
      onPanEnd: (details) {
        _snapToNearestStage();
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: LemonSlicePainter(
            rotation: _currentRotation,
            selectedIndex: _selectedStageIndex,
            stageProgress: widget.stageProgress,
          ),
        ),
      ),
    );
  }
}
