import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Level selection card widget with TOPIK indicator
class LevelSelectionCard extends StatefulWidget {
  final String title;
  final String description;
  final String topikLevel;
  final bool isSelected;
  final VoidCallback onTap;

  const LevelSelectionCard({
    required this.title,
    required this.description,
    required this.topikLevel,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  State<LevelSelectionCard> createState() => _LevelSelectionCardState();
}

class _LevelSelectionCardState extends State<LevelSelectionCard>
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

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

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
          height: screenHeight * 0.108, // 104/965
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.043, // 16/375
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
              // ── Icon ─────────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: widget.isSelected ? const Color(0xFFFFFEF7) : Colors.white,
                  border: Border.all(
                    color: widget.isSelected
                        ? const Color(0xFFFFDB59)
                        : const Color(0xFFF2E3CE),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(2.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.5),
                  child: SvgPicture.asset(
                    'assets/images/level_card_icon.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.024),

              // ── Text column ──────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    SizedBox(height: screenHeight * 0.002),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: screenWidth * 0.037,
                        color: const Color(0xFF907866),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    // ── TOPIK coral tag ──────────────────────
                    IntrinsicWidth(
                      child: Container(
                        height: screenHeight * 0.023,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9868),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.topikLevel,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: screenWidth * 0.024,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
