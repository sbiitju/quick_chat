import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/core/di/injection_container.dart' as di;
import 'package:quick_chat/core/routes/route_generator.dart';
import 'package:quick_chat/firebase_options.dart';
import 'package:quick_chat/flavors/build_config.dart';
import 'package:quick_chat/flavors/env_config.dart';
import 'package:quick_chat/flavors/environment.dart';

class AppService {
  AppService._internal();

  static final AppService _instance = AppService._internal();

  factory AppService() => _instance;

  BuildContext get context =>
      appRouter.routerDelegate.navigatorKey.currentContext!;

  static init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();
    _setBuildConfig();
    _setupFirebase();
  }

  static void _setBuildConfig() {
    EnvConfig devConfig = EnvConfig(
        appName: "Chat App", baseUrl: "", shouldCollectCrashLog: true);
    BuildConfig.instantiate(
      envType: Environment.PRODUCTION,
      envConfig: devConfig,
    );
  }

  static void _setupFirebase() {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
