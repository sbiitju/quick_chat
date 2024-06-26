import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_chat/core/utils/extensions.dart';
import 'package:quick_chat/features/home/domain/entities/user_entity.dart';

class UserResponse {
  final String displayName;
  final String email;
  final bool isActive;
  final Timestamp lastActive;
  final String photoURL;
  final String fcmToken;

  UserResponse({
    required this.displayName,
    required this.email,
    required this.isActive,
    required this.lastActive,
    required this.photoURL,
    required this.fcmToken,
  });

  factory UserResponse.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserResponse(
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      isActive: data['isActive'] ?? false,
      lastActive: data['lastActive'] ?? Timestamp.now(),
      photoURL: data['photoURL'] ?? '',
      fcmToken: data['fcmToken'] ?? '',
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      name: displayName,
      email: email,
      photoUrl: photoURL,
      isActive: isActive,
      lastActive: lastActive.toDate().formatToString(format: 'HH:mm:ss yyyy-MM-dd'),
      fcmToken:fcmToken,
    );
  }
}
