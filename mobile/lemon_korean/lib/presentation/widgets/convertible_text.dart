import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/chinese_converter.dart';
import '../providers/settings_provider.dart';

/// Convertible Text Widget
/// Automatically converts Chinese text based on user's language preference
/// Use this for any standalone Chinese text that isn't part of BilingualText
class ConvertibleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ConvertibleText(
    this.text, {
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  @override
  State<ConvertibleText> createState() => _ConvertibleTextState();
}

class _ConvertibleTextState extends State<ConvertibleText> {
  String _displayText = '';
  bool _isConverting = false;
  ChineseVariant? _lastVariant;

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
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

  @override
  void didUpdateWidget(ConvertibleText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _displayText = widget.text;
      if (_lastVariant != null) {
        _convertText(_lastVariant!);
      }
    }
  }

  Future<void> _convertText(ChineseVariant variant) async {
    _isConverting = true;
    _lastVariant = variant;

    if (variant == ChineseVariant.traditional) {
      final converted = await ChineseConverter.toTraditional(widget.text);
      if (mounted) {
        setState(() {
          _displayText = converted;
          _isConverting = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _displayText = widget.text;
          _isConverting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
