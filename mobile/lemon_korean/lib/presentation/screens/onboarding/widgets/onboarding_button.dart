import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/onboarding_colors.dart';
import '../utils/onboarding_text_styles.dart';

/// Button variant for styling
enum OnboardingButtonVariant {
  primary,   // Filled yellow background
  secondary, // Outlined with border
}

/// Professional primary button for onboarding with gradient and animations
class OnboardingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final OnboardingButtonVariant variant;
  final Color? backgroundColor;

  const OnboardingButton({
    required this.text,
    this.onPressed,
    this.variant = OnboardingButtonVariant.primary,
    this.isEnabled = true,
    this.backgroundColor,
    super.key,
  });

  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled && widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isEnabled && widget.onPressed != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.isEnabled && widget.onPressed != null) {
      _controller.reverse();
    }
  }

  void _handleTap() {
    if (widget.isEnabled && widget.onPressed != null) {
      HapticFeedback.mediumImpact();
      widget.onPressed!();
    }
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
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            // Primary: solid yellow, Secondary: outlined
            color: widget.variant == OnboardingButtonVariant.primary
                ? (widget.isEnabled
                    ? (widget.backgroundColor ?? OnboardingColors.primaryYellow)
                    : const Color(0xFFE5E8EB))  // Disabled gray
                : Colors.transparent,  // Secondary: transparent background
            borderRadius: BorderRadius.circular(14),  // Slightly larger radius
            border: widget.variant == OnboardingButtonVariant.secondary
                ? Border.all(
                    color: widget.isEnabled
                        ? OnboardingColors.textSecondary
                        : const Color(0xFFE5E8EB),
                    width: 1.5,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: OnboardingTextStyles.buttonLarge.copyWith(
                color: widget.variant == OnboardingButtonVariant.primary
                    ? (widget.isEnabled
                        ? OnboardingColors.textPrimary  // Dark text on yellow
                        : OnboardingColors.textTertiary)
                    : (widget.isEnabled
                        ? OnboardingColors.textPrimary  // Dark text for secondary
                        : OnboardingColors.textTertiary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
