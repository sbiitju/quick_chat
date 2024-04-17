// models/conversation.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final List<String> userIds;
  final Map<String, dynamic>? lastMessage;

  Conversation({
    required this.id,
    required this.userIds,
    this.lastMessage,
  });

  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Conversation(
      id: doc.id,
      userIds: List<String>.from(data['userIds']),
      lastMessage: data['lastMessage'],
    );
  }
}
