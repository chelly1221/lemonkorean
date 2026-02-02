import 'package:flutter/material.dart';
import 'onboarding_colors.dart';

/// Toss-style typography system for onboarding screens
class OnboardingTextStyles {
  // Large title - Toss uses very bold, tight letter spacing
  static const headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,  // Extra bold for Toss style
    height: 1.3,
    letterSpacing: -0.8,          // Tighter letter spacing
    color: OnboardingColors.textPrimary,
  );

  // Section title
  static const headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.35,
    letterSpacing: -0.5,
    color: OnboardingColors.textPrimary,
  );

  // Body text
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: OnboardingColors.textSecondary,
  );

  // Smaller body text
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: OnboardingColors.textSecondary,
  );

  // Button text - Toss uses medium weight, not too bold
  static const buttonLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  // Caption/label text
  static const caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: OnboardingColors.textTertiary,
  );

  // Card title
  static const cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: OnboardingColors.textPrimary,
    letterSpacing: -0.2,
  );
}
