// ignore_for_file: missing_provider_scope
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/chat_app.dart';
import 'package:quick_chat/core/services/app_service.dart';
import 'package:quick_chat/core/widget/app_startup_error_widget.dart';

void main() async {
  try {
    await AppService.init();
    runApp(
      const ProviderScope(
        child: ChatApp(),
      ),
    );
  } catch (e, st) {
    log(e.toString(), stackTrace: st);
    runApp(
      AppStartUpErrorWidget(error: e.toString()),
    );
  }
}
