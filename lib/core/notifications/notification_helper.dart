import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static const String _channelId = 'daily_reminder';
  static const String _channelName = 'Daily Reminder';
  static const String _channelDescription = 'Daily reminder for lunch time';
  static const int _dailyReminderNotificationId = 1;

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  // Singleton pattern
  NotificationHelper._privateConstructor();
  static final NotificationHelper instance =
      NotificationHelper._privateConstructor();

  // Get plugin instance
  FlutterLocalNotificationsPlugin get plugin {
    _flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    return _flutterLocalNotificationsPlugin!;
  }

  // Initialize notifications
  Future<bool> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Set local timezone
      final String timeZoneName = await _getLocalTimeZone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      // Android initialization settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // macOS initialization settings
      const DarwinInitializationSettings initializationSettingsMacOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // Combined initialization settings
      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS,
          );

      // Initialize the plugin
      final bool? result = await plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      // Request permissions for Android 13+
      if (Platform.isAndroid) {
        await _requestAndroidPermissions();
      }

      // Request permissions for iOS
      if (Platform.isIOS) {
        await _requestIOSPermissions();
      }

      return result ?? false;
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      return false;
    }
  }

  // Handle notification response
  static void _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    debugPrint('Notification tapped: ${notificationResponse.payload}');
    // Handle notification tap here
  }

  // Request Android permissions
  Future<void> _requestAndroidPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
    }
  }

  // Request iOS permissions
  Future<void> _requestIOSPermissions() async {
    if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iosImplementation = plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iosImplementation != null) {
        await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }
  }

  // Get local timezone
  Future<String> _getLocalTimeZone() async {
    try {
      // Try to get system timezone
      if (Platform.isAndroid || Platform.isIOS) {
        return 'Asia/Jakarta'; // Default to Jakarta timezone
      }
      return 'UTC';
    } catch (e) {
      debugPrint('Error getting timezone: $e');
      return 'UTC';
    }
  }

  // Schedule daily reminder at 11:00 AM
  Future<bool> scheduleDailyReminder() async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: iOSPlatformChannelSpecifics,
      );

      // Schedule for 11:00 AM daily
      await plugin.zonedSchedule(
        _dailyReminderNotificationId,
        'Lunch Time! 🍽️',
        'Don\'t forget to have your lunch. Check out great restaurants near you!',
        _nextInstanceOf11AM(),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_reminder',
      );

      debugPrint('Daily reminder scheduled for 11:00 AM');
      return true;
    } catch (e) {
      debugPrint('Error scheduling daily reminder: $e');
      return false;
    }
  }

  // Cancel daily reminder
  Future<bool> cancelDailyReminder() async {
    try {
      await plugin.cancel(_dailyReminderNotificationId);
      debugPrint('Daily reminder cancelled');
      return true;
    } catch (e) {
      debugPrint('Error cancelling daily reminder: $e');
      return false;
    }
  }

  // Get next instance of 11:00 AM
  tz.TZDateTime _nextInstanceOf11AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11, // 11:00 AM
      0,
      0,
    );

    // If 11:00 AM has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Show immediate notification (for testing)
  Future<bool> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: iOSPlatformChannelSpecifics,
      );

      await plugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      return true;
    } catch (e) {
      debugPrint('Error showing immediate notification: $e');
      return false;
    }
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await plugin.pendingNotificationRequests();
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await plugin.cancelAll();
  }

  // Check if daily reminder is scheduled
  Future<bool> isDailyReminderScheduled() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await getPendingNotifications();
    return pendingNotifications.any(
      (notification) => notification.id == _dailyReminderNotificationId,
    );
  }
}
