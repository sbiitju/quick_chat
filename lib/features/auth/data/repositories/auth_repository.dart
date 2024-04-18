import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/features/auth/data/data_sources/auth_data_source.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<UserCredential> signInWithGoogle() async {
    return _dataSource.signInWithGoogle();
  }

  Future<void> saveUser(User user) async {
    return _dataSource.saveUser(user);
  }
}

Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  final dataSource = ref.read(authDataSourceProvider);

  return AuthRepository(dataSource);
});
