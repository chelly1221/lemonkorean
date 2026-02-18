import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/onboarding_colors.dart';

// Local colors for redesigned card
const _selectedBg = Color(0xFFFFF9D3);
const _selectedBorder = Color(0xFFFFDB59);
const _unselectedBg = Color(0xFFFBF6EF);

/// Tappable card for vertical language list
class LanguageSelectionCard extends StatefulWidget {
  final String flagEmoji;
  final String nativeName;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageSelectionCard({
    required this.flagEmoji,
    required this.nativeName,
    required this.isSelected,
    required this.onTap,
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

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentLeft = constraints.maxWidth * 0.38;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 50,
              padding: EdgeInsets.only(
                left: contentLeft,
                right: OnboardingSpacing.md,
                top: OnboardingSpacing.sm,
                bottom: OnboardingSpacing.sm,
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
                  // Flag emoji in a fixed rectangular container
                  SizedBox(
                    width: 30,
                    height: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.flagEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: OnboardingSpacing.md),
                  // Language name
                  Expanded(
                    child: Text(
                      widget.nativeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
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
