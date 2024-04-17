import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Create a provider for managing authentication state
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {

  AuthNotifier() : super(null) {
    // Check if user is already signed in on initialization
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await FirebaseAuth.instance.authStateChanges().first;
      state = user;
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in aborted or failed.');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      state = userCredential.user;
      try{
        print('User: ${userCredential.user!.uid}');
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'displayName': state?.displayName,
          'email': state?.email,
          'photoURL': state?.photoURL, // You can set the profile photo URL here
        });
      }catch(e){
        print('Error: $e');
      }
    } catch (e) {
      print('Failed to sign in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      state = null;
    } catch (e) {
      print('Failed to sign out: $e');
      rethrow;
    }
  }
}
