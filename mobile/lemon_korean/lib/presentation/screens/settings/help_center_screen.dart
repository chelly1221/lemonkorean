import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpCenter),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Offline Learning Section
          _buildSectionHeader(l10n.offlineLearning),
          _buildFAQItem(
            context,
            question: l10n.howToDownload,
            answer: l10n.howToDownloadAnswer,
          ),
          _buildFAQItem(
            context,
            question: l10n.howToUseDownloaded,
            answer: l10n.howToUseDownloadedAnswer,
          ),

          const SizedBox(height: 24),

          // Storage Management Section
          _buildSectionHeader(l10n.storageManagement),
          _buildFAQItem(
            context,
            question: l10n.howToCheckStorage,
            answer: l10n.howToCheckStorageAnswer,
          ),
          _buildFAQItem(
            context,
            question: l10n.howToDeleteDownloaded,
            answer: l10n.howToDeleteDownloadedAnswer,
          ),

          const SizedBox(height: 24),

          // Notification Settings Section
          _buildSectionHeader(l10n.notificationSection),
          _buildFAQItem(
            context,
            question: l10n.howToEnableReminder,
            answer: l10n.howToEnableReminderAnswer,
          ),
          _buildFAQItem(
            context,
            question: l10n.whatIsReviewReminder,
            answer: l10n.whatIsReviewReminderAnswer,
          ),

          const SizedBox(height: 24),

          // Language Settings Section
          _buildSectionHeader(l10n.languageSection),
          _buildFAQItem(
            context,
            question: l10n.howToSwitchChinese,
            answer: l10n.howToSwitchChineseAnswer,
          ),

          const SizedBox(height: 24),

          // General FAQ Section
          _buildSectionHeader(l10n.faq),
          _buildFAQItem(
            context,
            question: l10n.howToStart,
            answer: l10n.howToStartAnswer,
          ),
          _buildFAQItem(
            context,
            question: l10n.progressNotSaved,
            answer: l10n.progressNotSavedAnswer,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppConstants.primaryColor,
        ),
      ),
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
