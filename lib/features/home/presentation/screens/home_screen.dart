import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_chat/core/constants/app_strings.dart';
import 'package:quick_chat/core/utils/logger.dart';
import 'package:quick_chat/core/utils/utils.dart';
import 'package:quick_chat/features/auth/providers/auth_providers.dart';
import 'package:quick_chat/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';
import 'package:quick_chat/features/home/providers/home_screen_provider.dart';

import '../../../../core/routes/routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<UserEntity>> userListState =
        ref.watch(userListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: _buildAppBarActions(ref, context),
      ),
      body: userListState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('${AppStrings.failedMessage} $error'),
        ),
        data: (userList) {
          return userList.isEmpty
              ? const Center(
                  child: Text(AppStrings.noUserFound),
                )
              : _buildUserList(userList, ref);
        },
      ),
    );
  }

  List<Widget> _buildAppBarActions(WidgetRef ref, BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await ref.read(authProvider.notifier).signOut();
          context.goNamed(Routes.auth);
        },
      )
    ];
  }

  Widget _buildUserList(List<UserEntity> userList, WidgetRef ref) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        final UserEntity user = userList[index];
        return ListTile(
          onTap: () {
            final conversationRepository =
                ref.read(conversationRepositoryProvider);
            final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
            final otherUserEmail = user.email;
            final fcmToken = user.fcmToken;
            conversationRepository.createConversation(
                [currentUserEmail, otherUserEmail]).then((_) {
              context.goNamed(Routes.conversation,
                  pathParameters: pathParameters(
                      currentUserEmail, otherUserEmail, fcmToken, user));
            }).catchError((error) {
              Log.debug("Failed to create conversation: $error");
            });
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }

  Map<String, String> pathParameters(String currentUserEmail,
      String otherUserEmail, String fcmToken, UserEntity user) {
    return {
      'conversationId': makeConversationID(currentUserEmail, otherUserEmail),
      'currentUserId': currentUserEmail,
      'fcmToken': fcmToken,
      'name': user.name,
    };
  }
}
