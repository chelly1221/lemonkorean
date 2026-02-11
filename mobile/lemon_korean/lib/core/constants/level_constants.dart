import 'package:flutter/material.dart';

class LevelConstants {
  static const int levelCount = 7;

  static const List<String> svgPaths = [
    'assets/levels/level_0_hangul.svg',
    'assets/levels/level_1_seed.svg',
    'assets/levels/level_2_sprout.svg',
    'assets/levels/level_3_green_lemon.svg',
    'assets/levels/level_4_yellow_lemon.svg',
    'assets/levels/level_5_shining_yellow_lemon.svg',
    'assets/levels/level_6_shining_golden_lemon.svg',
  ];

  static const List<Color> levelColors = [
    Color(0xFF5BA3EC), // Level 0 - 한글 (Blue)
    Color(0xFF8B6914), // Level 1 - 씨앗 (Brown)
    Color(0xFF66BB6A), // Level 2 - 새싹 (Green)
    Color(0xFF4CAF50), // Level 3 - 초록레몬 (Green)
    Color(0xFFFFD54F), // Level 4 - 노란레몬 (Yellow)
    Color(0xFFFFEB3B), // Level 5 - 반짝이는 노란레몬 (Bright Yellow)
    Color(0xFFFFB300), // Level 6 - 반짝이는 황금레몬 (Golden)
  ];

  static String getSvgPath(int level) {
    if (level < 0 || level >= levelCount) return svgPaths[0];
    return svgPaths[level];
  }

  static Color getLevelColor(int level) {
    if (level < 0 || level >= levelCount) return levelColors[0];
    return levelColors[level];
  }
}
