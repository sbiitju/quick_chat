import 'package:quick_chat/features/conversation/data/data_sources/conversation_datasource.dart';
import 'package:quick_chat/features/conversation/data/models/conversation_response.dart';
import 'package:quick_chat/features/conversation/data/repositories/conversation_repository_imp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class ConversationRepository {
  Future<void> createConversation(List<String> userIds);

  Future<List<Conversation>> getConversationsForUser(String userId);

  Future<List<Map<String, dynamic>>> getConversationWithUser(
      String currentUserId, String otherUserId);

  Future<void> sendMessage(String conversationId, String senderId,String fcmToken,String text);

  Stream<List<Map<String, dynamic>>> getConversationMessages(
      String conversationId);
}

final conversationRepositoryProvider = Provider<ConversationRepository>(
  (ref) {
    final dataSource = ref.watch(conversationDataSourceProvider);

    return ConversationRepositoryImpl(dataSource);
  },
);
