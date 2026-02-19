import 'dart:async';
import 'package:flutter/material.dart';

/// A countdown timer widget that displays remaining time and calls onTimeUp.
class CountdownTimerWidget extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback onTimeUp;
  final ValueChanged<int>? onTick;

  const CountdownTimerWidget({
    required this.totalSeconds,
    required this.onTimeUp,
    this.onTick,
    super.key,
  });

  @override
  State<CountdownTimerWidget> createState() => CountdownTimerWidgetState();
}

class CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late int _remaining;
  Timer? _timer;

  int get elapsed => widget.totalSeconds - _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 0) {
        _timer?.cancel();
        widget.onTimeUp();
        return;
      }
      setState(() => _remaining--);
      widget.onTick?.call(_remaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining ~/ 60;
    final seconds = _remaining % 60;
    final isLow = _remaining <= 30;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLow
            ? const Color(0xFFFFEBEE)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLow ? const Color(0xFFF44336) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 18,
            color: isLow ? const Color(0xFFF44336) : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: isLow ? const Color(0xFFF44336) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
