// data/datasources/conversation_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_chat/features/conversation/data/models/conversation_response.dart';

class ConversationDataSource {
  final FirebaseFirestore firestore;

  ConversationDataSource(this.firestore);

  Future<void> createConversation(List<String> userIds) async {
    final docRef = firestore.collection('conversations').doc(
          userIds.join('_'),
        ); // Generate a new document ID
    await docRef.set({
      'userIds': userIds,
      'lastMessage': null, // Initialize with no messages
    });
  }

  Future<List<Conversation>> getConversationsForUser(String userId) async {
    final querySnapshot = await firestore
        .collection('conversations')
        .where('userIds', arrayContains: "shahinbashar2@gmail.com")
        .get();

    return querySnapshot.docs
        .map((doc) => Conversation.fromFirestore(doc))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getConversationWithUser(
      String currentUserId, String otherUserId) async {
    final querySnapshot = await firestore
        .collection('conversations')
        .where('userIds', arrayContainsAny: [currentUserId, otherUserId]).get();

    if (querySnapshot.docs.isEmpty) {
      return []; // Conversation not found
    }

    final conversationDoc = querySnapshot.docs.first;
    final messagesSnapshot = await conversationDoc.reference
        .collection('messages')
        .orderBy('timestamp')
        .get();

    return messagesSnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> sendMessage(
      String conversationId, String senderId, String text) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
    await collectionRef.add({
      'text': text,
      'senderId': senderId,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<List<Map<String, dynamic>>> getConversationMessages(
      String conversationId) {
    final collectionRef = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
    return collectionRef
        .orderBy(
          'timestamp',
          descending: true,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
