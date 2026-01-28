import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/chinese_converter.dart';
import '../providers/settings_provider.dart';

/// Bilingual Text Widget
/// Displays Chinese text with Korean translation underneath in smaller font
/// Automatically converts Chinese text based on user's language preference (Simplified/Traditional)
class BilingualText extends StatelessWidget {
  final String chinese;
  final String korean;
  final TextStyle? chineseStyle;
  final TextStyle? koreanStyle;
  final TextAlign textAlign;
  final double koreanFontSizeRatio;

  const BilingualText({
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

    final defaultChineseStyle = chineseStyle ??
        Theme.of(context).textTheme.bodyMedium;

    final defaultKoreanStyle = koreanStyle ??
        TextStyle(
          fontSize: (defaultChineseStyle?.fontSize ?? 14) * koreanFontSizeRatio,
          color: (defaultChineseStyle?.color ?? Colors.black).withOpacity(0.6),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          convertedChinese,
          style: defaultChineseStyle,
          textAlign: textAlign,
        ),
        Text(
          korean,
          style: defaultKoreanStyle,
          textAlign: textAlign,
        ),
      ],
    );
  }
}

/// Inline Bilingual Text - for buttons and small UI elements
/// Automatically converts Chinese text based on user's language preference
class InlineBilingualText extends StatelessWidget {
  final String chinese;
  final String korean;
  final TextStyle? style;
  final double koreanFontSizeRatio;

  const InlineBilingualText({
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

    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium;
    final baseFontSize = baseStyle?.fontSize ?? 14;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: convertedChinese,
            style: baseStyle,
          ),
          TextSpan(
            text: '\n$korean',
            style: TextStyle(
              fontSize: baseFontSize * koreanFontSizeRatio,
              color: (baseStyle?.color ?? Colors.black).withOpacity(0.6),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
