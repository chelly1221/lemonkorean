import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/onboarding_colors.dart';
import '../utils/onboarding_text_styles.dart';

/// Professional primary button for onboarding with gradient and animations
class OnboardingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const OnboardingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
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
            // Toss-style: solid color, no gradient, no shadow
            color: widget.isEnabled
                ? OnboardingColors.primaryYellow
                : const Color(0xFFE5E8EB),  // Disabled gray
            borderRadius: BorderRadius.circular(14),  // Slightly larger radius
          ),
          child: Center(
            child: Text(
              widget.text,
              style: OnboardingTextStyles.buttonLarge.copyWith(
                color: widget.isEnabled
                    ? OnboardingColors.textPrimary  // Dark text on yellow
                    : OnboardingColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
