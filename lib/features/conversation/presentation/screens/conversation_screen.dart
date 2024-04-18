import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/core/utils/logger.dart';
import 'package:quick_chat/features/conversation/providers/conversation_providers.dart';

class ConversationScreen extends ConsumerWidget {
  final String conversationId;
  final String currentUserId;
  final String fcmToken;

  ConversationScreen(
      {super.key, required this.conversationId, required this.currentUserId, required this.fcmToken}) {
    Log.debug('ConversationSendScreen: $conversationId, $currentUserId');
  }

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationMessagesAsync =
        ref.watch(getConversationMessagesProvider(conversationId));
    final sendMessage = ref.read(sendMessageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
      ),
      body: conversationMessagesAsync.when(
        data: (messages) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  reverse: true, // Display messages from bottom to top
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message['senderId'] == currentUserId;

                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(isCurrentUser ? 'You' : 'Other User'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                            hintText: 'Type your message...'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final text = _textEditingController.text.trim();
                        if (text.isNotEmpty) {
                          sendMessage(conversationId, currentUserId,fcmToken, text);
                          _textEditingController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load messages: $error')),
      ),
    );
  }
}
