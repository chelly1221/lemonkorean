import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/onboarding_colors.dart';

/// Level selection card widget with TOPIK indicator
/// Enhanced design matching the new onboarding style
class LevelSelectionCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String description;
  final String topikLevel;
  final bool isSelected;
  final VoidCallback onTap;

  const LevelSelectionCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.topikLevel,
    required this.isSelected,
    required this.onTap,
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
          padding: const EdgeInsets.all(OnboardingSpacing.md),
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
            boxShadow: [
              BoxShadow(
                color: OnboardingColors.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Emoji
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: OnboardingSpacing.md),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: OnboardingColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // TOPIK level indicator - Toss style pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? OnboardingColors.primaryYellow.withOpacity(0.2)
                            : OnboardingColors.border,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.topikLevel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.isSelected
                              ? OnboardingColors.textPrimary
                              : OnboardingColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Checkmark - Toss style filled circle
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
