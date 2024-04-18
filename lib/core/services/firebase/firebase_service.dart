import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quick_chat/core/services/local_notification/android_notification_setup.dart';
import 'package:quick_chat/core/services/local_notification/local_notification_service.dart';
import 'package:quick_chat/core/utils/logger.dart';

import '../../../firebase_options.dart';

class FirebaseService {
  static final FirebaseService _firebaseService = FirebaseService._internal();
  late FirebaseMessaging _firebaseMessaging;
  late NotificationSettings settings;

  FirebaseService._internal();

  factory FirebaseService() {
    return _firebaseService;
  }

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );
      _firebaseMessaging = FirebaseMessaging.instance;
      await _requestPermissions();
      //for lack of Apple Developer Account, we will not be able to test this on iOS
      final apns = await _firebaseMessaging.getAPNSToken();
      await _firebaseMessaging.subscribeToTopic('Q-Chat');
      if (apns != null && Platform.isIOS) {
        await _iOSSetup();
        await _setupInteractedMessage();
      }
      if (Platform.isAndroid) {
        await _setupAndroid();
      }
    } catch (e) {
      Log.error(e.toString());
    }
  }

  Future<void> _setupAndroid() async {
    retrieveFCMToken();
    androidNotificationSetUp();
  }

  Future<void> _setupInteractedMessage() async {
    LocalNotificationService localNotificationService =
        LocalNotificationService();
    await localNotificationService.setup();

  }

  Future<void> _iOSSetup() async {
    try {
      if (Platform.isIOS && await _initiatePermissionStatusCheckForIOS()) {
        _enableForegroundNotificationForIOS();
      }

      if (Platform.isIOS) {
        _enableForegroundNotificationForIOS();
      }
    } catch (e) {
      Log.error(e.toString());
    }
  }

  Future<bool> _initiatePermissionStatusCheckForIOS() async {
    try {
      settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      Log.info('Permission status: ${settings.authorizationStatus}');
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        Log.info('Permission status: Authorized');

        return true;
      }

      return false;
    } catch (err) {
      return false;
    }
  }

  void _enableForegroundNotificationForIOS() {
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      badge: true,
      alert: true,
      sound: true,
    );
  }

  Future<String?> retrieveFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token;
  }

  Future<void> _requestPermissions() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
    } catch (err) {
      Log.error("Denied permission");
    }
  }
}


