import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

/// Notification service for managing local notifications
class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Handle notification tap on iOS < 10
      },
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      final initialized = await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          // Handle notification tap
          print('Notification tapped: ${details.payload}');
        },
      );

      if (initialized == true) {
        _isInitialized = true;
        print('NotificationService initialized successfully');
      }
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  /// Request notification permissions (especially for iOS)
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await initialize();

    if (Platform.isAndroid) {
      // Android 13+ requires runtime permission
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }
      return true; // Older Android versions don't need permission
    } else if (Platform.isIOS) {
      final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }
    return false;
  }

  /// Show pomodoro completion notification
  Future<void> showPomodoroComplete({
    required int sessionNumber,
    required String sessionType,
    int durationMinutes = 25,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Pomodoro Notifications',
      channelDescription: 'Notifications for pomodoro timer completion',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = sessionType == 'work'
        ? '🎯 Pomodoro Completed!'
        : '✨ Break Time Over!';

    final body = sessionType == 'work'
        ? 'Session #$sessionNumber finished ($durationMinutes min). Time for a break!'
        : 'Break is over. Ready for another session?';

    try {
      await _notifications.show(
        0, // notification ID
        title,
        body,
        details,
        payload: 'pomodoro_complete_$sessionNumber',
      );
      print('Notification shown: $title');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  /// Show pomodoro start notification (optional, for background mode)
  Future<void> showPomodoroStart({
    required int durationMinutes,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Pomodoro Notifications',
      channelDescription: 'Notifications for pomodoro timer',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      ongoing: true,
      autoCancel: false,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        1, // different ID for ongoing notification
        'Pomodoro in Progress',
        '$durationMinutes minutes focus session',
        details,
      );
    } catch (e) {
      print('Error showing start notification: $e');
    }
  }

  /// Cancel a specific notification
  Future<void> cancel(int id) async {
    try {
      await _notifications.cancel(id);
    } catch (e) {
      print('Error canceling notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      print('Error canceling all notifications: $e');
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final enabled = await androidImplementation.areNotificationsEnabled();
        return enabled ?? false;
      }
    }
    return true; // Assume enabled for iOS or if can't check
  }
}
