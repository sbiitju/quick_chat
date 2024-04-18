import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/core/utils/logger.dart';
import 'package:quick_chat/features/auth/data/repositories/auth_repository.dart';

// Create a provider for managing authentication state
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(null) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await FirebaseAuth.instance.authStateChanges().first;
      state = user;
    } catch (e) {
      Log.error("Failed to get user: ${e.toString()}");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      UserCredential userCredential = await _repository.signInWithGoogle();
      state = userCredential.user;
      _repository.saveUser(userCredential.user!);
    } catch (e) {
      Log.error('Failed to sign in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      state = null;
    } catch (e) {
      Log.error('Failed to sign out: $e');
      rethrow;
    }
  }
}
