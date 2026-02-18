import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/onboarding_colors.dart';

// Local colors for redesigned card
const _selectedBg = Color(0xFFFFF9D3);
const _selectedBorder = Color(0xFFFFDB59);
const _unselectedBg = Color(0xFFFBF6EF);

/// Tappable card for vertical language list
class LanguageSelectionCard extends StatefulWidget {
  final String flagEmoji;
  final String? flagSvgAsset;
  final bool flagShowBorder;
  final String nativeName;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageSelectionCard({
    required this.flagEmoji,
    required this.nativeName,
    required this.isSelected,
    required this.onTap,
    this.flagSvgAsset,
    this.flagShowBorder = false,
    super.key,
  });

  @override
  State<LanguageSelectionCard> createState() => _LanguageSelectionCardState();
}

class _LanguageSelectionCardState extends State<LanguageSelectionCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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

  Widget _buildNameText(double screenWidth) {
    final name = widget.nativeName;
    final parenStart = name.indexOf('(');
    if (parenStart == -1) {
      return Text(
        name,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: screenWidth * 0.048,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF43240D),
          letterSpacing: -0.2,
        ),
      );
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: name.substring(0, parenStart),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: screenWidth * 0.048,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF43240D),
              letterSpacing: -0.2,
            ),
          ),
          TextSpan(
            text: name.substring(parenStart),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF43240D),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height * 0.059;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentLeft = constraints.maxWidth * 0.30;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: cardHeight,
              padding: EdgeInsets.only(
                left: contentLeft,
                right: screenWidth * 0.043,
                top: cardHeight * 0.16,
                bottom: cardHeight * 0.16,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected ? _selectedBg : _unselectedBg,
                border: widget.isSelected
                    ? Border.all(color: _selectedBorder, width: 2)
                    : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  // Flag: SVG asset or emoji fallback
                  SizedBox(
                    width: screenWidth * 0.09,
                    height: screenWidth * 0.062,
                    child: Center(
                      child: SizedBox(
                        width: screenWidth * (widget.flagShowBorder ? 0.09 : 0.08),
                        height: screenWidth * (widget.flagShowBorder ? 0.062 : 0.053),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: widget.flagSvgAsset != null
                              ? SvgPicture.asset(
                                  widget.flagSvgAsset!,
                                  fit: BoxFit.cover,
                                )
                              : FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    widget.flagEmoji,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.043),
                  // Language name
                  Expanded(
                    child: _buildNameText(screenWidth),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
