// ============================================================
// Streak Reminder Notification Service
// Final Year Project — Gamification Module
//
// Reminds the user in the evening if they haven't completed
// today's check-in yet, so they don't lose their streak.
// Automatically reschedules for the next day right after a
// check-in is recorded, so the reminder still fires even if
// the app isn't reopened tomorrow.
//
// Dependencies (add to pubspec.yaml):
//   flutter_local_notifications: ^17.2.3
//   timezone: ^0.9.4
//   shared_preferences: ^2.2.3   (skip if already in your project)
// ============================================================

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _streakReminderId = 1001;
  static const String _prefsKey = 'last_checkin_date';

  /// Call once, early in main(), before runApp().
  Future<void> init() async {
    tzdata.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(settings);
  }

  /// Call once after login / on first app open (Android 13+ and iOS both
  /// require an explicit runtime prompt before notifications can show).
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Schedules (or reschedules) the streak reminder.
  /// - If the user already checked in today, the reminder is set for
  ///   tomorrow at [hour]:[minute].
  /// - If they haven't, and today's reminder time hasn't passed yet,
  ///   it's scheduled for today.
  /// - If today's time has already passed and they still haven't
  ///   checked in, it falls back to tomorrow.
  ///
  /// Call this once on app startup, and again every time a check-in
  /// is recorded (see [markCheckedInToday]).
  Future<void> scheduleStreakReminder({int hour = 20, int minute = 0}) async {
    await _plugin.cancel(_streakReminderId);

    final prefs = await SharedPreferences.getInstance();
    final lastCheckIn = prefs.getString(_prefsKey);
    final now = DateTime.now();
    final todayKey = _dateKey(now);

    DateTime targetDay;
    if (lastCheckIn == todayKey) {
      targetDay = now.add(const Duration(days: 1));
    } else {
      final todayReminder =
          DateTime(now.year, now.month, now.day, hour, minute);
      targetDay = todayReminder.isAfter(now)
          ? now
          : now.add(const Duration(days: 1));
    }

    final scheduledDate = tz.TZDateTime(
      tz.local,
      targetDay.year,
      targetDay.month,
      targetDay.day,
      hour,
      minute,
    );

    await _plugin.zonedSchedule(
      _streakReminderId,
      'Keep your streak alive',
      "You haven't checked in today yet — don't lose your streak.",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_channel',
          'Streak Reminders',
          channelDescription: 'Reminds you to complete your daily check-in',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Call this right after the backend confirms today's check-in
  /// succeeded (inside your "Mark Done Today" / check-in button handler).
  Future<void> markCheckedInToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _dateKey(DateTime.now()));
    await scheduleStreakReminder(); // now reschedules for tomorrow
  }

  Future<void> cancelStreakReminder() async {
    await _plugin.cancel(_streakReminderId);
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}