import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_chat/common/utils/logger.dart';
import 'package:quick_chat/features/conversation/providers/conversation_providers.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';
import 'package:quick_chat/features/home/providers/home_screen_provider.dart';

import '../../../../core/routes/routes.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<UserEntity>> userListState =
        ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: userListState.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Failed to fetch user list: $error'),
        ),
        data: (userList) {
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final UserEntity user = userList[index];
              return ListTile(
                onTap: () {
                  final conversationRepository =
                      ref.read(conversationRepositoryProvider);
                  final currentUserEmail =
                      FirebaseAuth.instance.currentUser!.email!;
                  final otherUserEmail = user.email;

                  conversationRepository.createConversation(
                      [currentUserEmail, otherUserEmail]).then((_) {
                    context.goNamed(Routes.conversation, pathParameters: {
                      'conversationId': '${currentUserEmail}_$otherUserEmail',
                      'currentUserId': currentUserEmail
                    });
                  }).catchError((error){
                      Log.debug("Failed to create conversation: $error");
                  });
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.isActive ? 'Active' : 'Inactive'),
              );
            },
          );
        },
      ),
    );
  }
}
