import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_chat/core/routes/routes.dart';
import 'package:quick_chat/core/widget/error_page.dart';
import 'package:quick_chat/features/auth/presentation/screens/auth_screen.dart';
import 'package:quick_chat/features/conversation/presentation/screens/conversation_screen.dart';
import 'package:quick_chat/features/home/presentation/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  errorBuilder: (context, state) {
    return const ErrorPage();
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser != null) {
          return "/${Routes.home}";
        } else {
          return "/${Routes.auth}";
        }
      },
    ),
    GoRoute(
      name: Routes.auth,
      path: "/${Routes.auth}",
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      name: Routes.home,
      path: "/${Routes.home}",
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          name: Routes.conversation,
          path:
              '${Routes.conversation}/:conversationId/:currentUserId/:fcmToken/:name',
          builder: (context, state) => ConversationScreen(
              conversationId: state.pathParameters['conversationId'] ?? "",
              currentUserId: state.pathParameters['currentUserId'] ?? "",
              fcmToken: state.pathParameters['fcmToken'] ?? "",
              name: state.pathParameters['name'] ?? ""),
        ),
      ],
    ),
  ],
);
