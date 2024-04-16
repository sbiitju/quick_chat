import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_chat/core/routes/route_generator.dart';
import 'package:quick_chat/core/theme/color_schemes.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode:ThemeMode.system,
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
            ),
            routerConfig: appRouter,
          );
        });
  }
}
