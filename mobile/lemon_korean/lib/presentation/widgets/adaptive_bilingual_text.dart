import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/chinese_converter.dart';
import '../providers/settings_provider.dart';
import 'bilingual_text.dart';

/// Adaptive Bilingual Text Widget
/// Automatically converts Chinese text based on user's language preference
/// (Simplified/Traditional) before displaying
class AdaptiveBilingualText extends StatelessWidget {
  final String chinese;
  final String korean;
  final TextStyle? chineseStyle;
  final TextStyle? koreanStyle;
  final TextAlign textAlign;
  final double koreanFontSizeRatio;

  const AdaptiveBilingualText({
    required this.chinese,
    required this.korean,
    this.chineseStyle,
    this.koreanStyle,
    this.textAlign = TextAlign.center,
    this.koreanFontSizeRatio = 0.6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    // Convert Chinese text based on user preference
    final convertedChinese = settings.chineseVariant == ChineseVariant.traditional
        ? ChineseConverter.toTraditional(chinese)
        : chinese;

    return BilingualText(
      chinese: convertedChinese,
      korean: korean,
      chineseStyle: chineseStyle,
      koreanStyle: koreanStyle,
      textAlign: textAlign,
      koreanFontSizeRatio: koreanFontSizeRatio,
    );
  }
}

/// Inline Adaptive Bilingual Text
/// Inline version that auto-converts Chinese based on settings
class InlineAdaptiveBilingualText extends StatelessWidget {
  final String chinese;
  final String korean;
  final TextStyle? style;
  final double koreanFontSizeRatio;

  const InlineAdaptiveBilingualText({
    required this.chinese,
    required this.korean,
    this.style,
    this.koreanFontSizeRatio = 0.7,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    // Convert Chinese text based on user preference
    final convertedChinese = settings.chineseVariant == ChineseVariant.traditional
        ? ChineseConverter.toTraditional(chinese)
        : chinese;

    return InlineBilingualText(
      chinese: convertedChinese,
      korean: korean,
      style: style,
      koreanFontSizeRatio: koreanFontSizeRatio,
    );
  }
}

/// Helper widget to convert any Chinese text widget
/// Wraps any widget and converts all Chinese text content
class ChineseTextConverter extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ChineseTextConverter({
    required this.text,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final convertedText = settings.chineseVariant == ChineseVariant.traditional
        ? ChineseConverter.toTraditional(text)
        : text;

    return Text(
      convertedText,
      style: style,
    );
  }
}
