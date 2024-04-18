import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/features/conversation/domain/repositories/conversation_repository.dart';

class SendMessageUseCase {
  final ConversationRepository _repository;

  SendMessageUseCase(this._repository);

  Future<void> sendMessage(
      String conversationId, String senderId,String fcmToken, String text) {
    return _repository.sendMessage(conversationId, senderId,fcmToken, text);
  }
}

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>(
  (ref) {
    final repository = ref.read(conversationRepositoryProvider);
    return SendMessageUseCase(repository);
  },
);
