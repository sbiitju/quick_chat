// data/repositories/conversation_repository.dart


import 'package:quick_chat/features/conversation/data/data_sources/conversation_data_source_imp.dart';
import 'package:quick_chat/features/conversation/data/models/conversation_response.dart';

abstract class ConversationRepository {
  Future<void> createConversation(List<String> userIds);
  Future<List<Conversation>> getConversationsForUser(String userId);
}

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationDataSource dataSource;

  ConversationRepositoryImpl(this.dataSource);

  @override
  Future<void> createConversation(List<String> userIds) {
    return dataSource.createConversation(userIds);
  }

  @override
  Future<List<Conversation>> getConversationsForUser(String userId) {
    return dataSource.getConversationsForUser(userId);
  }
}
