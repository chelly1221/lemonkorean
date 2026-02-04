import 'package:flutter/material.dart';

/// Toss-style professional color palette for onboarding screens
class OnboardingColors {
  // === Toss-style Background Colors ===
  static const backgroundYellow = Color(0xFFFFEF5F);     // Bright lemon yellow background
  static const backgroundWhite = Color(0xFFFFFFFF);      // Pure white

  // === Card Colors ===
  static const cardWhite = Color(0xFFFFFFFF);            // White card background
  static const cardSelected = Color(0xFFFFF9E3);         // Selected card background (subtle yellow)

  // === Primary Accent Colors ===
  static const primaryYellow = Color(0xFFFFEF5F);        // Button yellow (Toss-style)
  static const primaryYellowLight = Color(0xFFFFF3D6);   // Subtle yellow for icons
  static const accentOrange = Color(0xFFFF9F43);         // Accent orange
  static const accentGreen = Color(0xFF26D882);          // Modern green

  // === Text Colors (Toss-style) ===
  static const textPrimary = Color(0xFF191F28);          // Dark text (almost black)
  static const textSecondary = Color(0xFF6B7684);        // Gray text
  static const textTertiary = Color(0xFF8B95A1);         // Light gray text

  // === Legacy compatibility aliases ===
  static const darkBlue = textPrimary;                   // Primary text
  static const gray = textSecondary;                     // Secondary text
  static const lightGray = Color(0xFFF7F9FC);            // Legacy card background

  // === Border Colors ===
  static const border = Color(0xFFE5E8EB);               // Card border
  static const borderSelected = Color(0xFFFFD54F);       // Selected card border

  // === Goal card colors ===
  static const blueAccent = Color(0xFF4A90E2);           // Casual
  static const purpleAccent = Color(0xFF8B7BE2);         // Future use
  static const redAccent = Color(0xFFFF6B6B);            // Intensive

  // === Shadow ===
  static const cardShadow = Color(0x0D000000);           // Very subtle shadow (5% opacity)
}

/// Consistent spacing values across onboarding
class OnboardingSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
}
