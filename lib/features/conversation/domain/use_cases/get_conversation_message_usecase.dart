import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/features/conversation/domain/repositories/conversation_repository.dart';

class GetConversationMessagesUseCase {
  final ConversationRepository _repository;

  GetConversationMessagesUseCase(this._repository);

  Stream<List<Map<String, dynamic>>> execute(String conversationId) {
    return _repository.getConversationMessages(conversationId);
  }
}

final getConversationMessagesUseCaseProvider =
    Provider<GetConversationMessagesUseCase>(
  (ref) {
    final repository = ref.read(conversationRepositoryProvider);
    return GetConversationMessagesUseCase(repository);
  },
);
