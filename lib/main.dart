import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/chat_app.dart';
import 'package:quick_chat/common/services/app_service.dart';

void main() {
  AppService.init();
  runApp(const ProviderScope(
    child: ChatApp(),
  ));
}
