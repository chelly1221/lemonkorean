import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';

/// Language Settings Screen
/// Allow users to choose app language and Chinese variant
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================================================================
          // APP LANGUAGE SECTION
          // ================================================================
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.appLanguage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l10n.appLanguageDesc,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),

          // Language options
          ...AppLanguage.values.map((lang) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildLanguageOption(
              context: context,
              language: lang,
              isSelected: settings.appLanguage == lang,
              onTap: () async {
                await settings.setAppLanguage(lang);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.languageSelected(lang.nativeName)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          )),

        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required AppLanguage language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 3 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppConstants.primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected
                ? AppConstants.primaryColor.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              _getFlagEmoji(language),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(
          language.nativeName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          language.koreanName,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: AppConstants.primaryColor,
                size: 28,
              )
            : Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey[400],
                size: 28,
              ),
        onTap: onTap,
      ),
    );
  }

  String _getFlagEmoji(AppLanguage language) {
    switch (language) {
      case AppLanguage.zhCN:
        return '🇨🇳';
      case AppLanguage.zhTW:
        return '🇹🇼';
      case AppLanguage.ko:
        return '🇰🇷';
      case AppLanguage.en:
        return '🇺🇸';
      case AppLanguage.ja:
        return '🇯🇵';
      case AppLanguage.es:
        return '🇪🇸';
    }
  }
}
