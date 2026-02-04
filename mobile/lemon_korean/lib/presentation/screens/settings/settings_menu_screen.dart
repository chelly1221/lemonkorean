import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'language_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'help_center_screen.dart';
import 'app_info_screen.dart';

/// Settings Menu Screen
/// 마이페이지에서 톱니바퀴 아이콘 탭 시 표시되는 설정 메뉴 화면
class SettingsMenuScreen extends StatelessWidget {
  const SettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settings ?? 'Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          // ================================================================
          // SETTINGS SECTION
          // ================================================================
          _buildSectionHeader(l10n?.settings ?? 'Settings'),

          _buildMenuItem(
            context: context,
            icon: Icons.language,
            label: l10n?.languageSettings ?? 'Language Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSettingsScreen(),
                ),
              );
            },
          ),

          _buildMenuItem(
            context: context,
            icon: Icons.notifications_outlined,
            label: l10n?.notificationSettings ?? 'Notification Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: AppConstants.paddingMedium),
          const Divider(),

          // ================================================================
          // ABOUT SECTION
          // ================================================================
          _buildSectionHeader(l10n?.about ?? 'About'),

          _buildMenuItem(
            context: context,
            icon: Icons.help_outline,
            label: l10n?.helpCenter ?? 'Help Center',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpCenterScreen(),
                ),
              );
            },
          ),

          _buildMenuItem(
            context: context,
            icon: Icons.info_outline,
            label: l10n?.aboutApp ?? 'About App',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppInfoScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: AppConstants.paddingMedium),
          const Divider(),

          // ================================================================
          // LOGOUT SECTION
          // ================================================================
          const SizedBox(height: AppConstants.paddingSmall),

          Card(
            color: AppConstants.errorColor.withValues(alpha: 0.1),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: AppConstants.errorColor,
              ),
              title: Text(
                l10n?.logout ?? 'Log Out',
                style: const TextStyle(
                  color: AppConstants.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _showLogoutDialog(context, authProvider, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.paddingMedium,
        bottom: AppConstants.paddingSmall,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.bold,
          color: AppConstants.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    AuthProvider authProvider,
    AppLocalizations? l10n,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(dialogL10n?.logout ?? 'Log Out'),
          content: Text(dialogL10n?.confirmLogout ?? 'Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(dialogL10n?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.errorColor,
              ),
              child: Text(dialogL10n?.confirm ?? 'Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm == true && context.mounted) {
      await authProvider.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    }
  }
}
