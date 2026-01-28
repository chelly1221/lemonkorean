import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/chinese_converter.dart';
import '../providers/settings_provider.dart';

/// Bilingual Text Widget
/// Displays Chinese text with Korean translation underneath in smaller font
/// Automatically converts Chinese text based on user's language preference (Simplified/Traditional)
class BilingualText extends StatefulWidget {
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
  State<BilingualText> createState() => _BilingualTextState();
}

class _BilingualTextState extends State<BilingualText> {
  String _displayChinese = '';
  bool _isConverting = false;
  ChineseVariant? _lastVariant;

  @override
  void initState() {
    super.initState();
    _displayChinese = widget.chinese;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.watch<SettingsProvider>();

    // Only convert if variant changed
    if (_lastVariant != settings.chineseVariant && !_isConverting) {
      _convertText(settings.chineseVariant);
    }
  }

  Future<void> _convertText(ChineseVariant variant) async {
    _isConverting = true;
    _lastVariant = variant;

    if (variant == ChineseVariant.traditional) {
      final converted = await ChineseConverter.toTraditional(widget.chinese);
      if (mounted) {
        setState(() {
          _displayChinese = converted;
          _isConverting = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _displayChinese = widget.chinese;
          _isConverting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultChineseStyle = widget.chineseStyle ??
        Theme.of(context).textTheme.bodyMedium;

    final defaultKoreanStyle = widget.koreanStyle ??
        TextStyle(
          fontSize: (defaultChineseStyle?.fontSize ?? 14) * widget.koreanFontSizeRatio,
          color: (defaultChineseStyle?.color ?? Colors.black).withOpacity(0.6),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _displayChinese,
          style: defaultChineseStyle,
          textAlign: widget.textAlign,
        ),
        Text(
          widget.korean,
          style: defaultKoreanStyle,
          textAlign: widget.textAlign,
        ),
      ],
    );
  }
}

/// Inline Bilingual Text - for buttons and small UI elements
/// Automatically converts Chinese text based on user's language preference
class InlineBilingualText extends StatefulWidget {
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
  State<InlineBilingualText> createState() => _InlineBilingualTextState();
}

class _InlineBilingualTextState extends State<InlineBilingualText> {
  String _displayChinese = '';
  bool _isConverting = false;
  ChineseVariant? _lastVariant;

  @override
  void initState() {
    super.initState();
    _displayChinese = widget.chinese;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.watch<SettingsProvider>();

    // Only convert if variant changed
    if (_lastVariant != settings.chineseVariant && !_isConverting) {
      _convertText(settings.chineseVariant);
    }
  }

  Future<void> _convertText(ChineseVariant variant) async {
    _isConverting = true;
    _lastVariant = variant;

    if (variant == ChineseVariant.traditional) {
      final converted = await ChineseConverter.toTraditional(widget.chinese);
      if (mounted) {
        setState(() {
          _displayChinese = converted;
          _isConverting = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _displayChinese = widget.chinese;
          _isConverting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;
    final baseFontSize = baseStyle?.fontSize ?? 14;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: _displayChinese,
            style: baseStyle,
          ),
          TextSpan(
            text: '\n${widget.korean}',
            style: TextStyle(
              fontSize: baseFontSize * widget.koreanFontSizeRatio,
              color: (baseStyle?.color ?? Colors.black).withOpacity(0.6),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
