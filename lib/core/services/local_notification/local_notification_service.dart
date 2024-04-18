import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quick_chat/core/utils/logger.dart';

class LocalNotificationService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings(
      '@drawable/bionippy.png',
    );

    var iosSetting = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await _localNotificationsPlugin
        .initialize(
          initSettings,
          onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
        )
        .then((_) => Log.info('Local Notification Service: Setup Successful'))
        .catchError((Object error) {
      Log.info('Error(Local Notification Service): $error');
    });
  }

  Future<void> onDidReceiveLocalNotification(
      NotificationResponse response) async {
    Log.info('onDidReceiveLocalNotification: ${response.payload}');
  }

  Future<void> showNotification({
    required RemoteMessage remoteMessage,
  }) async {
    // notificationCount.value++;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'regular-notification',
      'Regular Notification',
      playSound: true,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _localNotificationsPlugin.show(
      remoteMessage.hashCode,
      remoteMessage.notification?.title ?? "",
      remoteMessage.notification?.body ?? "",
      notificationDetails,
      payload: jsonEncode(remoteMessage.data),
    );
  }

  Future<void> clearNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }
}
