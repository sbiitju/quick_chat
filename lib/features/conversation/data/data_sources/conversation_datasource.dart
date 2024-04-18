import 'package:quick_chat/core/provider/common_provider.dart';
import 'package:quick_chat/features/conversation/data/data_sources/conversation_data_source_imp.dart';
import 'package:quick_chat/features/conversation/data/models/conversation_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class ConversationDataSource {
  Future<void> createConversation(List<String> userIds);

  Future<List<Conversation>> getConversationsForUser(String userId);

  Future<List<Map<String, dynamic>>> getConversationWithUser(
      String currentUserId, String otherUserId);

  Future<void> sendMessage(String conversationId, String senderId,String fcmToken, String text);

  Stream<List<Map<String, dynamic>>> getConversationMessages(
      String conversationId);
}

final conversationDataSourceProvider = Provider<ConversationDataSource>((ref) {
  final firestore = ref.watch(fireStoreProvider);
  return ConversationDataSourceImp(firestore);
});
