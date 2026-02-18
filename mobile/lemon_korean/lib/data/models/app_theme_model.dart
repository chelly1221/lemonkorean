import 'package:flutter/material.dart';

/// App Theme Model
///
/// Represents the complete theme configuration fetched from the admin API.
/// This model contains all customizable colors, logos, and font settings.
class AppThemeModel {
  // Brand Colors
  final String primaryColor;
  final String secondaryColor;
  final String accentColor;

  // Status Colors
  final String errorColor;
  final String successColor;
  final String warningColor;
  final String infoColor;

  // Text Colors
  final String textPrimary;
  final String textSecondary;
  final String textHint;

  // Background Colors
  final String backgroundLight;
  final String backgroundDark;
  final String cardBackground;

  // Lesson Stage Colors
  final String stage1Color;
  final String stage2Color;
  final String stage3Color;
  final String stage4Color;
  final String stage5Color;
  final String stage6Color;
  final String stage7Color;

  // Media URLs (nullable)
  final String? splashLogoUrl;
  final String? loginLogoUrl;
  final String? faviconUrl;

  // Font Settings
  final String fontFamily;
  final String fontSource; // 'google', 'custom', 'system'
  final String? customFontUrl;

  // Metadata
  final int version;

  const AppThemeModel({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.errorColor,
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.cardBackground,
    required this.stage1Color,
    required this.stage2Color,
    required this.stage3Color,
    required this.stage4Color,
    required this.stage5Color,
    required this.stage6Color,
    required this.stage7Color,
    this.splashLogoUrl,
    this.loginLogoUrl,
    this.faviconUrl,
    required this.fontFamily,
    required this.fontSource,
    this.customFontUrl,
    required this.version,
  });

  /// Factory constructor from JSON
  factory AppThemeModel.fromJson(Map<String, dynamic> json) {
    return AppThemeModel(
      primaryColor: json['primary_color'] as String,
      secondaryColor: json['secondary_color'] as String,
      accentColor: json['accent_color'] as String,
      errorColor: json['error_color'] as String,
      successColor: json['success_color'] as String,
      warningColor: json['warning_color'] as String,
      infoColor: json['info_color'] as String,
      textPrimary: json['text_primary'] as String,
      textSecondary: json['text_secondary'] as String,
      textHint: json['text_hint'] as String,
      backgroundLight: json['background_light'] as String,
      backgroundDark: json['background_dark'] as String,
      cardBackground: json['card_background'] as String,
      stage1Color: json['stage1_color'] as String,
      stage2Color: json['stage2_color'] as String,
      stage3Color: json['stage3_color'] as String,
      stage4Color: json['stage4_color'] as String,
      stage5Color: json['stage5_color'] as String,
      stage6Color: json['stage6_color'] as String,
      stage7Color: json['stage7_color'] as String,
      splashLogoUrl: json['splash_logo_url'] as String?,
      loginLogoUrl: json['login_logo_url'] as String?,
      faviconUrl: json['favicon_url'] as String?,
      fontFamily: json['font_family'] as String,
      fontSource: json['font_source'] as String,
      customFontUrl: json['custom_font_url'] as String?,
      version: json['version'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'accent_color': accentColor,
      'error_color': errorColor,
      'success_color': successColor,
      'warning_color': warningColor,
      'info_color': infoColor,
      'text_primary': textPrimary,
      'text_secondary': textSecondary,
      'text_hint': textHint,
      'background_light': backgroundLight,
      'background_dark': backgroundDark,
      'card_background': cardBackground,
      'stage1_color': stage1Color,
      'stage2_color': stage2Color,
      'stage3_color': stage3Color,
      'stage4_color': stage4Color,
      'stage5_color': stage5Color,
      'stage6_color': stage6Color,
      'stage7_color': stage7Color,
      'splash_logo_url': splashLogoUrl,
      'login_logo_url': loginLogoUrl,
      'favicon_url': faviconUrl,
      'font_family': fontFamily,
      'font_source': fontSource,
      'custom_font_url': customFontUrl,
      'version': version,
    };
  }

  /// Convert hex string to Color
  /// Example: '#FFEF5F' -> Color(0xFFFFEF5F)
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Color getters for easy access
  Color get primary => hexToColor(primaryColor);
  Color get secondary => hexToColor(secondaryColor);
  Color get accent => hexToColor(accentColor);
  Color get error => hexToColor(errorColor);
  Color get success => hexToColor(successColor);
  Color get warning => hexToColor(warningColor);
  Color get info => hexToColor(infoColor);
  Color get textPrimaryCol => hexToColor(textPrimary);
  Color get textSecondaryCol => hexToColor(textSecondary);
  Color get textHintCol => hexToColor(textHint);
  Color get backgroundLightCol => hexToColor(backgroundLight);
  Color get backgroundDarkCol => hexToColor(backgroundDark);
  Color get cardBackgroundCol => hexToColor(cardBackground);
  Color get stage1 => hexToColor(stage1Color);
  Color get stage2 => hexToColor(stage2Color);
  Color get stage3 => hexToColor(stage3Color);
  Color get stage4 => hexToColor(stage4Color);
  Color get stage5 => hexToColor(stage5Color);
  Color get stage6 => hexToColor(stage6Color);
  Color get stage7 => hexToColor(stage7Color);

  /// Default theme (matches AppConstants defaults)
  factory AppThemeModel.defaultTheme() {
    return const AppThemeModel(
      primaryColor: '#FFEF5F',
      secondaryColor: '#4CAF50',
      accentColor: '#FF9800',
      errorColor: '#F44336',
      successColor: '#4CAF50',
      warningColor: '#FF9800',
      infoColor: '#2196F3',
      textPrimary: '#212121',
      textSecondary: '#757575',
      textHint: '#BDBDBD',
      backgroundLight: '#FAFAFA',
      backgroundDark: '#303030',
      cardBackground: '#FFFFFF',
      stage1Color: '#2196F3',
      stage2Color: '#4CAF50',
      stage3Color: '#FF9800',
      stage4Color: '#9C27B0',
      stage5Color: '#E91E63',
      stage6Color: '#F44336',
      stage7Color: '#607D8B',
      fontFamily: 'Pretendard',
      fontSource: 'local',
      version: 1,
    );
  }

  /// Copy with method for partial updates
  AppThemeModel copyWith({
    String? primaryColor,
    String? secondaryColor,
    String? accentColor,
    String? errorColor,
    String? successColor,
    String? warningColor,
    String? infoColor,
    String? textPrimary,
    String? textSecondary,
    String? textHint,
    String? backgroundLight,
    String? backgroundDark,
    String? cardBackground,
    String? stage1Color,
    String? stage2Color,
    String? stage3Color,
    String? stage4Color,
    String? stage5Color,
    String? stage6Color,
    String? stage7Color,
    String? splashLogoUrl,
    String? loginLogoUrl,
    String? faviconUrl,
    String? fontFamily,
    String? fontSource,
    String? customFontUrl,
    int? version,
  }) {
    return AppThemeModel(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      cardBackground: cardBackground ?? this.cardBackground,
      stage1Color: stage1Color ?? this.stage1Color,
      stage2Color: stage2Color ?? this.stage2Color,
      stage3Color: stage3Color ?? this.stage3Color,
      stage4Color: stage4Color ?? this.stage4Color,
      stage5Color: stage5Color ?? this.stage5Color,
      stage6Color: stage6Color ?? this.stage6Color,
      stage7Color: stage7Color ?? this.stage7Color,
      splashLogoUrl: splashLogoUrl ?? this.splashLogoUrl,
      loginLogoUrl: loginLogoUrl ?? this.loginLogoUrl,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSource: fontSource ?? this.fontSource,
      customFontUrl: customFontUrl ?? this.customFontUrl,
      version: version ?? this.version,
    );
  }

  @override
  String toString() {
    return 'AppThemeModel(primary: $primaryColor, font: $fontFamily, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppThemeModel && other.version == version;
  }

  @override
  int get hashCode => version.hashCode;
}
