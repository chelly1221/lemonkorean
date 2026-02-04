import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/onboarding_colors.dart';
import '../utils/onboarding_text_styles.dart';

/// Goal selection card with color-coded border and time indicator
class GoalSelectionCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String description;
  final String timeText;
  final String helperText;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalSelectionCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.timeText,
    required this.helperText,
    required this.accentColor,
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
                  ? widget.accentColor
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Emoji
                  Text(
                    widget.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: OnboardingSpacing.sm),
                  // Title
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  // Checkmark - Toss style filled circle
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: widget.isSelected ? 1.0 : 0.0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.accentColor,
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
              const SizedBox(height: OnboardingSpacing.sm),
              // Description
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: OnboardingColors.textSecondary,
                ),
              ),
              const SizedBox(height: OnboardingSpacing.sm),
              // Time indicator - Toss style
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: widget.isSelected
                        ? widget.accentColor
                        : OnboardingColors.textTertiary,
                  ),
                  const SizedBox(width: OnboardingSpacing.xs),
                  Text(
                    widget.timeText,
                    style: OnboardingTextStyles.caption.copyWith(
                      color: widget.isSelected
                          ? OnboardingColors.textPrimary
                          : OnboardingColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OnboardingSpacing.xs),
              // Helper text
              Text(
                widget.helperText,
                style: OnboardingTextStyles.caption.copyWith(
                  fontStyle: FontStyle.italic,
                  color: OnboardingColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
