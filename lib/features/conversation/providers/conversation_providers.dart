import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/features/conversation/domain/use_cases/send_message_usecase.dart';
import 'package:quick_chat/features/conversation/domain/use_cases/get_conversation_message_usecase.dart';

final getConversationMessagesProvider =
    StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>(
  (ref, conversationId) {
    final conversationUseCase =
        ref.watch(getConversationMessagesUseCaseProvider);

    return conversationUseCase.execute(conversationId);
  },
);

final sendMessageProvider = Provider<Function(String, String, String,String)>(
  (ref) {
    final sendMessageUseCase = ref.read(sendMessageUseCaseProvider);

    return (String conversationId, String senderId, String fcmToken,String message) {
      return sendMessageUseCase.sendMessage(conversationId, senderId,fcmToken, message);
    };
  },
);
