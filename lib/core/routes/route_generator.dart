import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_chat/core/routes/routes.dart';
import 'package:quick_chat/features/auth/presentation/screens/auth_screen.dart';
import 'package:quick_chat/features/chat/presentation/screens/chat_screen.dart';
import 'package:quick_chat/features/home/presentation/screens/home_screen.dart';

import '../../common/widget/error_page.dart';

final GoRouter appRouter = GoRouter(
  errorBuilder: (context, state) {
    return const ErrorPage();
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return "/${Routes.auth}";
      },
    ),
    GoRoute(
      name: Routes.landing,
      path: "/${Routes.landing}",
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
        name: Routes.auth,
        path: "/${Routes.auth}",
        builder: (context, state) =>  const AuthScreen(),
    ),
    GoRoute(
      name: Routes.home,
      path: "/${Routes.home}",
      builder: (context, state) =>  Container(),
      routes: [
        GoRoute(
          name: Routes.chat,
          path: Routes.chat,
          builder: (context, state) => const ChatScreen(),
        ),
      ]
    ),

  ],

);
