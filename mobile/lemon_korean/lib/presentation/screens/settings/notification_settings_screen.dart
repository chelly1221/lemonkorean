import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';

/// Notification Settings Screen
/// Configure daily reminders and review notifications
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知设置 / 알림 설정'),
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
              title: const Text(
                '启用通知 / 알림 활성화',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                '开启后可以接收学习提醒\n활성화하면 학습 알림을 받을 수 있습니다',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
              value: settings.notificationsEnabled,
              activeColor: AppConstants.primaryColor,
              onChanged: (value) async {
                final success = await settings.toggleNotifications(value);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '请在系统设置中允许通知权限\n시스템 설정에서 알림 권한을 허용해주세요',
                      ),
                      duration: Duration(seconds: 3),
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
              '每日学习提醒 / 매일 학습 알림',
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
                  title: const Text(
                    '每日提醒 / 매일 알림',
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: const Text(
                    '每天固定时间提醒学习\n매일 정해진 시간에 알림',
                    style: TextStyle(fontSize: 12, height: 1.5),
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
                    title: const Text(
                      '提醒时间 / 알림 시간',
                      style: TextStyle(fontSize: 14),
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
                                      '提醒时间已设置为 ${time.format(context)}\n알림 시간이 ${time.format(context)}(으)로 설정되었습니다',
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
              title: const Text(
                '复习提醒 / 복습 알림',
                style: TextStyle(fontSize: 15),
              ),
              subtitle: const Text(
                '根据记忆曲线提醒复习\n기억 곡선에 따라 복습 알림',
                style: TextStyle(fontSize: 12, height: 1.5),
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
                  child: Text(
                    '提示：\n'
                    '• 复习提醒会在完成课程后自动安排\n'
                    '• 部分手机需要在系统设置中关闭省电模式才能正常接收通知\n\n'
                    '팁:\n'
                    '• 복습 알림은 레슨 완료 후 자동으로 예약됩니다\n'
                    '• 일부 기기에서는 시스템 설정에서 절전 모드를 해제해야 알림을 정상적으로 받을 수 있습니다',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[900],
                      height: 1.5,
                    ),
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
