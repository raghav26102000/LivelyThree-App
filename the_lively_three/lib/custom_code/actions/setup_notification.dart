import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '/custom_code/widgets/in_app_notifications.dart';
// import '/main.dart';
import '/flutter_flow/nav/nav.dart';

// Global instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // 1. Request permissions
  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // if (await Permission.notification.isDenied) {
  //   await Permission.notification.request();
  // }

  // 2. iOS presentation options
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // 3. Init local notifications
  const androidInit =
      AndroidInitializationSettings('@drawable/ic_stat_ic_notification');
  const iosInit = DarwinInitializationSettings();
  const initSettings =
      InitializationSettings(android: androidInit, iOS: iosInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // 4. Create channel for Android 8+
  const channel = AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'Default channel for app notifications',
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // 5. Foreground listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint("📩 Received message: ${message.toMap()}");

    final type = (message.data['notification_type'] ?? 'push').toLowerCase();
    final title = message.data['title'] ??
        message.notification?.title ??
        "Update";
    final body = message.data['body'] ??
        message.data['content'] ?? // backend may send "content"
        message.notification?.body ??
        "";

    debugPrint("📩 Notification Type = '$type'");
    debugPrint("📩 Title = '$title'");
    debugPrint("📩 Body = '$body'");
    debugPrint("📩 Data = ${message.data}");

    switch (type) {
      case 'in-app':
      case 'in_app':
      case 'high-health-score':
      case 'plant-diversity':
      case 'subscription-cancellation':
        debugPrint("🎯 Processing in-app style notification ($type)");
        _attemptDelayedDialog(type, title, body);
        break;

      default:
        debugPrint("🔔 Processing regular push notification");
        await flutterLocalNotificationsPlugin.show(
          message.hashCode,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'General Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
    }
  });

  // 6. Taps
  FirebaseMessaging.instance.getInitialMessage().then((msg) {
    if (msg != null) {
      debugPrint("📱 Opened from terminated: ${msg.data}");
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((msg) {
    debugPrint("📱 Opened from background: ${msg.data}");
  });
}

// Show the actual dialog
void _showCustomDialog(BuildContext context, String type, String title, String body) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogCtx) {
      final onAction = () {
        debugPrint("🎯 Notification action pressed ($type)");
        Navigator.pop(dialogCtx);
      };

      switch (type) {
        case 'high-health-score':
          return HealthScoreNotification(title: title, body: body, onAction: onAction);
        case 'plant-diversity':
          return PlantDiversityNotification(title: title, body: body, onAction: onAction);
        case 'subscription-cancellation':
          return SubscriptionCancellationNotification(title: title, body: body, onAction: onAction);  
        default:
          return InAppNotification(title: title, body: body, onAction: onAction);
      }
    },
  );
}

// Retry until navigator context is ready
void _attemptDelayedDialog(String type, String title, String body) {
  int attempts = 0;
  const maxAttempts = 10;
  const delay = Duration(milliseconds: 500);

  void tryShowDialog() {
    attempts++;
    final ctx = appNavigatorKey.currentState?.overlay?.context;

    if (ctx != null) {
      _showCustomDialog(ctx, type, title, body);
      return;
    }

    if (attempts < maxAttempts) {
      Future.delayed(delay, tryShowDialog);
    } else {
      flutterLocalNotificationsPlugin.show(
        title.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'General Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  Future.delayed(delay, tryShowDialog);
}

// request permission separately
Future<void> requestNotificationPermission() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

