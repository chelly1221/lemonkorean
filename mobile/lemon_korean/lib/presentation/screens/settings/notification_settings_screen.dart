import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';

/// Notification Settings Screen
/// Configure daily reminders and review notifications
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationSettings),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Master Toggle
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                l10n.enableNotifications,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                l10n.enableNotificationsDesc,
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
              value: settings.notificationsEnabled,
              activeColor: AppConstants.primaryColor,
              onChanged: (value) async {
                final success = await settings.toggleNotifications(value);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.permissionRequired),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // Daily Reminder Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.dailyLearningReminder,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          Card(
            elevation: settings.notificationsEnabled ? 1 : 0,
            color: settings.notificationsEnabled ? Colors.white : Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    l10n.dailyReminder,
                    style: const TextStyle(fontSize: 15),
                  ),
                  subtitle: Text(
                    l10n.dailyReminderDesc,
                    style: const TextStyle(fontSize: 12, height: 1.5),
                  ),
                  value: settings.dailyReminderEnabled,
                  activeColor: AppConstants.primaryColor,
                  onChanged: settings.notificationsEnabled
                      ? (value) async {
                          await settings.toggleDailyReminder(value);
                        }
                      : null,
                ),
                if (settings.dailyReminderEnabled)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      Icons.access_time,
                      color: settings.notificationsEnabled
                          ? AppConstants.primaryColor
                          : Colors.grey,
                    ),
                    title: Text(
                      l10n.reminderTime,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        settings.dailyReminderTime.format(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ),
                    enabled: settings.notificationsEnabled,
                    onTap: settings.notificationsEnabled
                        ? () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: settings.dailyReminderTime,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppConstants.primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (time != null) {
                              await settings.setDailyReminderTime(time);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.reminderTimeSet(time.format(context)),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Review Reminder Section
          Card(
            elevation: settings.notificationsEnabled ? 1 : 0,
            color: settings.notificationsEnabled ? Colors.white : Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                l10n.reviewReminder,
                style: const TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                l10n.reviewReminderDesc,
                style: const TextStyle(fontSize: 12, height: 1.5),
              ),
              value: settings.reviewRemindersEnabled,
              activeColor: AppConstants.primaryColor,
              onChanged: settings.notificationsEnabled
                  ? (value) async {
                      await settings.toggleReviewReminders(value);
                    }
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[100]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.notificationTip,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.notificationTipContent,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[900],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
