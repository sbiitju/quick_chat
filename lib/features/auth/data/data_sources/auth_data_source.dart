import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_chat/core/services/firebase/firebase_service.dart';
import 'package:quick_chat/features/home/providers/home_screen_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthDataSource(this._firebaseAuth, this._firestore);

  Future<User?> get user => Future.value(_firebaseAuth.currentUser);

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> saveUser(User user) async {
    _firestore.collection('users').doc(user.uid).set({
      'displayName': user.displayName,
      'email': user.email,
      'isActive': true, // You can set the profile photo URL here
      'lastActive': DateTime.now(),
      'fcmToken': await FirebaseService().retrieveFCMToken(),
      'photoURL': user.photoURL, // You can set the profile photo URL here
    });
  }
}

Provider<AuthDataSource> authDataSourceProvider = Provider((ref) =>
    AuthDataSource(
        ref.read(firebaseAuthProvider), ref.read(fireStoreProvider)));
