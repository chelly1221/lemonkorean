import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutApp),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Logo and Name
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🍋',
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lemon Korean',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n.appName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Version Info
          _buildInfoCard(
            context,
            icon: Icons.info_outline,
            title: l10n.versionInfo,
            content: 'Version 1.0.0',
          ),

          const SizedBox(height: 12),

          // Developer Info
          _buildInfoCard(
            context,
            icon: Icons.code,
            title: l10n.developer,
            content: 'Lemon Korean Team',
          ),

          const SizedBox(height: 12),

          // App Description
          _buildInfoCard(
            context,
            icon: Icons.description,
            title: l10n.appIntro,
            content: l10n.appIntroContent,
          ),

          const SizedBox(height: 32),

          // Links Section Header
          Text(
            l10n.moreInfo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Terms of Service
          _buildLinkItem(
            context,
            icon: Icons.article,
            title: l10n.termsOfService,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.termsComingSoon)),
              );
            },
          ),

          // Privacy Policy
          _buildLinkItem(
            context,
            icon: Icons.privacy_tip,
            title: l10n.privacyPolicy,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.privacyComingSoon)),
              );
            },
          ),

          // Open Source Licenses
          _buildLinkItem(
            context,
            icon: Icons.lightbulb_outline,
            title: l10n.openSourceLicenses,
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Lemon Korean',
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🍋', style: TextStyle(fontSize: 30)),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Copyright
          Center(
            child: Text(
              '© 2024 Lemon Korean Team\nAll rights reserved',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
