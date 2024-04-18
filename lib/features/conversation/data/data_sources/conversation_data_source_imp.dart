import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:quick_chat/features/conversation/data/data_sources/conversation_datasource.dart';
import 'package:quick_chat/features/conversation/data/models/conversation_response.dart';

class ConversationDataSourceImp extends ConversationDataSource {
  final FirebaseFirestore firestore;

  ConversationDataSourceImp(this.firestore);

  @override
  Future<void> createConversation(List<String> userIds) async {
    final docRef = firestore.collection('conversations').doc(
          userIds.join('_'),
        ); // Generate a new document ID
    await docRef.set({
      'userIds': userIds,
      'lastMessage': null, // Initialize with no messages
    });
  }

  @override
  Future<List<Conversation>> getConversationsForUser(String userId) async {
    final querySnapshot = await firestore
        .collection('conversations')
        .where('userIds', arrayContains: "shahinbashar2@gmail.com")
        .get();

    return querySnapshot.docs
        .map((doc) => Conversation.fromFirestore(doc))
        .toList();
  }

  @override
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

  @override
  Future<void> sendMessage(String conversationId, String senderId,
      String fcmToken, String text) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
    await collectionRef.add({
      'text': text,
      'senderId': senderId,
      'timestamp': Timestamp.now(),
    });

    sendFCMNotification(fcmToken, senderId, text);
  }

  @override
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

  void sendFCMNotification(
      String fcmToken, String senderId, String message) async {
    const String serverKey =
        'AAAAnf_kv6o:APA91bHEDcnAeo4-MkScfTHByPgg7EMsLPAJFo7hp_OO48nzWrQ56qqHZ9HctQoFxRFR5kWn_X-XarMuxH9wEsi5heBdJDcqfdLCtiYjeW3vg2xoS2MLxq1qOxpOiAjPJNAl_JtYJ1bj'; // Replace with your FCM server key
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> body = {
      "to": fcmToken,
      "notification": {
        "title": senderId,
        "body": message,
      }
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      log('FCM notification sent successfully.');
    } else {
      log('Failed to send FCM notification. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  }
}
