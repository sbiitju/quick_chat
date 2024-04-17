import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quick_chat/common/services/local_notification/android_local_notification.dart';

androidNotificationSetUp() {
  if (Platform.isAndroid) {
    try {
      AndroidLocalNotificationServiceInstance();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        LocalNotificationService notificationService =
            AndroidLocalNotificationServiceInstance.localNotificationService;
        String? title = message.notification?.title;
        String? body = message.notification?.body;
        notificationService.showNotification(23, title, body, null);
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        LocalNotificationService notificationService =
            AndroidLocalNotificationServiceInstance.localNotificationService;
        String? title = message.notification?.title;
        String? body = message.notification?.body;
        notificationService.showNotification(23, title, body, null);
      });

    } catch (err) {
      // print(err);
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LocalNotificationService notificationService =
      AndroidLocalNotificationServiceInstance.localNotificationService;
  String? title = message?.notification?.title;
  String? body = message?.notification?.body;
  notificationService.showNotification(23, title, body, null);
}
