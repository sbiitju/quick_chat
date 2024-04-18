import 'package:quick_chat/features/conversation/data/data_sources/conversation_datasource.dart';
import 'package:quick_chat/features/conversation/data/models/conversation_response.dart';
import 'package:quick_chat/features/conversation/domain/repositories/conversation_repository.dart';

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

  @override
  Stream<List<Map<String, dynamic>>> getConversationMessages(
      String conversationId) {
    return dataSource.getConversationMessages(conversationId);
  }

  @override
  Future<List<Map<String, dynamic>>> getConversationWithUser(
      String currentUserId, String otherUserId) {
    return dataSource.getConversationWithUser(currentUserId, otherUserId);
  }

  @override
  Future<void> sendMessage(
      String conversationId, String senderId,String fcmToken, String text) {
    return dataSource.sendMessage(conversationId, senderId,fcmToken, text);
  }
}
