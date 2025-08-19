import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/presentation/providers/theme_provider.dart';
import '../providers/reminder_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
              onChanged: (_) {
                reminderProvider.toggleReminder();
              },
              secondary: const Icon(Icons.notifications_active),
            ),
          ],
        ),
      ),
    );
  }
}
