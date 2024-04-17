import 'package:go_router/go_router.dart';
import 'package:quick_chat/core/routes/routes.dart';
import 'package:quick_chat/features/auth/presentation/screens/auth_screen.dart';
import 'package:quick_chat/features/conversation/presentation/screens/conversation_screen.dart';
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
      name: Routes.auth,
      path: "/${Routes.auth}",
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
        name: Routes.home,
        path: "/${Routes.home}",
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            name: Routes.conversation,
            path: '${Routes.conversation}/:conversationId/:currentUserId',
            builder: (context, state) => ConversationScreen(
                conversationId: state.pathParameters['conversationId'] ?? "",
                currentUserId: state.pathParameters['currentUserId'] ?? ""),
          ),
        ]),
  ],
);
