import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/onboarding_colors.dart';

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 72,
          padding: const EdgeInsets.symmetric(
            horizontal: OnboardingSpacing.md,
            vertical: OnboardingSpacing.sm,
          ),
          decoration: BoxDecoration(
            // Toss-style: white card with subtle shadow
            color: widget.isSelected
                ? OnboardingColors.cardSelected
                : OnboardingColors.cardWhite,
            border: Border.all(
              color: widget.isSelected
                  ? OnboardingColors.borderSelected
                  : OnboardingColors.border,
              width: widget.isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: OnboardingColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Flag emoji
              Text(
                widget.flagEmoji,
                style: const TextStyle(fontSize: 32),
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
              // Checkmark (visible when selected)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.isSelected ? 1.0 : 0.0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: OnboardingColors.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
