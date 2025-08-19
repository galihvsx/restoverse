import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/notifications/notification_helper.dart';
import '../../../theme/presentation/providers/theme_provider.dart';
import '../providers/reminder_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Test notification method
  Future<void> _testNotification(BuildContext context) async {
    final notificationHelper = NotificationHelper.instance;
    final success = await notificationHelper.showImmediateNotification(
      title: 'Test Notification 🔔',
      body:
          'This is a test notification to verify that notifications are working properly!',
      payload: 'test_notification',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Test notification sent successfully!'
                : 'Failed to send test notification',
          ),
        ),
      );
    }
  }

  // Check scheduled notifications
  Future<void> _checkScheduledNotifications(BuildContext context) async {
    final notificationHelper = NotificationHelper.instance;
    final isScheduled = await notificationHelper.isDailyReminderScheduled();
    final pendingNotifications = await notificationHelper
        .getPendingNotifications();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Notification Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily reminder scheduled: ${isScheduled ? "Yes" : "No"}'),
                const SizedBox(height: 8),
                Text(
                  'Total pending notifications: ${pendingNotifications.length}',
                ),
                if (pendingNotifications.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('Pending notifications:'),
                  ...pendingNotifications.map(
                    (notification) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '• ID: ${notification.id}, Title: ${notification.title}',
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Show dialog to guide user to enable exact alarm permission
  void _showAlarmPermissionDialog(
    BuildContext context,
    ReminderProvider reminderProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'To use daily reminders, you need to allow this app to set alarms and reminders. '
            'Please enable this permission in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reminderProvider.openExactAlarmsSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;
    final reminderProvider = context.watch<ReminderProvider>();
    final isReminderEnabled = reminderProvider.isReminderEnabled;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
              secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),
            SwitchListTile(
              title: const Text('Daily Reminder'),
              value: isReminderEnabled,
              onChanged: (bool value) async {
                if (value) {
                  // Check exact alarm permission asynchronously for Android 15+
                  final canSchedule = await reminderProvider
                      .checkExactAlarmPermission();
                  if (!canSchedule) {
                    // Show dialog to guide user to settings
                    _showAlarmPermissionDialog(context, reminderProvider);
                    return;
                  }
                }
                reminderProvider.toggleReminder();
              },
              secondary: const Icon(Icons.notifications_active),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Notification Testing',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notification_add),
              title: const Text('Test Notification'),
              subtitle: const Text('Send a test notification immediately'),
              onTap: () => _testNotification(context),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Check Scheduled Notifications'),
              subtitle: const Text('View pending notification status'),
              onTap: () => _checkScheduledNotifications(context),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Daily Reminder Info',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '• Daily reminders are scheduled for 11:00 AM\n'
                '• Notifications will remind you about lunch time\n'
                '• Use "Test Notification" to verify notifications work\n'
                '• Use "Check Scheduled" to see if reminders are active',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
