import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Goal selection card — matches level selection card visual pattern
class GoalSelectionCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String timeText;
  final String helperText;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalSelectionCard({
    required this.emoji,
    required this.title,
    required this.timeText,
    required this.helperText,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  State<GoalSelectionCard> createState() => _GoalSelectionCardState();
}

class _GoalSelectionCardState extends State<GoalSelectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) => _controller.forward();
  void _handleTapUp(TapUpDetails details) => _controller.reverse();
  void _handleTapCancel() => _controller.reverse();

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: screenHeight * 0.108,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.043,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFFFF9D3)
                : const Color(0xFFFBF6EF),
            border: widget.isSelected
                ? Border.all(color: const Color(0xFFFFDB59), width: 2)
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              // ── Icon box ─────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? const Color(0xFFFFFEF7)
                      : Colors.white,
                  border: Border.all(
                    color: widget.isSelected
                        ? const Color(0xFFFFDB59)
                        : const Color(0xFFF2E3CE),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),

              SizedBox(width: screenWidth * 0.024),

              // ── Text column ───────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Line 1: Title
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: screenWidth * 0.0427,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF43240D),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0),
                    // Line 2: Time
                    Text(
                      widget.timeText,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: screenWidth * 0.037,
                        height: 1.1,
                        color: const Color(0xFF907866),
                      ),
                    ),
                    SizedBox(height: 3),
                    // Line 3: Helper text
                    Text(
                      widget.helperText,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: screenWidth * 0.033,
                        height: 1.1,
                        color: const Color(0xFF907866),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
