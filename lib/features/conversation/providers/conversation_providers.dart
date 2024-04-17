// providers/conversation_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/features/conversation/data/data_sources/conversation_data_source_imp.dart';
import 'package:quick_chat/features/conversation/data/repositories/conversation_repository_imp.dart';
import 'package:quick_chat/features/home/providers/home_screen_provider.dart';

final conversationDataSourceProvider = Provider<ConversationDataSource>((ref) {
  final firestore = ref.watch(firebaseProvider);
  return ConversationDataSource(firestore);
});

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  final dataSource = ref.watch(conversationDataSourceProvider);
  return ConversationRepositoryImpl(dataSource);
});

final conversationMessagesProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, conversationId) {
  final dataSource = ref.watch(conversationDataSourceProvider);
  return dataSource.getConversationMessages(conversationId);
});

