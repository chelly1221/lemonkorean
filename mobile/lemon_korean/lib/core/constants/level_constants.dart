import 'package:flutter/material.dart';

class LevelConstants {
  static const int levelCount = 10;

  static const List<String> svgPaths = [
    'assets/levels/level_0_hangul.svg',
    'assets/levels/level_1_seed.svg',
    'assets/levels/level_2_sprout.svg',
    'assets/levels/level_3_small_tree.svg',
    'assets/levels/level_4_tree.svg',
    'assets/levels/level_5_one_lemon.svg',
    'assets/levels/level_6_full_lemons.svg',
    'assets/levels/level_7_golden_tree.svg',
    'assets/levels/level_8_golden_farm.svg',
    'assets/levels/level_9_lemon_forest.svg',
  ];

  static const List<Color> levelColors = [
    Color(0xFF5BA3EC), // Level 0 - Hangul blue
    Color(0xFF8B6914), // Level 1 - Seed brown
    Color(0xFF66BB6A), // Level 2 - Sprout green
    Color(0xFF4CAF50), // Level 3 - Small tree green
    Color(0xFF43A047), // Level 4 - Full tree dark green
    Color(0xFFFFD54F), // Level 5 - One lemon yellow
    Color(0xFFFFEB3B), // Level 6 - Full lemons bright yellow
    Color(0xFFFFB300), // Level 7 - Golden tree amber
    Color(0xFFFFA000), // Level 8 - Golden farm dark amber
    Color(0xFF2E7D32), // Level 9 - Lemon Forest green
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
