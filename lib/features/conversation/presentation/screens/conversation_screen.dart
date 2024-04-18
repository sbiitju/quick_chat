import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_chat/core/constants/app_strings.dart';
import 'package:quick_chat/features/conversation/providers/conversation_providers.dart';

class ConversationScreen extends HookConsumerWidget {
  final String conversationId;
  final String currentUserId;
  final String fcmToken;
  final String name;

  const ConversationScreen(
      {super.key, required this.conversationId,
      required this.currentUserId,
      required this.fcmToken,
      required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textEditingController =
        useTextEditingController();
    final ScrollController scrollController = useScrollController();
    final conversationMessagesAsync = ref.watch(
      getConversationMessagesProvider(conversationId),
    );
    final sendMessage = ref.read(sendMessageProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name),
      ),
      body: conversationMessagesAsync.when(
        data: (messages) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.animateTo(
              scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildConversationList(scrollController, messages),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                              hintText: AppStrings.typeYourMessage),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final text = textEditingController.text.trim();
                          if (text.isNotEmpty) {
                            sendMessage(
                                conversationId, currentUserId, fcmToken, text);
                            textEditingController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load messages: $error')),
      ),
    );
  }

  Widget _buildConversationList(
      ScrollController scrollController, List<Map<String, dynamic>> messages) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        reverse: true, // Display messages from bottom to top
        itemBuilder: (context, index) {
          final message = messages[index];
          final isCurrentUser = message['senderId'] == currentUserId;
          return Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                isCurrentUser ? 'You' : name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Card(
                color: isCurrentUser
                    ? Theme.of(context).dividerColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        message['text'],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
