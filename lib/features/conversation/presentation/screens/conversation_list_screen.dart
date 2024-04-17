import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_chat/core/routes/routes.dart';
import 'package:quick_chat/features/conversation/data/models/conversation_response.dart';
import 'package:quick_chat/features/conversation/providers/conversation_providers.dart';

class ConversationListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationRepository = ref.watch(conversationRepositoryProvider);
    final currentUserEmail = 'shahinbashar2@gmail.com'; // Replace with actual current user email

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
      ),
      body: FutureBuilder<List<Conversation>>(
        future: conversationRepository.getConversationsForUser(currentUserEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load conversations: ${snapshot.error}'));
          }

          final conversations = snapshot.data ?? [];

          return conversations.isNotEmpty? ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              // Display conversation details in list
              return ListTile(
                onTap: () {
                  context.goNamed(Routes.conversation,pathParameters: {'conversationId': conversation.id, 'currentUserId': currentUserEmail});

                  // Navigate to conversation screen
                  // GoRouter.of(context).goNamed(Routes.conversation, arguments: conversation.id);
                },
                title: Text('Conversation ID: ${conversation.id}'),
                subtitle: Text('Participants: ${conversation.userIds.join(', ')}'),
              );
            },
          ): Center(child: Text('No conversations found'));
        },
      ),
    );
  }
}
